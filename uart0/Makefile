uart0.bin: uart0.elf
	arm-none-eabi-objcopy $^ -O binary $@

uart0.elf: linker.ld uart0.o console.o uart.o led.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
