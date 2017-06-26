qemu.bin: qemu.elf
	arm-none-eabi-objcopy $^ -O binary $@

qemu.elf: linker.ld qemu.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run:
	qemu-system-arm -machine integratorcp -cpu cortex-a8 -m 128m -nographic -kernel qemu.bin
