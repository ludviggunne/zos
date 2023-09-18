
SECTIONS
{
  . = 0x80000; /* Kernel Load Address */
  __kernel_begin = .;

  .text.boot  : { KEEP(*(.text.boot)) }
  .rodata     : { *(.rodata) }
  .data       : { *(.data) }

  . = ALIGN(0x8);
  __bss_begin = .;
  .bss (NOLOAD) : { *(.bss) }
  __bss_end = .;

  __kernel_end = .;
    
  /* User process 0 */
  . = ALIGN(0x8);
  . = . + 1024;
  __user0_stack = .;
  __user0_begin = .;
  .user0.text._start : { KEEP(*(.user0.text._start)) }
  .user0.text : { KEEP(*(.user0.text)) }
  __user0_end = .;

  /* User process 1 */
  . = ALIGN(0x8);
  . = . + 1024;
  __user1_stack = .;
  __user1_begin = .;
  .user1.text._start : { KEEP(*(.user1.text._start)) }
  .user1.text : { KEEP(*(.user1.text)) }
  __user1_end = .;

  /* /DISCARD/ : { *(.eh_frame) *(.comment)} */
}
