# Compiler and flags
CC      := gcc
CFLAGS  := -O2 -Wall -Wextra -std=c11
LDFLAGS :=

# Load variables from .env
ifneq (,$(wildcard .env))
        include .env
        export
endif

# From .env
ARCH    := $(shell $ARCH)
VERSION := $(shell $VERSION)

# Directories
SRC_DIR := src
OBJ_DIR := build
BIN_DIR := usr/local/bin
DEB_DIR := DEBIAN

# Files
TARGET  := hello
SRC     := $(SRC_DIR)/hello.c
OBJ     := $(OBJ_DIR)/hello.o
BIN     := $(BIN_DIR)/$(TARGET)
CONTROL_IN := $(DEB_DIR)/control.in
CONTROL    := $(DEB_DIR)/control

# Default target
all: $(BIN)

# Compile .c -> .o
$(OBJ): $(SRC)
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Link .o -> binary
$(BIN): $(OBJ)
	mkdir -p $(BIN_DIR)
	$(CC) $(OBJ) -o $@ $(LDFLAGS)

# Generate Debian control file
$(CONTROL): $(CONTROL_IN)
	sed "s/@ARCH@/$(ARCH)/g" $< > $@
	chmod 644 $@

# Build the .deb package
deb: $(CONTROL) all
	dpkg-deb --build --root-owner-group . ..

# Clean
clean:
	rm -rf $(OBJ_DIR)
	rm -f $(BIN)
	rm -f $(CONTROL)

.PHONY: all clean deb

