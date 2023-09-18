
comptime { 
    _ = @import("utils.zig"); 
    _ = @import("exceptions.zig");
    _ = @import("user0/main.zig");
    _ = @import("user1/main.zig");
    _ = @import("process/Scheduler.zig");
    _ = @import("symbols.zig");
}

const std       = @import("std");
const uart      = @import("peripherals/uart.zig");
const timer     = @import("peripherals/timer.zig");
const aarch64   = @import("aarch64.zig");
const Scheduler = @import("process/Scheduler.zig");
const user0     = @import("user0/symbols.zig");
const user1     = @import("user1/symbols.zig");
const symbols   = @import("symbols.zig");
const utils     = @import("utils.zig");
const excep     = @import("exceptions.zig");

// Boot code
comptime { asm (@embedFile("boot.S")); }

extern const __kernel_begin: *anyopaque;

export fn kmain() noreturn {

    symbols.@"kernel.stack_pointer" = __kernel_begin;

    // Init IO
    uart.init();
    uart.clear();
    uart.writer.print("UART initialized\n", .{}) catch unreachable;

    // Unmask interrupts
    aarch64.storeSysReg(.daif, 0);

    // Init processes
    Scheduler.instance.init() catch unreachable;

    _ = Scheduler.instance.schedule(.{
        .entry = user0.entry,
        .stack = user0.stack,
    }) catch unreachable;

    _ = Scheduler.instance.schedule(.{
        .entry = user1.entry,
        .stack = user1.stack,
    }) catch unreachable;

    Scheduler.instance.begin() catch unreachable;
    uart.writer.print("Scheduler initialized\n", .{}) catch unreachable;

    uart.writer.print("Waiting to start user processes...\n", .{}) catch unreachable;

    while (true) {}
}
