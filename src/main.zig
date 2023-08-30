
comptime { 
    _ = @import("utils.zig"); 
    _ = @import("exceptions.zig");
}

// Boot code
comptime { asm (@embedFile("boot.S")); }

//comptime { asm ( ".section .text" ); }
const uart = @import("peripherals/uart.zig");

comptime { asm ( ".section .text" ); }

// Kernel
export fn kmain() noreturn {
    uart.init();
    asm volatile ( "svc 0x0" );
    while (true) {}
}