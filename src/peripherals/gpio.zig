
const std = @import("std");
const address = @import("base.zig").address + 0x0020_0000;
const Register = @import("Register.zig");

pub const FunctionSelect = enum(u3) {
    input  = 0b000,
    output = 0b001,
    alt0   = 0b100,
    alt1   = 0b101,
    alt2   = 0b110,
    alt3   = 0b111,
    alt4   = 0b011,
    alt5   = 0b010,
};

pub const ResistorSelect = enum(u2) {
    none,
    pullup,
    pulldown,
};

pub const gpfsel1 = Register.init(address + 0x04);
pub const gpset0 = Register.init(address + 0x1c);
pub const gpclr0 = Register.init(address + 0x28);
pub const pup_pdn_cntrl_reg1 = Register.init(address + 0xe8);