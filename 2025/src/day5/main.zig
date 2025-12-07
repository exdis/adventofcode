const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day5/input.txt");
    defer input.deinit();

    var ranges: std.ArrayList(Range) = .{};
    defer ranges.deinit(allocator);
    var ids: std.ArrayList(usize) = .{};
    defer ids.deinit(allocator);

    for (input.lines.items) |line| {
        const range = splitRange(line) catch Range{ .start = 0, .end = 0 };
        // std.debug.print("start: {} end: {}\n", .{ range.start, range.end });
        if (range.start != 0 and range.end != 0) {
            try ranges.append(allocator, range);
        } else {
            const num = try std.fmt.parseInt(usize, line, 10);
            try ids.append(allocator, num);
        }
    }

    var result: u256 = 0;
    for (ids.items) |id| {
        for (ranges.items) |range| {
            if (id > range.start and id <= range.end) {
                // std.debug.print("Start={} End={} ID={}\n", .{ range.start, range.end, id });
                result += 1;
                break;
            }
        }
    }

    var combinedRanges: std.ArrayList(Range) = .{};
    defer combinedRanges.deinit(allocator);

    var rangePoints: std.ArrayList(RangePoint) = .{};
    defer rangePoints.deinit(allocator);

    for (ranges.items) |range| {
        try rangePoints.append(allocator, RangePoint{ .value = range.start, .end = false });
        try rangePoints.append(allocator, RangePoint{ .value = range.end, .end = true });
    }

    std.mem.sort(RangePoint, rangePoints.items, {}, compareRanges);

    var stack: std.ArrayList(bool) = .{};
    defer stack.deinit(allocator);

    var startPoint: usize = undefined;
    for (rangePoints.items) |rangePoint| {
        // std.debug.print("Value={} End={any}\n", .{ rangePoint.value, rangePoint.end });
        if (!rangePoint.end) {
            if (stack.items.len == 0) {
                startPoint = rangePoint.value;
            }
            try stack.append(allocator, true);
        } else {
            _ = stack.pop();
        }
        if (stack.items.len == 0) {
            try combinedRanges.append(allocator, Range{ .start = startPoint, .end = rangePoint.value });
        }
    }

    var result2: usize = 0;
    for (combinedRanges.items) |range| {
        // std.debug.print("Start={} End={}\n", .{ range.start, range.end });
        const valid = range.end - range.start + 1;
        result2 += valid;
    }

    std.debug.print("Result: {}\n", .{result});
    std.debug.print("Result 2: {}\n", .{result2});
}

const Range = struct { start: usize, end: usize };
const RangePoint = struct { value: usize, end: bool };

pub fn splitRange(str: []const u8) !Range {
    var iter = std.mem.splitScalar(u8, str, '-');

    const start_str = iter.next() orelse return error.InvalidFormat;
    const end_str = iter.next() orelse return error.InvalidFormat;

    const start = try std.fmt.parseInt(usize, start_str, 10);
    const end = try std.fmt.parseInt(usize, end_str, 10);

    return .{ .start = start, .end = end };
}

fn compareRanges(context: void, a: RangePoint, b: RangePoint) bool {
    _ = context;
    if (a.value != b.value) {
        return a.value < b.value;
    }
    return !a.end and b.end;
}
