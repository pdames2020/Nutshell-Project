// This is ONLY a demo micro-shell whose purpose is to illustrate the need for and how to handle nested alias substitutions and how to use Flex start conditions.
// This is to help students learn these specific capabilities, the code is by far not a complete nutshell by any means.
// Only "alias name word", "cd word", and "bye" run.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "global.h"
#include <unistd.h>
#include <limits.h>
#include <filesystem>
using namespace std;

char *getcwd(char *buf, size_t size);
int yyparse();

int runNotBuilt(string command, vector<string> args){
	//printf("%s\n",expression[0]);
	string binPath = "/bin/";

    binPath.append(command);
	char *c_binPath = (char*)binPath.c_str();

	char **argv = new char* [args.size()+2];
    argv[0] = c_binPath;         
    for (int j = 0;  j < args.size()+1;  ++j){
		argv[j+1] = (char*) args[j].c_str();
	}  
    argv[args.size()+1] = NULL;




	//int j = 0;
	cout <<"This is the expr_index: " << expr_index << endl;
	cout << "This is the args size: " << args.size() << endl;
 
	
	int pid = fork();
	if (pid == -1){
		cout << "Error in forking" << endl;
	}else if(pid ==0){
		execv(c_binPath, argv);
	}

	return 1;
}

int runCommandTable(){
	runNotBuilt(commandTable.commands[commandTable.commands.size()-1].command, commandTable.commands[commandTable.commands.size()-1].args);

	return 1;
}
int main()
{
    int aliasIndex = 0;
    int varIndex = 0;
    int expr_index = 0;
    string input = "";
    string output = "";
    // std::filesystem::path cwd = std::filesystem::current_path();
    char cwd[PATH_MAX];
    struct evTable varTable;
    struct aTable  aliasTable;
    struct Command currCommand;
    struct Pipeline commandTable;
    vector<string> expression;
    vector<string> cmd; 
    vector<string> cmdTblCom;
    vector<string> cmdTblArg;
    char* subAliases(char* name);
    bool built;


    getcwd(cwd, sizeof(cwd));

    strcpy(varTable.var[varIndex], "PWD");
    strcpy(varTable.word[varIndex], cwd);
    varIndex++;
    strcpy(varTable.var[varIndex], "HOME");
    strcpy(varTable.word[varIndex], cwd);
    varIndex++;
    strcpy(varTable.var[varIndex], "PROMPT");
    strcpy(varTable.word[varIndex], "nutshell");
    varIndex++;
    strcpy(varTable.var[varIndex], "PATH");
    strcpy(varTable.word[varIndex], ".:/bin");
    varIndex++;

    system("clear");
    while(1)
    {
        cout <<"["<< varTable.word[2] <<"]"<< endl;;
        yyparse();
       // runCommandTable();
    }

   return 0;
}
