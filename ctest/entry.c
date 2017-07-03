void led_write(unsigned int pattern);



char first_character(char *string)
{
    return *string;
}



void entry(void)
{
    led_write(0b0111);
    char *derp = "CDEFAB";
    led_write(first_character(derp));
    while (1);
}
