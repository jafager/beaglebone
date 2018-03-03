MEMORY
{
    ram : ORIGIN = 0x00100000, LENGTH = 0x00100000
}

SECTIONS
{
    .text : { *(.text*) } > ram
    .data : { *(.data*) } > ram

    bss_begin = .;
        .bss : { *(.bss*) } > ram
    bss_end = .;

    stack_abt_bottom = .;
        . = . + 0x1000;
    stack_abt_top = .;

    stack_fiq_bottom = .;
        . = . + 0x1000;
    stack_fiq_top = .;

    stack_irq_bottom = .;
        . = . + 0x1000;
    stack_irq_top = .;

    stack_und_bottom = .;
        . = . + 0x1000;
    stack_und_top = .;

    stack_svc_bottom = .;
        . = . + 0x1000;
    stack_svc_top = .;
}
