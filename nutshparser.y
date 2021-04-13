%{
// This is ONLY a demo micro-shell whose purpose is to illustrate the need for and how to handle nested alias substitutions and how to use Flex start conditions.
// This is to help students learn these specific capabilities, the code is by far not a complete nutshell by any means.
// Only "alias name word", "cd word", and "bye" run.
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "global.h"
#include <errno.h>

int yylex(void);
int yyerror(char *s);
int runCD(char* arg);
int runSetAlias(char *name, char *word);

extern char **environ;
%}

%union {char *string;}

%start cmd_line
%token <string> BYE CD STRING ALIAS END SETENV PRINTENV UNSETENV UNALIAS LS WC VARIABLE PIPE_BAR PIPE_GRTR PIPE_LESS WORD

%%
cmd_line    :
	BYE END 		                {exit(1); return 1; }
	| CD STRING END        			{runCD($2); return 1;}
	| ALIAS STRING STRING END		{clearExpression(); runSetAlias($2, $3); return 1;}
	| ALIAS END                         {printAlias(); return 1;}
    | SETENV STRING STRING END      {runSetenv($2, $3); return 1;} 
	| PRINTENV END                      { printenv(); return 1;}
	| UNSETENV VARIABLE END         {unsetenv($2); return 1;}
	| UNALIAS STRING END               {runUnalias($2); return 1;}
    | STRING STRING END                 {clearExpression(); return 1;}


%%

int yyerror(char *s) {
  printf("%s\n",s);
  return 0;
  }

void clearExpression(){
    free(expression);
	expr_index = 0;
}  


int runCD(char* arg) {
	if (arg[0] != '/') { // arg is relative path
		strcat(varTable.word[0], "/");
		strcat(varTable.word[0], arg);

		if(chdir(varTable.word[0]) == 0) {
			return 1;
		}
		else {
			getcwd(cwd, sizeof(cwd));
			strcpy(varTable.word[0], cwd);
			printf("Directory not found\n");
			return 1;
		}
	}
	else { // arg is absolute path
		if(chdir(arg) == 0){
			strcpy(varTable.word[0], arg);
			return 1;
		}
		else {
			printf("Directory not found\n");
                       	return 1;
		}
	}
}

int runSetAlias(char *name, char *word) {
	// Tokenize name: alias a b
	//Tokenized = ['alias', 'a', 'b']
	// Check if (name == Tokenized

	for (int i = 0; i < aliasIndex; i++) {
		if(strcmp(name, word) == 0){
			printf("Error, expansion of \"%s\" would create a loop.\n", name);
			return 1;
		}
		else if((strcmp(aliasTable.name[i], name) == 0) && (strcmp(aliasTable.word[i], word) == 0)){
			printf("Error, expansion of \"%s\" would create a loop.\n", name);
			return 1;
		}
		else if(strcmp(aliasTable.name[i], name) == 0) {
			strcpy(aliasTable.word[i], word);
			return 1;
		}
	}
	strcpy(aliasTable.name[aliasIndex], name);
	strcpy(aliasTable.word[aliasIndex], word);
	aliasIndex++;

	return 1;
}

int printAlias(){
	for(int i = 0; i < aliasIndex; i++){
		printf("%s%s%s\n", aliasTable.name[i], "=", aliasTable.word[i]);
	}
	return 1;
}

int runSetenv(char *variable, char *word) {

	printf("hello");
	for (int i = 0; i < varIndex; i++) {
		if(strcmp(variable, word) == 0){
			printf("Error: variable and word are the same value\n");
			return 1;
		}
		else if((strcmp(varTable.var[i], variable) == 0) && (strcmp(varTable.word[i], word) == 0)){
			printf("Error: same values\n");
			return 1;
		}
		else if(strcmp(varTable.var[i], variable) == 0) {
			strcpy(varTable.word[i], word);
			return 1;
		}
	}
	strcpy(varTable.var[varIndex], variable);
	strcpy(varTable.word[varIndex], word);
	varIndex++;

	return 1;
	// | STRING PIPE_BAR STRING END    {runPipeBar($1, $3);}
    // | STRING PIPE_GRTR STRING END   {runPipeGrtr($1, $3);}
    // | STRING PIPE_LESS STRING END   {runPipeLess($1, $3);}
    // | UNALIAS STRING                {printf("setenv");}
    // | ALIAS                         {printf("setenv");}
    // | LS                            {printf("ls");}
    // | WC                            {printf("setenv");}

}

int printenv(){
	for(int i = 0; i < varIndex; i++){
		printf("%s = %s\n", varTable.var[i], varTable.word[i]);
	}
	return 1;
}	

int runUnalias(char *name){
	int removeIndex = -1;
	for(int i = 0; i < aliasIndex; i++){
		printf("%s\n", name);
		//printf("%s\n", aliasTable.name[i]);
		if(aliasTable.word[i] == name){
			printf("%s", "here");
			removeIndex = i;
		}
		if((removeIndex > -1) && (i != aliasIndex - 1)){
			strcpy(aliasTable.name[i], aliasTable.name[i+1]);
			strcpy(aliasTable.word[i], aliasTable.word[i+1]);
			printf("%d", i);
			printf("%s", aliasTable.name[i]);
			printf("%s", aliasTable.word[i]);
		}
	}
	aliasIndex--;
	return 1;
}