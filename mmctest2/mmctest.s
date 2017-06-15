.syntax unified


.text


.global mmctest
mmctest:


    /* Switch to Abort mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x17
    msr cpsr, r0

    ldr sp, =stack_abort


    /* Switch to Fast Interrupt Request mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x11
    msr cpsr, r0

    ldr sp, =stack_fiq


    /* Switch to Interrupt Request mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x12
    msr cpsr, r0

    ldr sp, =stack_irq


    /* Switch to Undefined Instruction mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x1b
    msr cpsr, r0

    ldr sp, =stack_undefined


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


    /* Set vector table */

    ldr r0, =vector_table
    mcr p15, 0, r0, c12, c0, 0

    ldr r0, =message_vector_table_initialized
    bl console_puts


    /* Enable instruction cache */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 12)
    mcr p15, 0, r0, c1, c0, 0

    ldr r0, =message_instruction_cache_enabled
    bl console_puts


    /* Build translation table */

    ldr r0, =translation_table
    mov r1, 0
next_entry:
    ldr r2, =0xc02
    orr r2, r2, r1, lsl 20
    str r2, [r0]
    add r0, r0, 4
    add r1, r1, 1
    ldr r2, =0x1000
    cmp r1, r2
    bne next_entry

    ldr r0, =message_translation_table_created
    bl console_puts

    /* Set translation table */

    ldr r0, =translation_table
    mcr p15, 0, r0, c2, c0, 0

    ldr r0, =message_translation_table_set
    bl console_puts


    /* Configure domain */

    mov r0, 0x3
    mcr p15, 0, r0, c3, c0, 0

    ldr r0, =message_domain_configured
    bl console_puts


    /* Enable MMU */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 0)
    mcr p15, 0, r0, c1, c0, 0

    ldr r0, =message_mmu_enabled
    bl console_puts


    /* Enable data and L2 cache */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 2)
    mcr p15, 0, r0, c1, c0, 0

    ldr r0, =message_data_and_l2_caches_enabled
    bl console_puts


    /* Initialize MMCHS controller */

    bl mmc_init

    ldr r0, =message_mmchs_controller_initialized
    bl console_puts


    /* Success! */

    ldr r0, =message_ready
    bl console_puts


hang:

    b hang


vector_table:

    ldr pc, =handler_reset          /* Reset */
    ldr pc, =handler_undefined      /* Undefined Instruction */
    ldr pc, =handler_swi            /* Software Interrupt */
    ldr pc, =handler_prefetch_abort /* Prefetch Abort */
    ldr pc, =handler_data_abort     /* Data Abort */
    b .                             /* Not Assigned */
    ldr pc, =handler_irq            /* IRQ */
    ldr pc, =handler_fiq            /* FIQ */


handler_reset:

    ldr r0, =message_reset
    bl console_puts
    b .


handler_undefined:

    ldr r0, =message_undefined
    bl console_puts
    b .


handler_swi:

    ldr r0, =message_swi
    bl console_puts
    b .


handler_prefetch_abort:

    ldr r0, =message_prefetch_abort
    bl console_puts
    b .


handler_data_abort:

    ldr r0, =message_data_abort
    bl console_puts
    b .


handler_irq:

    ldr r0, =message_irq
    bl console_puts
    b .


handler_fiq:

    ldr r0, =message_fiq
    bl console_puts
    b .



message_ready:

    .asciz "Ready.\r\n"


message_reset:

    .asciz "Reset!\r\n"


message_undefined:

    .asciz "Undefined Instruction!\r\n"


message_swi:

    .asciz "Software Interrupt!\r\n"


message_irq:

    .asciz "Interrupt Request!\r\n"


message_fiq:

    .asciz "Fast Interrupt Request!\r\n"


message_prefetch_abort:

    .asciz "Prefetch Abort!\r\n"


message_data_abort:

    .asciz "Data Abort!\r\n"


message_console_initialized:

    .asciz "Console initialized.\r\n"


message_vector_table_initialized:

    .asciz "Vector table initialized.\r\n"


message_instruction_cache_enabled:

    .asciz "Instruction cache enabled.\r\n"


message_translation_table_created:

    .asciz "Translation table created.\r\n"


message_translation_table_set:

    .asciz "Translation table set.\r\n"


message_domain_configured:

    .asciz "Domain configured.\r\n"


message_mmu_enabled:

    .asciz "MMU enabled.\r\n"


message_data_and_l2_caches_enabled:

    .asciz "Data and L2 caches enabled.\r\n"


message_mmchs_controller_initialized:

    .asciz "MMCHS controller initialized.\r\n"
