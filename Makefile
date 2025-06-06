# Makefile for setlang project

# Directories
SRC_DIR := src
BIN_DIR := bin

# Executable
EXE := $(BIN_DIR)/setlang

# Sources
LEX_SRC := $(SRC_DIR)/lexer.l
YACC_SRC := $(SRC_DIR)/parser.y
LEX_C := $(SRC_DIR)/lex.yy.c
YACC_C := $(SRC_DIR)/parser.tab.c
YACC_H := $(SRC_DIR)/parser.tab.h

CPP_SRCS := $(SRC_DIR)/string_stack.cpp $(SRC_DIR)/set_storage.cpp
OBJ_SRCS := $(LEX_C) $(YACC_C) $(CPP_SRCS)

# Compiler and flags
CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra

# Default target
all: $(EXE)

# Final binary
$(EXE): $(OBJ_SRCS)
	mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $(OBJ_SRCS) -o $(EXE)

# Lex file
$(LEX_C): $(LEX_SRC)
	flex -o $(LEX_C) $(LEX_SRC)

# Bison files
$(YACC_C) $(YACC_H): $(YACC_SRC)
	bison -d -o $(YACC_C) $(YACC_SRC)

# Run with input file (optional FILE=path.sl)
run: $(EXE)
ifndef FILE
	@read -p "Enter input file (.sl): " file; \
	if [ -f $$file ]; then $(EXE) < $$file; else echo "File not found: $$file"; fi
else
	@if [ -f $(FILE) ]; then $(EXE) < $(FILE); else echo "File not found: $(FILE)"; fi
endif

# Clean generated files (but not final binary)
clean:
	rm -f $(LEX_C) $(YACC_C) $(YACC_H)

# Clean everything
distclean: clean
	rm -f $(EXE)
	rm -f $(SRC_DIR)/parser_app  # Remove stray builds

.PHONY: all clean distclean run
