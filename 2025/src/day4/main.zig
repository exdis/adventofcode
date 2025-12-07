const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day4/input.txt");
    defer input.deinit();

    const grid = try createGrid(allocator, input.lines);
    defer freeGrid(allocator, grid);

    var result: u256 = 0;

    for (grid, 0..) |row, y| {
        for (row, 0..) |char, x| {
            if (char != '@') continue;
            var adjustmentRolls: usize = 0;
            // top
            if (y > 0 and grid[y - 1][x] == '@') {
                adjustmentRolls += 1;
            }
            // bottom
            if (y < grid.len - 1 and grid[y + 1][x] == '@') {
                adjustmentRolls += 1;
            }
            // left
            if (x > 0 and grid[y][x - 1] == '@') {
                adjustmentRolls += 1;
            }
            // right
            if (x < grid[y].len - 1 and grid[y][x + 1] == '@') {
                adjustmentRolls += 1;
            }
            // top-left
            if (y > 0 and x > 0 and grid[y - 1][x - 1] == '@') {
                adjustmentRolls += 1;
            }
            // top-right
            if (y > 0 and x < grid[y].len - 1 and grid[y - 1][x + 1] == '@') {
                adjustmentRolls += 1;
            }
            // bottom-left
            if (y < grid.len - 1 and x > 0 and grid[y + 1][x - 1] == '@') {
                adjustmentRolls += 1;
            }
            // bottom-right
            if (y < grid.len - 1 and x < grid[y].len - 1 and grid[y + 1][x + 1] == '@') {
                adjustmentRolls += 1;
            }
            if (adjustmentRolls < 4) {
                result += 1;
            }
            // std.debug.print("grid[{d}][{d}] = {c}\n", .{ y, x, char });
        }
    }

    std.debug.print("Result: {}\n", .{result});
}

pub fn createGrid(allocator: std.mem.Allocator, lines: std.ArrayList([]const u8)) ![][]u8 {
    const grid = try allocator.alloc([]u8, lines.items.len);
    errdefer allocator.free(grid);

    for (lines.items, 0..) |line, i| {
        grid[i] = try allocator.alloc(u8, line.len);
        @memcpy(grid[i], line);
    }

    return grid;
}

pub fn freeGrid(allocator: std.mem.Allocator, grid: [][]u8) void {
    for (grid) |row| {
        allocator.free(row);
    }
    allocator.free(grid);
}
