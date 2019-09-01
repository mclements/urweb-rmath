.SUFFIXES: .in .c.in .c .o .sml

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

all: rmath.h rmath.c rmath.urs rmath.ur rmath.o
	${M4} ${M4FLAGS} ${M4SCRIPT} -D LIBRMATH=${LIBRMATH} rmath.urp.in > rmath.urp
	./driver.sh cffi

%.h: %.h.in
	${M4} ${M4FLAGS} ${M4SCRIPT} $< > $*.h

%.c: %.c.in
	${M4} ${M4FLAGS} ${M4SCRIPT} $< > $*.c

%.urs: %.urs.in
	${M4} ${M4FLAGS} ${M4SCRIPT} $< > $*.urs

%.ur: %.ur.in
	${M4} ${M4FLAGS} ${M4SCRIPT} $< > $*.ur

clean:
	rm rmath.h || true
	rm rmath.c || true
	rm rmath.ur || true
	rm rmath.urs || true
	rm rmath.urp || true
	rm rmath.o || true
	rm cffi.exe || true
