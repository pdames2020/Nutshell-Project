%{
#include <stdio.h>
#include "nutshparser.tab.h"
%}

SETENV "setenv"   
META [<>|"\&]

%%

{SETENV}" "[A-Za-z][A-Za-z0-9]*" "[A-Za-z0-9|("(META)")|(\(META))]*  		{printf("hello");}
"printenv"		{printf("print the values of all the environment variables");}
"unsetenv"		{printf("unsetenv");}
"cd"			{printf("cd");}
"alias"			{printf("alias");}
"unalias"		{printf("unalias");}
"bye"			{printf("bye");}
.				{printf("empty character");}

%% 

