.syntax unified



uartdr  = 0x000



.text



.global uart_init
uart_init:

    /* NB: No initialization needed under QEMU */

    bx lr



.global uart_putc
uart_putc:

    /* NB: The QEMU PL011 implementation never runs out of FIFO space so there's no need to worry about buffer overrun */

    uart_base   .req r0
    character   .req r1

    strb character, [uart_base, uartdr]

    bx lr

    .unreq uart_base
    .unreq character



.global uart_puts
uart_puts:

    uart_base   .req r4
    string      .req r5
    character   .req r6

    push {r4-r6,lr}

    mov uart_base, r0
    mov string, r1

uart_puts_next_character:

    ldrb character, [string]
    cmp character, 0
    popeq {r4-r6,pc}
    mov r0, uart_base
    mov r1, character
    bl uart_putc
    add string, string, 1
    b uart_puts_next_character

    .unreq uart_base
    .unreq string
    .unreq character
