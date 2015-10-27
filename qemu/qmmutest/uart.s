.syntax unified


.text


.global uart_init
uart_init:

	/* No initialization needed under QEMU */

	bx lr


.global uart_putc
uart_putc:

	/* Output the character in r1 on the UART address in r0 */
	strb r1, [r0]

	bx lr


.global uart_puts
uart_puts:

	push {lr}

uart_puts_next_character:

	ldrb r2, [r1]
	cmp r2, 0
	popeq {pc}
	push {r0-r1}
	mov r1, r2
	bl uart_putc
	pop {r0-r1}
	add r1, r1, 1
	b uart_puts_next_character
