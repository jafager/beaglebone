#include "stdint.h"
#include "reg.h"
#include "led.h"
#include "console.h"
#include "sdram.h"



void ramtest(void)
{
    led_init();
    led_write(0b0100);
    
    console_init();
    led_write(0b0101);

    console_puts("Initializing SDRAM...\r\n");
    sdram_init();
    console_puts("SDRAM initialized.\r\n");

    console_puts("\r\n");

    uint32_t test_count = 0;
    while (1)
    {
        console_puts("Beginning write test...\r\n");
        for (uint32_t row = 0; row < 16; row++)
        {
            for (uint32_t column = 0; column < 64; column++)
            {
                for (uint32_t offset = 0; offset < (128 * 1024); offset++)
                {
                    uint32_t *address = 0x80000000 + (row * 64 * 128 * 1024 * 4) + (column * 128 * 1024 * 4) + (offset * 4);
                    *address = 0xdeadbeef + ((uint32_t)address & 0xffff) + ((test_count & 0xffff) << 18);
                }
                console_puts(".");
            }
            console_puts("\r\n");
        }
        console_puts("Write test complete.\r\n");
        console_puts("\r\n");
        console_puts("Beginning read test...\r\n");
        for (uint32_t row = 0; row < 16; row++)
        {
            for (uint32_t column = 0; column < 64; column++)
            {
                for (uint32_t offset = 0; offset < (128 * 1024); offset++)
                {
                    uint32_t *address = 0x80000000 + (row * 64 * 128 * 1024 * 4) + (column * 128 * 1024 * 4) + (offset * 4);
                    uint32_t value = *address;
                    uint32_t expected_value = 0xdeadbeef + ((uint32_t)address & 0xffff) + ((test_count & 0xffff) << 18);
                    if (value != expected_value)
                    {
                        console_puts("\r\n");
                        console_puts("Read test failed at address 0x");
                        console_hexprint((uint32_t)address);
                        console_puts(", expected value 0x");
                        console_hexprint(expected_value);
                        console_puts(", actual value 0x");
                        console_hexprint(value);
                        console_puts("\r\n");
                        while (1);
                    }
                }
                console_puts(".");
            }
            console_puts("\r\n");
        }
        console_puts("Read test complete.\r\n");
        console_puts("\r\n");
        test_count++;
    }
}
