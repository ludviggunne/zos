
const std = @import("std");

const address = @import("base.zig").address + 0x0000_3000;
const Register = @import("Register.zig");
const irq = @import("irq.zig");

const freq: u32 = 1_000_000;

const cs = Register.init(address + 0x00);
const clo = Register.init(address + 0x04);
const chi = Register.init(address + 0x08);
const c1 = Register.init(address + 0x10);
const c3 = Register.init(address + 0x18);

pub const Timer = enum(u5) {
    timer1 = 1,
    timer2 = 3,
};

fn registerSelect(timer: Timer) *const Register {
    return switch(timer) {
        .timer1 => &c1, 
        .timer2 => &c3,
    };
}

pub fn init(timer: Timer, interval: u32) void {
    registerSelect(timer).write(clo.read() + interval);
    irq.irq0_set_en_0.set(@intFromEnum(timer), 1, 1);
}

pub fn reset(timer: Timer, interval: u32) void {
    var reg = registerSelect(timer);
    reg.write(reg.read() + interval);
    cs.set(@intFromEnum(timer), 1, 1);
}

pub fn getStatus() std.EnumSet(Timer) {
    var status = std.EnumSet(Timer).initEmpty();
    for (std.enums.values(Timer)) |timer| {
        if (cs.get(@intFromEnum(timer), 1) == 1) {
            status.insert(timer);
        } 
    }
    return status;
}
