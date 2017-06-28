boot.bin: boot.elf
	arm-none-eabi-objcopy $^ -O binary $@

boot.elf: linker.ld startup.o boot.o console.o uart.o reg.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

run: boot.bin sd_card.img
	qemu-system-arm -machine integratorcp -cpu cortex-a8 -m 128 -nographic -kernel boot.bin -sd sd_card.img

debug: boot.bin sd_card.img
	qemu-system-arm-debug -machine integratorcp -cpu cortex-a8 -m 128 -nographic -kernel boot.bin -sd sd_card.img

dump: boot.elf
	arm-none-eabi-objdump -d $^
