
comptime { 
    _ = @import("utils.zig"); 
    _ = @import("exceptions.zig");
}

// Boot code
comptime { asm (@embedFile("boot.S")); }

const uart = @import("peripherals/uart.zig");

comptime { asm ( ".section .text" ); }

// Kernel
export fn kmain() noreturn {
    uart.init();
    uart.writer.print("UART initialized\n", .{}) catch unreachable;
    asm volatile ( "svc 0x69" );
    uart.writer.print("Exception should have been handled by now..\n", .{})
        catch unreachable;
    while (true) {}
}
