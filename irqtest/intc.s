.syntax unified


mpu_intc_base	= 0x4820000
intc_sysconfig	= 0x010
intc_idle		= 0x050
intc_ilr_base	= 0x100


.text


.global intc_init
intc_init:

	intc_base	.req r0
	tmp			.req r1

	/* Disable clock idling */
	ldr intc_base, =mpu_intc_base
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
	ilr_base	.req r3
	tmp			.req r0

	/* Sanitize input */
	and number, number, 0x7f
	and priority, priority, 0x3f
	and irqfiq, irqfiq, 0x1

	/* Enable interrupt */
	ldr ilr_base, =intc_ilr_base
	mov tmp, priority, lsl 2
	orr tmp, tmp, irqfiq
	str tmp, [ilr_base, number, lsl 2]

	bx lr
	.unreq number
	.unreq priority
	.unreq irqfiq
	.unreq ilr_base
	.unreq tmp
