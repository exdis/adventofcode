const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day7/input.txt");
    defer input.deinit();

    // std.debug.print("{s}", .{input.data});

    const startIdx = std.mem.indexOfScalar(u8, input.lines.items[0], 'S') orelse {
        return error.WrongInput;
    };

    var rays: std.ArrayList(bool) = .{};
    defer rays.deinit(allocator);
    try rays.resize(allocator, input.lines.items[0].len);
    rays.items[startIdx] = true;

    var paths: std.ArrayList(usize) = .{};
    defer paths.deinit(allocator);
    try paths.appendNTimes(allocator, 0, input.lines.items[0].len);
    paths.items[startIdx] = 1;

    var result: usize = 0;
    var result2: usize = 0;
    for (input.lines.items, 0..input.lines.items.len) |line, i| {
        if (i == 0) continue;
        for (line, 0..line.len) |char, j| {
            for (0..rays.items.len) |rayIdx| {
                if (rayIdx == j and rays.items[rayIdx]) {
                    if (char == '^') {
                        rays.items[rayIdx] = false;
                        if (rayIdx < rays.items.len - 1) {
                            rays.items[rayIdx + 1] = true;
                            paths.items[rayIdx + 1] += paths.items[rayIdx];
                        }
                        if (rayIdx > 0) {
                            rays.items[rayIdx - 1] = true;
                            paths.items[rayIdx - 1] += paths.items[rayIdx];
                        }
                        paths.items[rayIdx] = 0;
                        result += 1;
                    }
                    // std.debug.print("#### CHAR {c} RAY at line {d} idx {d}\n", .{ char, i, j });
                }
            }
        }
    }

    for (paths.items) |num| {
        result2 += num;
    }

    std.debug.print("Result: {}\n", .{result});
    std.debug.print("Result 2: {}\n", .{result2});
}
