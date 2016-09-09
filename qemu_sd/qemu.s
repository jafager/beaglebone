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



/* SD card shenanigans */

/* set block length to 512 bytes */

ldr r0, =message_setting_block_length
bl console_puts

ldr r0, =0x1c000008
mov r1, 512
str r1, [r0]
ldr r0, =0x1c00000c
mov r1, 0x450
str r1, [r0]

/* read block */

ldr r0, =message_reading_block
bl console_puts

ldr r0, =0x1c000008
mov r1, 0
str r1, [r0]
ldr r0, =0x1c00000c
ldr r1, =0x411
str r1, [r0]

/* read data */

ldr r0, =message_reading_data
bl console_puts

ldr r0, =0x1c000028
ldr r1, =512
str r1, [r0]

ldr r0, =0x1c00002c
mov r1, 7
str r1, [r0]

next_byte:

ldr r1, =0x1c000080
ldr r0, [r1]
bl console_putc
subs r2, 1
bne next_byte


/* All done */

ldr r0, =message_done
bl console_puts



/* Terminate */

hang:

	b hang



/* Messages */

message_console_initialized:

	.asciz "Console initialized.\r\n"

message_setting_block_length:

	.asciz "Setting block length...\r\n"

message_reading_block:

	.asciz "Reading block...\r\n"

message_reading_data:

	.asciz "Reading data...\r\n"

message_done:

	.asciz "Done.\r\n"
