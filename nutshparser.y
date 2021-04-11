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
	| ALIAS STRING STRING END		{runSetAlias($2, $3); return 1;}
	| ALIAS                         {printAlias(); return 1;}
    | SETENV VARIABLE WORD END      {setenv($2, $3, 1); return 1;} 
	| UNSETENV VARIABLE END         {unsetenv($2); return 1;}
    



%%

int yyerror(char *s) {
  printf("%s\n",s);
  return 0;
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
}

int printAlias(){
	for(int i = 0; i < aliasIndex; i++){
		printf("%s%s%s\n", aliasTable.name[i], "=", aliasTable.word[i]);
	}
	return 1;
}

int runSetenv(char *variable, char *word, char *overwrite){
	// The setenv() function adds the variable name to the environment
    //    with the value value, if name does not already exist.  If name
    //    does exist in the envinronment, then its value is changed to value
    //    if overwrite is nonzero; if overwrite is zero, then the value of
    //    name is not changed (and setenv() returns a success status).
    //    This function makes copies of the strings pointed to by name and
    //    value (by contrast with putenv(3)).
	char *es;

    if (variable == NULL || variable[0] == '\0' || strchr(variable, '=') != NULL ||
            word == NULL) {
        errno = EINVAL;
        return -1;
    }

    if (getenv(variable) != NULL && overwrite == 0)
        return 0;

    unsetenv(variable);             /* Remove all occurrences */

    es = malloc(strlen(variable) + strlen(word) + 2);
                                /* +2 for '=' and null terminator */
    if (es == NULL)
        return -1;

    strcpy(es, variable);
    strcat(es, word);

    return (putenv(es) != 0) ? -1 : 0;

	// | STRING PIPE_BAR STRING END    {runPipeBar($1, $3);}
    // | STRING PIPE_GRTR STRING END   {runPipeGrtr($1, $3);}
    // | STRING PIPE_LESS STRING END   {runPipeLess($1, $3);}
    // | UNALIAS STRING                {printf("setenv");}
    // | ALIAS                         {printf("setenv");}
    // | LS                            {printf("ls");}
    // | WC                            {printf("setenv");}

}