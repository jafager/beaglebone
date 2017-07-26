MEMORY
{
    ram : ORIGIN = 0x80000000, LENGTH = 0x40000000
}

SECTIONS
{
    .text : { *(.text*) } > ram
    .data : { *(.data*) } > ram
    bss_begin = .;
    .bss : { *(.bss*) } > ram
    bss_end = .;
}
