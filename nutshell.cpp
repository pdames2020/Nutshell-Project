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
        cout << varTable.word[2] << endl;;
        yyparse();
    }

   return 0;
}
