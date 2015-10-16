.syntax unified


ctrl_base				= 0x44e10000
ctrl_conf_uart0_rxd		= 0x970
ctrl_conf_uart0_txd		= 0x974

cm_wkup_base			= 0x44e00400
cm_wkup_clkstctrl		= 0x000
cm_wkup_uart0_clkctrl	= 0x4b4

cm_per_base				= 0x44e00000
cm_per_l4hs_clkstctrl	= 0x11c

uart0_base				= 0x44e09000


.text


.global console_init
console_init:

	base	.req r0
	tmp		.req r1

	push {lr}

	/* Set pinmux: UART0 pins are on UART0_RXD and UART0_TXD */
	ldr base, =ctrl_base
	mov tmp, 0x20
	str tmp, [base, ctrl_conf_uart0_rxd]
	str tmp, [base, ctrl_conf_uart0_txd]

	/* Enable clocks required for UART0 */
	ldr base, =cm_wkup_base
	ldr tmp, [base, cm_wkup_clkstctrl]
	bic tmp, 0x3 /* clear CLKTRCTL bits */
	orr tmp, 0x2 /* set CLKTRCTL to SW_WKUP */
	str tmp, [base, cm_wkup_clkstctrl]
	ldr base, =cm_per_base
	ldr tmp, [base, cm_per_l4hs_clkstctrl]
	bic tmp, 0x3 /* clear CLKTRCTL bits */
	orr tmp, 0x2 /* set CLKTRCTL to SW_WKUP */
	str tmp, [base, cm_per_l4hs_clkstctrl]
	ldr base, =cm_wkup_base
	ldr tmp, [base, cm_wkup_uart0_clkctrl]
	bic tmp, 0x3 /* clear MODULEMODE bits */
	orr tmp, 0x2 /* set MODULEMODE to ENABLE */
	str tmp, [base, cm_wkup_uart0_clkctrl]

	/* Configure the UART */
	ldr r0, =uart0_base
	bl uart_init

	pop {pc}
	.unreq base
	.unreq tmp


.global console_putc
console_putc:

	mov r1, r0
	ldr r0, =uart0_base
	bl uart_putc
