
const std = @import("std");

const Self = @This();

mem: *volatile u32,

pub fn init(addr: u64) Self {
    return .{
        .mem = @ptrFromInt(addr),
    };
}

pub fn write(self: Self, value: u32) void {
    self.mem.* = value;
}

pub fn read(self: Self) u32 {
    return self.mem.*;
}

pub fn set(self: Self, offset: u5, width: u5, value: u32) void {
    var mask = (@as(u32, 1) << (width)) - 1;
    mask <<= offset;
    mask = ~mask;
    self.mem.* &= mask;
    self.mem.* |= value << offset;
}

pub fn set_enum(self: Self, offset: u5, value: anytype) void {
    switch (@typeInfo(@TypeOf(value))) {
        .Enum => |Enum| {
            const TagType = Enum.tag_type;
            const bits: u5 = @truncate(@typeInfo(TagType).Int.bits);
            self.set(offset, bits, @intFromEnum(value));
        },
        else => @compileError("Expected enum, found " 
            ++ @typeName(@TypeOf(value))),
    }
}

pub fn get(self: Self, offset: u5, width: u5) u32 {
    var mask = (@as(u32, 1) << width) - 1;
    return mask & (self.mem.* >> offset);
}
