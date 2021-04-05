%{
#include <stdio.h>
#include "nutshparser.tab.h"
%}

%%

"setenv"		{printf("hello");}
"printenv"		{printf("print the values of all the environment variables");}
"unsetenv"		{printf("unsetenv");}
"cd"			{printf("cd");}
"alias"			{printf("alias");}
"unalias"		{printf("unalias");}
"bye"			{printf("bye");}
.				{printf("empty character");}

%% 
