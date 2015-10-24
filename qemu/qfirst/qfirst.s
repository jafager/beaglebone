.syntax unified


.text


.global qfirst
qfirst:

	ldr r4, =0x01234567
	ldr r5, =0x89abcdef

hang:

	b hang
