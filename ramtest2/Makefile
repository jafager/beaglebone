all: ramtest.bin

%.bin: %.elf
	arm-none-eabi-objcopy $^ -O binary $@

ramtest.elf: ramtest.ld startup.o ramtest.o sdram.o console.o uart.o led.o reg.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -O2 -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

dump: ramtest.elf
	arm-none-eabi-objdump -d $^ | more

read: ramtest.elf
	arm-none-eabi-readelf -a $^ | more
