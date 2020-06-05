boot.tap: boot.bas data/screenz.tap
	bas2tap -sLoaders -a10 boot.bas boot.tap
	cat data/screenz.tap >> boot.tap

boot.bas: src/boot.bas boot.bin
# Replace the __LOADER__ placeholder with the machine codes with bytes represented as {XX}
	sed "s/__LOADER__/$(shell hexdump -ve '1/1 "{%02x}"' boot.bin)/" src/boot.bas > boot.bas

boot.bin: src/boot.asm
	pasmo --bin src/boot.asm boot.bin

clean:
	rm -f \
		*.bas \
		*.bin
