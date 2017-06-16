.syntax unified


cm_per_base             = 0x44e00000

cm_per_mmc0_clkctrl     = 0x3c

mmchs0_base             = 0x48060000

sd_sysconfig            = 0x110
sd_sysconfig_sysreset   = (1 << 1)

sd_sysstatus            = 0x114
sd_sysstatus_resetdone  = (1 << 0)

sd_capa                 = 0x240
sd_capa_vs18            = (1 << 26)
sd_capa_vs30            = (1 << 25)

sd_con                  = 0x12c
sd_con_ceata            = (1 << 12)
sd_con_dw8              = (1 << 5)
sd_con_od               = (1 << 0)

sd_hctl                 = 0x228
sd_hctl_sdvs_mask       = (0x7 << 9)
sd_hctl_sdvs_30         = (0x6 << 9)
sd_hctl_sdvs_18         = (0x5 << 9)
sd_hctl_sdbp            = (1 << 8)
sd_hctl_dtw             = (1 << 1)

sd_sysctl               = 0x22c
sd_sysctl_ice           = (1 << 0)
sd_sysctl_ics           = (1 << 1)
sd_sysctl_clkd_mask     = (0x3ff << 6)
sd_sysctl_clkd_1023     = (0x3ff << 6)


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

    /* Initiate soft reset */

    ldr base, =mmchs0_base
    mov tmp, sd_sysconfig_sysreset
    str tmp, [base, sd_sysconfig]

    /* Wait for soft reset to complete */

mmc_init_wait_for_reset:

    ldr base, =mmchs0_base
    ldr tmp, [base, sd_sysstatus]
    tst tmp, sd_sysstatus_resetdone
    beq mmc_init_wait_for_reset

    /* Set controller capabilities (1.8V and 3.0V voltage support) */

    ldr base, =mmchs0_base
    mov tmp, (sd_capa_vs18 | sd_capa_vs30)
    str tmp, [base, sd_capa]

    /* No documentation on current figures for SD_CURCAPA, so ignore it for now */

    /* We can probably skip idle and wakeup modes since we are not allowing it to idle? */

    mov tmp, 0x308
    str tmp, [base, sd_sysconfig]

    /* Configure bus transfer modes and bus power */

    ldr tmp, [base, sd_con]
    bic tmp, tmp, sd_con_od
    bic tmp, tmp, sd_con_dw8
    bic tmp, tmp, sd_con_ceata
    str tmp, [base, sd_con]

    ldr tmp, [base, sd_hctl]
    bic tmp, tmp, sd_hctl_sdvs_mask
    bic tmp, tmp, sd_hctl_dtw
    orr tmp, tmp, sd_hctl_sdvs_30
    str tmp, [base, sd_hctl]
    ldr tmp, [base, sd_hctl]
    orr tmp, tmp, sd_hctl_sdbp
    str tmp, [base, sd_hctl]

    ldr r0, =message_waiting_for_bus_power
    bl console_puts

mmc_init_wait_for_bus_power:

    ldr base, =mmchs0_base
    ldr tmp, [base, sd_hctl]
    tst tmp, sd_hctl_sdbp
    beq mmc_init_wait_for_bus_power

    /* Enable internal clock */

    ldr tmp, [base, sd_sysctl]
    orr tmp, tmp, sd_sysctl_ice
    str tmp, [base, sd_sysctl]

    ldr tmp, [base, sd_sysctl]
    ldr r2, =sd_sysctl_clkd_mask
    bic tmp, tmp, r2
    ldr r2, =sd_sysctl_clkd_1023
    orr tmp, tmp, r2
    str tmp, [base, sd_sysctl]

    ldr r0, =message_waiting_for_clock_stable
    bl console_puts

mmc_init_wait_for_clock_stable:

    ldr base, =mmchs0_base
    ldr tmp, [base, sd_sysctl]
    tst tmp, sd_sysctl_ics
    beq mmc_init_wait_for_clock_stable

    /* We can probably skip idle mode configuration since we are not allowing it to idle? */

    pop {pc}



message_waiting_for_bus_power:

    .asciz "Waiting for bus power...\r\n"


message_waiting_for_clock_stable:

    .asciz "Waiting for internal clock to stabilize...\r\n"




.global mmc_identify_card
mmc_identify_card:

    base    .req r4
    tmp     .req r5
    index   .req r6

    push {r4-r6,lr}

    /* Send an initialization stream */

    ldr base, =mmchs0_base
    ldr tmp, [base, sd_con]
    orr tmp, tmp, sd_con_init
    str tmp, [base, sd_con]

    mov tmp, 0
    str tmp, [base, sd_cmd]

mmc_identify_card_delay:

    mov index, 1024
    ldr tmp, [base, sd_stat]
    subs index, index, 1
    bne mmc_identify_card_delay

    ldr tmp, [base, sd_stat]
    bic tmp, tmp, sd_stat_cc
    str tmp, [base, sd_stat]

    ldr tmp, [base, sd_con]
    bic tmp, tmp, sd_con_init
    str tmp, [base, sd_con]

    mov tmp, -1
    str tmp, [base, sd_stat]

    /* Change clock frequency to fit protocol */

    /* Send a CMD0 command */

    mov tmp, 0x190000
    str tmp, [base, sd_cmd]

mmc_identify_card_get_response:

    ldr r0, [base, sd_rsp10]
    bl console_pretty_hexprint
    b mmc_identify_card_get_response

    pop {r4-r6,pc}
