%{
// This is ONLY a demo micro-shell whose purpose is to illustrate the need for and how to handle nested alias substitutions and how to use Flex start conditions.
// This is to help students learn these specific capabilities, the code is by far not a complete nutshell by any means.
// Only "alias name word", "cd word", and "bye" run.
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "global.h"
<<<<<<< Updated upstream
=======

extern char **environ;
>>>>>>> Stashed changes

int yylex(void);
int yyerror(char *s);
int runCD(char* arg);
int runSetAlias(char *name, char *word);
<<<<<<< Updated upstream
=======
int runCDHome();
int printAlias();
int runSetenv(char *variable, char *word);
int printenv();

>>>>>>> Stashed changes
%}

%union {char *string;}

%start cmd_line
<<<<<<< Updated upstream
%token <string> BYE CD STRING ALIAS END SETENV PRINTENV UNSETENV UNALIAS LS WC VARIABLE PIPE_BAR PIPE_GRTR PIPE_LESS
=======
%token <string> BYE CD STRING ALIAS END SETENV PRINTENV UNSETENV UNALIAS LS WC VARIABLE PIPE_BAR PIPE_GRTR PIPE_LESS 
>>>>>>> Stashed changes

%%
cmd_line    :
	BYE END 		                {exit(1); return 1; }
	| CD							{runCDHome();}
	| CD STRING          			{runCD($2);}
	| ALIAS STRING STRING END		{runSetAlias($2, $3); return 1;}
<<<<<<< Updated upstream
    | SETENV VARIABLE STRING END    {printf("setenv");}  
    | STRING PIPE_BAR STRING END    {printf("bar_pipe");}
    | STRING PIPE_GRTR STRING END   {printf("greater_pipe");}
    | STRING PIPE_LESS STRING END   {printf("less_pipe");}
    | PRINTENV END                  {printf("setenv");}
=======
    | SETENV STRING STRING END    {runSetenv($2, $3);}  
    | STRING PIPE_BAR STRING END    {printf("bar_pipe");}
    | STRING PIPE_GRTR STRING END   {printf("greater_pipe");}
    | STRING PIPE_LESS STRING END   {printf("less_pipe");}
    | PRINTENV END                  {printenv();}
>>>>>>> Stashed changes
    | UNSETENV VARIABLE END         {printf("setenv");}
    | UNALIAS STRING                {printf("setenv");}
    | ALIAS                         {printf("setenv");}
    | LS                            {printf("setenv");}
    | WC                            {printf("setenv");}


%%

int yyerror(char *s) {
  printf("%s\n",s);
  return 0;
  }
  
int runCDHome(){
	chdir("/Nutshell-Project/");
	return 1;
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
<<<<<<< Updated upstream
}
=======
}

int runSetenv(char *variable, char *word) {
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
}

int printenv(){
	for(int i = 0; i < varIndex; i++){
		printf("%s = %s\n", varTable.var[i], varTable.word[i]);
	}
	return 1;

}	

int printAlias(){
	for(int i = 0; i < aliasIndex; i++){
		printf("%s%s%s\n", aliasTable.name[i], "=", aliasTable.word[i]);
	}
	return 1;
}

	
	
	
	
	
	
	
	
	
	
	

>>>>>>> Stashed changes
