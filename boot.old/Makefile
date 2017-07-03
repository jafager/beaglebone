all: uart.o

%.o: %.c
	arm-none-eabi-gcc -c -o $@ -ffreestanding -nostdlib $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.o
