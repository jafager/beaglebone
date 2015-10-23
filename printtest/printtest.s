.syntax unified


.text


.global printtest
printtest:

	/* Set up the processor (disable IRQ/FIQ, Supervisor mode) */
	mrs r0, cpsr
	bic r0, r0, 0x1f
	orr r0, r0, 0x13
	msr cpsr, r0

	/* Set up Supervisor mode stack */
	ldr sp, =stack_supervisor

	/* Initialize console */
	bl console_init

	/* Print some values */

	ldr r0, =0xdeadbeef
	bl pretty_hexprint
	ldr r0, =0xdeadbeef
	bl pretty_binprint

	ldr r0, =0xfeedabba
	bl pretty_hexprint
	ldr r0, =0xfeedabba
	bl pretty_binprint

	ldr r0, =0x01234567
	bl pretty_hexprint
	ldr r0, =0x01234567
	bl pretty_binprint


hang:

	b hang


.global hexprint
hexprint:

	value		.req r0
	shift_width	.req r1
	digit		.req r2

	mov shift_width, 32

next_digit:

	/* Isolate the current digit */
	sub shift_width, shift_width, 4
	mov digit, value, lsr shift_width
	and digit, digit, 0xf
	cmp digit, 0x9
	addhi digit, 39
	add digit, digit, '0'

	/* Output the digit on the console */
	push {r0-r2, lr}
	mov r0, digit
	bl console_putc
	pop {r0-r2, lr}

	/* If there are more digits, repeat for the next digit */
	cmp shift_width, 0
	bne next_digit

	bx lr
	.unreq value
	.unreq shift_width
	.unreq digit


.global pretty_hexprint
pretty_hexprint:

	push {r0, lr}

	mov r0, '0'
	bl console_putc

	mov r0, 'x'
	bl console_putc

	pop {r0}
	bl hexprint

	mov r0, '\r'
	bl console_putc

	mov r0, '\n'
	bl console_putc

	pop {pc}


.global binprint
binprint:

	value		.req r0
	shift_width	.req r1
	digit		.req r2

	mov shift_width, 32

next_binary_digit:

	/* Isolate the current digit */
	sub shift_width, shift_width, 1
	mov digit, value, lsr shift_width
	and digit, digit, 0x1
	add digit, digit, '0'

    /* Output the digit on the console */
    push {r0-r2, lr}
    mov r0, digit
    bl console_putc
    pop {r0-r2, lr}

    /* If there are more digits, repeat for the next digit */
    cmp shift_width, 0
    bne next_binary_digit

    bx lr
	.unreq value
	.unreq shift_width
	.unreq digit


.global pretty_binprint
pretty_binprint:

	push {r0, lr}

	mov r0, '0'
	bl console_putc

	mov r0, 'b'
	bl console_putc

	pop {r0}
	bl binprint

	mov r0, '\r'
	bl console_putc

	mov r0, '\n'
	bl console_putc

	pop {pc}


