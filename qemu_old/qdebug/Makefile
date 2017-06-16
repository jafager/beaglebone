qdebug.bin: qdebug.elf
	arm-none-eabi-objcopy $^ -O binary $@

qdebug.elf: linker.ld qdebug.o console.o uart.o debug.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run:
	qemu-system-arm -m 128 -kernel qdebug.bin -nographic -machine integratorcp -cpu cortex-a8
