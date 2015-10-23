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

memtest:

	ldr r0, =message_initiating_memtest
	bl console_puts

	ldr r4, =0x80000000
	ldr r5, =0xdb

write_next_address:

	str r5, [r4]

	ldr r5, =0x9ffffffc
	cmp r4, r5
	beq done_writing
	add r4, r4, 4
	b write_next_address

done_writing:

	ldr r4, =0x80000000
	ldr r5, =0xdb

read_next_address:

	ldr r6, [r4]
	cmp r6, r5
	bne read_failed

read_success:

	ldr r5, =0x9ffffffc
	cmp r4, r5
	beq done_reading
	add r4, r4, 4
	b read_next_address
	
done_reading:

	ldr r0, =message_memtest_complete
	bl console_puts

	b memtest

read_failed:

	ldr r0, =message_memtest_fail
	bl console_puts
	b read_success


hang:

	b hang


message_console_initialized:
	.asciz "Console initialized.\r\n"

message_initializing_sdram:
	.asciz "Initializing SDRAM.\r\n"

message_sdram_initialized:
	.asciz "SDRAM Initialized.\r\n"

message_memtest:
	.asciz "Initiating memory test.\r\n"

message_memtest_fail:
	.asciz "\r\nMemory test failed cell!\r\n"

message_memtest_complete:
	.asciz "\r\nMemory test complete.\r\n"

message_initiating_memtest:
	.asciz "Initiating memory test.\r\n"

message_readback_failed:
	.asciz "Readback test failed!\r\n"

message_initiating_delayed_memtest:
	.asciz "\r\nInitiating delayed memory test.\r\n"

message_delayed_read_failed:
	.asciz "\r\nDelayed read test failed cell!\r\n"

