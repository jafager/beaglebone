.syntax unified



.text



.global qemu
qemu:



/* Set up the supervisor stack */

ldr sp, =stack_supervisor



/* Initialize console */

bl console_init

ldr r0, =message_console_initialized
bl console_puts



/* Terminate */

hang:

	b hang



/* Messages */

message_console_initialized:

	.asciz "Console initialized.\r\n"
