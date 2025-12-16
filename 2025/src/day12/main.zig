const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day12/input.txt");
    defer input.deinit();

    var i: usize = 4 * 6;

    var result: usize = 0;

    while (i < input.lines.items.len) : (i += 1) {
        const line = input.lines.items[i];
        var iter = std.mem.splitScalar(u8, line, ':');

        const size = iter.next() orelse return error.WrongInput;
        var sizeIter = std.mem.splitScalar(u8, size, 'x');

        const x: usize = try std.fmt.parseInt(u8, sizeIter.next().?, 10);
        const y: usize = try std.fmt.parseInt(u8, sizeIter.next().?, 10);

        var blocks = iter.next() orelse return error.WrongInput;
        blocks = std.mem.trim(u8, blocks, " ");

        var blocksIter = std.mem.splitScalar(u8, blocks, ' ');

        var sumBlocks: usize = 0;
        while (blocksIter.next()) |block| {
            sumBlocks += try std.fmt.parseInt(usize, block, 10);
        }

        if ((x / 3) * (y / 3) >= sumBlocks) {
            result += 1;
        }
    }

    std.debug.print("Result: {}\n", .{result});
}
