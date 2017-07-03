#ifndef LED_H
#define LED_H



#include "stdint.h"
#include "reg.h"



#define CM_PER                                      0x44e00000
#define CM_PER_GPIO1_CLKCTRL                        0xac
#define CM_PER_GPIO1_CLKCTRL_MODULEMODE             (0b11 << 0)
#define CM_PER_GPIO1_CLKCTRL_MODULEMODE_ENABLE      (0b10 << 0)
#define CTRL                                        0x44e10000
#define CTRL_CONF_GPMC_A5                           0x854
#define CTRL_CONF_GPMC_A6                           0x858
#define CTRL_CONF_GPMC_A7                           0x85c
#define CTRL_CONF_GPMC_A8                           0x860
#define CTRL_CONF_MMODE                             (0b111 << 0)
#define CTRL_CONF_MMODE_MODE7                       (0b111 << 0)
#define CTRL_CONF_PUDEN                             (1 << 3)
#define CTRL_CONF_PUDEN_ENABLE                      (0 << 3)
#define CTRL_CONF_PUTYPESEL                         (1 << 4)
#define CTRL_CONF_PUTYPESEL_PULLDOWN                (0 << 4)
#define CTRL_CONF_RXACTIVE                          (1 << 5)
#define CTRL_CONF_RXACTIVE_ENABLE                   (1 << 5)
#define CTRL_CONF_SLEWCTRL                          (1 << 6)
#define CTRL_CONF_SLEWCTRL_FAST                     (0 << 6)
#define GPIO1                                       0x4804c000
#define GPIO_CLEARDATAOUT                           0x190
#define GPIO_LED_MASK                               (0b1111 << 21)
#define GPIO_OE                                     0x134
#define GPIO_SETDATAOUT                             0x194



void led_init(void);
void led_write(uint32_t pattern);



#endif /* LED_H */
