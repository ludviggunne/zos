
pub const SysReg = enum {
    daif,
    elr_el1,
    esr_el1,
    vbar_el1,
    CurrentEL,
};

pub fn loadSysReg(comptime reg: SysReg) u64 {
    return asm volatile (
        "mrs x0, " ++ @tagName(reg)
        : [ret] "={x0}" (->u64)
    );
} 

pub fn storeSysReg(comptime reg: SysReg, value: u64) void {
    _ = asm volatile (
        "msr " ++ @tagName(reg) ++ ", x0"
        :: [value] "{x0}" (value)
    );
}
