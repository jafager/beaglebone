#include "stdint.h"
#include "qemu.h"
#include "uart.h"
#include "console.h"



void console_init(void)
{
    uart_init(CONSOLE);
}



void console_println(uint8_t *string)
{
    console_print(string);
    console_print("\r\n");
}



void console_print(uint8_t *string)
{
    console_puts(string);
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



void console_print_hexadecimal(uint32_t value)
{
    uint32_t bits = 32;
    while (bits > 0)
    {
        bits -= 4;
        uint8_t digit = (value >> bits) & 0xf;
        if (digit > 9)
            digit = digit - 10 + 'a';
        else
            digit = digit + '0';
        console_putc(digit);
    }
}



void console_print_binary(uint32_t value)
{
    uint32_t bits = 32;
    while (bits > 0)
    {
        bits -= 1;
        uint8_t digit = (value >> bits) & 0x1;
        digit += '0';
        console_putc(digit);
        if (((bits % 4) == 0) && (bits > 0))
            console_putc(' ');
    }
}



void console_print_decimal(uint32_t value)
{
    uint32_t remainder = value / 10;
    if (remainder > 0)
        console_print_decimal(remainder);
    uint8_t digit = value % 10;
    digit += '0';
    console_putc(digit);
}
