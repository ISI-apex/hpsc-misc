
all: a53fsb.bin

a53fsb.bin: a53fsb.out
	aarch64-linux-gnu-objcopy a53fsb.out a53fsb.bin -O binary

a53fsb.out: a53fsb.S
	aarch64-linux-gnu-as a53fsb.S -o a53fsb.out
