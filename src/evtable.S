
/*
    Exception Vector Table (EL1)
*/

#include "exception.h"

.globl evtable_init
.globl evtable

.macro  evtentry   label
b       \label
.balign 0x80
.endm

.macro unimplemented_handler type
excep_begin
ldr     x0, =\type
mrs     x1, elr_el1
mrs     x2, esr_el1
bl      unimplHandlerErr
excep_end
.endm

// Call when entering exception handler
.macro excep_begin
    // Mask interrupts
    str   x0, [sp, #-16]!
    mov   x0, #(0b1111 << 6)
    msr   daif, x0
    ldr   x0, [sp], #16
    // Push registers x0-x30 to stack
    stp   x0, x1, [sp, #-16]!
    stp   x2, x3, [sp, #-16]!
    stp   x4, x5, [sp, #-16]!
    stp   x6, x7, [sp, #-16]!
    stp   x8, x9, [sp, #-16]!
    stp   x10, x11, [sp, #-16]!
    stp   x12, x13, [sp, #-16]!
    stp   x14, x15, [sp, #-16]!
    stp   x16, x17, [sp, #-16]!
    stp   x18, x19, [sp, #-16]!
    stp   x20, x21, [sp, #-16]!
    stp   x22, x23, [sp, #-16]!
    stp   x24, x25, [sp, #-16]!
    stp   x26, x27, [sp, #-16]!
    stp   x28, x29, [sp, #-16]!
    str   x30, [sp, #-16]!
.endm


// Call when exiting exception handler
.macro excep_end
    // Pop registers x0-x30 from stack
    ldr   x30, [sp], #16
    ldp   x28, x29, [sp], #16
    ldp   x26, x27, [sp], #16
    ldp   x24, x25, [sp], #16
    ldp   x22, x23, [sp], #16
    ldp   x20, x21, [sp], #16
    ldp   x18, x19, [sp], #16
    ldp   x16, x17, [sp], #16
    ldp   x14, x15, [sp], #16
    ldp   x12, x13, [sp], #16
    ldp   x10, x11, [sp], #16
    ldp   x8, x9, [sp], #16
    ldp   x6, x7, [sp], #16
    ldp   x4, x5, [sp], #16
    ldp   x2, x3, [sp], #16
    ldp   x0, x1, [sp], #16
    // Unmask interrupts
    msr   daif, xzr
    // Return from exception
    eret
.endm


evtable_init:
    adr       x0, evtable
    msr       vbar_el1, x0
    ret

.align 11        // 11 ls bits of vbar_el1 are reserved
evtable:
    evtentry     Sync_Handler_E1t
    evtentry     IRQ_Handler_E1t
    evtentry     FIQ_Handler_E1t
    evtentry     SError_Handler_E1t

    evtentry     Sync_Handler_E1h
    evtentry     IRQ_Handler_E1h
    evtentry     FIQ_Handler_E1h
    evtentry     SError_Handler_E1h

    evtentry     Sync_Handler_E0_64
    evtentry     IRQ_Handler_E0_64
    evtentry     FIQ_Handler_E0_64
    evtentry     SError_Handler_E0_64

    evtentry     Sync_Handler_E0_32
    evtentry     IRQ_Handler_E0_32
    evtentry     FIQ_Handler_E0_32
    evtentry     SError_Handler_E0_32


Sync_Handler_E1t:
    unimplemented_handler 0

IRQ_Handler_E1t:
    unimplemented_handler 1

FIQ_Handler_E1t:
    unimplemented_handler 2

SError_Handler_E1t:
    unimplemented_handler 3

Sync_Handler_E1h:
    unimplemented_handler 4

IRQ_Handler_E1h:
    unimplemented_handler 5

FIQ_Handler_E1h:
    unimplemented_handler 6

SError_Handler_E1h:
    unimplemented_handler 7

Sync_Handler_E0_64:
    unimplemented_handler 8

IRQ_Handler_E0_64:
    unimplemented_handler 9

FIQ_Handler_E0_64:
    unimplemented_handler 10

SError_Handler_E0_64:
    unimplemented_handler 11

Sync_Handler_E0_32:
    unimplemented_handler 12

IRQ_Handler_E0_32:
    unimplemented_handler 13

FIQ_Handler_E0_32:
    unimplemented_handler 14

SError_Handler_E0_32:
    unimplemented_handler 15