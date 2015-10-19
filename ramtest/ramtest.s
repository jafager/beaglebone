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


hang:

	b hang


message_console_initialized:
	.asciz "Console initialized.\r\n"

message_initializing_sdram:
	.asciz "Initializing SDRAM...\r\n"

message_sdram_initialized:
	.asciz "SDRAM Initialized.\r\n"
