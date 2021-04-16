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
void clearExpression();
int printAlias();
int runSetenv(char *variable, char *word) ;
int printenv();
int runUnalias(char *name);
int runNotBuilt();
void addToLine(char* token);
void runPipeBar(char* token);
void runPipeLesser(char* token);
void runPipeGreater(char* token);
void runCommandTable();

extern char **environ;
%}

%union {char *string;}

%start cmd_line
%token <string> BYE CD STRING ALIAS END SETENV PRINTENV UNSETENV UNALIAS VARIABLE PIPE_BAR OUTPUT_REDIRECT INPUT_REDIRECT

%%

cmd_line    :
	BYE END 		                {exit(1); return 1; }
	| CD STRING END        			{runCD($2); return 1;}
	| ALIAS STRING STRING END		{clearExpression(); runSetAlias($2, $3); return 1;}
	| ALIAS END                     {printAlias(); return 1;}
    | SETENV STRING STRING END      {runSetenv($2, $3); return 1;} 
	| PRINTENV END                  {printenv(); return 1;}
	| UNSETENV VARIABLE END         {unsetenv($2); return 1;}
	| UNALIAS STRING END            {runUnalias($2); return 1;}
	| stmts
;


stmts:
	| stmt stmts

stmt:
	STRING{
		addToLine($1);
	}
	| PIPE_BAR STRING{
		printf("%s\n", "add pipe to bar");
		addToLine("|");
		addToLine($2);
		// runPipeBar($2);
		// addToLine($2);
		// built = true;
	}
	| OUTPUT_REDIRECT STRING{
		//runPipeGreater($2);
		// addToLine($2);
		// built = true;
	}
	| INPUT_REDIRECT STRING{
		//runPipeLesser($2);
		// addToLine($2);
		// built = true;
	}
	| END{
		// if(built == false){
		// 	runNotBuilt(); 
		// }
		//Line: cat f3.txt | head -2 | tail -1

		char** cmd; 
		char** cmdTblCom;
		char** cmdTblArg;
		int start_index = 0;
		int i = 0;
		printf("Expr_index: %d\n", expr_index);
		while(i < expr_index){
			printf("first for loop\n");
			printf("This is expr elem %d: %s\n", i, expression[i]);
			if(strcmp(expression[i],"|") == 0){
				int j = 0;
				printf("This is i before while: %d\n", i);
				while(start_index < i){
					printf("1");
					cmd[j] = (char*) malloc((sizeof(expression[start_index]) + 1) * sizeof(char));
					printf("2");
					strcpy(cmd[j], expression[start_index]);
					printf("3");
					printf("cmd: %s\n", cmd[j]);
					j++;
					start_index++;
				}
				start_index = i + 1;	
				for(int k = 0; k < (sizeof(cmd)/sizeof(char)); k++){
					printf("second for loop\n");
					if(k == 0){
						cmdTblCom[k] = (char*) malloc((sizeof(cmd[0]) + 1) * sizeof(char));
						strcpy(cmdTblCom[k], cmd[0]);
						printf("Command: %s\n", cmd[0]);
					}
					else{
						cmdTblArg[k - 1] = (char*) malloc((sizeof(cmd[k]) + 1) * sizeof(char));
						strcpy(cmdTblArg[k - 1], cmd[k]);	
						printf("Argument: %s\n", cmd[k]);
					}
				}
			}
			else{
				i++;
			}
		}
		
		
		clearExpression(); 
		return 1;
	}
;
      
%%

void runPipeBar(char* token){
	
}
void runCommandTable(){
	//input
	// arg
    // for elem in commtable:
	//     if elem is not last elem 
	//      input = elem(arg) 
	// 	 arg = input
	


}

/*void addToLine(char* token){
	printf("hello");
    expression[expr_index] = (char*) malloc((sizeof(token) + 1) * sizeof(char));
    printf("hello");
    strcpy(expression[expr_index], token);
    
    for(int i = 0; i < 10; i++){
        printf("Elem %d %s\n",i , expression[i]);
    }
    printf("expression: %s\n", expression[expr_index]);
    
    expr_index++;
}*/

void addToLine(char* token){
	//printf("hello");
    expression[expr_index] = (char*) malloc((sizeof(token) + 1) * sizeof(char));
    strcpy(expression[expr_index], token);
    for(int i = 0; i < 10; i++){
        printf("Elem %d %s\n",i , expression[i]);
    }
    printf("expression: %s\n", expression[expr_index]);
    expr_index++;
}

int runNotBuilt(){
	//printf("%s\n",expression[0]);
	char* arguments[expr_index];
	
	char* binPath = NULL;
	int argLength = strlen(expression[0]);
	binPath = malloc(5 + argLength);
	strcat(binPath, "/bin/");
	strcat(binPath, expression[0]);
	
	arguments[0] = binPath;
	//int j = 0;
	
	for(int i = 1; i < expr_index; i++){
		arguments[i] = expression[i];
		//j++;
	}
	
	for(int i = 0; i < expr_index; i++){
		printf("Argument: %d %s\n", i, arguments[i]);
	}
	
	arguments[expr_index] = NULL;
	
	int pid = fork();
	if (pid == -1){
		printf("Error in forking\n");
	}else if(pid ==0){
		execv(binPath, arguments);
	}else{
		wait(NULL);
	}

	return 1;
}

int yyerror(char *s) {
  printf("%s\n",s);
  return 0;
  }

void clearExpression(){
	//printf("clear expressionnnnnnn\n");
	/*for(int i = 0; i < 10; i++){
        printf("Elem from clear expression %d %s\n",i , expression[i]);
    }*/
    for(int i = 0; i < sizeof(expression)/sizeof(char); i++){
        expression[i] = NULL;
    }
	expr_index = 0;
}  


int runCD(char* arg) {
	//expr_index = 0;
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
	//clearExpression();
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

/*stmts:
	| stmt stmts
	
stmt:
	STRING{
		addToLine($1);
	}
	| END{
		runNotBuilt(); clearExpression(); return 1;
	}
;
*/