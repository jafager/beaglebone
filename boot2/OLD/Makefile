all: boot.bin kernel.bin kernel.sd

%.bin: %.elf
	arm-none-eabi-objcopy $^ -O binary $@

boot.elf: boot.ld startup.o boot.o console.o uart.o led.o reg.o
	arm-none-eabi-ld -o $@ -T $^

kernel.elf: kernel.ld kernel.o console.o uart.o led.o reg.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -O2 -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

%.sd: %.bin
	./mksdimg $^ $@

clean:
	rm -f *.bin *.elf *.o *.sd

dump: boot.elf
	arm-none-eabi-objdump -d $^ | more

read: boot.elf
	arm-none-eabi-readelf -a $^ | more
