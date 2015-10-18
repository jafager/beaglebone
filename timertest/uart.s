.syntax unified


uart_lsr				= 0x14
uart_lsr_txfifoe		= 5
uart_thr				= 0x00
uart_sysc				= 0x54
uart_sysc_softreset		= 1
uart_sysc_idlemode		= 3
uart_syss				= 0x58
uart_syss_resetdone		= 0
uart_dll				= 0x00
uart_dlh				= 0x04
uart_lcr				= 0x0c
uart_mdr1				= 0x20


.text


/* uart_init: initialize the UART with base address in r0 */

.global uart_init
uart_init:

	uart_base	.req r0
	tmp			.req r1

	/* Initiate soft reset */
	mov tmp, (1 << uart_sysc_softreset)
	str tmp, [uart_base, uart_sysc]

	/* Wait for soft reset to complete */
	wait_for_reset:
	ldr tmp, [uart_base, uart_syss]
	tst tmp, (1 << uart_syss_resetdone)

	/* Disable smart idle */
	ldr tmp, [uart_base, uart_sysc]
	bic tmp, tmp, (0x3 << uart_sysc_idlemode)
	orr tmp, tmp, (0x1 << uart_sysc_idlemode)
	str tmp, [uart_base, uart_sysc]

	/* Set the divisor */
	mov tmp, 0xbf /* to access the uart_dll and uart_dlh registers */
	str tmp, [uart_base, uart_lcr]
	mov tmp, 0x1a /* 115,200 baud, low byte */
	str tmp, [uart_base, uart_dll]
	mov tmp, 0x00 /* 115,200 baud, high byte */
	str tmp, [uart_base, uart_dlh]

	/* Set frame formatting */
	mov tmp, 0x03 /* 8N1 */
	str tmp, [uart_base, uart_lcr]

	/* Set UART mode */
	mov tmp, 0 /* 16x UART */
	str tmp, [uart_base, uart_mdr1]

	bx lr
	.unreq uart_base
	.unreq tmp


/* uart_putc: output the character in r0 to the UART with base address in r1 */
.global uart_putc
uart_putc:

	character	.req r0
	uart_base	.req r1
	tmp			.req r2

	/* Sanitize input */
	and character, character, 0xff

	/* Wait for transmit fifo to be empty */
wait_to_transmit:
	ldr tmp, [uart_base, uart_lsr]
	tst tmp, (1 << uart_lsr_txfifoe)
	beq wait_to_transmit

	/* Put character in transmit FIFO */
	str character, [uart_base, uart_thr]

	bx lr
	.unreq character
	.unreq uart_base
	.unreq tmp


/* uart_puts: output the null-terminated string at address r0 to the UART with base address in r1 */

.global uart_puts
uart_puts:

	character   .req r0
	uart_base	.req r1
	string      .req r2

	push {lr}

	mov string, r0

next_character:

	ldrb character, [string]
	cmp character, 0
	beq end_of_string
	bl uart_putc
	add string, string, 1
	b next_character

end_of_string:

	pop {pc}
	.unreq character
	.unreq string
