#ifndef _UART_H_
#define _UART_H_



#define UART_LSR                0x14
#define UART_LSR_TXFIFOE        (1 << 5)
#define UART_LSR_RXFIFOE        (1 << 0)
#define UART_THR                0x00
#define UART_SYSC               0x54
#define UART_SYSC_SOFTRESET     (1 << 1)
#define UART_SYSC_IDLEMODE      (1 << 3)
#define UART_SYSS               0x58
#define UART_SYSS_RESETDONE     (1 << 0)
#define UART_DLL                0x00
#define UART_DLH                0x04
#define UART_LCR                0x0c
#define UART_MDR1               0x20

#define LOOP_TIMEOUT            1024



int uart_init(uint32_t base_address);
int uart_putc(uint32_t base_address, unsigned char character);
int uart_puts(uint32_t base_address, unsigned char *string);
unsigned char uart_getc(uint32_t base_address);



#endif
