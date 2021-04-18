%{
// This is ONLY a demo micro-shell whose purpose is to illustrate the need for and how to handle nested alias substitutions and how to use Flex start conditions.
// This is to help students learn these specific capabilities, the code is by far not a complete nutshell by any means.
// Only "alias name word", "cd word", and "bye" run.
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include "global.h"
using namespace std;

int yylex(void);
int yyerror(char* s);
int runCD(char* arg);
int runSetAlias(char *name, char *word);
void clearExpression();
int printAlias();
int runSetenv(char *variable, char *word) ;
int printenv();
int runUnalias(char *name);
int runNotBuilt();
void addToLine(string token);
void runPipeBar(char* token);
void runPipeLesser(char* token);
void runPipeGreater(char* token);
int runCommandTable();
void clearCommandPlusArg();
void clearCurrCommand();
void addToCommandTable();

extern char **environ;
int aliasIndex;
int varIndex;
int expr_index;
string input = "";
string output = "";
char cwd[PATH_MAX];
struct evTable varTable;
struct aTable  aliasTable;
struct Command currCommand;
struct Pipeline commandTable;
vector<string> expression;
vector<string> cmd; 
char* subAliases(char* name);
bool built;
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
		cout << "add pipe to bar" << endl;
		addToLine("|");
		addToLine($2);
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
		addToCommandTable();
		runCommandTable();
	}
;
      
%%
void clearCommandPlusArg(){
	cmd.clear();
}
void clearCurrCommand(){
	currCommand.command.clear();
	currCommand.args.clear();
}

void addToCommandTable(){
		// if(built == false){
		// 	runNotBuilt(); 
		// }
		//Line: cat f3.txt | head -2 | tail -1
		// wc -l f3.txt f1.txt | sort

		int start_index = 0;
		int i = 0;
		cout << "Expr_index:" << expr_index << endl;
		while(i < expr_index){
			cout << "First for loop" << endl;
			cout << "This is expr elem " << i << " " << expression[i] << endl;

			if((expression[i] == "|") || (i == (expression.size()-1))){
				// if((sizeof(cmd)/sizeof(char)) >= 1){
				// 	for(int i = 0; i < sizeof(cmd); i++)
				// 		cmd[i] = NULL;
				//}
				
				int j = 0;
				cout << "This is i before while: " << i << endl;
				cout << "This is the start_index: " << start_index << endl;

				while((start_index < i) || (start_index == expression.size()-1)){
				    cout << "This is the start_index: " << start_index << endl;
				    cout << "This is i: " << i << endl;
				    cout << "This is j: " << j << endl;



					cout << "Expression using start index: " << expression[start_index] << endl;
				
					cmd.push_back(expression[start_index]);
					cout << cmd.back() << endl;
					j++;
					start_index++;
				}
				start_index = i + 1;	
				for(int k = 0; k < cmd.size(); k++){
					cout << "second for loop" << endl;
					if(k == 0){
						//cmdTblCom[k] = (char*) malloc((sizeof(cmd[0]) + 1) * sizeof(char));
						//strcpy(cmdTblCom[k], cmd[0]);
						//printf("Command: %s\n", cmd[0]);
						cout << "Command: " << cmd[k] << endl;
						// cmdTblCom.push_back(cmd[k]);
						currCommand.command = cmd[k];
					}
					else{
						//cmdTblArg[k - 1] = (char*) malloc((sizeof(cmd[k]) + 1) * sizeof(char));
						//strcpy(cmdTblArg[k - 1], cmd[k]);	
						//printf("Argument: %s\n", cmd[k]);
						cout << "Argument: " << cmd[k] << endl;
						currCommand.args.push_back(cmd[k]);
					}
				}
				clearCommandPlusArg();
				// Add to command table
				commandTable.commands.push_back(currCommand);
				clearCurrCommand();
				
			}
				i++;
		}
		
		//Print out the contents of the command table.
		for(int i = 0; i < commandTable.commands.size(); i++){
			cout << "This is command "<< i << " "<< commandTable.commands[i].command << endl;
			for (int j = 0; j < commandTable.commands[i].args.size(); j++){
				cout << "This is arg " << j << " "<<  commandTable.commands[i].args[j] << endl;
			}
		}
		clearExpression(); 
}

void runPipeBar(string token){
	
}
	//input
	// arg
    // for elem in commtable:
	//     if elem is not last elem 
	//      input = elem(arg) 
	// 	 arg = input
	




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

void addToLine(string token){
	//printf("hello");
	cout << "This is the expr_index: " << expr_index << endl;
	expression.push_back(token);
    for(int i = 0; i < expression.size(); i++){
		cout << "Elem " << i << " " << expression[i] << endl;
    }
	cout << "expression: " << expression[expr_index] << endl; 
    expr_index++;
}

char *convert(const string & s)
{
   char *pc = new char[s.size()+1];
   strcpy(pc, s.c_str());
   return pc; 
}


int yyerror(char *s) {
  cout << s << endl;
  return 0;
  }

void clearExpression(){
    expression.clear();
	expr_index = 0;
}  



int runCD(char* arg) {
	clearExpression();
	addToLine("cd");
	addToLine(arg);

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
			cout << "Directory not found" << endl;
			return 1;
		}
	}
	else { // arg is absolute path
		if(chdir(arg) == 0){
			strcpy(varTable.word[0], arg);
			return 1;
		}
		else {
			cout << "Directory not found" << endl;
            return 1;
		}
	}
	return 1;
	//clearExpression();
}

int runSetAlias(char *name, char *word) {
	clearExpression();
	addToLine("alias");
	addToLine(name);
	addToLine(word);

	for (int i = 0; i < aliasIndex; i++) {
		if(strcmp(name, word) == 0){
			cout << "Error, expansion of " << name << " would create a loop." << endl;
			return 1;
		}
		else if((strcmp(aliasTable.name[i], name) == 0) && (strcmp(aliasTable.word[i], word) == 0)){
			cout << "Error, expansion of " << name << " would create a loop." << endl;
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
	clearExpression();
	addToLine("alias");
	for(int i = 0; i < aliasIndex; i++){
		cout << aliasTable.name[i] << "=" << aliasTable.word[i] << endl;
	}
	return 1;
}

int runSetenv(char *variable, char *word) {
	clearExpression();
	addToLine("setenv");
	addToLine(variable);
	addToLine(word);

	for (int i = 0; i < varIndex; i++) {
		if(strcmp(variable, word) == 0){
			cout << "Error: variable and word are the same value" << endl;
			return 1;
		}
		else if((strcmp(varTable.var[i], variable) == 0) && (strcmp(varTable.word[i], word) == 0)){
			cout << "Error: same values" << endl;
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
	clearExpression();
	addToLine("printenv");
	for(int i = 0; i < varIndex; i++){
		cout << varTable.var[i] << " = "<< varTable.word[i]  << endl;
	}
	return 1;
}	

int runUnalias(char *name){
	clearExpression();
	addToLine("unalias");
	addToLine(name);
	int removeIndex = -1;
	for(int i = 0; i < aliasIndex; i++){
		cout << name << endl;
		//printf("%s\n", aliasTable.name[i]);
		if(aliasTable.word[i] == name){
			cout << "here" << endl;
			removeIndex = i;
		}
		if((removeIndex > -1) && (i != aliasIndex - 1)){
			strcpy(aliasTable.name[i], aliasTable.name[i+1]);
			strcpy(aliasTable.word[i], aliasTable.word[i+1]);
			cout << i << endl;
			cout << aliasTable.name[i] << endl;
			cout << aliasTable.word[i] << endl;

		}
	}
	aliasIndex--;
	return 1;
}

// int runCommandTable(){
	
//     // vector<string> builtCommands;
// 	// builtCommands.push_back("cd");
// 	// builtCommands.push_back("alias");
// 	// builtCommands.push_back("setenv");
// 	// builtCommands.push_back("printenv");
// 	// builtCommands.push_back("unsetenv");
// 	// builtCommands.push_back("unalias");

// 	// for(int i = 0; i < commandTable.commands.size(); i++){
// 	// 	cout << "This is command "<< i << " "<< commandTable.commands[i].command << endl;
// 	// 	cout << "This is the size of args " << " " << commandTable.commands[i].args.size() << endl;
// 	// 	// Check if it is unbuilt or built
// 	// 	if(commandTable.commands[i].command == builtCommands[0]){
// 	// 		string argument = commandTable.commands[i].args[0];
// 	// 		char *c_arg = (char*)argument.c_str();
// 	// 		cout << "This is the argument: " << c_arg << endl;
// 	// 		runCD(c_arg);
// 	// 	}
// 	// 	else if(commandTable.commands[i].command == builtCommands[1]){
// 	// 		if(commandTable.commands[i].args.size() == 0){
// 	// 			printAlias();
// 	// 		}
// 	// 		else if(commandTable.commands[i].args.size() == 2){
// 	// 			char* c_argument0 = (char*) commandTable.commands[i].args[0].c_str();
// 	// 			char* c_argument1 = (char*) commandTable.commands[i].args[1].c_str();
// 	// 			runSetAlias(c_argument0, c_argument1);
// 	// 		}
// 	// 	}
// 	// 	else if(commandTable.commands[i].command == builtCommands[2]){
// 	// 		if(commandTable.commands[i].args.size() == 2){
// 	// 			char* c_argument0 = (char*) commandTable.commands[i].args[0].c_str();
// 	// 			char* c_argument1 = (char*) commandTable.commands[i].args[1].c_str();
// 	// 			runSetenv(c_argument0, c_argument1);
// 	// 		}
// 	// 	}
// 	// 	else if(commandTable.commands[i].command == builtCommands[3]){
// 	// 		if(commandTable.commands[i].args.size() == 0){
// 	// 			printenv();
// 	// 		}
// 	// 		//printenv
// 	// 	}
// 	// 	else if(commandTable.commands[i].command == builtCommands[4]){
// 	// 		if(commandTable.commands[i].args.size() == 1){
// 	// 			char* c_argument0 = (char*) commandTable.commands[i].args[0].c_str();
// 	// 			unsetenv(c_argument0);
// 	// 		}
// 	// 		//unsetenv
// 	// 	}
// 	// 	else if(commandTable.commands[i].command == builtCommands[5]){
// 	// 		if(commandTable.commands[i].args.size() == 1){
// 	// 			char* c_argument0 = (char*) commandTable.commands[i].args[0].c_str();
// 	// 			runUnalias(c_argument0);
// 	// 		}
// 	// 		//unalias
// 	// 	}
// 	// 	else{
// 	// 		runNotBuilt(commandTable.commands[i].command, commandTable.commands[i].args);
// 	// 	}


// 	runNotBuilt(commandTable.commands[commands.size()-1].command, commandTable.commands[commands.size()-1].args);
// 	for (int j = 0; j < commandTable.commands[i].args.size(); j++){
// 		cout << "This is arg " << j << " "<<  commandTable.commands[i].args[j] << endl;
// 	}	
// 	return 1;

// }

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