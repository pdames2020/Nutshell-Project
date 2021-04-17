# Simple Makefile
all:
	bison -d nutshparser.y
	flex nutshscanner.l
	g++ -o nutshell.o nutshell.cpp nutshparser.tab.c lex.yy.c

clean:
	rm nutshparser.tab.c nutshparser.tab.h lex.yy.c