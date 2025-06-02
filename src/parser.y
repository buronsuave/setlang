%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
%}

%union {
    char* str;
}

%token <str> VAR
%token CMD_NONE CMD_MONO CMD_BIN CMD_SET
%token ASSIGN SMC OPENKEY CLOSEKEY COLON
%start program

%%

program:
    /* empty */
    | program statement
    ;

statement:
    cmd_none_stmt
    | cmd_mono_stmt
    | cmd_bin_stmt
    | set_declaration_stmt
    ;

cmd_none_stmt:
    CMD_NONE SMC                     { printf("Valid cmd-none statement\n"); }
    ;

cmd_mono_stmt:
    CMD_MONO VAR SMC                 { printf("Valid cmd-mono statement\n"); }
    ;

cmd_bin_stmt:
    VAR CMD_BIN VAR SMC              { printf("Valid bin infix\n"); }
    | CMD_BIN VAR VAR SMC            { printf("Valid bin prefix\n"); }
    ;

set_declaration_stmt:
    CMD_SET VAR ASSIGN set_content SMC { printf("Valid set declaration\n"); }
    | CMD_SET VAR ASSIGN CMD_BIN VAR VAR SMC { printf("Valid derived (prefix) set\n"); }
    | CMD_SET VAR ASSIGN VAR CMD_BIN VAR SMC { printf("Valid derived (infix) set\n"); }
    ;

set_content:
    OPENKEY elements CLOSEKEY
    ;

elements:
    VAR
    | elements COLON VAR
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main() {
    return yyparse();
}
