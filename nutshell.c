#include <stdio.h>
#include "nutshparser.tab.h"


int main(void){
	printf("Welcome to Nutshell! Please enter a command: ");
	yyparse();
	printf("No errors!");
	return 0;
}