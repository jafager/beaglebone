.syntax unified


.text


.global qfirstc
qfirstc:


	/* Set up the supervisor mode stack */

	ldr sp, =stack_supervisor


	/* Initialize BSS segment */

	ldr r0, =bss_begin
	ldr r1, =bss_end
	mov r2, 0

initialize_bss_byte:

	cmp r0, r1
	strbne r2, [r0]
	addne r0, r0, 1
	bne initialize_bss_byte


	/* Branch to C entry point */

	bl c_entry


hang:

	b hang
