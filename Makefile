patches := $(shell find src/patches -name \*.asm)
taps    := $(addprefix tap/,$(addsuffix .tap,$(basename $(notdir $(patches)))))

all: $(taps)

$(taps): tap/%.tap : boot.%.bas breath.tap
# Create a temporary file first in order to make sure the target file
# gets created only after the entire job has succeeded
	$(eval TMPFILE=$(shell tempfile).tap)

	bas2tap -sLoaders -a10 $< $(TMPFILE)
	cat breath.tap >> $(TMPFILE)

# Rename the temporary file to the target name
	mv $(TMPFILE) $@

boot.%.bas: boot.%.bin src/boot.bas
# Replace the __LOADER__ placeholder with the machine codes with bytes represented as {XX}
	sed s/__LOADER__/$(shell hexdump -ve '1/1 "{%02x}"' $<)/ src/boot.bas > $@

boot.%.bin: boot.%.asm
	pasmo --bin $< $@

boot.%.asm: src/boot.asm src/patches/%.asm
	sed s/__PATCH__/src\\/patches\\/$*.asm/ src/boot.asm > $@

breath.tap: breath.000
	0totap -o breath.tap breath.000

breath.000: scr/breath.scr
	rm -f breath.000
	binto0 scr/breath.scr 4
	mv scr/breath.000 breath.000

clean:
	rm -f \
		*.000 \
		*.asm \
		*.bas \
		*.bin \
		*.tap
