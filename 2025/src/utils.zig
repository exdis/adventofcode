const std = @import("std");

pub const InputLines = struct {
    data: []u8,
    lines: std.ArrayList([]const u8),
    allocator: std.mem.Allocator,

    pub fn deinit(self: *InputLines) void {
        self.lines.deinit(self.allocator);
        self.allocator.free(self.data);
    }
};

pub fn readInputLines(allocator: std.mem.Allocator, filename: []const u8) !InputLines {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const data = try file.readToEndAlloc(allocator, 50000);
    errdefer allocator.free(data);

    var lines: std.ArrayList([]const u8) = .{};
    errdefer lines.deinit(allocator);

    var iter = std.mem.splitScalar(u8, data, '\n');
    while (iter.next()) |line| {
        if (line.len > 0) {
            try lines.append(allocator, line);
        }
    }

    return .{
        .data = data,
        .lines = lines,
        .allocator = allocator,
    };
}

pub fn parseDay(args: [][:0]u8) !u32 {
    var day: ?u32 = null;

    var i: usize = 1;
    while (i < args.len) : (i += 1) {
        const arg = args[i];

        if (std.mem.eql(u8, arg, "--day") or std.mem.eql(u8, arg, "-d")) {
            if (i + 1 >= args.len) {
                std.debug.print("Error: {s} requires a value\n", .{arg});
                return error.MissingDayValue;
            }
            day = std.fmt.parseInt(u32, args[i + 1], 10) catch {
                std.debug.print("Error: '{s}' is not a valid number\n", .{args[i + 1]});
                return error.InvalidDayValue;
            };

            if (day.? < 1 or day.? > 25) {
                std.debug.print("Error: day must be between 1 and 25\n", .{});
                return error.InvalidDayRange;
            }

            i += 1;
        }
    }

    if (day == null) {
        std.debug.print("Error: --day argument is required\n", .{});
        std.debug.print("Usage: program --day <1-25>\n", .{});
        return error.MissingDayArgument;
    }

    return day.?;
}
