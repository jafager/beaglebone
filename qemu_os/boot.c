#include "console.h"



void boot(void)
{
    console_init();

    for (uint32_t value = 0; value < 1000000; value += 999)
    {
        console_print_binary(value);
        console_print("    ");
        console_print_hexadecimal(value);
        console_print("    ");
        console_print_decimal(value);
        console_println("");
    }
    while (1);
}
