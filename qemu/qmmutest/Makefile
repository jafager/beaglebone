qmmutest.bin: qmmutest.elf
	arm-none-eabi-objcopy $^ -O binary $@

qmmutest.elf: linker.ld qmmutest.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run: qmmutest.bin
	qemu-system-arm -m 128 -kernel qmmutest.bin -nographic -machine integratorcp -cpu cortex-a8
