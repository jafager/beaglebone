#ifndef CONSOLE_H
#define CONSOLE_H



#include "stdint.h"



#define CONSOLE     UART0



void console_puts(uint8_t *string);



#endif /* CONSOLE_H */
