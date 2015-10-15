.syntax unified


.text


.global first
first:


	/* Set up the processor to run the rest of our code */

	mrs r0, cpsr
	bic r0, r0, 0x1f /* clear mode bits */
	orr r0, r0, 0xd3 /* disable IRQ and FIQ interrupts and set Supervisor mode */
	msr cpsr, r0


	/* Set up the stack, which is used in some of our subroutines */

	ldr sp, =stack_init


	/* Initialize the LEDs */

	bl led_init


	/* Set a distinctive pattern on the LEDs */

	mov r0, 0b1001
	bl led_set


	/* Infinite loop, for safety */

hang:

	b hang
