# .SUFFIXES: .c.in .h.in .urs.in .ur.in .urp.in .o

M4       = m4
M4FLAGS  =
M4SCRIPT =

CFLAGS := -I/usr/local/include/urweb `pkg-config --cflags libRmath`

ifeq ($(OS),Windows_NT)
    DLLEXT := .dll
else
    DLLEXT := .so
endif

LIBRMATH = $(shell pkg-config --variable=libdir libRmath)/libRmath$(DLLEXT)

all: rmathffi.h rmathffi.c rmathffi.urs rmathffi.o rmath.ur rmath.urs rmath.urp
	./driver.sh test

rmath.urp: rmath.urp.in
	${M4} ${M4FLAGS} ${M4SCRIPT} -D LIBRMATH=${LIBRMATH} rmath.urp.in > rmath.urp

%.h: %.h.in
	${M4} ${M4FLAGS} ${M4SCRIPT} $< > $*.h

%.c: %.c.in
	${M4} ${M4FLAGS} ${M4SCRIPT} $< > $*.c

%.urs: %.urs.in
	${M4} ${M4FLAGS} ${M4SCRIPT} $< > $*.urs

%.ur: %.ur.in
	${M4} ${M4FLAGS} ${M4SCRIPT} $< > $*.ur

clean:
	rm -f rmathffi.h rmathffi.c rmathffi.urs rmathffi.o rmath.urp rmath.ur rmath.urs
	rm -f test.exe
