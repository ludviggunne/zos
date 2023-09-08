
comptime { 
    _ = @import("utils.zig"); 
    _ = @import("exceptions.zig");
}

// Boot code
comptime { asm (@embedFile("boot.S")); }

const std = @import("std");
const uart = @import("peripherals/uart.zig");
const timer = @import("peripherals/timer.zig");
const aarch64 = @import("aarch64.zig");

comptime { asm ( ".section .text" ); }

const t1int: u32 = 500_000;
const t2int: u32 = 700_000;

// Kernel
export fn kmain() noreturn {
    uart.init();
    uart.clear();
    uart.writer.print("UART initialized\n", .{}) catch unreachable;

    aarch64.storeSysReg(.daif, 0);
    timer.init(.timer1, t1int);
    timer.init(.timer2, t2int); 
    uart.writer.print("Timers initialized\n", .{}) catch unreachable;

    while (true) {}
}

pub fn timerHandler(status: std.EnumSet(timer.Timer)) void {
    var iter = status.iterator();
    while (iter.next()) |t| {
        uart.writer.print("{s} triggered! ", .{ @tagName(t), })
            catch unreachable;
        timer.reset(t, switch (t) {
            .timer1 => t1int,
            .timer2 => t2int,
        });
    }
    uart.writer.print("\n", .{}) catch unreachable;
}
