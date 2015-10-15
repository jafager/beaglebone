first.bin: first.elf
	arm-none-eabi-objcopy $^ -O binary $@

first.elf: linker.ld first.o led.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
