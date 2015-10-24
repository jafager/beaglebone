qfirst.bin: qfirst.elf
	arm-none-eabi-objcopy $^ -O binary $@

qfirst.elf: linker.ld qfirst.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
