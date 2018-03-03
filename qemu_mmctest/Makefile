all: mmctest.bin

%.bin: %.elf
	arm-none-eabi-objcopy $^ -O binary $@

mmctest.elf: mmctest.ld startup.o mmctest.o mmc.o console.o uart.o reg.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -O2 -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
