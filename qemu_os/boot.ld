MEMORY
{
    ram : ORIGIN = 0x00010000, LENGTH = 0x03ff0000
}

SECTIONS
{
    .text : { *(.text*) } > ram
    .data : { *(.data*) } > ram
    bss_begin = .;
    .bss : { *(.bss*) } > ram
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
