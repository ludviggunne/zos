
const std = @import("std");
const aarch64 = @import("../aarch64.zig");
const Self = @This();

id: u32,
status: Status,
context: Context,

const Status = enum {
    uninitialized, 
    running,
};

pub var scratch_context: Context = undefined;

pub const Context align(16) = packed struct {

    x0:  u64 = 0,
    x1:  u64 = 0,
    x2:  u64 = 0,
    x3:  u64 = 0,
    x4:  u64 = 0,
    x5:  u64 = 0,
    x6:  u64 = 0,
    x7:  u64 = 0,
    x8:  u64 = 0,
    x9:  u64 = 0,
    x10: u64 = 0,
    x11: u64 = 0,
    x12: u64 = 0,
    x13: u64 = 0,
    x14: u64 = 0,
    x15: u64 = 0,
    x16: u64 = 0,
    x17: u64 = 0,
    x18: u64 = 0,
    x19: u64 = 0,
    x20: u64 = 0,
    x21: u64 = 0,
    x22: u64 = 0,
    x23: u64 = 0,
    x24: u64 = 0,
    x25: u64 = 0,
    x26: u64 = 0,
    x27: u64 = 0,
    x28: u64 = 0,
    x29: u64 = 0,
    x30: u64 = 0,
    x31: u64 = 0,
    sp: *anyopaque,

    pub fn fp(self: *@This()) **anyopaque {
        return @ptrCast(&self.x29);
    }

    pub fn pc(self: *@This()) **anyopaque {
        return @ptrCast(&self.x30);
    }

    pub fn print(self: *@This()) void {
        @import("../peripherals/uart.zig").print(
            \\
            \\ x0:  {d}  x1:  {d} x2:  {d} x3:  {d}
            \\     ...
            \\ pc: {x} sp:  {x}
            \\
            , .{ self.x0, self.x1, self.x2, self.x3, self.pc().*, self.sp, }
        );
    }
};
