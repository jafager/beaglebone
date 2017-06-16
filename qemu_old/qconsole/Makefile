qconsole.bin: qconsole.elf
	arm-none-eabi-objcopy $^ -O binary $@

qconsole.elf: linker.ld qconsole.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run:
	qemu-system-arm -m 128 -kernel qconsole.bin -nographic -machine integratorcp -cpu cortex-a8
