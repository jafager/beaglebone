MEMORY
{
	sdram : ORIGIN = 0x00010000, LENGTH = 0x07FF0000
}

SECTIONS
{
	.text : { *(.text*) } > sdram
	. = . + 0x1000;
	stack_supervisor = .;
}
