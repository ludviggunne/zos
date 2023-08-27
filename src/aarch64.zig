
pub const SysReg = enum {
    daif,
    elr_el1,
    esr_el1,
};

pub fn loadSysReg(comptime reg: SysReg) u64 {
    return asm volatile (
        "mrs x0, " ++ @tagName(reg)
        : [ret] "=x0" (->u64)
    );
} 