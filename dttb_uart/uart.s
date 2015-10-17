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

ctrl_base				= 0x44e10000
ctrl_conf_uart0_rxd		= 0x970
ctrl_conf_uart0_txd		= 0x974
ctrl_conf_uart1_rxd		= 0x980
ctrl_conf_uart1_txd		= 0x984

cm_wkup_base			= 0x44e00400
cm_wkup_clkstctrl		= 0x000
cm_wkup_uart0_clkctrl	= 0x4b4

cm_per_base				= 0x44e00000
cm_per_l4hs_clkstctrl	= 0x11c
cm_per_uart1_clkctrl	= 0x06c
cm_per_l3s_clkstctrl	= 0x004

uart0_base				= 0x44e09000
uart1_base				= 0x48022000

.equ CONF_UART0_RXD, 0x44E10970
.equ CONF_UART0_TXD, 0x44E10974

_start:

    /* set uart mux config */
    ldr r0, =ctrl_base
    ldr r1, =(0x1<<4)|(0x1<<5)
    str r1, [r0, ctrl_conf_uart1_rxd]
    ldr r0, =ctrl_base
    ldr r1, =0x0
    str r1, [r0, ctrl_conf_uart1_txd]

    /* setup_clocks_for_console */
	bl enable_uart_clocks
	bl enable_uart1_clocks

    /* UART soft reset */
	ldr r0, =uart0_base
	bl uart_soft_reset
	ldr r0, =uart1_base
	bl uart_soft_reset

    /* turn off smart idle */
	ldr r0, =uart0_base
	bl uart_disable_smart_idle
	ldr r0, =uart1_base
	bl uart_disable_smart_idle

    /* initialize UART */
	ldr r0, =uart0_base
	bl uart_init
	ldr r0, =uart1_base
	bl uart_init

    ldr     r0, ='A'
.loop:
    cmp     r0, #'Z'
    movgt   r0, #'A'
    ldr     r1, =uart0_base
    bl uart_putc
    ldr     r1, =uart1_base
    bl uart_putc
    mov     r3, r0
    ldr     r0, ='\r'
    ldr     r1, =uart0_base
    bl uart_putc
    ldr     r1, =uart1_base
    bl uart_putc
    ldr     r0, ='\n'
    ldr     r1, =uart0_base
    bl uart_putc
    ldr     r1, =uart1_base
    bl uart_putc
    mov     r0, r3
    add     r0, #1
    b .loop


.global uart_putc
uart_putc:

	character	.req r0
	uart_base	.req r1
	tmp			.req r2

	/* Sanitize input */
	and character, character, 0xff

	/* Wait for transmit FIFO to be empty */
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


.global uart_soft_reset
uart_soft_reset:

	uart_base	.req r0
	tmp			.req r1

	/* Initiate soft reset */
	mov tmp, (1 << uart_sysc_softreset)
	str tmp, [uart_base, uart_sysc]

	/* Wait for soft reset to complete */
wait_for_reset:
	ldr tmp, [uart_base, uart_syss]
	tst tmp, (1 << uart_syss_resetdone)

	bx lr
	.unreq uart_base
	.unreq tmp


.global uart_init
uart_init:

	uart_base	.req r0
	tmp			.req r1
	
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


.global enable_uart_clocks
enable_uart_clocks:

	base	.req r0
	tmp		.req r1
	
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
	
	bx lr
	.unreq base
	.unreq tmp


.global enable_uart1_clocks
enable_uart1_clocks:

	base	.req r0
	tmp		.req r1
	
	/* Enable clocks required for UART1 */
	@ldr base, =cm_wkup_base
	@ldr tmp, [base, cm_wkup_clkstctrl]
	@bic tmp, 0x3 /* clear CLKTRCTL bits */
	@orr tmp, 0x2 /* set CLKTRCTL to SW_WKUP */
	@str tmp, [base, cm_wkup_clkstctrl]
	ldr base, =cm_per_base
	ldr tmp, [base, cm_per_l3s_clkstctrl]
	bic tmp, 0x3 /* clear CLKTRCTL bits */
	orr tmp, 0x2 /* set CLKTRCTL to SW_WKUP */
	str tmp, [base, cm_per_l3s_clkstctrl]
	ldr base, =cm_per_base
	ldr tmp, [base, cm_per_uart1_clkctrl]
	bic tmp, 0x3 /* clear MODULEMODE bits */
	orr tmp, 0x2 /* set MODULEMODE to ENABLE */
	str tmp, [base, cm_per_uart1_clkctrl]
	
	bx lr
	.unreq base
	.unreq tmp


.global uart_disable_smart_idle
uart_disable_smart_idle:

	uart_base	.req r0
	tmp			.req r1

	ldr tmp, [uart_base, uart_sysc]
	bic tmp, tmp, (0x3 << uart_sysc_idlemode)
	orr tmp, tmp, (0x1 << uart_sysc_idlemode)
	str tmp, [uart_base, uart_sysc]

	bx lr
	.unreq uart_base
	.unreq tmp
