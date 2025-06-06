%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>

#include "string_stack.h"
#include "set_storage.h" 

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
    CMD_NONE SMC { 
        std::string cmd = gStringStack.pop();
	if (cmd == "ShowSets") {
	    showSets();	    
        } else if (cmd == "Sets") {
            listSets();
	}
    }
    ;

cmd_mono_stmt:
    CMD_MONO VAR SMC {
	std::string set = gStringStack.pop();
	std::string cmd = gStringStack.pop();
	
	if (cmd == "Clear") {
	    clearSet(set);
	} else if (cmd == "Delete") {
	    deleteSet(set);
	} else if (cmd == "ShowSet") {
	    showSet(set);
	}
    }
    ;

cmd_bin_stmt:
    VAR CMD_BIN VAR SMC { 
	std::string set2 = gStringStack.pop();
	std::string cmd = gStringStack.pop();
	std::string set1 = gStringStack.pop();

	if (cmd == "Concat") {
	    std::set<std::string> result = concatSets(set1, set2);
	    printSet(result);
	} else if (cmd == "Union") {
	    std::set<std::string> result = unionSets(set1, set2);
	    printSet(result);
	} else if (cmd == "Intersection") {
            std::set<std::string> result = intersectSets(set1, set2);
	    printSet(result);
	}
    }

    | CMD_BIN VAR COLON VAR SMC {
	std::string set2 = gStringStack.pop();
	std::string set1 = gStringStack.pop();
	std::string cmd = gStringStack.pop();

        if (cmd == "Concat") {                                                          
            std::set<std::string> result = concatSets(set1, set2);                      
            printSet(result);                                                           
        } else if (cmd == "Union") {                                                    
            std::set<std::string> result = unionSets(set1, set2);                       
            printSet(result);                                                           
        } else if (cmd == "Intersection") {
            std::set<std::string> result = intersectSets(set1, set2);
            printSet(result);
        }     
    }
    ;

set_declaration_stmt:
    CMD_SET VAR ASSIGN set_content SMC { 
	std::set<std::string> elements;	
	while (gStringStack.size() > 1) {
	    elements.insert(gStringStack.pop());
	}
	
	std::string set = gStringStack.pop();
	addSet(set, elements);
    }

    | CMD_SET VAR ASSIGN CMD_BIN VAR COLON VAR SMC { 
	std::string set2 = gStringStack.pop();
	std::string set1 = gStringStack.pop();
	std::string cmd = gStringStack.pop();
	std::string set = gStringStack.pop();

	if (cmd == "Concat") {                      
            std::set<std::string> newSet = concatSets(set1, set2);
	    addSet(set, newSet);
        } else if (cmd == "Union") {                
            std::set<std::string> newSet = unionSets(set1, set2);
	    addSet(set, newSet);
        } else if (cmd == "Intersection") {         
            std::set<std::string> newSet = intersectSets(set1, set2);
	    addSet(set, newSet);
	}
    }

    | CMD_SET VAR ASSIGN VAR CMD_BIN VAR SMC { 
	std::string set2 = gStringStack.pop();        
        std::string cmd = gStringStack.pop();        
        std::string set1 = gStringStack.pop();
        std::string set = gStringStack.pop();
                                                                                      
    	if (cmd == "Concat") {
            std::set<std::string> newSet = concatSets(set1, set2);
            addSet(set, newSet);
        } else if (cmd == "Union") {
            std::set<std::string> newSet = unionSets(set1, set2);
            addSet(set, newSet);
        } else if (cmd == "Intersection") {
            std::set<std::string> newSet = intersectSets(set1, set2);
            addSet(set, newSet);
        }
    }

    | CMD_SET CMD_BIN VAR COLON VAR COLON VAR SMC { 
	std::string set2 = gStringStack.pop();        
        std::string set1 = gStringStack.pop();        
        std::string set = gStringStack.pop();
        std::string cmd = gStringStack.pop();
                                                                                      
    	if (cmd == "Concat") {
            std::set<std::string> newSet = concatSets(set1, set2);
            addSet(set, newSet);
        } else if (cmd == "Union") {
            std::set<std::string> newSet = unionSets(set1, set2);
            addSet(set, newSet);
        } else if (cmd == "Intersection") {
            std::set<std::string> newSet = intersectSets(set1, set2);
            addSet(set, newSet);
        }
    }
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
