
comptime {
    asm (@embedFile("evtable.S"));
}

comptime { asm (".section .text"); }

const uart = @import("peripherals/uart.zig");
const aarch64 = @import("aarch64.zig");
const std = @import("std");

pub const ExceptionType = enum (u64) {
    sync_e1t,
    irq_e1t,
    fiq_e1t,
    serror_e1t,
    sync_e1h,
    irq_e1h,
    fiq_e1h,
    serror_e1h,
    sync_e0_64,
    irq_e0_64,
    fiq_e0_64,
    serror_e0_64,
    sync_e0_32,
    irq_e0_32,
    fiq_e0_32,
    serror_e0_32,
};

pub export fn handleException(excep_type: u64) void {
    const excep: ExceptionType = @enumFromInt(excep_type);
    switch (excep) {
        .irq_e1h => @import("main.zig").timerHandler(
                @import("peripherals/timer.zig").getStatus()
            ),
        else => {
            const elr = aarch64.loadSysReg(.elr_el1);
            const esr = aarch64.loadSysReg(.esr_el1);
            uart.writer.print(
                \\Unimplemented exception:
                \\    Type: {s}
                \\    ELR:  {x}
                \\    ESR:  {x}
                \\
                , .{
                    @tagName(@as(
                        ExceptionType,
                        @enumFromInt(excep_type)
                    )),
                    elr, 
                    esr,
                }
            ) catch unreachable;
        }
    }
}
