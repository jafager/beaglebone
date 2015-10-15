# first
This is a first attempt at writing bare-metal code for the Beaglebone that runs as an SPL bootloader (i.e. direct from ROM, without U-Boot).  All it does is disable interrupts, put the CPU in System mode, initialize the LEDs, and light the leftmost and rightmost LEDs.  It runs out of onboard SRAM and does not bother initializing the SDRAM.
