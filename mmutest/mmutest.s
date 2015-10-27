.syntax unified


.text


.global mmutest
mmutest:


    /* Switch to Abort mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x17
    msr cpsr, r0

    ldr sp, =stack_abort


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

    ldr r0, =message_console_initialized
    bl console_puts


    /* Enable instruction cache */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 12)
    mcr p15, 0, r0, c1, c0, 0

    ldr r0, =message_console_initialized
    bl console_puts


    /* Build translation table */

    ldr r0, =translation_table
    mov r1, 0
next_entry:
    ldr r2, =0x302
    orr r2, r2, r1, lsl 20
    str r2, [r0]
    add r0, r0, 4
    add r1, r1, 1
    ldr r2, =0x1000
    cmp r1, r2
    bne next_entry

    ldr r0, =message_console_initialized
    bl console_puts


    /* Set translation table */

    ldr r0, =translation_table
    mcr p15, 0, r0, c2, c0, 0

    ldr r0, =message_console_initialized
    bl console_puts


    /* Configure domain */

    mov r0, 0x3
    mcr p15, 0, r0, c3, c0, 0


    /* Enable MMU */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 0)
    mcr p15, 0, r0, c1, c0, 0

    ldr r0, =message_console_initialized
    bl console_puts


    /* Enable data and L2 cache */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 2)
    mcr p15, 0, r0, c1, c0, 0

    ldr r0, =message_console_initialized
    bl console_puts


    /* Success! */

    ldr r0, =message_ready
    bl console_puts


hang:

    b hang


vector_table:

    b .                             /* Reset */
    b .                             /* Undefined Instruction */
    b .                             /* Software Interrupt */
    ldr pc, =handler_prefetch_abort /* Prefetch Abort */
    ldr pc, =handler_data_abort     /* Data Abort */
    b .                             /* Not Assigned */
    b .                             /* IRQ */
    b .                             /* FIQ */


handler_prefetch_abort:

    ldr r0, =message_prefetch_abort
    bl console_puts
    b .


handler_data_abort:

    ldr r0, =message_data_abort
    bl console_puts
    b .


message_ready:

    .asciz "Ready.\r\n"


message_prefetch_abort:

    .asciz "Prefetch Abort!\r\n"


message_data_abort:

    .asciz "Data Abort!\r\n"


message_console_initialized:

    .asciz "Console initialized.\r\n"
