%{
#include <stdio.h>
int yylex();
int yyerror(char *s);


%}

%token SETENV PRINTENV HOME PATH


%%