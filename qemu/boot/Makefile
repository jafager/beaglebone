boot.bin: boot.elf
	arm-none-eabi-objcopy $^ -O binary $@

boot.elf: linker.ld startup.o boot.o console.o uart.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run: boot.bin
	qemu-system-arm -machine integratorcp -cpu cortex-a8 -m 128 -nographic -kernel boot.bin

dump: boot.elf
	arm-none-eabi-objdump -d $^
