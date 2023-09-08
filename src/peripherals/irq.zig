
const address = @import("base.zig").address + 0x0000_b000;
const Register = @import("Register.zig");

pub const irq0_set_en_0 = Register.init(address + 0x210);
