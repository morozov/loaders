boot.tap: boot.bas data/screenz.tap
# Create a temporary file first in order to make sure the target file
# gets created only after the entire job has succeeded
	$(eval TMPFILE=$(shell tempfile).tap)

	bas2tap -sLoaders -a10 boot.bas $(TMPFILE)
	cat data/screenz.tap >> $(TMPFILE)

# Rename the temporary file to the target name
	mv $(TMPFILE) $@

boot.bas: src/boot.bas boot.bin
# Replace the __LOADER__ placeholder with the machine codes with bytes represented as {XX}
	sed "s/__LOADER__/$(shell hexdump -ve '1/1 "{%02x}"' boot.bin)/" src/boot.bas > boot.bas

boot.bin: src/boot.asm
	pasmo --bin src/boot.asm boot.bin

clean:
	rm -f \
		*.bas \
		*.bin
