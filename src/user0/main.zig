
const zos = struct {
    const uart = @import("../peripherals/uart.zig");
    const utils = @import("../utils.zig");
};

pub export fn user0Main() linksection(".user0.text._start") void {

    var s = asm volatile (
        \\mov   x0, sp
        : [ret] "={x0}" (->u64)
    );

    zos.uart.writer.print("User0 stack pointer: {x}", .{ s })
        catch unreachable;
    
    for (0..5) |i| {
        zos.uart.writer.print("User 0 says hi! Counter: {d}\n", .{ i }) catch unreachable;
        zos.utils.delay(10_000_000);
    } 

    _ = asm volatile ("svc 0x69");
}
