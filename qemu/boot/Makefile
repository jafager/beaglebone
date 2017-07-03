all: boot.bin kernel.bin kernel.img

%.bin: %.elf
	arm-none-eabi-objcopy $^ -O binary $@

boot.elf: boot.ld startup.o boot.o console.o uart.o reg.o
	arm-none-eabi-ld -o $@ -T $^

kernel.elf: kernel.ld kernel.o console.o uart.o reg.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

%.img: %.bin
	./mksdimg $^ $@

clean:
	rm -f *.bin *.elf *.o

run: boot.bin kernel.img
	qemu-system-arm -machine integratorcp -cpu cortex-a8 -m 128 -nographic -kernel boot.bin -drive if=sd,format=raw,index=0,file=kernel.img

derp: boot.bin derp.img
	qemu-system-arm -machine integratorcp -cpu cortex-a8 -m 128 -nographic -kernel boot.bin -drive if=sd,format=raw,index=0,file=derp.img

moby: boot.bin moby_dick.img
	qemu-system-arm -machine integratorcp -cpu cortex-a8 -m 128 -nographic -kernel boot.bin -drive if=sd,format=raw,index=0,file=moby_dick.img

debug: boot.bin kernel.img
	qemu-system-arm-debug -machine integratorcp -cpu cortex-a8 -m 128 -nographic -kernel boot.bin -drive if=sd,format=raw,index=0,file=kernel.img

dump: boot.elf
	arm-none-eabi-objdump -d $^
