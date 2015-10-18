irqtest.bin: irqtest.elf
	arm-none-eabi-objcopy $^ -O binary $@

irqtest.elf: linker.ld irqtest.o led.o console.o uart.o timer.o intc.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
