const std = @import("std");
const utils = @import("../utils.zig");

const Num = struct {
    value: u16,
    overflowCnt: u16,

    pub fn init(v: u16, o: u16) Num {
        return .{ .value = v % 100, .overflowCnt = o };
    }

    pub fn add(self: Num, rhs: u16) Num {
        const newValue = (self.value + rhs) % 100;
        const overflow = (self.value + rhs) / 100;
        return Num.init(newValue, overflow);
    }

    pub fn sub(self: Num, rhs: u16) Num {
        const newValue = (self.value + 100 - (rhs % 100)) % 100;
        var overflow: u16 = 0;
        if (self.value <= rhs) {
            overflow = (100 - self.value + rhs) / 100;
        }
        if (self.value == 0 and overflow > 0) {
            overflow -= 1;
        }
        return Num.init(newValue, overflow);
    }

    pub fn get(self: Num) u16 {
        return self.value;
    }

    pub fn getOverflowCnt(self: Num) u16 {
        return self.overflowCnt;
    }
};

pub fn run() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input = try utils.readInputLines(allocator, "src/day1/input.txt");
    defer input.deinit();

    var number = Num.init(50, 0);
    var result: u32 = 0;
    var result2: u32 = 0;

    for (input.lines.items) |line| {
        if (line.len == 0) continue;

        const dir = line[0..1];
        const cnt = try std.fmt.parseInt(u16, line[1..], 10);

        if (std.mem.eql(u8, dir, "R")) {
            number = number.add(cnt);
        } else if (std.mem.eql(u8, dir, "L")) {
            number = number.sub(cnt);
        } else {
            return error.InvalidDirection;
        }

        if (number.get() == 0) {
            result += 1;
        }

        result2 += number.getOverflowCnt();

        std.debug.print("Direction={s} Cnt={} Num={} Overflow={} \n", .{ dir, cnt, number.get(), number.getOverflowCnt() });
    }

    std.debug.print("Result={}\n", .{result});
    std.debug.print("Result2={}\n", .{result2});
}
