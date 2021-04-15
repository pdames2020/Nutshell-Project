%{
// This is ONLY a demo micro-shell whose purpose is to illustrate the need for and how to handle nested alias substitutions and how to use Flex start conditions.
// This is to help students learn these specific capabilities, the code is by far not a complete nutshell by any means.
// Only "alias name word", "cd word", and "bye" run.
#include "nutshparser.tab.h"
#include <string.h>
#include "global.h"


char* subAliases(char* name){
    for (int i = 0; i < aliasIndex; i++) {
        if(strcmp(aliasTable.name[i], name) == 0) {
            return aliasTable.word[i];
        }
    }
    return name;
}
bool ifAlias(char* name){
    for (int i = 0; i < aliasIndex; i++) {
        if(strcmp(aliasTable.name[i], name) == 0) {
            return true;
        }
    }
    return false;
}


// void printExpression(){
//     printf("%s\n", "Adding alias");
//     for(int i = 0; i < 10; i++){
//         printf("Elem %d %s\n",i , (expression[i]));
//     }
// }


bool isStart(char* name){
    printf("Name: %s\n", name);
    printf("First token: %s\n", expression[0]);

    if(expression[0] == name){
        return true;
    }
    else{
        return false;
    }
}
%}
%array
%option noyywrap
%x string_condition

CHAR            [.A-Za-z0-9!\/_-][.A-Za-z0-9!\/_-]*
ANYCHAR            [)(*&%$#@!`;,\.a-zA-Z0-9'/*_=~ -][)(*&%$#@!`;,\.a-zA-Z0-9'/*_=~ -]*
PIPE_BAR [|]
PIPE_GRTR [>]
PIPE_LESS [<]
SETENV "setenv" 
PRINTENV "printenv"  
HOME "HOME"
PATH "PATH"
META [\<\>|"\&]
QUOTE ["]
NOTQUOTE [^"]
<<<<<<< Updated upstream
WORD [A-Za-z0-9|(\"(META)\")|(\\(META))|(\"A-Za-z0-9(META) \")]* 
=======
WORD [^<>|"\\&\n \t]+
>>>>>>> Stashed changes
VARIABLE [A-Za-z][A-Za-z0-9]*

%%

<string_condition>{ANYCHAR}+     {yylval.string = strdup(yytext);return STRING;}
<string_condition>[\"]          {BEGIN(INITIAL);}

[ ]		            { }
bye                 { return BYE; }
cd		            { return CD;}
<<<<<<< Updated upstream
pwd					{return PWD;}
echo 				{return ECHO;}
ssh 				{return SSH;}
alias		        { return ALIAS;}
ping				{return PING;}
date				{return DATE;}
{PIPE_BAR}          { return PIPE_BAR; }
{PIPE_GRTR}         { return PIPE_GRTR; }
{PIPE_LESS}         { return PIPE_LESS; }
{PRINTENV}          { return PRINTENV;}
=======
alias		        {return ALIAS; }
unalias             { return UNALIAS; }
{PIPE_BAR}          { return PIPE_BAR; }
{PIPE_GRTR}         { return PIPE_GRTR; }
{PIPE_LESS}         { return PIPE_LESS; }
{SETENV}            { return SETENV; }
{PRINTENV}          { return PRINTENV; }
>>>>>>> Stashed changes
"\n"		        { return END; }
[\"]                 { BEGIN(string_condition); }
{CHAR}+              {if(ifAlias(yytext)) {
                        printf("yytext: %s\n", yytext);
                        //source: https://www.cs.princeton.edu/~appel/modern/c/software/flex/flex.html
                           char *yycopy = strdup( subAliases(yytext) );
                           for ( int i = strlen(subAliases(yytext)) - 1; i >= 0; --i )
                               unput( yycopy[i] );
                           free( yycopy );
                    } else {
                        printf("yytext: %s\n", yytext);
                        yylval.string = strdup(yytext);
                        return STRING;
                    };
                     }
{WORD}              { return WORD; }

%%