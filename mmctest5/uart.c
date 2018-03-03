#include "stdint.h"
#include "reg.h"
#include "uart.h"



void uart_init(uint32_t base_address)
{
    /* Initiate soft reset */
    regwrite32(base_address + UART_SYSC, UART_SYSC_SOFTRESET);

    /* Wait for reset to complete */
    while (!(regread32(base_address + UART_SYSS) & UART_SYSS_RESETDONE));
    /* TODO: implement a timeout */

    /* Disable idle mode */
    regmask32(base_address + UART_SYSC, UART_SYSC_IDLEMODE_MASK, UART_SYSC_IDLEMODE_NO_IDLE);

    /* Set baud rate to 115,200 */
    regmask32(base_address + UART_LCR, UART_LCR_DLAB, UART_LCR_DLAB);
    regmask32(base_address + UART_DLL, UART_DLL_MASK, UART_DLL_115200);
    regmask32(base_address + UART_DLH, UART_DLH_MASK, UART_DLH_115200);
    regmask32(base_address + UART_LCR, UART_LCR_DLAB, 0);

    /* Set frame formatting to 8N1 */
    regmask32(base_address + UART_LCR, UART_LCR_FRAME, UART_LCR_FRAME_8N1);

    /* Set mode to UART 16x */
    regmask32(base_address + UART_MDR1, UART_MDR1_MODESELECT, UART_MDR1_MODESELECT_UART16X);
}



void uart_puts(uint32_t base_address, uint8_t *string)
{
    uint8_t *character = string;
    while (*character)
        uart_putc(base_address, *character++);
}



void uart_putc(uint32_t base_address, uint8_t character)
{
    while (!(regread32(base_address + UART_LSR) & UART_LSR_TXFIFOE));
    regwrite32(base_address + UART_THR, character);
}



uint8_t uart_getc(uint32_t base_address)
{
    while (!(regread32(base_address + UART_LSR) & UART_LSR_RXFIFOE));
    return regread32(base_address + UART_RHR);
}
