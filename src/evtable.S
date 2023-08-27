
.globl evtable_init
.globl evtable
.section .text

// Every entry simply passes the exception type
// as a number to a generic handler
.macro  evtentry   label
    excep_begin
    mov     x0, #\@
    bl      handleException
    excep_end
    .balign 0x80
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
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry
    evtentry