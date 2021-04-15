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

char* subAliases(char* name);

bool built = false;