mmctest.bin: mmctest.elf
	arm-none-eabi-objcopy $^ -O binary $@

mmctest.elf: linker.ld mmctest.o mmc.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
