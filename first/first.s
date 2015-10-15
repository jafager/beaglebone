.syntax unified


.text


.global first
first:

	mrs r0, cpsr
	bic r0, r0, 0x1f
	orr r0, r0, 0x13
	orr r0, r0, 0xc0
	msr cpsr, r0

	ldr sp, =stack_init

	bl led_init

	mov r0, 0b1001
	bl led_set

hang:

	b hang
