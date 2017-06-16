.syntax unified


.text


.global qdebug
qdebug:

	ldr sp, =stack_supervisor

	bl console_init

	ldr r0, =message_ready
	bl console_puts


	ldr r0, =0x01234567
	bl debug_print_hex
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x01234567
	bl debug_print_bin
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x89abcdef
	bl debug_print_hex
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x89abcdef
	bl debug_print_bin
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0xdeadbeef
	bl debug_print_hex
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0xdeadbeef
	bl debug_print_bin
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0xfeedabba
	bl debug_print_hex
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0xfeedabba
	bl debug_print_bin
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x867c5309
	bl debug_print_hex
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x867c5309
	bl debug_print_bin
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x00000000
	bl debug_print_hex
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x00000000
	bl debug_print_bin
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0xffffffff
	bl debug_print_hex
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0xffffffff
	bl debug_print_bin
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x43218765
	bl debug_print_hex
	ldr r0, =crlf
	bl console_puts

	ldr r0, =0x43218765
	bl debug_print_bin
	ldr r0, =crlf
	bl console_puts

hang:

	b hang


/* Messages */


message_ready:

	.asciz "Ready.\r\n"

crlf:

	.asciz "\r\n"
