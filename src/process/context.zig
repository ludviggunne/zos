
const Context = @import("Process.zig").Context;

pub var user: *Context = undefined;
pub var kernel_sp: *Context = undefined;

comptime {
   @export(user,      .{ .name = "user.context", });
   @export(kernel,    .{ .name = "kernel.context", });
}
