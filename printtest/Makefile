printtest.bin: printtest.elf
	arm-none-eabi-objcopy $^ -O binary $@

printtest.elf: linker.ld printtest.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
