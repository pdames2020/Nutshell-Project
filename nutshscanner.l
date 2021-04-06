%{
#include <stdio.h>
#include "nutshparser.tab.h"
%}

SETENV "setenv" 
PRINTENV "printenv"  
HOME "HOME"
PATH "PATH"
META [\<\>|"\&]
QUOTE ["]
NOTQUOTE [^"]

%%

{SETENV}" "[A-Za-z][A-Za-z0-9]*" "[A-Za-z0-9|("(META)")|(\(META))]*  		{printf("set the value of variable to word");}
{PRINTENV}																	{printf("print the values of all the environment variables");}
/*{HOME}																		{printf("shows the home directory of the user");}*/
{PATH}																		{printf("shows the list of paths to be searched to find a command's executable file");}
"alias"			{printf("alias");}
"unalias"		{printf("unalias");}
"bye"			{printf("bye");}
.				{printf("empty character");}

%% 

