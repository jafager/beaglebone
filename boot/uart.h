#ifndef UART_H
#define UART_H



#include "stdint.h"



#define UART0           0x44e09000
#define UART1           0x48022000
#define UART2           0x48024000
#define UART3           0x481a6000
#define UART4           0x481a8000
#define UART5           0x481aa000



#define UART_DLH                        0x04
#define UART_DLH_115200                 (0x00 << 0)
#define UART_DLH_MASK                   (0xff << 0)
#define UART_DLL                        0x00
#define UART_DLL_115200                 (0x1a << 0)
#define UART_DLL_MASK                   (0xff << 0)
#define UART_LCR                        0x0c
#define UART_LCR_DLAB                   (1 << 7)
#define UART_LCR_FRAME                  (0b111111 << 0)
#define UART_LCR_FRAME_8N1              (0b000011 << 0)
#define UART_LSR                        0x14
#define UART_LSR_RXFIFOE                (1 << 0)
#define UART_LSR_TXFIFOE                (1 << 5)
#define UART_MDR1                       0x20
#define UART_MDR1_MODESELECT            (0b111 << 0)
#define UART_MDR1_MODESELECT_UART16X    (0b000 << 0)
#define UART_SYSC                       0x54
#define UART_SYSC_IDLEMODE_MASK         (0b11 << 3)
#define UART_SYSC_IDLEMODE_NO_IDLE      (0b01 << 3)
#define UART_SYSC_SOFTRESET             (1 << 1)
#define UART_SYSS                       0x58
#define UART_SYSS_RESETDONE             (1 << 0)
#define UART_THR                        0x00



void uart_init(uint32_t base_address);
void uart_puts(uint32_t base_address, uint8_t *string);
void uart_putc(uint32_t base_address, uint8_t character);
uint8_t uart_getc(uint32_t base_address);



#endif /* UART_H */
