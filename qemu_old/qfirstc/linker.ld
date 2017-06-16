MEMORY
{
	sdram : ORIGIN = 0x00010000, LENGTH = 0x07FF0000
}

SECTIONS
{
	.text : { *(.text*) } > sdram
	.data : { *(.data*) } > sdram
	bss_begin = .;
	.bss : { *(.bss*) } > sdram
	bss_end = .;
	. = . + 0x1000;
	stack_supervisor = .;
}
