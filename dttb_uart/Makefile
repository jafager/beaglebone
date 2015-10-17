all: uart.bin uart.elf

%.bin: %.elf
	arm-none-eabi-objcopy $^ -O binary $@


%.elf: linker.ld %.o 
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
