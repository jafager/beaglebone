	.cpu arm7tdmi
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"boot.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Ready.\015\012\000"
	.text
	.align	2
	.global	boot
	.syntax unified
	.arm
	.fpu softvfp
	.type	boot, %function
boot:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	ldr	r0, .L2
	bl	console_puts
	nop
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, lr}
	bx	lr
.L3:
	.align	2
.L2:
	.word	.LC0
	.size	boot, .-boot
	.ident	"GCC: (GNU) 7.1.0"
