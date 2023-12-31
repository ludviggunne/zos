
// Exception table
comptime { asm (@embedFile("evtable.S")); }

const uart      = @import("peripherals/uart.zig");
const utils     = @import("utils.zig");
const aarch64   = @import("aarch64.zig");
const std       = @import("std");

var message: [:0] volatile u8 = @constCast("none");

pub const Type = enum (u64) {
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

pub export fn unimplHandlerErr(excep_type: u64) noreturn {

    const excep: Type = @enumFromInt(excep_type);
    const elr: *anyopaque = @ptrFromInt(aarch64.loadSysReg(.elr_el1));
    const esr = aarch64.loadSysReg(.esr_el1);

    uart.print(
        \\Unimplemented exception:
        \\    Type:            [{s}]
        \\    Taken from:      {x}
        \\    Syndrome:        0x{x}
        \\    Exception class: [{b}]
        \\    Message:         '{s}'
        \\
        , .{
            @tagName(excep),
            elr, 
            esr,
            (esr >> 26) & 0x3f,
            @volatileCast(message),
        }
    );

    utils._hang();
}

pub fn setMessage(msg: []const u8) void {
    message = @constCast(msg);        
}
