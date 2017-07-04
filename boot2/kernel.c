#include "console.h"



void kernel(void)
{
    console_puts("Kernel ready.\r\n");
    while (1);
}
