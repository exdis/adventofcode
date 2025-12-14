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
    }

    std.debug.print("Result: {}\n", .{result});
}

const State = struct {
    lights: usize,
    presses: usize,
};
