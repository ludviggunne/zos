.section ".text.boot"
.globl _start

_start:
    // Halt non primary cores
    mrs     x0, mpidr_el1
    and     x0, x0, #0xFF
    cmp     x0, #0x00
    beq     main_core
    b       spin_core

main_core:

    // Disable MMU & caches for EL1
    mov     x0, #0
    msr     sctlr_el1, x0

    // Set execution state to aarch64
    mov     x0, #(1 << 31)
    msr     hcr_el2, x0

    // Use EL1h and mask interrupts
    mov     x0, #((7 << 6) | (5 << 0))
    msr     spsr_el2, x0
    mrs     x1, cpacr_el1

    // Don't trap SVE instructions
    // This is a quick fix because I can't figure out how 
    // to prevent zig from generating these instructions
    mov     x0, #((3 << 20) | (3 << 16))
    orr     x0, x1, x0
    msr     cpacr_el1, x0
    
    // Transition from EL2 to EL1
    adr     x0, el1_entry
    msr     elr_el2, x0
    eret

el1_entry:
    // Setup stack
    ldr     x0, =__kernel_stack
    mov     sp, x0
    // Start chainloader
    b       clEntry 

spin_core:
    b       spin_core
