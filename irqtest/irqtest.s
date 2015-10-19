.syntax unified


.text


.global irqtest
irqtest:


	/* Disable IRQ and FIQ interrupts */

	mrs r0, cpsr
	orr r0, r0, 0xc0
	msr cpsr, r0


	/* Switch to IRQ mode */

	mrs r0, cpsr
	bic r0, r0, 0x1f
	orr r0, r0, 0x12
	msr cpsr, r0


	/* Set up the IRQ mode stack */

	ldr sp, =stack_irq


	/* Switch to Supervisor mode */

	mrs r0, cpsr
	bic r0, r0, 0x1f
	orr r0, r0, 0x13
	msr cpsr, r0

	
	/* Set up the Supervisor mode stack */

	ldr sp, =stack_supervisor


	/* Initialize the LEDs */

	bl led_init


	/* Output a test pattern on the LEDs */

	mov r0, 0b1111
	bl led_set


	/* Initialize the console */

	bl console_init


	/* Output a message to the console */

	ldr r0, =message_ready
	bl console_puts

	
	/* Initialize the timer */

	bl timer_init
	ldr r0, =message_timer_initialized
	bl console_puts


	/* Enable UART0 RHR interrupt */

	ldr r0, =0x44e09000
	ldr r1, [r0, 0x04]
	orr r1, r1, (1 << 0)
	str r1, [r0, 0x04]

	ldr r0, =message_enable_rhr
	bl console_puts


	/* Enable UART0 interrupt in the INTC */

	ldr r0, =0x48200000
	ldr r1, =(1 << 8)
	str r1, [r0, 0xc8]

	ldr r0, =message_enable_uart0
	bl console_puts


	/* Set up interrupt vector table */

	ldr r0, =vector_table
	mcr p15, 0, r0, c12, c0, 0

	ldr r0, =message_set_up_vector_table
	bl console_puts


	/* Enable interrupts */

	cpsie i

	ldr r0, =message_enable_interrupts
	bl console_puts


	/* Main loop */

main_loop:

	wfe
	b main_loop


	/* Test pattern */
	/*
	mov r0, 'A'
next_character:
	bl console_putc
	cmp r0, 'Z'
	addne r0, r0, 1
	bne next_character
	mov r0, 'A'
	b next_character
	*/


	/* Interrupt handler */

interrupt_handler:

	push {r0-r4, lr}

	ldr r0, =message_interrupt
	bl console_puts

	ldr r0, =0x44e09000
	ldr r1, [r0, 0x00]

	ldr r0, =0x48200000
	mov r1, 1
	str r1, [r0, 0x48]

	dsb
	pop {r0-r4, lr}
	subs pc, lr, 4


vector_table:
	ldr pc, =interrupt_handler
	ldr pc, =interrupt_handler
	ldr pc, =interrupt_handler
	ldr pc, =interrupt_handler
	ldr pc, =interrupt_handler
	ldr pc, =interrupt_handler
	ldr pc, =interrupt_handler
	ldr pc, =interrupt_handler


.pool


/* Messages */

message_ready:
	.asciz "Console initialized.\r\n"

message_timer_initialized:
	.asciz "Timer initialized.\r\n"

message_interrupt:
	.asciz "Executing interrupt!\r\n"

message_enable_rhr:
	.asciz "RHR interrupt enabled.\r\n"

message_enable_uart0:
	.asciz "UART0 interrupt enabled.\r\n"

message_set_up_vector_table:
	.asciz "Set up interrupt vector table.\r\n"

message_enable_interrupts:
	.asciz "Interrupts enabled! Hold onto your butts...\r\n"
