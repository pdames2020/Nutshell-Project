#pragma once

extern int yylex();
extern int yylineno();
extern char* yytext;


enum token_type{
	SETENV = 1, 
	PRINTENV,  
	PATH,
	META,
	QUOTE,
	NOTQUOTE,	
};