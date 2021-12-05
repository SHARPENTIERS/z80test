# gmake

RMF   := del

NAME = z80test
VERSION = 1.0

PROGS := z80full z80flags z80doc z80docflags z80ccf z80memptr
SRCS  := main idea crctab tests testmacros print

all: $(addsuffix .mzt,$(PROGS)) $(addsuffix .asm,$(SRCS))

%.out : %.asm $(addsuffix .asm,$(SRCS))
	sjasm.exe $<

%.mzt : %.out
	php makeMzt.php $< $(basename $<) 0x8000 0x8000 $@

FILES := Makefile loader.bas $(addsuffix .asm,$(PROGS)) $(addsuffix .asm, $(SRCS))

clean:
	$(RMF) *.out *.mzt *.lst
