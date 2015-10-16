.syntax unified


uart_sysc			= 0x54
uart_sysc_softreset	= 1
uart_sysc_idlemode	= 3
uart_syss			= 0x58
uart_syss_resetdone	= 0
uart_lcr			= 0x0c
uart_dll			= 0x00
uart_dlh			= 0x04
uart_mdr1			= 0x20
uart_lsr			= 0x14
uart_lsr_txfifoe	= 5
uart_thr			= 0x00


.text


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
	beq wait_for_reset

	/* Disable smart idle */
	mov tmp, (1 << uart_sysc_idlemode)
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


.global uart_putc
uart_putc:

	uart_base	.req r0
	character	.req r1
	tmp			.req r2

	/* Wait until the transmit FIFO is empty */
wait_to_transmit:
	ldr tmp, [uart_base, uart_lsr]
	tst tmp, (1 << uart_lsr_txfifoe)
	beq wait_to_transmit

	/* Put character in the transmit FIFO */
	str character, [uart_base, uart_thr]

	bx lr
	.unreq uart_base
	.unreq character
	.unreq tmp
