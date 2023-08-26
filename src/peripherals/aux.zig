const address = @import("base.zig").address + 0x0021_5000;
const Register = @import("Register.zig");

pub const enables = Register.init(address + 0x04);
pub const mu_io_reg = Register.init(address + 0x40);
pub const mu_ier_reg = Register.init(address + 0x44);
pub const mu_lcr_reg = Register.init(address + 0x4c);
pub const mu_mcr_reg = Register.init(address + 0x50);
pub const mu_lsr_reg = Register.init(address + 0x54);
pub const mu_cntl_reg = Register.init(address + 0x60);
pub const mu_baud_reg = Register.init(address + 0x68);
