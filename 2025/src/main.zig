const std = @import("std");
const utils = @import("utils.zig");

const day1 = @import("day1/main.zig");
const day2 = @import("day2/main.zig");
const day3 = @import("day3/main.zig");
const day4 = @import("day4/main.zig");
const day5 = @import("day5/main.zig");
const day6 = @import("day6/main.zig");
const day7 = @import("day7/main.zig");
const day8 = @import("day8/main.zig");
const day9 = @import("day9/main.zig");
const day10 = @import("day10/main.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const day = try utils.parseDay(args);

    switch (day) {
        1 => try day1.run(),
        2 => try day2.run(),
        3 => try day3.run(),
        4 => try day4.run(),
        5 => try day5.run(),
        6 => try day6.run(),
        7 => try day7.run(),
        8 => try day8.run(),
        9 => try day9.run(),
        10 => try day10.run(),
        else => std.debug.print("Day {d} not implemented yet\n", .{day}),
    }
}
