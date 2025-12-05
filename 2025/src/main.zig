const std = @import("std");
const utils = @import("utils.zig");

const day1 = @import("day1/main.zig");
const day2 = @import("day2/main.zig");

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
        else => std.debug.print("Day {d} not implemented yet\n", .{day}),
    }
}
