#include "uart.h"
#include "reg.h"


void uart_init(uint32_t base_address)
{
    /* Initiate soft reset */
    regwrite32(base_address + UART_SYSC, UART_SYSC_SOFTRESET);

    /* Wait for soft reset to complete */
    while (!(regread32(base_address + UART_SYSS) & UART_SYSS_RESETDONE));

    /* Disable smart idle */
    regmask32(base_address + UART_SYSC, UART_SYSC_IDLEMODE, UART_SYSC_IDLEMODE_DISABLE);

    /* Set the divisor */
    regmask32(base_address + UART_LCR, UART_LCR_DIV_EN, UART_LCR_DIV_EN_ENABLE);
    write32(base_address + UART_DLL, UART_DLL_115200);
    write32(base_address + UART_DLH, UART_DLH_115200);
    regmask32(base_address + UART_LCR, UART_LCR_DIV_EN, UART_LCR_DIV_EN_DISABLE);
    
    /* Set 8N1 */


}



void uart_putc(uint32_t base_address, uint8_t character)
{
    while(!uart_transmit_fifo_empty(base_address));
    regwrite32(base_address + UART_THR, character);
}



void uart_puts(uint32_t base_address, uint8_t *string)
{
    uint8_t *next_character = string;
    uint32_t status;
    if (*next_character)
        uart_putc(base_address, next_character++);
}



uint8_t uart_getc(uint32_t base_address)
{
    while(uart_receive_fifo_empty(base_address));
    return regread32(base_address + UART_RHR);
}
