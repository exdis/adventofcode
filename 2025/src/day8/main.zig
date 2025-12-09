const std = @import("std");
const utils = @import("../utils.zig");

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day8/input.txt");
    defer input.deinit();

    const pointsCount = input.lines.items.len;

    var points = std.AutoHashMap(usize, Point).init(allocator);
    defer points.deinit();

    var distances: std.ArrayList(Connection) = .{};
    defer distances.deinit(allocator);

    for (input.lines.items, 0..pointsCount) |line, idx| {
        var splitted = std.mem.splitScalar(u8, line, ',');
        const xs = splitted.next() orelse return error.WrongCoord;
        const ys = splitted.next() orelse return error.WrongCoord;
        const zs = splitted.next() orelse return error.WrongCoord;

        const x = try std.fmt.parseInt(i32, xs, 10);
        const y = try std.fmt.parseInt(i32, ys, 10);
        const z = try std.fmt.parseInt(i32, zs, 10);
        std.debug.print("### {} {} {}\n", .{ x, y, z });

        try points.put(idx, Point{ .id = idx, .x = x, .y = y, .z = z });
    }

    for (0..pointsCount) |i| {
        var j: usize = i + 1;
        while (j < pointsCount) : (j += 1) {
            if (j < pointsCount) {
                const point1 = points.get(i) orelse return error.PointNotFound;
                const point2 = points.get(j) orelse return error.PointNotFound;
                const dist = distance(point1, point2);
                try distances.append(allocator, Connection{ .p1 = i, .p2 = j, .dist = dist });
            }
        }
    }

    std.mem.sort(Connection, distances.items, {}, compareDist);

    std.debug.print("{any}", .{distances.items[0]});
}

const Point = struct {
    id: usize,
    x: i32,
    y: i32,
    z: i32,
};

const Connection = struct { p1: usize, p2: usize, dist: f64 };

fn distance(p1: Point, p2: Point) f64 {
    const dx = @as(f64, @floatFromInt(p2.x - p1.x));
    const dy = @as(f64, @floatFromInt(p2.y - p1.y));
    const dz = @as(f64, @floatFromInt(p2.z - p1.z));
    return @sqrt(dx * dx + dy * dy + dz * dz);
}

fn compareDist(context: void, a: Connection, b: Connection) bool {
    _ = context;
    return a.dist < b.dist;
}
