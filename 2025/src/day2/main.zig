const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day2/input.txt");
    defer input.deinit();

    var ranges = std.mem.splitScalar(u8, input.data, ',');

    var result: u256 = 0;
    var result2: u256 = 0;
    while (ranges.next()) |r| {
        if (r.len == 0) continue;
        const range = std.mem.trim(u8, r, "\n");
        var ends = std.mem.splitScalar(u8, range, '-');
        const s = ends.next().?;
        const start = try std.fmt.parseInt(u256, s, 10);
        const e = ends.next().?;
        const end = try std.fmt.parseInt(u256, e, 10);
        std.debug.print("Range: {s} Start: {} End: {}\n", .{ range, start, end });
        var i: u256 = start;
        while (i < end + 1) : (i += 1) {
            if (try isMagic(i)) {
                std.debug.print("    Found magic number: {}\n", .{i});
                result += i;
            }
            if (try isMagic2(i)) {
                std.debug.print("    Found magic2 number: {}\n", .{i});
                result2 += i;
            }
        }
    }

    std.debug.print("Result {}\n", .{result});
    std.debug.print("Result 2 {}\n", .{result2});
}

fn isMagic(num: u256) !bool {
    const allocator = std.heap.page_allocator;
    const str = try std.fmt.allocPrint(allocator, "{d}", .{num});
    defer allocator.free(str);
    if (str.len % 2 != 0) {
        return false;
    }
    const half = str.len / 2;
    if (std.mem.eql(u8, str[0..half], str[half..]) == false) {
        return false;
    }
    return true;
}

fn isMagic2(num: u256) !bool {
    const allocator = std.heap.page_allocator;
    const str = try std.fmt.allocPrint(allocator, "{d}", .{num});
    defer allocator.free(str);

    var i: usize = 1;
    while (i < str.len + 1 / 2) : (i += 1) {
        var j: usize = i;
        if (str.len % j != 0) continue;
        var result: bool = false;
        while (j + i <= str.len) : (j += i) {
            result = std.mem.eql(u8, str[(j - i)..j], str[j..(j + i)]);
            if (!result) break;
        }
        if (result) {
            return true;
        }
    }

    return false;
}
