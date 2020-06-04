boot.tap: boot.bas loader.tap screenz.tap
	bas2tap -sBarbarian+ -a10 boot.bas boot.tap
	cat loader.tap screenz.tap >> boot.tap

loader.tap: loader.asm $(shell find patches/ -type f)
	pasmo --tap loader.asm loader.tap
