const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day3/input.txt");
    defer input.deinit();

    var result: u256 = 0;
    var result2: u256 = 0;
    for (input.lines.items) |line| {
        if (line.len == 0) {
            continue;
        }
        result += try task1(line);
        result2 += try task2(line);
    }

    std.debug.print("Result: {}\n", .{result});
    std.debug.print("Result 2: {}\n", .{result2});
}

fn task1(line: []const u8) !u8 {
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

    return joltage;
}

fn task2(line: []const u8) !u256 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var i: usize = 1;
    var nums: std.ArrayList(u8) = .{};
    defer nums.deinit(allocator);
    try nums.append(allocator, line[0]);
    while (i < line.len) : (i += 1) {
        const num = try charToInt(line[i]);
        const lastNum = try charToInt(nums.getLast());
        if (num > lastNum) {
            if (line.len - i > 12 - nums.items.len and nums.items.len <= 12) {
                var k: usize = 0;
                if (line.len - i < 12) {
                    k = 12 - (line.len - i);
                }
                var flag = false;
                while (k < nums.items.len) : (k += 1) {
                    const ci = try charToInt(nums.items[k]);
                    if (num > ci) {
                        nums.items[k] = line[i];
                        nums.shrinkRetainingCapacity(k + 1);
                        flag = true;
                        break;
                    }
                }
                if (!flag) {
                    if (nums.items.len == 12) {
                        nums.items[nums.items.len - 1] = line[i];
                    } else if (nums.items.len < 12) {
                        try nums.append(allocator, line[i]);
                    }
                }
            } else {
                if (nums.items.len < 12) {
                    try nums.append(allocator, line[i]);
                } else {
                    nums.items[nums.items.len - 1] = line[i];
                }
            }
        } else {
            if (line.len - i >= 12 - nums.items.len and nums.items.len < 12) {
                try nums.append(allocator, line[i]);
            }
        }
    }
    const num = try std.fmt.parseInt(u256, nums.items, 10);
    return num;
}

fn charToInt(c: u8) !u8 {
    if (!std.ascii.isDigit(c)) return error.InvalidDigit;

    return c - '0';
}
