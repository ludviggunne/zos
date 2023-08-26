
pub export fn memzero(begin: usize, end: usize) void {
    const size = end - begin;
    const mem: [*]u8 = @ptrFromInt(begin);
    for (mem[0..size]) |*byte| {
        byte.* = 0;
    }
}