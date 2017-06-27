#ifndef CONSOLE_H
#define CONSOLE_H



#include "stdint.h"



#define CONSOLE     UART0



void console_puts(uint8_t *string);
void console_putc(uint8_t character);
uint8_t console_getc(void);
void console_hexprint(uint32_t value);



#endif /* CONSOLE_H */
