.syntax unified


cm_per_base             = 0x44e00000

cm_per_mmc0_clkctrl     = 0x3c

mmchs0_base             = 0x48060000

sd_sysconfig            = 0x110
sd_sysconfig_sysreset   = (1 << 1)
sd_sysstatus            = 0x114
sd_sysstatus_resetdone  = (1 << 0)


.text


.global mmc_init
mmc_init:

    base    .req r0
    tmp     .req r1

    push {lr}


    /* Enable the clock for the MMC module */

    ldr base, =cm_per_base
    mov tmp, 2
    str tmp, [base, cm_per_mmc0_clkctrl]

    /* Wait for module to wake up */

    ldr r0, [base, cm_per_mmc0_clkctrl]
    bl console_pretty_hexprint

    /* Initiate soft reset */

    ldr base, =mmchs0_base
    mov tmp, sd_sysconfig_sysreset
    str tmp, [base, sd_sysconfig]

    /* Wait for soft reset to complete */

mmc_init_wait_for_reset:

    ldr r0, [base, sd_sysstatus]
    bl console_pretty_hexprint

    ldr base, =mmchs0_base
    ldr tmp, [base, sd_sysstatus]
    tst tmp, sd_sysstatus_resetdone
    beq mmc_init_wait_for_reset

    pop {pc}
