.syntax unified


uart0_base	= 0x16000000


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

/* console_pretty_hexprint: pretty print the value of r0 in hex to the console */

.global console_pretty_hexprint
console_pretty_hexprint:

    push {r0, lr}

    mov r0, '0'
    bl console_putc
    mov r0, 'x'
    bl console_putc

    pop {r0}
    bl console_hexprint

    mov r0, '\r'
    bl console_putc
    mov r0, '\n'
    bl console_putc

    pop {pc}


/* console_hexprint: print the value of r0 in hex to the console */

.global console_hexprint
console_hexprint:

    push {lr}

    mov r1, 32

next_digit:

    sub r1, r1, 4
    mov r2, r0, lsr r1
    and r2, r2, 0xf
    add r2, r2, '0'
    cmp r2, '9'
    addhi r2, r2, 39
    push {r0-r3}
    mov r0, r2
    bl console_putc
    pop {r0-r3}
    cmp r1, 0
    bne next_digit

    pop {pc}

