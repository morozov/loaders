boot.tap: src/boot.bas loader.tap screenz.tap
	bas2tap -sLoaders -a10 src/boot.bas boot.tap
	cat loader.tap screenz.tap >> boot.tap

loader.tap: src/loader.asm $(shell find src/patches/ -type f)
	pasmo --tap src/loader.asm loader.tap
