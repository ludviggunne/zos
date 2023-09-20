
SECTIONS
{
  . = 0x80000;

  __kernel_stack = .;

  .boot        : { KEEP(*(.text.boot)) }

  .chainloader : { *(.text.chainloader) }

  .shared      : {
                   *(.text.shared)
                   *(.rodata.shared)
                   *(.data.shared)
                 }


  .kernel      : {
                   __kernel_begin = .;
                   *(.text.kernel.start)
                   *(.text*)
                   *(.rodata*)
                   *(.data*)

                   . = ALIGN(0x8);
 
                   __bss_begin = .;
                   *(.bss*)
                   __bss_end = .;
 
                   __kernel_end = .;
 
                   __kernel_size = __kernel_end - __kernel_begin;
                 }

  /*/DISCARD/ : { *(compiler_rt) }*/
}
