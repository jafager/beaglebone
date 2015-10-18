.syntax unified


.text


.global timertest
timertest:


	/* Set up the processor to run the rest of our code */

	mrs r0, cpsr
	bic r0, r0, 0x1f /* clear mode bits */
	orr r0, r0, 0xd3 /* disable IRQ and FIQ interrupts and set Supervisor mode */
	msr cpsr, r0


	/* Set up the stack, which is used in some of our subroutines */

	ldr sp, =stack_init


	/* Initialize the LEDs */

	bl led_init


	/* Output a test pattern on the LEDs */

	mov r0, 0b1111
	bl led_set


	/* Initialize the console */

	bl console_init


	/* Output a test pattern to the console */

	mov r0, 'A'
next_test_character:
	bl console_putc
	cmp r0, 'Z'
	beq end_of_test_pattern
	add r0, r0, 1
	b next_test_character
end_of_test_pattern:
	mov r0, '\r'
	bl console_putc
	mov r0, '\n'
	bl console_putc


	/* Output a message to the console */

	ldr r0, =message_ready
	bl console_puts

	
	/* Initialize the timer */

	bl timer_init
	ldr r0, =message_timer_initialized
	bl console_puts


	/* Sleep, print a message, repeat */

repeat:

	ldr r0, =0x10000
	bl timer_sleep

	ldr r0, =message_sleep_completed
	bl console_puts

	b repeat


message_ready:
	.asciz "Ready.\r\n"

message_timer_initialized:
	.asciz "Timer initialized.\r\n"

message_sleep_completed:
	.asciz "Sleep completed.\r\n"
