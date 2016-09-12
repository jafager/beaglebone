.syntax unified


.text


.global mmctest
mmctest:


    /* Switch to Supervisor mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x13
    msr cpsr, r0

    ldr sp, =stack_supervisor


    /* Initialize console */

    bl console_init

    ldr r0, =message_console_initialized
    bl console_puts


	/* Initialize MMC */

	bl mmc_init

	ldr r0, =message_mmc_initialized
	bl console_puts


hang:

    b hang


message_console_initialized:

    .asciz "Console initialized.\r\n"

message_mmc_initialized:

	.asciz "MMC initialized.\r\n"
