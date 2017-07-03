#include "led.h"
#include "console.h"



void boot(void)
{
    led_write(0b0001);
    led_init();
    led_write(0b0011);
    console_init();
    led_write(0b0101);
    console_puts("Ready.\r\n");
    led_write(0b0111);
}
