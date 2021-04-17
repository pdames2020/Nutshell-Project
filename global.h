#ifndef GLOBAL_H
#define GLOBAL_H

#include "stdbool.h"
#include <limits.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <vector>
#include <iostream>
#include <string>
using namespace std;


struct evTable {
   char var[128][100];
   char word[128][100];
};

struct aTable {
	char name[128][100];
	char word[128][100];
};


struct Command{
   string command;
   vector<string> args;
};

struct Pipeline{
   vector<Command> commands;
   bool background;
};

extern struct Command currCommand;
extern struct Pipeline commandTable;

extern string input;
extern string output;


extern char cwd[PATH_MAX];

extern struct evTable varTable;

extern struct aTable aliasTable;

extern int aliasIndex, varIndex;

extern vector<string> expression;

extern int expr_index;

extern vector<string> cmd; 

extern vector<string> cmdTblCom;

extern vector<string> cmdTblArg;

extern char* subAliases(char* name);

extern bool built;

#endif