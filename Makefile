taps = tap/barbarian.tap \
	tap/bill-gilbert.tap \
	tap/bomb-jack.tap \
	tap/football.tap \
	tap/robocop.tap \
	tap/tank.tap \
	tap/tank-codes.tap \
	tap/trap-door.tap

all: $(taps)

$(taps): tap/%.tap : boot.%.bas data/screenz.tap
# Create a temporary file first in order to make sure the target file
# gets created only after the entire job has succeeded
	$(eval TMPFILE=$(shell tempfile).tap)

	bas2tap -sLoaders -a10 $< $(TMPFILE)
	cat data/screenz.tap >> $(TMPFILE)

# Rename the temporary file to the target name
	mv $(TMPFILE) $@

boot.%.bas: boot.%.bin src/boot.bas
# Replace the __LOADER__ placeholder with the machine codes with bytes represented as {XX}
	sed s/__LOADER__/$(shell hexdump -ve '1/1 "{%02x}"' $<)/ src/boot.bas > $@

boot.%.bin: boot.%.asm
	pasmo --bin $< $@

boot.%.asm: src/boot.asm src/patches/%.asm
	sed s/__PATCH__/src\\/patches\\/$*.asm/ src/boot.asm > $@

clean:
	rm -f \
		*.asm \
		*.bas \
		*.bin
