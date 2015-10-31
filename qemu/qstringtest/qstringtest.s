.syntax unified


.text


.global qconsole
qconsole:

	ldr sp, =stack_supervisor

	bl console_init

	ldr r0, =message_ready
	bl console_puts


hang:

	b hang


/* Messages */


message_ready:

	.asciz "Ready.\r\n"
