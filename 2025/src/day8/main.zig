const std = @import("std");
const utils = @import("../utils.zig");

const connCount: usize = 1000;

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

    var circuits: std.ArrayList(std.ArrayList(usize)) = .{};
    defer {
        for (circuits.items) |*circuit| {
            circuit.deinit(allocator);
        }
        circuits.deinit(allocator);
    }

    var firstCircuit: std.ArrayList(usize) = .{};
    try firstCircuit.append(allocator, distances.items[0].p1);
    try circuits.append(allocator, firstCircuit);

    for (distances.items, 0..distances.items.len) |conn, idx| {
        if (idx >= connCount) break;
        var flag = false;
        for (circuits.items) |*circuit| {
            if (std.mem.indexOfScalar(usize, circuit.items, conn.p1) != null and
                std.mem.indexOfScalar(usize, circuit.items, conn.p2) != null)
            {
                // Both points are already in the circuit
                flag = true;
                break;
            } else if (std.mem.indexOfScalar(usize, circuit.items, conn.p1) != null and
                std.mem.indexOfScalar(usize, circuit.items, conn.p2) == null)
            {
                // p1 is in the circuit, add p2
                try circuit.append(allocator, conn.p2);
                flag = true;
                break;
            } else if (std.mem.indexOfScalar(usize, circuit.items, conn.p2) != null and
                std.mem.indexOfScalar(usize, circuit.items, conn.p1) == null)
            {
                // p2 is in the circuit, add p1
                try circuit.append(allocator, conn.p1);
                flag = true;
                break;
            }
        }
        if (!flag) {
            // Both points are new, create a new circuit
            var newCircuit: std.ArrayList(usize) = .{};
            try newCircuit.append(allocator, conn.p1);
            try newCircuit.append(allocator, conn.p2);
            try circuits.append(allocator, newCircuit);
        }
    }

    while (true) {
        var reconnectionCount: usize = 0;
        for (circuits.items, 0..circuits.items.len) |*circuit, idx| {
            for (circuit.items) |point_id| {
                if (idx == circuits.items.len - 1) break;
                for (circuits.items, 0..circuits.items.len) |*otherCircuit, k| {
                    if (k < idx or k == idx) continue;
                    if (std.mem.indexOfScalar(usize, circuits.items[k].items, point_id) != null) {
                        for (otherCircuit.items) |other_point_id| {
                            if (std.mem.indexOfScalar(usize, circuit.items, other_point_id) == null) {
                                try circuit.append(allocator, other_point_id);
                                try otherCircuit.resize(allocator, 0);
                                reconnectionCount += 1;
                            }
                        }
                    }
                }
            }
        }
        if (reconnectionCount == 0) break;
    }

    std.mem.sort(std.ArrayList(usize), circuits.items, {}, compareCircuits);

    var result: usize = 1;
    for (0..3) |idx| {
        const circuit = circuits.items[idx];
        result *= circuit.items.len;
    }

    std.debug.print("Result: {}\n", .{result});

    var processedPoints: std.ArrayList(usize) = .{};
    defer processedPoints.deinit(allocator);

    var result2: i32 = 0;
    for (distances.items) |conn| {
        if (std.mem.indexOfScalar(usize, processedPoints.items, conn.p1) == null) {
            try processedPoints.append(allocator, conn.p1);
        }
        if (std.mem.indexOfScalar(usize, processedPoints.items, conn.p2) == null) {
            try processedPoints.append(allocator, conn.p2);
        }
        if (processedPoints.items.len == input.lines.items.len) {
            const point1 = points.get(conn.p1) orelse return error.PointNotFound;
            const point2 = points.get(conn.p2) orelse return error.PointNotFound;
            result2 = point1.x * point2.x;
            break;
        }
    }

    std.debug.print("Result 2: {}\n", .{result2});
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

fn compareCircuits(context: void, a: std.ArrayList(usize), b: std.ArrayList(usize)) bool {
    _ = context;
    return a.items.len > b.items.len;
}
