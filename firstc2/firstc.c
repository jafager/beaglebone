void firstc(void)
{

	unsigned int* ctrl_base		= (unsigned int *)0x44e10000;
	unsigned int* cm_per_base	= (unsigned int *)0x48e00000;
	unsigned int* gpio1_base	= (unsigned int *)0x4804c000;

	/* set pinmux */
	*(ctrl_base + 0x854) = 0x27;
	*(ctrl_base + 0x858) = 0x27;
	*(ctrl_base + 0x85c) = 0x27;
	*(ctrl_base + 0x860) = 0x27;

	/* enable clock */
	*(cm_per_base + 0xac) = 0x2;

	/* set pins as outputs */
	*(gpio1_base + 0x134) &= ~(0xf << 21);

	/* turn all LEDs on */
	*(gpio1_base + 0x194) |= (0xf << 21);

}
