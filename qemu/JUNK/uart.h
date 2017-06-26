#ifndef UART_H
#define UART_H

int uart_init(uint32_t base_address);
int uart_putc(uint32_t base_address, uint8_t character);
int uart_puts(uint32_t base_address, uint8_t *string);
uint8_t uart_getc(uint32_t base_address);

#endif /* UART_H */
