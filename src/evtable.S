
.globl evtable_init
.section .text

// Dereference pointer, puts value in same register
.macro deref reg
    ldr     \reg, [\reg]
.endm

// Push reg to stack
.macro push reg
    str     \reg, [sp, #-8]!
.endm

// Pop reg from stack
.macro pop reg
    ldr     \reg, [sp], #8
.endm

// Mask interrupts
.macro irq_mask
    str     x0, [sp, #-8]!
    mov     x0, #(0b1111 << 6)
    msr     daif, x0
    ldr     x0, [sp], #8
.endm

// Unmask interrupts
.macro irq_unmask
    msr     daif, xzr
.endm

// Saves general registers and stack pointer
//  to Context struct pointed to by process.context.*
.macro save_process_context

    // Get current Process.Context struct address
    push    x29
    str     x29, [sp, #-8]!
    ldr     x29, process.context
    deref   x29

    stp     x0, x1, [x29], #16
    stp     x2, x3, [x29], #16
    stp     x4, x5, [x29], #16
    stp     x6, x7, [x29], #16
    stp     x8, x9, [x29], #16
    stp     x10, x11, [x29], #16
    stp     x12, x13, [x29], #16
    stp     x14, x15, [x29], #16
    stp     x16, x17, [x29], #16
    stp     x18, x19, [x29], #16
    stp     x20, x21, [x29], #16
    stp     x22, x23, [x29], #16
    stp     x24, x25, [x29], #16
    stp     x26, x27, [x29], #16
    str     x28, [x30], #8

    // We put pointer in x0 instead
    //  so we can save x29 and x30
    mov     x0, x29
    pop     x29
    stp     x29, x30, [x0], #16

    // Save stack pointer
    mov     x1, sp
    str     x1, [x0]

.endm

// Restores general registers and stack pointer
//  to values specified in Context struct pointed to
//  by process.context.*
.macro restore_process_context
    
    // Get current Process.Current struct address
    ldr     x29, =process.context
    deref   x29

    // Restore stack pointer
    ldr     x0, =stack_pointer.offset
    deref   x0

    // Add offset to struct pointer to get address of sp field
    add     x0, x0, x29
    deref   x0
    mov     sp, x0
    
    // Restore general registers 
    ldp     x0, x1, [x29], #16      
    ldp     x2, x3, [x29], #16      
    ldp     x4, x5, [x29], #16      
    ldp     x6, x7, [x29], #16      
    ldp     x8, x9, [x29], #16      
    ldp     x10, x11, [x29], #16      
    ldp     x12, x13, [x29], #16      
    ldp     x14, x15, [x29], #16      
    ldp     x16, x17, [x29], #16      
    ldp     x18, x19, [x29], #16      
    ldp     x20, x21, [x29], #16      
    ldp     x22, x23, [x29], #16      
    ldp     x24, x25, [x29], #16      
    ldp     x26, x27, [x29], #16      
    ldr     x28, [x29], #8
    push    x0
    mov     x0, x29
    ldp     x29, x30, [x0]
    pop     x0
    
.endm

.macro save_kernel_stack_pointer
    mov     x1, sp
    ldr     x0, =kernel.stack_pointer
    str     x1, [x0]
.endm

.macro restore_kernel_stack_pointer
    ldr     x0, =kernel.stack_pointer    
    deref   x0
    mov     sp, x0 
.endm

.macro switch_begin
    irq_mask
    save_process_context
//    restore_kernel_stack_pointer    
.endm

.macro switch_end
//    save_kernel_stack_pointer
    restore_process_context
    irq_unmask
    eret
.endm

.macro unimplemented type
    mov     x0, \type
    b       unimplHandlerErr
.endm

.p2align 11        // 11 ls bits of vbar_el1 are reserved
evtable:
    // sync_e1t
    unimplemented 0x0
    .balign  0x80

    // irq_e1t
    unimplemented 0x1
    .balign  0x80

    // fiq_e1t
    unimplemented 0x2
    .balign  0x80

    // serror_e1t
    unimplemented 0x3
    .balign  0x80

    // sync_e1h
    unimplemented 0x4
    .balign  0x80

    // irq_e1h
    b       switch
    .balign  0x80

    // fiq_e1h
    unimplemented 0x6
    .balign  0x80

    // serror_e1h
    unimplemented 0x7
    .balign  0x80

    // sync_e0_64
    unimplemented 0x8
    .balign  0x80

    // irq_e0_64
    unimplemented 0x9
    .balign  0x80

    // fiq_e0_64
    unimplemented 0xa
    .balign  0x80

    // serror_e0_64
    unimplemented 0xb
    .balign  0x80

    // sync_e0_32
    unimplemented 0xc
    .balign  0x80

    // irq_e0_32
    unimplemented 0xd
    .balign  0x80

    // fiq_e0_32
    unimplemented 0xe
    .balign  0x80

    // serror_e0_32
    unimplemented 0xf
    .balign  0x80

switch:
    switch_begin
    bl      handleSwitchException
    switch_end
