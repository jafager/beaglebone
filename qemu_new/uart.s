.syntax unified



.text



.global uart_init
uart_init:

	/* No initialization required for QEMU */

	bx lr



.global uart_putc
uart_putc:

	/* Output the character in r1 on the UART address in r0 */
	strb r1, [r0]

	bx lr



.global uart_puts
uart_puts:

	push {lr}
	push {r1-r2}

uart_puts_next_character:

	/* Load the next character */
	ldrb r2, [r1]

	/* If the character is 0, we've reached the end of the string, so return */
	cmp r2, 0
	popeq {r1-r2}
	popeq {pc}

	/* Output the character */
	push {r1}
	mov r1, r2
	bl uart_putc
	pop {r1}

	/* Move the pointer to the next character */
	add r1, r1, 1
	b uart_puts_next_character
