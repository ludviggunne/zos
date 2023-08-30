
comptime {
    asm (@embedFile("evtable.S"));
}

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
    const elr: u64 = aarch64.loadSysReg(.elr_el1);
    const esr: u64 = aarch64.loadSysReg(.esr_el1);
    uart.writer.print(
        \\Exception triggered:
        \\    Type: {s}
        \\    ELR:  {x}
        \\    ESR:  {x}
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