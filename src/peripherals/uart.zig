const aux = @import("aux.zig");
const gpio = @import("gpio.zig");

pub const baudrate: usize = 115200;
const baud_reg_value: u32 = @import("../clock.zig").freq / (baudrate * 8) - 1;

pub fn init() void {
    // Set alt5 for pin 14 & 15 (TDX1 & RDX1)
    gpio.gpfsel1.set_enum(12, gpio.FunctionSelect.alt5);
    gpio.gpfsel1.set_enum(15, gpio.FunctionSelect.alt5);

    // Disable pull-up / -down
    gpio.pup_pdn_cntrl_reg0.set_enum(28, gpio.ResistorSelect.none);
    gpio.pup_pdn_cntrl_reg0.set_enum(30, gpio.ResistorSelect.none);

    aux.enables.write(1); // enable mini UART
    aux.mu_cntl_reg.write(0); // disable transmit & receive, and auto flow control
    aux.mu_ier_reg.write(0); // disable interrupts
    aux.mu_mcr_reg.write(2); // set RTS line high
    aux.mu_baud_reg.write(baud_reg_value); // set baudrate
    aux.mu_lcr_reg.write(3); // enable 8-bit mode
    aux.mu_cntl_reg.set(0, 2, 3); // enable transmit and receive
}

pub fn write(char: u8) void {
    while (aux.mu_lsr_reg.read() & 0x20 == 0) {}
    aux.mu_io_reg.write(char);
}

pub fn writeString(str: []const u8) void {
    for (str) |c| {
        write(c);
    }
}
