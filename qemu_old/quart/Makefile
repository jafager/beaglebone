quart.bin: quart.elf
	arm-none-eabi-objcopy $^ -O binary $@

quart.elf: linker.ld quart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run:
	qemu-system-arm -m 128 -kernel quart.bin -nographic -machine integratorcp -cpu cortex-a8
