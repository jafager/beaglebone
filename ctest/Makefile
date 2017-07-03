all: ctest.bin

%.bin: %.elf
	arm-none-eabi-objcopy $^ -O binary $@

ctest.elf: linker.ld startup.o entry.o led.o
	arm-none-eabi-ld -o $@ -T $^

%.o: %.c
	arm-none-eabi-gcc -O -fno-branch-count-reg -fno-combine-stack-adjustments -fno-compare-elim -fno-cprop-registers -fno-defer-pop -fno-forward-propagate -fno-guess-branch-probability -fno-if-conversion -fno-if-conversion2 -fno-inline-functions-called-once -fno-ipa-profile -fno-ipa-pure-const -fno-ipa-reference -fno-move-loop-invariants -fno-omit-frame-pointer -fno-reorder-blocks -fno-sched-pressure -fno-section-anchors -fno-shrink-wrap -fno-split-wide-types -fno-ssa-phiopt -fno-tree-bit-ccp -fno-tree-builtin-call-dce -fno-tree-ccp -fno-tree-ch -fno-tree-coalesce-vars -fno-tree-copy-prop -fno-tree-dce -fno-tree-dominator-opts -fno-tree-dse -fno-tree-fre -fno-tree-pta -fno-tree-sink -fno-tree-slsr -fno-tree-sra -fno-tree-ter -c -o $@ $^

%.o: %.s
	arm-none-eabi-as -o $@ $^

clean:
	rm -f *.bin *.elf *.o

dump: ctest.elf
	arm-none-eabi-objdump -d $^ | more

read: ctest.elf
	arm-none-eabi-readelf -a $^ | more

#  -fpack-struct=<number>      		
#  -fsched-stalled-insns-dep=<number> 	
#  -fsched-stalled-insns=<number> 	
#  -fira-region=[one|all|mixed] 		[default]
#  -fvect-cost-model=[unlimited|dynamic|cheap] 	[default]

