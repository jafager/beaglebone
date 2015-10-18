.syntax unified


mpu_intc_base				= 0x4820000
intc_sysconfig				= 0x010
intc_sysconfig_softreset	= 1
intc_sysstatus				= 0x014
intc_sysstatus_resetdone	= 0
intc_idle					= 0x050
intc_ilr_base				= 0x100
intc_mir_clear_base			= 0x088


.text


.global intc_init
intc_init:

	intc_base	.req r0
	tmp			.req r1

	ldr intc_base, =mpu_intc_base

	/* Initiate soft reset */
	mov tmp, (1 << intc_sysconfig_softreset)
	str tmp, [intc_base, intc_sysconfig]

	/* Wait for soft reset to complete */
wait_for_reset:
	ldr tmp, [intc_base, intc_sysstatus]
	tst tmp, (1 << intc_sysstatus_resetdone)
	beq wait_for_reset

	/* Disable clock idling */
	mov tmp, 0
	str tmp, [intc_base, intc_sysconfig]
	mov tmp, 1
	str tmp, [intc_base, intc_idle]

	bx lr
	.unreq intc_base
	.unreq tmp


.global intc_enable_interrupt
intc_enable_interrupt:

	number		.req r0
	priority	.req r1
	irqfiq		.req r2
	base		.req r3
	tmp			.req r4
	offset		.req r5
	tmp2		.req r6

	push {r4-r6}

	/* Sanitize input */
	and number, number, 0x7f
	and priority, priority, 0x3f
	and irqfiq, irqfiq, 0x1

	/* Configure priority and IRQ/FIQ setting */
	ldr base, =intc_ilr_base
	mov tmp, priority, lsl 2
	orr tmp, tmp, irqfiq
	str tmp, [base, number, lsl 2]

	/* Clear interrupt mask */
	ldr base, =intc_mir_clear_base
	mov offset, 0x20 /* size of each register bank */
	mov tmp, number, lsr 5 /* number of register bank */
	mul tmp2, offset, tmp
	mov offset, tmp2
	and tmp2, number, 0x1f /* bitmask bit */
	mov tmp, 1
	lsl tmp, tmp2
	str tmp, [base, offset]

	pop {r4-r6}
	bx lr
	.unreq number
	.unreq priority
	.unreq irqfiq
	.unreq base
	.unreq tmp
	.unreq offset
