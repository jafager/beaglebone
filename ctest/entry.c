void led_write(unsigned int pattern);



void entry(void)
{
    const char *derp = "DERP";
    led_write(0b0101);
    while (1);
}
