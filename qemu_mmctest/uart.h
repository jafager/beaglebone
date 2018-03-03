#ifndef UART_H
#define UART_H



#include "stdint.h"



void uart_init(uint32_t base_address);
void uart_puts(uint32_t base_address, uint8_t *string);
void uart_putc(uint32_t base_address, uint8_t character);
uint8_t uart_getc(uint32_t base_address);



#endif /* UART_H */
