
const Self = @This();

const Scheduler = @import("../Scheduler.zig");
const Process   = @import("../Process.zig");

context: *Scheduler,
index: usize,

pub fn init(context: *Scheduler) Self {

    return .{
        .context = context,
        .index = 0,
    };
}

pub fn invoke(self: *Self) void {

    self.index %= self.context.processes.len;
    self.context.current = &self.context.processes.slice()[self.index];
    //self.index += 1;
}

pub fn interval(self: *Self) u32 {

    _ = self;
    return 10_00_000;
}
