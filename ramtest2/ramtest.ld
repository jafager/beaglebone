MEMORY
{
    sram : ORIGIN = 0x402f0400, LENGTH = 0x0001b400
}

SECTIONS
{
    .text : { *(.text*) } > sram
    .data : { *(.data*) } > sram
    bss_begin = .;
    .bss : { *(.bss*) } > sram
    bss_end = .;
    . = . + 0x1000;
    stack_abt = .;
    . = . + 0x1000;
    stack_fiq = .;
    . = . + 0x1000;
    stack_irq = .;
    . = . + 0x1000;
    stack_und = .;
    . = . + 0x1000;
    stack_svc = .;
}
