
const address linksection(".data.shared") = @import("base.zig").address + 0x0021_5000;
const Register = @import("Register.zig");

pub const enables     linksection(".data.shared") = Register.init(address + 0x04);
pub const mu_io_reg   linksection(".data.shared") = Register.init(address + 0x40);
pub const mu_ier_reg  linksection(".data.shared") = Register.init(address + 0x44);
pub const mu_lcr_reg  linksection(".data.shared") = Register.init(address + 0x4c);
pub const mu_mcr_reg  linksection(".data.shared") = Register.init(address + 0x50);
pub const mu_lsr_reg  linksection(".data.shared") = Register.init(address + 0x54);
pub const mu_cntl_reg linksection(".data.shared") = Register.init(address + 0x60);
pub const mu_baud_reg linksection(".data.shared") = Register.init(address + 0x68);
