.section ".text.boot"
.globl _start

// Disable MMU & caches for EL1
.set el1_entry_sctlr_el1, 0
// Set execution state to aarch64
.set el1_entry_hcr_el2, 1 << 31
// Use EL1h and mask interrupts
.set el1_entry_spsr_el2, (7 << 6) | (5 << 0)

_start:
    // Halt non primary cores
    mrs     x0, mpidr_el1
    and     x0, x0, #0xFF
    cmp     x0, #0x00
    beq     el1_entry
    b       spin_core
main_core:
    // Transition from EL2 to EL1
    ldr     x0, =el1_entry_sctlr_el1
    msr     sctlr_el1, x0
    ldr     x0, =el1_entry_hcr_el2
    msr     hcr_el2, x0
    ldr     x0, =el1_entry_spsr_el2
    msr     spsr_el2, x0
    adr     x0, el1_entry
    msr     elr_el2, x0
    eret
el1_entry:
    // Setup stack
    ldr     x0, =__kernel_begin
    mov     sp, x0
    // Zero uninitialized data
    ldr     x0, =__bss_begin
    ldr     x1, =__bss_end
    bl      memzero
    bl      kmain
    b       spin_core
spin_core:
    b       spin_core