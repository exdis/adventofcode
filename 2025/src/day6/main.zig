const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try utils.readInputLines(allocator, "src/day6/input.txt");
    defer input.deinit();

    var nums: std.ArrayList(std.ArrayList(usize)) = .{};
    defer {
        for (nums.items) |*row| {
            row.deinit(allocator);
        }
        nums.deinit(allocator);
    }

    var cnt: usize = undefined;

    for (input.lines.items, 0..input.lines.items.len) |line, idx| {
        if (idx == input.lines.items.len - 1) break;
        var row: std.ArrayList(usize) = .{};
        // std.debug.print("Line: {s}\n", .{line});
        var buf: std.ArrayList(u8) = .{};
        defer buf.deinit(allocator);
        for (line) |c| {
            // std.debug.print("  Char: {c}\n", .{c});
            if (c == ' ' or c == '\n') {
                if (buf.items.len > 0) {
                    const num = try std.fmt.parseInt(usize, buf.items, 10);
                    // std.debug.print("    Num: {d}\n", .{num});
                    try row.append(allocator, num);
                    buf.clearAndFree(allocator);
                }
            } else {
                try buf.append(allocator, c);
            }
        }
        const num = try std.fmt.parseInt(usize, buf.items, 10);
        try row.append(allocator, num);
        try nums.append(allocator, row);
    }

    cnt = nums.items[0].items.len;
    var cols: std.ArrayList(std.ArrayList(usize)) = .{};
    defer {
        for (cols.items) |*item| {
            item.deinit(allocator);
        }
        cols.deinit(allocator);
    }

    for (0..cnt) |col_idx| {
        var col: std.ArrayList(usize) = .{};
        for (nums.items) |row| {
            // std.debug.print("Row item: {any}\n", .{row.items});
            try col.append(allocator, row.items[col_idx]);
        }
        try cols.append(allocator, col);
    }

    const opsline = input.lines.items[input.lines.items.len - 1];
    var ops: std.ArrayList(u8) = .{};
    defer ops.deinit(allocator);

    for (opsline) |c| {
        if (c == '*' or c == '+') {
            try ops.append(allocator, c);
        }
    }

    var result: usize = 0;
    for (ops.items, 0..ops.items.len) |op, idx| {
        if (op == '*') {
            var iresult: usize = 1;
            for (cols.items[idx].items) |num| {
                iresult *= num;
            }
            result += iresult;
        } else if (op == '+') {
            for (cols.items[idx].items) |num| {
                result += num;
            }
        }
    }

    std.debug.print("Result: {}\n", .{result});

    var maxLen: usize = 0;
    for (input.lines.items) |line| {
        maxLen = @max(maxLen, line.len);
    }

    var i: usize = 0;

    var cols2: std.ArrayList(std.ArrayList(usize)) = .{};
    defer {
        for (cols2.items) |*item| {
            item.deinit(allocator);
        }
        cols2.deinit(allocator);
    }

    for (0..cnt) |_| {
        const col: std.ArrayList(usize) = .{};
        try cols2.append(allocator, col);
    }

    var colCnt: usize = 0;
    while (i < maxLen) : (i += 1) {
        var j: usize = 0;
        var buf: std.ArrayList(u8) = .{};
        defer buf.deinit(allocator);
        var spaceCnt: usize = 0;
        while (j < input.lines.items.len - 1) : (j += 1) {
            const line = input.lines.items[j];
            if (i < line.len and line[i] != ' ') {
                try buf.append(allocator, line[i]);
            } else {
                spaceCnt += 1;
            }
        }
        if (buf.items.len > 0) {
            const num = try std.fmt.parseInt(usize, buf.items, 10);
            if (colCnt < cols2.items.len) {
                try cols2.items[colCnt].append(allocator, num);
            }
            buf.clearAndFree(allocator);
        }
        if (spaceCnt == input.lines.items.len - 1) {
            colCnt += 1;
            spaceCnt = 0;
        }
    }

    var result2: usize = 0;
    for (ops.items, 0..ops.items.len) |op, idx| {
        if (op == '*') {
            var iresult: usize = 1;
            for (cols2.items[idx].items) |num| {
                iresult *= num;
            }
            result2 += iresult;
        } else if (op == '+') {
            for (cols2.items[idx].items) |num| {
                result2 += num;
            }
        }
    }

    std.debug.print("Result 2: {}\n", .{result2});
}
