.syntax unified



.text



.global qemu
qemu:



    /* Switch to Abort mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x17
    msr cpsr, r0

    ldr sp, =stack_abort



    /* Switch to Undefined mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x1b
    msr cpsr, r0

    ldr sp, =stack_undefined



    /* Switch to Interrupt Request mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x12
    msr cpsr, r0

    ldr sp, =stack_irq



    /* Switch to Fast Interrupt Request mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x11
    msr cpsr, r0

    ldr sp, =stack_fiq



    /* Switch to Supervisor mode and set up its stack */

    mrs r0, cpsr
    bic r0, r0, 0x1f
    orr r0, r0, 0x13
    msr cpsr, r0

    ldr sp, =stack_supervisor



    /* Initialize console */

    bl console_init



    /* Set up interrupt/exception vector table */

    ldr r0, =vector_table
    mcr p15, 0, r0, c12, c0, 0



    /* Enable instruction cache */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 12)
    mcr p15, 0, r0, c1, c0, 0



    /* Build translation table for identity mapping */

    table   .req r0
    frame   .req r1
    entry   .req r2

    ldr table, =translation_table
    mov frame, 0

    qemu_translation_table_next_entry:

        ldr entry, =0xc02
        orr entry, entry, frame, lsl 20
        str entry, [table]
        add table, table, 4
        add frame, frame, 1
        cmp frame, 0x1000
        bne qemu_translation_table_next_entry

    .unreq table
    .unreq frame
    .unreq entry

    

    /* Set translation table */

    ldr r0, =translation_table
    mcr p15, 0, r0, c2, c0, 0



    /* Configure domain */

    mov r0, 0x3
    mcr p15, 0, r0, c3, c0, 0



    /* Enable MMU */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 0)
    mcr p15, 0, r0, c1, c0, 0



    /* Enable data and L2 cache */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, (1 << 2)
    mcr p15, 0, r0, c1, c0, 0



    /* Ready */

    ldr r0, =message_ready
    bl console_puts



    /* Hang the processor */

    b .



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
