#ifndef QEMU_H
#define QEMU_H



#define CONSOLE         UART0

#define UART0           0x16000000
#define UART1           0x17000000

#define UART_UARTDR     0x000
#define UART_UARTFR     0x018
#define UARTFR_RXFE     (1 << 4)



#endif /* QEMU_H */
