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



    /* Initialize the LEDs */
    bl led_init



    /* Jump to C entry point */
    bl entry



    /* Hang the processor safely */
    b .



handler_reset:

    mov r0, 0b1000
    bl led_write
    b .



handler_undef:

    mov r0, 0b1001
    bl led_write
    b .



handler_swi:

    mov r0, 0b1010
    bl led_write
    b .



handler_pabt:

    mov r0, 0b1011
    bl led_write
    b .



handler_dabt:

    mov r0, 0b1100
    bl led_write
    b .



handler_irq:

    mov r0, 0b1101
    bl led_write
    b .



handler_fiq:

    mov r0, 0b1110
    bl led_write
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
