
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
const ldaddr    = @import("ldaddr.zig").ldaddr;

extern const __kernel_stack: ldaddr;
extern const __bss_begin:    ldaddr;
extern const __bss_end:      ldaddr;

export fn kmain() linksection(".text.kernel.start") noreturn {

    uart.printLn("--- Kernel entry ---", .{});

    uart.printLn("Initalizing exception vector table", .{});
    _ = asm volatile(
            \\ adr       x0, evtable
            \\ msr       vbar_el1, x0
        );

    uart.printLn(
        "Clearing .bss section ({x} --> {x})", 
        .{ &__bss_begin, &__bss_end, }
    );
    utils.memzero(
        @intFromPtr(&__bss_begin),
        @intFromPtr(&__bss_end)
    );

    uart.printLn("I'm gonna try something...", .{});
    _ = asm volatile("svc 0x69");

    //symbols.@"kernel.stack_pointer" = __kernel_stack;

    while (true) {}
}

pub fn processTest() void {

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
    uart.printLn("Scheduler initialized", .{});

    uart.printLn("Waiting to start user processes...", .{});
}
