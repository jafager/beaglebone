timertest.bin: timertest.elf
	arm-none-eabi-objcopy $^ -O binary $@

timertest.elf: linker.ld timertest.o led.o console.o uart.o timer.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o
