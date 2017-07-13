#ifndef CONSOLE_H
#define CONSOLE_H



#include "stdint.h"



void console_init(void);
void console_println(uint8_t *string);
void console_print(uint8_t *string);
void console_puts(uint8_t *string);
void console_putc(uint8_t character);
uint8_t console_getc(void);
void console_print_hexadecimal(uint32_t value);
void console_print_binary(uint32_t value);
void console_print_decimal(uint32_t value);



#endif /* CONSOLE_H */
