MEMORY
{
	sram : ORIGIN = 0x402f0400, LENGTH = 0x0001b400
}

SECTIONS
{
	.text : { *(.text*) } > sram
	. = . + 0x1000;
	stack_supervisor = .;
	. = . + 0x1000;
	stack_irq = .;
	interrupt_vector_table = .;
	. = . + 0x20;
}
