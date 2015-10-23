.syntax unified


.text


.global ramtest
ramtest:

	mrs r0, cpsr
	bic r0, r0, 0x1f
	orr r0, r0, 0x13
	msr cpsr, r0

	ldr sp, =stack_supervisor

	bl console_init

	ldr r0, =message_console_initialized
	bl console_puts

	ldr r0, =message_initializing_sdram
	bl console_puts

	bl sdram_init

	ldr r0, =message_sdram_initialized
	bl console_puts

	ldr r0, =0x80000000
next_address:
	ldr r1, =0xffff
	and r1, r0, r1
	str r1, [r0]
	ldr r2, [r0]
	cmp r1, r2
	beq success
	push {r0-r3}
	ldr r0, =message_memtest_fail
	bl console_puts
	pop {r0-r3}
success:
	ldr r2, =0xfffc
	cmp r1, r2
	bne no_update
	push {r0-r3}
	mov r0, '.'
	bl console_putc
	pop {r0-r3}
no_update:
	ldr r1, =0x9ffffffc
	cmp r0, r1
	beq done_memtest
	add r0, r0, 4
	b next_address
done_memtest:
	ldr r0, =message_memtest_complete
	bl console_puts


hang:

	b hang


message_console_initialized:
	.asciz "Console initialized.\r\n"

message_initializing_sdram:
	.asciz "Initializing SDRAM...\r\n"

message_sdram_initialized:
	.asciz "SDRAM Initialized.\r\n"

message_memtest_fail:
	.asciz "Memory test failed cell!\r\n"

message_memtest_complete:
	.asciz "\r\nMemory test complete.\r\n"
