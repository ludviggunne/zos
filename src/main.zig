
// Bring in memzero
comptime { _ = @import("utils.zig"); }

// Boot code
comptime { asm (@embedFile("boot.S")); }

//comptime { asm ( ".section .text" ); }
const uart = @import("peripherals/uart.zig");

fn concat(a: []const u8, b: []const u8) []const u8 {
    const c = a ++ b;
    return c;
}

comptime { asm ( concat(".section ", ".test")); }

// Kernel
export fn kmain() noreturn {
    uart.init();
    uart.writeString("Hello, world!");
    while (true) {}
}