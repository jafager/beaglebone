qstringtest.bin: qstringtest.elf
	arm-none-eabi-objcopy $^ -O binary $@

qstringtest.elf: linker.ld qstringtest.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run:
	qemu-system-arm -m 128 -kernel qstringtest.bin -nographic -machine integratorcp -cpu cortex-a8
