
pub export fn memzero(begin: usize, end: usize) void {
    const size = end - begin;
    const mem: [*]u8 = @ptrFromInt(begin);
    for (mem[0..size]) |*byte| {
        byte.* = 0;
    }
}

pub fn delay(t: u64) linksection(".text.shared") void {
    var t_ = t;
    while (t_ > 0) {
        _ = asm volatile("nop");
        t_ -= 1;
    }
}

pub export fn _hang() noreturn {

    _ = asm volatile (
        \\ b _hang
    );

    unreachable;
}

pub fn isAligned(comptime almt: usize, ptr: *anyopaque) bool {
    return @intFromPtr(ptr) % almt == 0; 
}
