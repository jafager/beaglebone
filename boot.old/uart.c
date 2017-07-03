#include <stdint.h>
#include "reg.h"
#include "uart.h"



int uart_init(uint32_t base_address)
{
    // TODO: implement
    return 0;
}



int uart_putc(uint32_t base_address, unsigned char character)
{
    uint32_t counter = 0;
    while(!(read32(base_address + UART_LSR) & UART_LSR_TXFIFOE))
        if(counter++ > LOOP_TIMEOUT)
            return 1;
    write32(base_address + UART_THR, character);
    return 0;

}



int uart_puts(uint32_t base_address, unsigned char *string)
{
    // TODO: implement
    return 0;
}



unsigned char uart_getc(uint32_t base_address)
{
    // TODO: implement
    return 0;
}
