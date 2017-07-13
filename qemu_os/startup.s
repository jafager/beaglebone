.syntax unified



cpsr_jazelle        = (1 << 24)
cpsr_irq_disable    = (1 << 7)
cpsr_fiq_disable    = (1 << 6)
cpsr_thumb          = (1 << 5)
cpsr_svc            = (0b11111 << 0)
cpsr_svc_abt        = (0b10111 << 0)
cpsr_svc_fiq        = (0b10001 << 0)
cpsr_svc_irq        = (0b10010 << 0)
cpsr_svc_svc        = (0b10011 << 0)
cpsr_svc_sys        = (0b11111 << 0)
cpsr_svc_und        = (0b11011 << 0)
cpsr_svc_usr        = (0b10000 << 0)

c1_icache           = (1 << 12)



.text



.global startup
startup:



    /* Disable Jazelle, IRQ and FIQ interrupts, and Thumb mode */

    mrs r0, cpsr
    bic r0, r0, cpsr_jazelle
    orr r0, r0, cpsr_irq_disable
    orr r0, r0, cpsr_fiq_disable
    bic r0, r0, cpsr_thumb
    msr cpsr, r0



    /* Set up stack pointers for various processor modes */

    mrs r0, cpsr
    bic r0, r0, cpsr_svc
    orr r0, r0, cpsr_svc_abt
    msr cpsr, r0
    ldr sp, =stack_abt

    mrs r0, cpsr
    bic r0, r0, cpsr_svc
    orr r0, r0, cpsr_svc_fiq
    msr cpsr, r0
    ldr sp, =stack_fiq

    mrs r0, cpsr
    bic r0, r0, cpsr_svc
    orr r0, r0, cpsr_svc_irq
    msr cpsr, r0
    ldr sp, =stack_irq

    mrs r0, cpsr
    bic r0, r0, cpsr_svc
    orr r0, r0, cpsr_svc_und
    msr cpsr, r0
    ldr sp, =stack_und

    mrs r0, cpsr
    bic r0, r0, cpsr_svc
    orr r0, r0, cpsr_svc_svc
    msr cpsr, r0
    ldr sp, =stack_svc



    /* Set up the interrupt/exception vector table */

    ldr r0, =vector_table
    mcr p15, 0, r0, c12, c0, 0



    /* Enable instruction cache */

    mrc p15, 0, r0, c1, c0, 0
    orr r0, r0, c1_icache
    mcr p15, 0, r0, c1, c0, 0



    /* Branch to C entry point */

    bl boot



    /* Hang the processor safely */

    b .



handler_reset:

    ldr r0, =0xdeadbee0
    b .



handler_undef:

    ldr r0, =0xdeadbee1
    b .



handler_swi:

    ldr r0, =0xdeadbee2
    b .



handler_pabt:

    ldr r0, =0xdeadbee3
    b .



handler_dabt:

    ldr r0, =0xdeadbee4
    b .



handler_irq:

    ldr r0, =0xdeadbee5
    b .



handler_fiq:

    ldr r0, =0xdeadbee6
    b .



vector_table:

    ldr pc, =handler_reset
    ldr pc, =handler_undef
    ldr pc, =handler_swi
    ldr pc, =handler_pabt
    ldr pc, =handler_dabt
    b .
    ldr pc, =handler_irq
    ldr pc, =handler_fiq
