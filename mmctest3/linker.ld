MEMORY
{
	sram : ORIGIN = 0x402f0400, LENGTH = 0x0001b400
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
