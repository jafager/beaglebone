#ifndef UART_H
#define UART_H



#include "stdint.h"



#define UART0           0x16000000
#define UART1           0x17000000

#define UART_UARTDR     0x000



void uart_puts(uint32_t base_address, uint8_t *string);
void uart_putc(uint32_t base_address, uint8_t character);



#endif /* UART_H */
