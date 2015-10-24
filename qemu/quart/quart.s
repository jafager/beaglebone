.syntax unified


uart0_base	= 0x16000000


.text


.global quart
quart:

	ldr r4, =uart0_base

	mov r5, 'R'
	strb r5, [r4]
	mov r5, 'e'
	strb r5, [r4]
	mov r5, 'a'
	strb r5, [r4]
	mov r5, 'd'
	strb r5, [r4]
	mov r5, 'y'
	strb r5, [r4]
	mov r5, '.'
	strb r5, [r4]
	mov r5, '\r'
	strb r5, [r4]
	mov r5, '\n'
	strb r5, [r4]

hang:

	b hang
