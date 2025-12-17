const std = @import("std");
const utils = @import("../utils.zig");
const regex = @import("regex");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day10/input.txt");
    defer input.deinit();

    var result: usize = 0;
    var result2: usize = 0;
    for (input.lines.items) |line| {
        // Find the pattern part [.###.#]
        const bracket_start = std.mem.indexOf(u8, line, "[") orelse continue;
        const bracket_end = std.mem.indexOf(u8, line, "]") orelse continue;
        const pattern = line[bracket_start + 1 .. bracket_end];
        // std.debug.print("Pattern: {s}\n", .{pattern});

        // Find the curly brace part {10,11,11,5,10,5}
        const brace_start = std.mem.indexOf(u8, line, "{") orelse continue;
        const brace_end = std.mem.indexOf(u8, line, "}") orelse continue;
        const numbers_str = line[brace_start + 1 .. brace_end];

        // Parse jolatges from {...}
        var joltages: std.ArrayList(usize) = .{};
        defer joltages.deinit(allocator);
        var num_iter = std.mem.splitScalar(u8, numbers_str, ',');
        while (num_iter.next()) |num_str| {
            const num = try std.fmt.parseInt(usize, num_str, 10);
            try joltages.append(allocator, num);
        }
        // std.debug.print("Joltages: {any}\n", .{joltages.items});

        // Parse buttons (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2)
        const middle_part = line[bracket_end + 1 .. brace_start];
        var buttons: std.ArrayList(std.ArrayList(usize)) = .{};
        defer {
            for (buttons.items) |*button| {
                button.deinit(allocator);
            }
            buttons.deinit(allocator);
        }

        var i: usize = 0;
        while (i < middle_part.len) {
            if (middle_part[i] == '(') {
                // Find matching )
                const close_paren = std.mem.indexOfScalarPos(u8, middle_part, i, ')') orelse break;
                const button_str = middle_part[i + 1 .. close_paren];

                // Parse comma-separated numbers
                var button: std.ArrayList(usize) = .{};
                var button_iter = std.mem.splitScalar(u8, button_str, ',');
                while (button_iter.next()) |num_str| {
                    const num = try std.fmt.parseInt(usize, num_str, 10);
                    try button.append(allocator, num);
                }
                try buttons.append(allocator, button);

                i = close_paren + 1;
            } else {
                i += 1;
            }
        }

        var bitmask: usize = 0;
        for (pattern, 0..) |c, m| {
            if (c == '#') {
                bitmask |= (@as(usize, 1) << @intCast(m));
            }
        }
        // std.debug.print("Bitmask: 0b{b}\n", .{bitmask});

        var bitmaskButtons: std.ArrayList(usize) = .{};
        defer bitmaskButtons.deinit(allocator);

        for (buttons.items) |button| {
            var bm: usize = 0;
            for (button.items) |num| {
                bm |= (@as(usize, 1) << @intCast(num));
            }
            // std.debug.print("Bitmask button: {any} 0b{b}\n", .{ button, bm });
            try bitmaskButtons.append(allocator, bm);
        }

        var queue: std.ArrayList(State) = .{};
        defer queue.deinit(allocator);
        var visited = std.AutoHashMap(usize, void).init(allocator);
        defer visited.deinit();

        try queue.append(allocator, State{ .lights = 0, .presses = 0 });
        try visited.put(0, {});

        var idx: usize = 0;
        while (idx < queue.items.len) : (idx += 1) {
            const current = queue.items[idx];

            if (current.lights == bitmask) {
                result += current.presses;
                break;
            }

            for (bitmaskButtons.items) |btn| {
                const newLights = current.lights ^ btn;

                if (visited.contains(newLights)) continue;

                try visited.put(newLights, {});

                try queue.append(allocator, State{
                    .lights = newLights,
                    .presses = current.presses + 1,
                });
            }
        }

        const n = joltages.items.len;

        var options = std.AutoHashMap(u64, std.ArrayList(std.ArrayList(usize))).init(allocator);
        defer {
            var it = options.valueIterator();
            while (it.next()) |list| {
                for (list.items) |*pressed| {
                    pressed.deinit(allocator);
                }
                list.deinit(allocator);
            }
            options.deinit();
        }

        var output = std.AutoHashMap(u64, []usize).init(allocator);
        defer {
            var it = output.valueIterator();
            while (it.next()) |supply| {
                allocator.free(supply.*);
            }
            output.deinit();
        }

        const buttonNums = buttons.items.len;
        const allCombinations = @as(usize, 1) << @intCast(buttonNums);

        for (0..allCombinations) |combo| {
            var pressed: std.ArrayList(usize) = .{};
            for (0..buttonNums) |b| {
                if ((combo & (@as(usize, 1) << @intCast(b))) != 0) {
                    try pressed.append(allocator, b);
                }
            }

            const supply = try allocator.alloc(usize, n);
            for (0..n) |j| {
                var count: usize = 0;
                for (pressed.items) |b| {
                    for (buttons.items[b].items) |pos| {
                        if (pos == j) count += 1;
                    }
                }
                supply[j] = count;
            }

            var parityHash: u64 = 0;
            for (supply, 0..) |s, j| {
                if (s % 2 == 1) {
                    parityHash |= (@as(u64, 1) << @intCast(j));
                }
            }

            const entry = try options.getOrPut(parityHash);
            if (!entry.found_existing) {
                entry.value_ptr.* = .{};
            }
            try entry.value_ptr.append(allocator, pressed);

            try output.put(combo, supply);
        }

        var memo = std.AutoHashMap(u64, usize).init(allocator);
        defer memo.deinit();

        const part2 = try opt(allocator, joltages.items, &options, &output, buttons.items, &memo);
        result2 += part2;
    }

    std.debug.print("Result: {}\n", .{result});
    std.debug.print("Result 2: {}\n", .{result2});
}

const State = struct {
    lights: usize,
    presses: usize,
};

fn opt(
    allocator: std.mem.Allocator,
    demands: []const usize,
    options: *std.AutoHashMap(u64, std.ArrayList(std.ArrayList(usize))),
    output: *std.AutoHashMap(u64, []usize),
    buttons: []std.ArrayList(usize),
    memo: *std.AutoHashMap(u64, usize),
) !usize {
    var hasher = std.hash.Wyhash.init(0);
    const bytes = std.mem.sliceAsBytes(demands);
    hasher.update(bytes);
    const stateHash = hasher.final();

    if (memo.get(stateHash)) |cached| {
        return cached;
    }

    for (demands) |d| {
        if (d > 10000) {
            try memo.put(stateHash, 999999);
            return 999999;
        }
    }

    var sum: usize = 0;
    for (demands) |d| sum += d;
    if (sum == 0) {
        try memo.put(stateHash, 0);
        return 0;
    }

    var parityHash: u64 = 0;
    for (demands, 0..) |d, j| {
        if (d % 2 == 1) {
            parityHash |= (@as(u64, 1) << @intCast(j));
        }
    }

    var answer: usize = 999999;

    if (options.get(parityHash)) |pressedList| {
        for (pressedList.items) |pressed| {
            const supply = try allocator.alloc(usize, demands.len);
            defer allocator.free(supply);

            for (0..demands.len) |j| {
                var count: usize = 0;
                for (pressed.items) |b| {
                    for (buttons[b].items) |pos| {
                        if (pos == j) count += 1;
                    }
                }
                supply[j] = count;
            }

            const remain = try allocator.alloc(usize, demands.len);
            defer allocator.free(remain);

            var valid = true;
            for (demands, 0..) |d, j| {
                const s = supply[j];
                if (d < s) {
                    valid = false;
                    break;
                }
                remain[j] = (d - s) / 2;
            }

            if (!valid) continue;

            const cost = pressed.items.len + 2 * try opt(allocator, remain, options, output, buttons, memo);
            answer = @min(answer, cost);
        }
    }

    try memo.put(stateHash, answer);
    return answer;
}
