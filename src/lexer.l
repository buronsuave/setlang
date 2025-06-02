%{
#include "parser.tab.h"
#include <stdio.h>
%}

%%
Concat          { return CMD_BIN; }
Clear           { return CMD_MONO; }
Delete          { return CMD_MONO; }
Union           { return CMD_BIN; }
Intersection    { return CMD_BIN; }
ShowSets        { return CMD_NONE; }
ShowSet         { return CMD_MONO; }
Sets            { return CMD_NONE; }
Set             { return CMD_SET; }
":="            { return ASSIGN; }
";"             { return SMC; }
"{"             { return OPENKEY; }
"}"             { return CLOSEKEY; }
","             { return COLON; }
[a-zA-Z0-9]+    { yylval.str = strdup(yytext); return VAR; }
[ \t\n]+        ;  // Ignore whitespace
.               { printf("Unknown token: %s\n", yytext); return 0; }
%%

int yywrap() { return 1; }
