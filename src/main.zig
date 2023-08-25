
const gpio = @import("peripherals/gpio.zig");

comptime {
    asm (
        @embedFile("boot.S")
    );
}

export fn memzero64(begin: u64, end: u64) void {
    _ = .{ begin, end, };
}

export fn kmain() noreturn {

    gpio.gpfsel1.set_enum(18, gpio.FunctionSelect.output);
    gpio.pup_pdn_cntrl_reg1.set_enum(0, gpio.ResistorSelect.none);

    while (true) {
        gpio.gpset0.set(16, 1, 1);
        for (0..2_500_000) |_| { asm volatile ( "nop" ); }
        gpio.gpclr0.set(16, 1, 1);
        for (0..2_500_000) |_| { asm volatile ( "nop" ); }
    }
}