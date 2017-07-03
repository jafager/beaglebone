all: boot.bin kernel.bin kernel.img

%.bin: %.elf
	arm-none-eabi-objcopy $^ -O binary $@

boot.elf: boot.ld startup.o boot.o console.o uart.o led.o reg.o
	arm-none-eabi-ld -o $@ -T $^

kernel.elf: kernel.ld kernel.o console.o uart.o led.o reg.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -fomit-frame-pointer -c -o $@ $^
	#arm-none-eabi-gcc -O -c -o $@ $^
	#arm-none-eabi-gcc -faggressive-loop-optimizations -fauto-inc-dec -fbranch-count-reg -fcombine-stack-adjustments -fcompare-elim -fcprop-registers -fdce -fdefer-pop -fdelete-null-pointer-checks -fdse -fearly-inlining -fforward-propagate -ffp-contract=fast -ffp-int-builtin-inexact -ffunction-cse -fgcse-lm -fguess-branch-probability -fif-conversion -fif-conversion2 -finline -finline-atomics -finline-functions-called-once -fipa-profile -fipa-pure-const -fipa-reference -fira-algorithm=CB -fira-hoist-pressure -fira-share-save-slots -fira-share-spill-slots -fivopts -fjump-tables -flifetime-dse -flifetime-dse=2 -fmath-errno -fmove-loop-invariants -fomit-frame-pointer -fpeephole -fplt -fprintf-return-value -freg-struct-return -frename-registers -freorder-blocks -freorder-blocks-algorithm=simple -fsched-critical-path-heuristic -fsched-dep-count-heuristic -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic -fsched-pressure -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic -fsched-stalled-insns-dep -fschedule-fusion -fsection-anchors -fshort-enums -fshrink-wrap -fshrink-wrap-separate -fsigned-zeros -fsimd-cost-model=unlimited -fsplit-ivs-in-unroller -fsplit-wide-types -fssa-backprop -fssa-phiopt -fstack-reuse=all -fstdarg-opt -fstrict-volatile-bitfields -ftrapping-math -ftree-bit-ccp -ftree-builtin-call-dce -ftree-ccp -ftree-ch -ftree-coalesce-vars -ftree-copy-prop -ftree-cselim -ftree-dce -ftree-dominator-opts -ftree-dse -ftree-forwprop -ftree-fre -ftree-loop-if-convert -ftree-loop-im -ftree-loop-ivcanon -ftree-loop-optimize -ftree-parallelize-loops=1 -ftree-phiprop -ftree-pta -ftree-reassoc -ftree-scev-cprop -ftree-sink -ftree-slsr -ftree-sra -ftree-ter -fweb -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

%.img: %.bin
	./mksdimg $^ $@

clean:
	rm -f *.bin *.elf *.o *.img

dump: boot.elf
	arm-none-eabi-objdump -d $^ | more

read: boot.elf
	arm-none-eabi-readelf -a $^ | more
