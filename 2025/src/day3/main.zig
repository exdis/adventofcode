const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day3/input.txt");
    defer input.deinit();

    var result: u256 = 0;
    for (input.lines.items) |line| {
        if (line.len == 0) {
            continue;
        }
        var max: u8 = 0;
        var joltage: u8 = 0;
        var i: usize = 0;
        while (i < line.len - 1) : (i += 1) {
            const num = try charToInt(line[i]);
            const nextNum = try charToInt(line[i + 1]);
            if (num > max) {
                max = num;
                joltage = num * 10 + nextNum;
            } else {
                const newJoltage = max * 10 + @max(num, nextNum);
                if (newJoltage > joltage) {
                    joltage = newJoltage;
                }
            }
        }
        result += joltage;
    }

    std.debug.print("Result: {}", .{result});
}

fn charToInt(c: u8) !u8 {
    if (!std.ascii.isDigit(c)) return error.InvalidDigit;

    return c - '0';
}
