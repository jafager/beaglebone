MEMORY
{
    sram : ORIGIN = 0x00010000, LENGTH = 0x07ff0000
}

SECTIONS
{
    .text : { *(.text*) } > sram
    . = . + 0x1000;
    stack_abort = .;
    . = . + 0x1000;
    stack_undefined = .;
    . = . + 0x1000;
    stack_irq = .;
    . = . + 0x1000;
    stack_fiq = .;
    . = . + 0x1000;
    stack_supervisor = .;
    translation_table = ALIGN(0x4000);
    . = translation_table + 0x4000;
}
