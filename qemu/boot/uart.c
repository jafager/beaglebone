#include "stdint.h"
#include "reg.h"
#include "uart.h"



void uart_puts(uint32_t base_address, uint8_t *string)
{
    uint8_t *character = string;
    while (*character)
        uart_putc(base_address, *character++);
}



void uart_putc(uint32_t base_address, uint8_t character)
{
    regwrite32(base_address + UART_UARTDR, character);
}



uint8_t uart_getc(uint32_t base_address)
{
    while (regread32(base_address + UART_UARTFR) & UARTFR_RXFE);
    return regread32(base_address + UART_UARTDR);
}
