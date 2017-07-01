.syntax unified



ctrl_base               = 0x44e10000
ctrl_conf_gpmc_a5       = 0x854
ctrl_conf_gpmc_a6       = 0x858
ctrl_conf_gpmc_a7       = 0x85c
ctrl_conf_gpmc_a8       = 0x860

cm_per_base             = 0x44e00000
cm_per_gpio1_clkctrl    = 0xac

gpio1_base              = 0x4804c000
gpio_oe                 = 0x134
gpio_cleardataout       = 0x190
gpio_setdataout         = 0x194



.text



.global led_init
led_init:

    base    .req r4
    tmp     .req r5

    push {r4-r5,lr}

    /* Set pinmux */
    ldr base, =ctrl_base
    ldr tmp, [base, ctrl_conf_gpmc_a5]
    bic tmp, tmp, 0b111111
    orr tmp, tmp, 0b100111
    str tmp, [base, ctrl_conf_gpmc_a5]
    ldr tmp, [base, ctrl_conf_gpmc_a6]
    bic tmp, tmp, 0b111111
    orr tmp, tmp, 0b100111
    str tmp, [base, ctrl_conf_gpmc_a6]
    ldr tmp, [base, ctrl_conf_gpmc_a7]
    bic tmp, tmp, 0b111111
    orr tmp, tmp, 0b100111
    str tmp, [base, ctrl_conf_gpmc_a7]
    ldr tmp, [base, ctrl_conf_gpmc_a8]
    bic tmp, tmp, 0b111111
    orr tmp, tmp, 0b100111
    str tmp, [base, ctrl_conf_gpmc_a8]

    /* Enable clock */
    ldr base, =cm_per_base
    ldr tmp, [base, cm_per_gpio1_clkctrl]
    bic tmp, tmp, 0b11
    orr tmp, tmp, 0b10
    str tmp, [base, cm_per_gpio1_clkctrl]

    /* Set outputs */
    ldr base, =gpio1_base
    ldr tmp, [base, gpio_oe]
    bic tmp, tmp, 0b1111 << 21
    str tmp, [base, gpio_oe]

    /* Set LEDs */
    ldr base, =gpio1_base
    mov tmp, 0b1111 << 21
    str tmp, [base, gpio_setdataout]

    pop {r4-r5,pc}
    
    .unreq base
    .unreq tmp



.global led_write
led_write:

    pattern .req r0
    base    .req r4
    tmp     .req r5

    push {r4-r5,lr}

    ldr base, =gpio1_base
    mov tmp, 0b1111 << 21
    str tmp, [base, gpio_cleardataout]

    ldr base, =gpio1_base
    and tmp, pattern, 0b1111
    mov tmp, tmp, lsl 21
    str tmp, [base, gpio_setdataout]

    pop {r4-r5,pc}

    .unreq pattern
    .unreq base
    .unreq tmp
