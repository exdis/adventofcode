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
    for (ops.items, 0..cnt) |op, idx| {
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

    std.debug.print("Result: {}", .{result});
}
