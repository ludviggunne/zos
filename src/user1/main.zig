
const zos = struct {
    const uart = @import("../peripherals/uart.zig");
    const utils = @import("../utils.zig");
};

pub export fn user1Main() linksection(".text.user1._start") void {
    
    while (true) {
        zos.uart.writer.print("User 1 says hi!\n", .{}) catch unreachable;
        zos.utils.delay(200_000_000);
    } 
}
