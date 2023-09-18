
const Process = @import("process/Process.zig");

pub var @"process.context": *Process.Context align(16) = &Process.scratch_context;
pub var @"kernel.stack_pointer": *anyopaque = undefined;
pub const @"stack_pointer.offset": usize = @offsetOf(Process.Context, "sp");

comptime {
    @export(@"process.context", .{ .name = "process.context", });
    @export(@"kernel.stack_pointer", .{ .name = "kernel.stack_pointer", });
    @export(@"stack_pointer.offset", .{ .name = "stack_pointer.offset", });
}
