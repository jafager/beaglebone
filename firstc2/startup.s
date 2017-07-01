.syntax unified


.text


.global startup
startup:


	/* Set up the processor to run the rest of our code */

	mrs r0, cpsr
	bic r0, r0, 0x1f /* clear mode bits */
	orr r0, r0, 0xd3 /* disable IRQ and FIQ interrupts and set Supervisor mode */
	msr cpsr, r0


	/* Set up the stack, which is used in some of our subroutines */

	ldr sp, =stack_supervisor


	/* Jump to main function */

	ldr r4, =firstc
	blx r4


	/* Hang the processor safely */

hang:

	b hang
