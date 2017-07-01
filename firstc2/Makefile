firstc.bin: firstc.elf
	arm-none-eabi-objcopy $^ -O binary $@

firstc.elf: linker.ld startup.o firstc.o
	arm-none-eabi-ld -o $@ -T $^
	
firstc.o: firstc.c
	arm-none-eabi-gcc -c -o $@ -ffreestanding -nostdlib $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
