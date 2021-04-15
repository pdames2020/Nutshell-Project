#include "stdbool.h"
#include <limits.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

struct evTable {
   char var[128][100];
   char word[128][100];
};

struct aTable {
	char name[128][100];
	char word[128][100];
};

char cwd[PATH_MAX];

struct evTable varTable;

struct aTable aliasTable;

int aliasIndex, varIndex;

char **expression;

int expr_index;

struct Command{
	char* command;
	char* args[];
};

struct Pipeline{
	struct Command commands[10];
	bool background;
};

struct Command currCommand;
struct Pipeline commandTable;
char builtIns[8][8] = {"cd", "ls", "printenv", "setenv", "alias", "unalias", "ls", "wc"};
int comTableIndex;

//struct Pipeline createCommandTable();

//struct Pipeline commandTable = createCommandTable();

//struct Pipeline commandTable.commands = {"cat" "", }


int commandIndex;

// char* input;
int input_index;
char* output;
int output_index;



char* subAliases(char* name);