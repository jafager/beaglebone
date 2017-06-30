#include "led.h"
#include "console.h"



void boot(void)
{
    led_init();
    led_write(0b1111);
    //console_init();
    //console_puts("Ready.\r\n");
    while (1);
}
