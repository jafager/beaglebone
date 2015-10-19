ramtest.bin: ramtest.elf
	arm-none-eabi-objcopy $^ -O binary $@

ramtest.elf: linker.ld ramtest.o console.o uart.o sdram.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
