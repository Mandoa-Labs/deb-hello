# Compiler and flags
CC      := gcc
CFLAGS  := -O2 -Wall -Wextra -std=c11
LDFLAGS :=

# Directories
SRC_DIR := src
OBJ_DIR := build
BIN_DIR := usr/local/bin

# Targets
TARGET  := hello
SRC     := $(SRC_DIR)/hello.c
OBJ     := $(OBJ_DIR)/hello.o
BIN     := $(BIN_DIR)/$(TARGET)

# Default target
all: $(BIN)

# Compile .c -> .o
$(OBJ): $(SRC)
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Link .o -> binary (inside Debian filesystem layout)
$(BIN): $(OBJ)
	mkdir -p $(BIN_DIR)
	$(CC) $(OBJ) -o $@ $(LDFLAGS)

# Build the .deb package
deb: all
	dpkg-deb --build --root-owner-group . ..

# Clean build artifacts
clean:
	rm -rf $(OBJ_DIR)
	rm -f $(BIN)

.PHONY: all clean deb

