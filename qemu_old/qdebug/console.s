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
