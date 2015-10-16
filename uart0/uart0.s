.syntax unified


.text


.global uart0
uart0:

	bl led_init

	mov r0, 0b0001
	bl led_set

	bl console_init

	mov r0, 0b0010
	bl led_set

	mov r0, 'R'
	bl console_putc

	mov r0, 'e'
	bl console_putc

	mov r0, 'a'
	bl console_putc

	mov r0, 'd'
	bl console_putc

	mov r0, 'y'
	bl console_putc

	mov r0, '.'
	bl console_putc

	mov r0, 0b0011
	bl led_set

hang:

	b hang
