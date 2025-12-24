# Load variables from .env
ifneq (,$(wildcard .env))
        include .env
        export
endif

# From .env
ARCH    := $(ARCH)
VERSION := $(VERSION)

# Set compiler based on architecture
ifeq ($(ARCH),armhf)
        CC := arm-linux-gnueabihf-gcc
else ifeq ($(ARCH),armv6l)
        CC := arm-linux-gnueabihf-gcc
else ifeq ($(ARCH),arm64)
        CC := aarch64-linux-gnu-gcc
else ifeq ($(ARCH),amd64)
        CC := gcc
else ifeq ($(ARCH),i386)
        CC := i686-linux-gnu-gcc
else
        CC := gcc
endif

# Compiler flags
CFLAGS  := -O2 -Wall -Wextra -std=c11
LDFLAGS :=

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
	sed \
	  -e "s/@ARCH@/$(ARCH)/g" \
	  -e "s/@VERSION@/$(VERSION)/g" \
	  $< > $@
	chmod 644 $@

# Build the .deb package
deb: $(CONTROL) all
	dpkg-deb --build --root-owner-group . .

# Clean
clean:
	rm -rf $(OBJ_DIR)
	rm -f $(BIN)
	rm -f $(CONTROL)

.PHONY: all clean deb

