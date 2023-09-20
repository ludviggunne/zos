
const uart    = @import("peripherals/uart.zig");
const options = @import("options");
const utils   = @import("utils.zig");

comptime { _ = @import("main.zig"); }

extern const __kernel_begin: u64;

comptime { asm(@embedFile("boot.S")); }

fn hexc(q: u64) u8 {
    return switch (q) {
        0...9 => '0' + @as(u8, @truncate(q)),
        10 => 'a',
        11 => 'b',
        12 => 'c',
        13 => 'd',
        14 => 'e',
        15 => 'f',
        else => unreachable,
    };
}

fn printHex(v: u64) void {
    uart.cWrite("0x");
    inline for (0..16) |i| {
        const msk: u64 = @shlExact(@as(u64, 0xf), (15 - i) * 4);
        const c = hexc(@truncate(@shrExact(v & msk, (15 - i) * 4)));
        uart.writeByte(c);
    }
}

pub export fn clEntry() linksection(".text.chainloader") noreturn {

    uart.init(); 
    uart.cWrite("UART initialized\n");

    if (options.chainloader) {

        uart.cWrite("--- Chainloader started ---\n");
        uart.cWrite("Kernel entry point: ");
        printHex(@intFromPtr(&__kernel_begin));
        uart.cWrite("\n");
        uart.cWrite("Waiting for kernel packet...\n");

        // Get kernel size
        var ksize = uart.readType(usize);

        // Read kernel code
        var dst = @as([*]u8, @ptrCast(&__kernel_begin))[0..ksize];

        uart.readBytes(dst);
        utils.delay(100_000); 
        uart.cWrite("Kernel packet recieved (size = ");
        printHex(ksize);
        uart.cWrite(")\n");
    }

    // Reset stack pointer and jump to kernel
    _ = asm volatile(
        \\ ldr      x0, =__kernel_stack
        \\ mov      sp, x0
        \\ b        kmain
        );

    unreachable;
}
