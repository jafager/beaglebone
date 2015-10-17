uart.bin: uart.elf
	arm-none-eabi-objcopy $^ -O binary $@

uart.elf: linker.ld uart.o 
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
