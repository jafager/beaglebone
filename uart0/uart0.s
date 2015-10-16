/*
Outputs alphabet over serial.
*/

.equ CONF_UART0_TXD, 0x44E10974
.equ CM_WKUP_CLKSTCTRL, 0x44E00400
.equ CM_PER_L4HS_CLKSTCTRL, 0x44E0011C
.equ CM_WKUP_UART0_CLKCTRL, 0x44E004B4
.equ UART0_SYSC, 0x44E09054
.equ UART0_SYSS, 0x44E09058
.equ UART0_BASE, 0x44E09000

_start:

    /* set uart mux config */
    ldr r0, =CONF_UART0_TXD
    ldr r1, =0x0
    str r1, [r0]

    /* setup_clocks_for_console */
    ldr r0, =CM_WKUP_CLKSTCTRL
    ldr r1, [r0]
    and r1, #~0x3
    orr r1, #0x2
    str r1, [r0]
    ldr r0, =CM_PER_L4HS_CLKSTCTRL
    ldr r1, [r0]
    and r1, #~0x3
    orr r1, #0x2
    str r1, [r0]
    ldr r0, =CM_WKUP_UART0_CLKCTRL
    ldr r1, [r0]
    and r1, #~0x3
    orr r1, #0x2
    str r1, [r0]

    /* UART soft reset */
    ldr r0, =UART0_SYSC
    ldr r1, [r0]
    orr r1, #0x2
    str r1, [r0]
    ldr r0, =UART0_SYSS
.uart_soft_reset:
    ldr r1, [r0]
    ands r1, #0x1
    beq .uart_soft_reset
    /* turn off smart idle */
    ldr r0, =UART0_SYSC
    ldr r1, [r0]
    orr r1, #(0x1 << 0x3)
    str r1, [r0]

    /* initialize UART */
    ldr r0, =UART0_BASE
    ldr r1, =26
.uart_init:
	/* waiting on recieve errors to clear */
    ldrb    r3, [r0, #20]
    uxtb    r3, r3
    tst     r3, #0x40
    beq     .uart_init
	/* disable interrupts */
    mov     r3, #0
    strb    r3, [r0, #4]
	/* set uart mode to disabled */
    mov     r3, #7
    strb    r3, [r0, #32]
	/* 8N1, enable divisor latch */
    mvn     r3, #0x7c
    strb    r3, [r0, #12]
	/* set divisor to 0 */
    mov     r3, #0
    strb    r3, [r0]
    strb    r3, [r0, #4]
	/* 8N1, disable divisor latch */
    mov     r3, #3
    strb    r3, [r0, #12]
    /* modem control? -- force RTS and DTR to low */
	strb    r3, [r0, #16]
	/* enable and clear FIFOs */
    mov     r3, #7
    strb    r3, [r0, #8]
	/* 8N1, enable divisor latch */
    mvn     r3, #0x7c
    strb    r3, [r0, #12]
	/* set divisor to the value of r1 */
    uxtb    r3, r1
    strb    r3, [r0]
    ubfx    r1, r1, #8, #8
    strb    r1, [r0, #4]
	/* 8N1, disable divisor latch */
    mov     r3, #3
    strb    r3, [r0, #12]
	/* set uart mode to 16x uart */
    mov     r3, #0
    strb    r3, [r0, #32]

    ldr     r1, =UART0_BASE
    ldr     r0, ='A'
.loop:
    cmp     r0, #'Z'
    movgt   r0, #'A'
    bl .uart_putc
    mov     r3, r0
    ldr     r0, ='\r'
    bl .uart_putc
    ldr     r0, ='\n'
    bl .uart_putc
    mov     r0, r3
    add     r0, #1
    b .loop

.uart_putc:
    ldrb    r2, [r1, #20]
    uxtb    r2, r2
    tst     r2, #32
    beq     .uart_putc
    strb    r0, [r1]
    bx      lr
