
pub const entry = @extern(*anyopaque, .{ .name = "__user1_begin", });
pub const stack = @extern(*anyopaque, .{ .name = "__user1_stack", });
