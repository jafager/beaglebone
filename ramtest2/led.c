#include "stdint.h"
#include "reg.h"
#include "led.h"



void led_init(void)
{
    /* Set pin multiplexer for GPMC_A5-A8 to GPIO1_21-24 (LED pins) */
    regmask32(CTRL + CTRL_CONF_GPMC_A5, CTRL_CONF_SLEWCTRL, CTRL_CONF_SLEWCTRL_FAST);
    regmask32(CTRL + CTRL_CONF_GPMC_A5, CTRL_CONF_RXACTIVE, CTRL_CONF_RXACTIVE_ENABLE);
    regmask32(CTRL + CTRL_CONF_GPMC_A5, CTRL_CONF_PUTYPESEL, CTRL_CONF_PUTYPESEL_PULLDOWN);
    regmask32(CTRL + CTRL_CONF_GPMC_A5, CTRL_CONF_PUDEN, CTRL_CONF_PUDEN_ENABLE);
    regmask32(CTRL + CTRL_CONF_GPMC_A5, CTRL_CONF_MMODE, CTRL_CONF_MMODE_MODE7);
    regmask32(CTRL + CTRL_CONF_GPMC_A6, CTRL_CONF_SLEWCTRL, CTRL_CONF_SLEWCTRL_FAST);
    regmask32(CTRL + CTRL_CONF_GPMC_A6, CTRL_CONF_RXACTIVE, CTRL_CONF_RXACTIVE_ENABLE);
    regmask32(CTRL + CTRL_CONF_GPMC_A6, CTRL_CONF_PUTYPESEL, CTRL_CONF_PUTYPESEL_PULLDOWN);
    regmask32(CTRL + CTRL_CONF_GPMC_A6, CTRL_CONF_PUDEN, CTRL_CONF_PUDEN_ENABLE);
    regmask32(CTRL + CTRL_CONF_GPMC_A6, CTRL_CONF_MMODE, CTRL_CONF_MMODE_MODE7);
    regmask32(CTRL + CTRL_CONF_GPMC_A7, CTRL_CONF_SLEWCTRL, CTRL_CONF_SLEWCTRL_FAST);
    regmask32(CTRL + CTRL_CONF_GPMC_A7, CTRL_CONF_RXACTIVE, CTRL_CONF_RXACTIVE_ENABLE);
    regmask32(CTRL + CTRL_CONF_GPMC_A7, CTRL_CONF_PUTYPESEL, CTRL_CONF_PUTYPESEL_PULLDOWN);
    regmask32(CTRL + CTRL_CONF_GPMC_A7, CTRL_CONF_PUDEN, CTRL_CONF_PUDEN_ENABLE);
    regmask32(CTRL + CTRL_CONF_GPMC_A7, CTRL_CONF_MMODE, CTRL_CONF_MMODE_MODE7);
    regmask32(CTRL + CTRL_CONF_GPMC_A8, CTRL_CONF_SLEWCTRL, CTRL_CONF_SLEWCTRL_FAST);
    regmask32(CTRL + CTRL_CONF_GPMC_A8, CTRL_CONF_RXACTIVE, CTRL_CONF_RXACTIVE_ENABLE);
    regmask32(CTRL + CTRL_CONF_GPMC_A8, CTRL_CONF_PUTYPESEL, CTRL_CONF_PUTYPESEL_PULLDOWN);
    regmask32(CTRL + CTRL_CONF_GPMC_A8, CTRL_CONF_PUDEN, CTRL_CONF_PUDEN_ENABLE);
    regmask32(CTRL + CTRL_CONF_GPMC_A8, CTRL_CONF_MMODE, CTRL_CONF_MMODE_MODE7);

    /* Enable clocks for GPIO1 module */
    regmask32(CM_PER + CM_PER_GPIO1_CLKCTRL, CM_PER_GPIO1_CLKCTRL_MODULEMODE, CM_PER_GPIO1_CLKCTRL_MODULEMODE_ENABLE);

    /* Wait for GPIO1 clocks to stabilize */
    while ((regread32(CM_PER + CM_PER_GPIO1_CLKCTRL) & CM_PER_GPIO1_CLKCTRL_MODULEMODE) != CM_PER_GPIO1_CLKCTRL_MODULEMODE_ENABLE);

    /* Set the LED pins as outputs */
    regmask32(GPIO1 + GPIO_OE, GPIO_LED_MASK, 0);

    /* Clear LEDs */
    led_write(0b0110);
}



void led_write(uint32_t pattern)
{
    regwrite32(GPIO1 + GPIO_CLEARDATAOUT, 0xf << 21);
    regwrite32(GPIO1 + GPIO_SETDATAOUT, (pattern & 0xf) << 21);
}