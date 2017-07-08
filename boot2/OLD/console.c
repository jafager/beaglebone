#include "stdint.h"
#include "uart.h"
#include "console.h"



void console_init(void)
{
    uart_init(CONSOLE);
}



void console_puts(uint8_t *string)
{
    uart_puts(CONSOLE, string);
}



void console_putc(uint8_t character)
{
    uart_putc(CONSOLE, character);
}



uint8_t console_getc(void)
{
    return uart_getc(CONSOLE);
}



void console_hexprint(uint32_t value)
{
    uint32_t bits = 32;
    while (bits > 0)
    {
        bits -= 4;
        uint32_t digit = ((value >> bits) & 0xf) + 48;
        if (digit > 57)
            digit += 39;
        console_putc(digit);
    }
}
