const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day11/input.txt");
    defer input.deinit();

    var devices = std.StringHashMap(std.ArrayList([]const u8)).init(allocator);
    defer {
        var itemsIter = devices.iterator();

        while (itemsIter.next()) |item| {
            item.value_ptr.deinit(allocator);
        }
        devices.deinit();
    }

    for (input.lines.items) |line| {
        var iter = std.mem.splitScalar(u8, line, ' ');
        var device: std.ArrayList([]const u8) = .{};
        var idx: usize = 0;
        var inputName: []const u8 = undefined;
        while (iter.next()) |item| : (idx += 1) {
            if (idx == 0) {
                inputName = item[0..3];
            } else {
                try device.append(allocator, item);
            }
        }
        try devices.put(inputName, device);
    }

    var queue: std.ArrayList([]const u8) = .{};
    defer queue.deinit(allocator);

    const you = devices.get("you") orelse return error.WrongInput;

    for (you.items) |item| {
        try queue.append(allocator, item);
    }

    var result: usize = 0;
    while (queue.pop()) |item| {
        if (std.mem.eql(u8, item, "out")) {
            result += 1;
        } else {
            const nextDevice = devices.get(item) orelse return error.WrongInput;

            for (nextDevice.items) |it| {
                try queue.append(allocator, it);
            }
        }
    }

    std.debug.print("Result: {}\n", .{result});

    var cache = std.StringHashMap(usize).init(allocator);
    defer {
        var it = cache.keyIterator();
        while (it.next()) |key| {
            allocator.free(key.*);
        }
        cache.deinit();
    }

    var result2 = try countPath(allocator, "svr", "fft", devices, &cache) * try countPath(allocator, "fft", "dac", devices, &cache) * try countPath(allocator, "dac", "out", devices, &cache);
    result2 += try countPath(allocator, "svr", "dac", devices, &cache) * try countPath(allocator, "dac", "fft", devices, &cache) * try countPath(allocator, "fft", "out", devices, &cache);

    std.debug.print("Result 2: {}\n", .{result2});
}

fn makeCacheKey(allocator: std.mem.Allocator, from: []const u8, to: []const u8) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}|{s}", .{ from, to });
}

fn countPath(allocator: std.mem.Allocator, from: []const u8, to: []const u8, devices: std.StringHashMap(std.ArrayList([]const u8)), cache: *std.StringHashMap(usize)) !usize {
    const key = try makeCacheKey(allocator, from, to);
    defer allocator.free(key);

    if (cache.get(key)) |cached| {
        return cached;
    }
    if (std.mem.eql(u8, from, to)) {
        const newKey = try makeCacheKey(allocator, from, to);
        try cache.put(newKey, 1);
        return 1;
    } else {
        const emptyList: std.ArrayList([]const u8) = .{};
        const connectionsFrom = devices.get(from) orelse emptyList;

        var result: usize = 0;
        for (connectionsFrom.items) |conn| {
            result += try countPath(allocator, conn, to, devices, cache);
        }

        const newKey = try makeCacheKey(allocator, from, to);
        try cache.put(newKey, result);

        return result;
    }
}

const State = struct {
    device: []const u8,
    path: std.StringHashMap(void),
};
