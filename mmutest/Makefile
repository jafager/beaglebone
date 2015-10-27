mmutest.bin: mmutest.elf
	arm-none-eabi-objcopy $^ -O binary $@

mmutest.elf: linker.ld mmutest.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
