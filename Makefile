# Simple Makefile

CC=/usr/bin/cc

all:  bison-config flex-config nutshell

bison-config:
	bison -d nutshparser.y

flex-config:
	flex nutshscanner.l

nutshell: 
	$(cc) nutshell.c nutshparser.tab.c lex.yy.c -o nutshell.o

clean:
	rm nutshparser.tab.c nutshparser.tab.h lex.yy.c