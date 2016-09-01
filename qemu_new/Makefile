qemu.bin: qemu.elf
	arm-none-eabi-objcopy $^ -O binary $@

qemu.elf: linker.ld qemu.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run: qemu.bin
	qemu-system-arm -m 128 -kernel qemu.bin -nographic -machine integratorcp -cpu cortex-a8
