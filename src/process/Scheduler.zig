

const Self = @This();

const std = @import("std");

// Scheduling policy is selected here
const Policy = @import("policy/RoundRobin.zig");

const Process   = @import("Process.zig");
const ProcDescr = @import("ProcDescr.zig");
const aarch64   = @import("../aarch64.zig");
const symbols   = @import("../symbols.zig");
const timer     = @import("../peripherals/timer.zig");
const uart      = @import("../peripherals/uart.zig");
const utils     = @import("../utils.zig");

const max_processes: usize = 32;

processes: std.BoundedArray(Process, max_processes),
current: ?*Process,
id_count: u32,
policy: Policy,

pub var instance: Self = undefined;

pub fn init(self: *Self) !void {
    
    self.id_count = 0;

    self.* = .{
        .processes = try @TypeOf(self.processes).init(0),
        .current = null,
        .id_count = 0,
        .policy = Policy.init(self),
    };
}

pub fn schedule(self: *Self, descr: ProcDescr) !u32 {

    var proc: Process = .{
        .id = self.id_count,
        .status = .uninitialized,
        .context = .{
            .sp = descr.stack,
        },
    };

    proc.context.pc().* = descr.entry;
    try self.processes.append(proc);
    uart.writer.print("Scheduled process id={d}.\n", .{ proc.id, })
        catch unreachable;
    self.id_count += 1;
    return proc.id;
}

pub fn begin(self: *Self) !void {

    if (self.processes.len == 0) {
        uart.writer.print("Begin called with no processes scheduled.\n", .{})
            catch unreachable;
        return error.NoneScheduled;
    } 

    const current = &self.processes.slice()[0];
    uart.writer.print("Initializing first process id={d}.\n", .{ current.id })
        catch unreachable;
    timer.init(.scheduler, self.policy.interval());
    symbols.@"process.context" = &current.context;
    self.current = current;
    self.current.?.context.x0 = 1;
    self.current.?.context.x1 = 2;
    self.current.?.context.x2 = 3;
    self.current.?.context.x3 = 4;
}

pub fn invoke(self: *Self) void {

    if (self.current == null) { 
        uart.writer.print(" -> Switch invoked with no running processes.\n", .{})
            catch unreachable;
        return;
    }
    self.policy.invoke();
    const current = self.current.?;
    uart.writer.print(" -> Switched to process id={d}\n", .{ current.id, })
        catch unreachable;
    symbols.@"process.context" = &current.context;
    current.context.print();
    assertAlignment();
    aarch64.storeSysReg(
        .elr_el1,
        @intFromPtr(current.context.pc().*)
    );
}

pub export fn handleSwitchException() void {

    uart.writer.print("Interrupt request", .{}) catch unreachable;

    const status = timer.getStatus();
    if (status.contains(.scheduler)) {
        uart.writer.print(" -> Scheduler invoked", .{}) catch unreachable;
        instance.invoke();
        timer.reset(
            .scheduler,
            instance.policy.interval()
        ); 
    }

    uart.writer.print("\n", .{}) catch unreachable;
}

pub fn assertAlignment() void {
    if (!utils.isAligned(16, symbols.@"process.context")) {
        uart.writer.print("!!! process.context is misaligned !!!\n", .{})
            catch unreachable;
    }
}
