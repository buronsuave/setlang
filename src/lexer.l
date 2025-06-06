%option noyywrap

%{
#include "parser.tab.h"
#include "string_stack.h"
#include <string>
#include <cstring>
#include <iostream>

#define PUSH_TOKEN(token) gStringStack.push(std::string(token))
%}

%%
Concat          { PUSH_TOKEN(yytext); return CMD_BIN; }
Clear           { PUSH_TOKEN(yytext); return CMD_MONO; }
Delete          { PUSH_TOKEN(yytext); return CMD_MONO; }
Union           { PUSH_TOKEN(yytext); return CMD_BIN; }
Intersection    { PUSH_TOKEN(yytext); return CMD_BIN; }
ShowSets        { PUSH_TOKEN(yytext); return CMD_NONE; }
ShowSet         { PUSH_TOKEN(yytext); return CMD_MONO; }
Sets            { PUSH_TOKEN(yytext); return CMD_NONE; }
Set             { return CMD_SET; }
":="            { return ASSIGN; }
";"             { return SMC; }
"{"             { return OPENKEY; }
"}"             { return CLOSEKEY; }
","             { return COLON; }
[a-zA-Z0-9]+    { PUSH_TOKEN(yytext); return VAR; }
[ \t\n]+        ;  // Ignore whitespace
.               { std::cerr << "Unknown token: " << yytext << "\n"; return 0; }
%%
