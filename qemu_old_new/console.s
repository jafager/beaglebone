.syntax unified



uart0_base  = 0x16000000



.text



.global console_init
console_init:

    push {lr}

    ldr r0, =uart0_base
    bl uart_init

    pop {pc}



.global console_putc
console_putc:

    push {lr}

    mov r1, r0
    ldr r0, =uart0_base
    bl uart_putc

    pop {pc}



.global console_puts
console_puts:

    push {lr}

    mov r1, r0
    ldr r0, =uart0_base
    bl uart_puts

    pop {pc}



.global console_hexprint
console_hexprint:

    word    .req r4
    bits    .req r5
    digit   .req r6

    push {r4-r6,lr}

    mov word, r0
    mov bits, 32

console_hexprint_next_digit:

    sub bits, bits, 4
    mov digit, word, lsr bits
    and digit, digit, 0xf
    add digit, digit, '0'
    cmp digit, '9'
    addhi digit, digit, 39
    mov r0, digit
    bl console_putc
    cmp bits, 0
    bne console_hexprint_next_digit

    pop {r4-r6,pc}

    .unreq word
    .unreq bits
    .unreq digit



.global console_pretty_hexprint
console_pretty_hexprint:

    string  .req r4

    push {r4,lr}

    mov string, r0
    mov r0, '0'
    bl console_putc
    mov r0, 'x'
    bl console_putc
    mov r0, string
    bl console_puts
    mov r0, '\r'
    bl console_putc
    mov r0, '\n'
    bl console_putc

    pop {r4,pc}

    .unreq string
