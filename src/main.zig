
comptime { 
    _ = @import("utils.zig"); 
    _ = @import("exceptions.zig");
}

// Boot code
comptime { asm (@embedFile("boot.S")); }

//comptime { asm ( ".section .text" ); }
const uart = @import("peripherals/uart.zig");

fn concat(a: []const u8, b: []const u8) []const u8 {
    const c = a ++ b;
    return c;
}

comptime { asm ( ".section .text" ); }

// Kernel
export fn kmain() noreturn {
    uart.init();
    uart.writer.print("The number is {d}, and the name is {s}\n", .{ 25, "Ludvig" })
        catch unreachable;
    asm volatile ( "svc 0x0" );
    while (true) {}
}