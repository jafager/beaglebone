.syntax unified


cm_wkup_base			= 0x44e00400
cm_wkup_clkstctrl		= 0x000
cm_wkup_uart0_clkctrl	= 0x4b4

cm_per_base				= 0x44e00000
cm_per_l4hs_clkstctrl	= 0x11c

uart0_base	= 0x44e09000


.text


/* console_init: initialize the console serial port at UART0 */

.global console_init
console_init:

	base	.req r0
	tmp		.req r1

	push {lr}

	/* Enable clocks required for UART0 module */

	ldr base, =cm_wkup_base
	ldr tmp, [base, cm_wkup_clkstctrl]
	bic tmp, 0x3 /* clear CLKTRCTRL bits */
	orr tmp, 0x2 /* set CLKTRCTRL to SW_WKUP */
	str tmp, [base, cm_wkup_clkstctrl]

	ldr base, =cm_per_base
	ldr tmp, [base, cm_per_l4hs_clkstctrl]
	bic tmp, 0x3 /* clear CLKTRCTRL bits */
	orr tmp, 0x2 /* set CLKTRCTRL to SW_WKUP */
	str tmp, [base, cm_per_l4hs_clkstctrl]

	ldr base, =cm_wkup_base
	ldr tmp, [base, cm_wkup_uart0_clkctrl]
	bic tmp, 0x3 /* clear MODULEMODE bits */
	orr tmp, 0x2 /* set MODULEMODE to ENABLE */
	str tmp, [base, cm_wkup_uart0_clkctrl]

	/* Initialize and configure UART0 */

	ldr base, =uart0_base
	bl uart_init

	pop {pc}
	.unreq base
	.unreq tmp


/* console_puts: print the null-terminated string at address r0 to the console */

.global console_puts
console_puts:

	push {lr}

	string		.req r0
	uart_base	.req r1

	ldr uart_base, =uart0_base
	bl uart_puts

	pop {pc}
	.unreq string
	.unreq uart_base


/* console_putc: print the character in r0 to the console */

.global console_putc
console_putc:

	push {lr}

	ldr r1, =uart0_base
	bl uart_putc

	pop {pc}


/* console_enable_rhr_interrupt: enable the RHR interrupt for UART0 */

.global console_enable_rhr_interrupt
console_enable_rhr_interrupt:

	push {lr}

	ldr r0, =uart0_base
	bl uart_enable_rhr_interrupt

	pop {pc}


/* console_getc: get a character from the console and return it in r0 */

.global console_getc
console_getc:

	push {lr}

	ldr r0, =uart0_base
	bl uart_getc

	pop {pc}


/* console_pretty_hexprint: pretty print the value of r0 in hex to the console */

.global console_pretty_hexprint
console_pretty_hexprint:

    push {r0, lr}

    mov r0, '0'
    bl console_putc
    mov r0, 'x'
    bl console_putc

    pop {r0}
    bl console_hexprint

    mov r0, '\r'
    bl console_putc
    mov r0, '\n'
    bl console_putc

    pop {pc}


/* console_hexprint: print the value of r0 in hex to the console */

.global console_hexprint
console_hexprint:

    push {lr}

    mov r1, 32

next_digit:

    sub r1, r1, 4
    mov r2, r0, lsr r1
    and r2, r2, 0xf
    add r2, r2, '0'
    cmp r2, '9'
    addhi r2, r2, 39
    push {r0-r3}
    mov r0, r2
    bl console_putc
    pop {r0-r3}
    cmp r1, 0
    bne next_digit

    pop {pc}
