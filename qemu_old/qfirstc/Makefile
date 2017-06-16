qfirstc.bin: qfirstc.elf
	arm-none-eabi-objcopy $^ -O binary $@

qfirstc.elf: linker.ld qfirstc.o c_entry.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run: qfirstc.bin
	qemu-system-arm -m 128 -kernel qfirstc.bin -nographic -machine integratorcp -cpu cortex-a8
