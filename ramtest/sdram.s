.syntax unified


.text


.global sdram_init
sdram_init:


	/* enable clocks */

	ldr r0, =0x44e00000
	mov r1, 0x2
	str r1, [r0, 0xd0]
	str r1, [r0, 0x28]
wait_for_enable:
	ldr r1, [r0, 0x28]
	cmp r1, 0x2
	bne wait_for_enable

	ldr r0, =message_clocks_enabled
	push {r0-r3}
	bl console_puts
	pop {r0-r3}


	/* configure pll */

	ldr r0, =0x44e00400

	ldr r1, [r0, 0x94]
	bic r1, r1, 0x7
	orr r1, r1, 0x4
	str r1, [r0, 0x94]
wait_for_bypass:
	ldr r1, [r0, 0x34]
	tst r1, 0x100
	beq wait_for_bypass

	ldr r1, [r0, 0x40]
	ldr r2, =0x0007ffff
	bic r1, r1, r2
	ldr r2, =0x00019017
	orr r1, r1, r2
	str r1, [r0, 0x40]

	ldr r1, [r0, 0xa0]
	orr r1, r1, 0x1
	str r1, [r0, 0xa0]

	ldr r1, [r0, 0x94]
	orr r1, r1, 0x7
	str r1, [r0, 0x94]

wait_for_lock:
	ldr r1, [r0, 0x34]
	tst r1, 0x1
	beq wait_for_lock

	ldr r0, =message_pll_locked
	push {r0-r3}
	bl console_puts
	pop {r0-r3}


	/* configure cmd control registers */

	ldr r0, =0x44e12000

	mov r1, 0x80
	str r1, [r0, 0x1c]
	str r1, [r0, 0x50]
	str r1, [r0, 0x84]

	mov r1, 0x1
	str r1, [r0, 0x28]
	str r1, [r0, 0x5c]
	str r1, [r0, 0x90]

	mov r1, 0x0
	str r1, [r0, 0x2c]
	str r1, [r0, 0x60]
	str r1, [r0, 0x94]

	ldr r0, =message_cmd_regs
	push {r0-r3}
	bl console_puts
	pop {r0-r3}


	/* configure data registers */

	ldr r0, =0x44e12000

	mov r1, 0x38
	str r1, [r0, 0x0c8]
	str r1, [r0, 0x16c]

	mov r1, 0x44
	str r1, [r0, 0x0dc]
	str r1, [r0, 0x180]

	mov r1, 0x0
	str r1, [r0, 0x0f0]
	str r1, [r0, 0x0fc]
	str r1, [r0, 0x134]
	str r1, [r0, 0x138]
	str r1, [r0, 0x194]
	str r1, [r0, 0x1a0]
	str r1, [r0, 0x1d8]
	str r1, [r0, 0x1dc]

	mov r1, 0x94
	str r1, [r0, 0x108]
	str r1, [r0, 0x1ac]

	mov r1, 0x7d
	str r1, [r0, 0x120]
	str r1, [r0, 0x1c4]

	ldr r0, =message_data_regs
	push {r0-r3}
	bl console_puts
	pop {r0-r3}


	/* configure io ctrl registers */

	ldr r0, =0x44e11400

	ldr r1, =0x18b
	str r1, [r0, 0x08]
	str r1, [r0, 0x0c]
	str r1, [r0, 0x10]
	str r1, [r0, 0x44]
	str r1, [r0, 0x48]

	ldr r0, =message_io_ctrl_regs
	push {r0-r3}
	bl console_puts
	pop {r0-r3}


	/* configure phy */

	ldr r0, =0x4c000000

	ldr r1, =0x00100007
	str r1, [r0, 0xe4]
	str r1, [r0, 0xe8]

	ldr r0, =message_phy
	push {r0-r3}
	bl console_puts
	pop {r0-r3}


	/* set cke to be controlled by emif/ddr phy */

	ldr r0, =0x44e1131c
	mov r1, 0x1
	str r1, [r0]

	ldr r0, =message_cke
	push {r0-r3}
	bl console_puts
	pop {r0-r3}


	/* set sdram timings */

	ldr r0, =0x4c000000

	ldr r1, =0x0aaad4db
	str r1, [r0, 0x1c]

	ldr r1, =0x266b7fda
	str r1, [r0, 0x20]
	str r1, [r0, 0x24]

	ldr r1, =0x501f867f
	str r1, [r0, 0x28]
	str r1, [r0, 0x2c]

	ldr r0, =message_timings
	push {r0-r3}
	bl console_puts
	pop {r0-r3}


	/* configure sdram */

	ldr r0, =0x4c000000

	ldr r1, =0x00002800
	str r1, [r0, 0x10]

	push {r0-r3}
	ldr r0, =message_sdram
	bl console_puts
	pop {r0-r3}

	ldr r1, =0x50074b34
	str r1, [r0, 0xc8]

	push {r0-r3}
	ldr r0, =message_sdram
	bl console_puts
	pop {r0-r3}

	ldr r1, =0x61c05332
	str r1, [r0, 0x110]
	str r1, [r0, 0x008]

	push {r0-r3}
	ldr r0, =message_sdram
	bl console_puts
	pop {r0-r3}

	ldr r1, =0x00000c30
	str r1, [r0, 0x10]
	str r1, [r0, 0x14]
	@str r1, [r0, 0x10]
	@str r1, [r0, 0x14]

	push {r0-r3}
	ldr r0, =message_sdram
	bl console_puts
	pop {r0-r3}

	ldr r1, =0x61c05332
	str r1, [r0, 0x08]

	push {r0-r3}
	ldr r0, =message_sdram
	bl console_puts
	pop {r0-r3}

	
	/* configure vtp */

	ldr r0, =0x44e10000

	ldr r1, [r0, 0xe0c]
	orr r1, r1, (1 << 6)
	str r1, [r0, 0xe0c]

	ldr r1, [r0, 0xe0c]
	bic r1, r1, 0x1
	str r1, [r0, 0xe0c]

wait_for_ready:

	ldr r1, [r0, 0xe0c]
	tst r1, (1 << 5)
	beq wait_for_ready

	ldr r0, =message_vtp
	push {r0-r3}
	bl console_puts
	pop {r0-r3}

	bx lr

message_clocks_enabled:
	.asciz "Clocks enabled.\r\n"
message_pll_locked:
	.asciz "PLL locked.\r\n"
message_cmd_regs:
	.asciz "Command registers.\r\n"
message_data_regs:
	.asciz "Data registers.\r\n"
message_io_ctrl_regs:
	.asciz "IO ctrl registers.\r\n"
message_phy:
	.asciz "PHY.\r\n"
message_cke:
	.asciz "CKE.\r\n"
message_timings:
	.asciz "SDRAM timings.\r\n"
message_sdram:
	.asciz "SDRAM.\r\n"
message_vtp:
	.asciz "VTP.\r\n"
