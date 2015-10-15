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

	ldr base, =ctrl_base
	mov tmp, 0x27
	str tmp, [base, ctrl_conf_gpmc_a5]
	str tmp, [base, ctrl_conf_gpmc_a6]
	str tmp, [base, ctrl_conf_gpmc_a7]
	str tmp, [base, ctrl_conf_gpmc_a8]

	ldr base, =cm_per_base
	mov tmp, 2
	str tmp, [base, cm_per_gpio1_clkctrl]

	ldr base, =gpio1_base
	ldr tmp, [base, gpio_oe]
	@bfc tmp, 21, 4
	bic tmp, tmp, (0xf << 21)
	str tmp, [base, gpio_oe]

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
	and pattern, pattern, 0xf
	lsl pattern, pattern, 21
	str pattern, [gpio_base, gpio_setdataout]

	bx lr
	.unreq pattern
	.unreq gpio_base


.global led_write
led_write:

	pattern			.req r0

	push {lr}

	eor pattern, pattern, pattern
	bl led_clear
	eor pattern, pattern, pattern
	bl led_set

	pop {pc}
	.unreq pattern
