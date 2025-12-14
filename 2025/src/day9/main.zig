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

    var allx = std.AutoHashMap(usize, usize).init(allocator);
    defer allx.deinit();
    var ally = std.AutoHashMap(usize, usize).init(allocator);
    defer ally.deinit();

    for (input.lines.items) |line| {
        // std.debug.print("{s}\n", .{line});
        var parts = std.mem.splitScalar(u8, line, ',');
        const xs = parts.next() orelse return error.InvalidInput;
        const ys = parts.next() orelse return error.InvalidInput;
        const x = try std.fmt.parseInt(usize, xs, 10);
        const y = try std.fmt.parseInt(usize, ys, 10);
        try corners.append(allocator, Coords{ .x = x, .y = y });
        try allx.put(x, 0);
        try ally.put(y, 0);
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

    const uniqueX = try allocator.alloc(usize, allx.count());
    defer allocator.free(uniqueX);
    const uniqueY = try allocator.alloc(usize, ally.count());
    defer allocator.free(uniqueY);

    var iterX = allx.keyIterator();
    var i: usize = 0;
    while (iterX.next()) |key| : (i += 1) {
        uniqueX[i] = key.*;
    }

    var iterY = ally.keyIterator();
    var j: usize = 0;
    while (iterY.next()) |key| : (j += 1) {
        uniqueY[j] = key.*;
    }

    std.mem.sort(usize, uniqueX, {}, std.sort.asc(usize));
    std.mem.sort(usize, uniqueY, {}, std.sort.asc(usize));

    for (uniqueX, 0..) |x, iii| {
        try allx.put(x, iii);
    }

    for (uniqueY, 0..) |y, iii| {
        try ally.put(y, iii);
    }

    const grid = try allocator.alloc([]bool, uniqueY.len);
    var allocated: usize = 0;
    defer {
        for (0..allocated) |ii| {
            allocator.free(grid[ii]);
        }
        allocator.free(grid);
    }
    for (grid, 0..) |*row, jj| {
        row.* = try allocator.alloc(bool, uniqueX.len);
        allocated = jj + 1;
        @memset(row.*, false);
    }

    for (corners.items) |point| {
        const x = allx.get(point.x) orelse return error.WrongPoint;
        const y = ally.get(point.y) orelse return error.WrongPoint;
        grid[y][x] = true;
    }

    for (corners.items, 0..) |point, idx| {
        var nextPoint: Coords = undefined;
        if (idx < corners.items.len - 1) {
            nextPoint = corners.items[idx + 1];
        } else if (idx == corners.items.len - 1) {
            nextPoint = corners.items[0];
        } else {
            break;
        }
        const cx = allx.get(point.x) orelse return error.WrongPoint;
        const cy = ally.get(point.y) orelse return error.WrongPoint;

        // vertical
        if (point.x == nextPoint.x) {
            const nextCy = ally.get(nextPoint.y) orelse return error.WrongPoint;

            for (@min(cy, nextCy)..@max(cy, nextCy)) |yy| {
                grid[yy][cx] = true;
            }
        }

        // horizontal
        if (point.y == nextPoint.y) {
            const nextCx = allx.get(nextPoint.x) orelse return error.WrongPoint;

            for (@min(cx, nextCx)..@max(cx, nextCx)) |xx| {
                grid[cy][xx] = true;
            }
        }
    }

    for (grid, 0..) |row, rowidx| {
        var inside = false;
        var prevWasEdge = false;

        for (row, 0..) |col, idx| {
            if (col == true) {
                if (!prevWasEdge) {
                    inside = !inside;
                }
                prevWasEdge = true;
            } else {
                if (inside) {
                    grid[rowidx][idx] = true;
                }
                prevWasEdge = false;
            }
        }
    }

    var maxArea2: usize = 0;
    for (cornerCombinations.items) |combination| {
        // std.debug.print("Combination: ({d},{d}) - ({d},{d})\n", .{ combination[0].x, combination[0].y, combination[1].x, combination[1].y });
        const leftX = @min(combination[0].x, combination[1].x);
        const rightX = @max(combination[0].x, combination[1].x);
        const topY = @max(combination[0].y, combination[1].y);
        const bottomY = @min(combination[0].y, combination[1].y);

        const cx1 = allx.get(leftX) orelse return error.WrongPoint;
        // const cy1 = ally.get(topY) orelse return error.WrongPoint;
        const cx2 = allx.get(rightX) orelse return error.WrongPoint;
        const cy2 = ally.get(topY) orelse return error.WrongPoint;
        // const cx3 = allx.get(rightX) orelse return error.WrongPoint;
        // const cy3 = ally.get(bottomY) orelse return error.WrongPoint;
        // const cx4 = allx.get(leftX) orelse return error.WrongPoint;
        const cy4 = ally.get(bottomY) orelse return error.WrongPoint;
        // check if edges are not inside
        var allInside = true;
        outer: for (cy4..cy2 + 1) |y| {
            for (cx1..cx2 + 1) |x| {
                if (!grid[y][x]) {
                    allInside = false;
                    break :outer;
                }
            }
        }
        if (!allInside) continue;
        const xDiff = rightX - leftX + 1;
        const yDiff = topY - bottomY + 1;
        const area = xDiff * yDiff;
        if (area > maxArea2) {
            maxArea2 = area;
        }
    }

    std.debug.print("Result 2: {d}\n", .{maxArea2});

    // for (grid) |row| {
    //     for (row) |col| {
    //         if (col == true) {
    //             std.debug.print("#", .{});
    //         } else {
    //             std.debug.print(".", .{});
    //         }
    //     }
    //     std.debug.print("\n", .{});
    // }
}

const Coords = struct {
    x: usize,
    y: usize,
};
