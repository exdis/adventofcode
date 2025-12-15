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

    std.debug.print("Result {}\n", .{result});
}
