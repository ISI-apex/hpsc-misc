foo:
        mov     x0, 0xa000
        movk    x0, 0xfffe, lsl 16
	br	x0
