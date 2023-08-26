
comptime {
    asm (@embedFile("evtable.S"));
    asm (".section .text");
}

const uart = @import("peripherals/uart.zig");
const excep_strs = [_][]const u8 {
  "Sync E1t",
  "IRQ E1t",
  "FIQ E1t",
  "SError E1t",
  "Sync E1h",
  "IRQ E1h",
  "FIQ E1h",
  "SError E1h",
  "Sync E0 64",
  "IRQ E0 64",
  "FIQ E0 64",
  "SError E0 64",
  "Sync E0 32",
  "IRQ E0 32",
  "FIQ E0 32",
  "SError E0 32"
};


pub export const Sync_E1t: u64 = 0;
pub export const IRQ_E1t: u64 = 1;
pub export const FIQ_E1t: u64 = 2; 
pub export const SError_E1t: u64 = 3; 
pub export const Sync_E1h: u64 = 4; 
pub export const IRQ_E1h: u64 = 5; 
pub export const FIQ_E1h: u64 = 6; 
pub export const SError_E1h: u64 = 7; 
pub export const Sync_E0_64: u64 = 8; 
pub export const IRQ_E0_64: u64 = 9; 
pub export const FIQ_E0_64: u64 = 10; 
pub export const SError_E0_64: u64 = 11; 
pub export const Sync_E0_32: u64 = 12; 
pub export const IRQ_E0_32: u64 = 13; 
pub export const FIQ_E0_32: u64 = 14; 
pub export const SError_E0_32: u64 = 15; 

pub export fn unimplHandlerErr(type_: usize, elr: u64, esr: u64) void {
    uart.writer.print("Unimplemented exception handler error:\n" ++
                      "    Type: {s}\n" ++
                      "    ELR:  {x}\n" ++
                      "    ESR:  {x}\n",
        .{ excep_strs[type_], elr, esr}
    ) catch unreachable;
}