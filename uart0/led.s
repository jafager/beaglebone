.syntax unified


ctrl_base				= 0x44e10000
ctrl_conf_gpmc_a5		= 0x854
ctrl_conf_gpmc_a6		= 0x858
ctrl_conf_gpmc_a7		= 0x85c
ctrl_conf_gpmc_a8		= 0x860

cm_per_base				= 0x44e00000
cm_per_gpio1_clkctrl	= 0xac

gpio1_base				= 0x4804c000
gpio_oe					= 0x134
gpio_cleardataout		= 0x190
gpio_setdataout			= 0x194


.text


.global led_init
led_init:

	base	.req r0
	tmp		.req r1

	push {lr}

	/* Set pinmux: LED pins are on GPIO1_21-24 which are multiplexed with GPMC_A5-A8 */
	ldr base, =ctrl_base
	mov tmp, 0x27
	str tmp, [base, ctrl_conf_gpmc_a5]
	str tmp, [base, ctrl_conf_gpmc_a6]
	str tmp, [base, ctrl_conf_gpmc_a7]
	str tmp, [base, ctrl_conf_gpmc_a8]

	/* Enable the clock for the GPIO1 module */
	ldr base, =cm_per_base
	mov tmp, 2
	str tmp, [base, cm_per_gpio1_clkctrl]

	/* Set the LED pins as outputs */
	ldr base, =gpio1_base
	ldr tmp, [base, gpio_oe]
	@bfc tmp, 21, 4
	bic tmp, tmp, (0xf << 21)
	str tmp, [base, gpio_oe]

	/* Clear LEDs on initialization */
	mov r0, 0b1111
	bl led_clear

	pop {pc}
	.unreq base
	.unreq tmp


.global led_clear
led_clear:

	pattern		.req r0
	gpio_base	.req r1

	ldr gpio_base, =gpio1_base

	/* Sanitize argument and shift into the proper position */
	and pattern, pattern, 0xf
	lsl pattern, pattern, 21

	str pattern, [gpio_base, gpio_cleardataout]

	bx lr
	.unreq pattern
	.unreq gpio_base


.global led_set
led_set:

	pattern		.req r0
	gpio_base	.req r1

	ldr gpio_base, =gpio1_base
	
	/* Sanitize argument and shift into the proper position */
	and pattern, pattern, 0xf
	lsl pattern, pattern, 21

	str pattern, [gpio_base, gpio_setdataout]

	bx lr
	.unreq pattern
	.unreq gpio_base


.global led_write
led_write:

	pattern .req r0

	push {lr}

	/* Clear the inverse of the pattern we were passed */
	eor pattern, pattern, pattern
	bl led_clear

	/* Invert it back and set the pattern */
	eor pattern, pattern, pattern
	bl led_set

	pop {pc}
	.unreq pattern
