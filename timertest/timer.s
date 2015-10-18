.syntax unified


cm_per_base				= 0x44e00000
cm_per_l3s_clkstctrl	= 0x04
cm_per_timer2_clkctrl	= 0x80

dmtimer2_base			= 0x48040000

timer_tclr				= 0x38


.text


.global timer_init
timer_init:

	base	.req r0
	tmp		.req r1

	/* Enable clocks required for TIMER7 module */

	ldr base, =cm_per_base

	ldr tmp, [base, cm_per_l3s_clkstctrl]
	bic tmp, 0x3 /* clear CLKTRCTL bits */
	orr tmp, 0x2 /* set CLKTRCTL to SW_WKUP */
	str tmp, [base, cm_per_l3s_clkstctrl]

	ldr tmp, [base, cm_per_timer2_clkctrl]
	bic tmp, 0x3 /* clear MODULEMODE bits */
	orr tmp, 0x2 /* set MODULEMODE to ENABLE */
	str tmp, [base, cm_per_timer2_clkctrl]

	/* Set to auto-reload and start the timer */

	ldr base, =dmtimer2_base
	mov tmp, 0x3
	str tmp, [base, timer_tclr]

	bx lr
	.unreq tmp
	.unreq base
