#include "stdint.h"
#include "uart.h"
#include "console.h"



void console_puts(uint8_t *string)
{
    uart_puts(CONSOLE, string);
}
