#ifndef UART_H
#define UART_H



#include "stdint.h"



#define UART0           0x16000000
#define UART1           0x17000000

#define UART_UARTDR     0x000
#define UART_UARTFR     0x018
#define UARTFR_RXFE     (1 << 4)



void uart_puts(uint32_t base_address, uint8_t *string);
void uart_putc(uint32_t base_address, uint8_t character);
uint8_t uart_getc(uint32_t base_address);



#endif /* UART_H */
