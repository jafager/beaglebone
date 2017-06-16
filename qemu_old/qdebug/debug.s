.syntax unified


.text


/* debug_print_hex: print the contents of r0 in hexadecimal on the console */

.global debug_print_hex
debug_print_hex:

	value	.req r0
	width	.req r1
	digit	.req r2

	mov width, 32

dph_next_digit:

	push {lr}

	sub width, width, 4
	mov digit, value, lsr width
	and digit, digit, 0xf
	add digit, digit, '0'
	cmp digit, '9'
	addhi digit, digit, 39

	push {r0-r2}
	mov r0, digit
	bl console_putc
	pop {r0-r2}

	cmp width, 0
	bne dph_next_digit

	pop {pc}


/* debug_print_bin: print the contents of r0 in binary on the console */

.global debug_print_bin
debug_print_bin:

	value	.req r0
	width	.req r1
	digit	.req r2

	mov width, 32

dpb_next_digit:

	push {lr}

	sub width, width, 1
	mov digit, value, lsr width
	and digit, digit, 0x1
	add digit, digit, '0'

	push {r0-r2}
	mov r0, digit
	bl console_putc
	pop {r0-r2}

	cmp width, 0
	bne dpb_next_digit

	pop {pc}
