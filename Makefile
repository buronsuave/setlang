# Makefile for setlang project

# Variables
SRC_DIR := src
BIN_DIR := bin
EXE := $(BIN_DIR)/setlang

LEX_SRC := $(SRC_DIR)/lexer.l
YACC_SRC := $(SRC_DIR)/parser.y
LEX_C := $(SRC_DIR)/lex.yy.c
YACC_C := $(SRC_DIR)/parser.tab.c
YACC_H := $(SRC_DIR)/parser.tab.h

CC := gcc
CFLAGS := -Wall -Wextra

# Default target
all: $(EXE)

# Binary depends on generated C files
$(EXE): $(LEX_C) $(YACC_C)
	mkdir -p $(BIN_DIR)
	$(CC) $(LEX_C) $(YACC_C) -o $(EXE)

# Generate lex.yy.c from lexer.l
$(LEX_C): $(LEX_SRC)
	flex -o $(LEX_C) $(LEX_SRC)

# Generate parser.tab.c and parser.tab.h from parser.y
$(YACC_C) $(YACC_H): $(YACC_SRC)
	bison -d -o $(YACC_C) $(YACC_SRC)

# Run with input file (optional FILE=path.sl)
run: $(EXE)
ifndef FILE
	@read -p "Enter input file (.sl): " file; \
	if [ -f $$file ]; then $(EXE) < $$file; else echo "File not found: $$file"; fi
else
	@# Suppress command echo here:
	@if [ -f $(FILE) ]; then $(EXE) < $(FILE); else echo "File not found: $(FILE)"; fi
endif

# Clean generated files
clean:
	rm -f $(LEX_C) $(YACC_C) $(YACC_H)
	rm -f $(EXE)

# Clean everything
distclean: clean
	rm -rf $(BIN_DIR)
