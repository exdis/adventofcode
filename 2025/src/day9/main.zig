const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day9/input.txt");
    defer input.deinit();

    var corners: std.ArrayList(Coords) = .{};
    defer corners.deinit(allocator);

    for (input.lines.items) |line| {
        // std.debug.print("{s}\n", .{line});
        var parts = std.mem.splitScalar(u8, line, ',');
        const xs = parts.next() orelse return error.InvalidInput;
        const ys = parts.next() orelse return error.InvalidInput;
        const x = try std.fmt.parseInt(usize, xs, 10);
        const y = try std.fmt.parseInt(usize, ys, 10);
        try corners.append(allocator, Coords{ .x = x, .y = y });
    }

    var cornerCombinations: std.ArrayList([2]Coords) = .{};
    defer cornerCombinations.deinit(allocator);

    for (corners.items, 0..corners.items.len) |corner1, i| {
        for (corners.items[i + 1 ..]) |corner2| {
            try cornerCombinations.append(allocator, [2]Coords{ corner1, corner2 });
        }
    }

    var maxArea: usize = 0;
    for (cornerCombinations.items) |combination| {
        // std.debug.print("Combination: ({d},{d}) - ({d},{d})\n", .{ combination[0].x, combination[0].y, combination[1].x, combination[1].y });
        const xDiff = @max(combination[0].x, combination[1].x) - @min(combination[0].x, combination[1].x) + 1;
        const yDiff = @max(combination[0].y, combination[1].y) - @min(combination[0].y, combination[1].y) + 1;
        const area = xDiff * yDiff;
        // std.debug.print("Area: {d}\n", .{area});
        if (area > maxArea) {
            maxArea = area;
        }
    }

    std.debug.print("Result: {d}\n", .{maxArea});
}

const Coords = struct {
    x: usize,
    y: usize,
};
