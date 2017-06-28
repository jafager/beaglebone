MEMORY
{
    ram : ORIGIN = 0x04000000, LENGTH = 0x04000000
}

SECTIONS
{
    .text : { *(.text*) } > ram
    .data : { *(.data*) } > ram
    bss_begin = .;
    .bss : { *(.bss*) } > ram
    bss_end = .;
}
