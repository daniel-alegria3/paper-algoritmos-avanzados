# Makefile for Shortest Path Algorithms in C3
# Compiles to WebAssembly

.PHONY: all clean build dijkstra ran2025

# C3 compiler
C3C := c3c

# Build flags
WASM_FLAGS := --target wasm32 --use-stdlib=no
DEBUG_FLAGS := -O0 -g
RELEASE_FLAGS := -O3

# Output directory
BUILD_DIR := build
WASM_DIR := $(BUILD_DIR)/wasm

# Default to release build
BUILD_TYPE ?= release

ifeq ($(BUILD_TYPE),debug)
    CFLAGS := $(DEBUG_FLAGS)
else
    CFLAGS := $(RELEASE_FLAGS)
endif

# Targets
all: $(WASM_DIR)/dijkstra.wasm $(WASM_DIR)/ran2025.wasm

$(WASM_DIR):
	@mkdir -p $(WASM_DIR)

# Build Dijkstra WebAssembly module
$(WASM_DIR)/dijkstra.wasm: dijkstra.c3 $(WASM_DIR)
	$(C3C) compile dijkstra.c3 $(WASM_FLAGS) $(CFLAGS) --no-entry -o $(WASM_DIR)/dijkstra

# Build Ran2025 WebAssembly module
$(WASM_DIR)/ran2025.wasm: ran2025.c3 $(WASM_DIR)
	$(C3C) compile ran2025.c3 $(WASM_FLAGS) $(CFLAGS) --no-entry -o $(WASM_DIR)/ran2025

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

# Build individual algorithms
dijkstra: $(WASM_DIR)/dijkstra.wasm

ran2025: $(WASM_DIR)/ran2025.wasm

# Help target
help:
	@echo "Shortest Path Algorithms in C3 - WebAssembly Build"
	@echo ""
	@echo "Targets:"
	@echo "  all        - Build all algorithms (default)"
	@echo "  dijkstra   - Build Dijkstra algorithm only"
	@echo "  ran2025    - Build Ran2025 algorithm only"
	@echo "  clean      - Remove all build artifacts"
	@echo ""
	@echo "Variables:"
	@echo "  BUILD_TYPE - Build type: 'release' (default) or 'debug'"
	@echo ""
	@echo "Examples:"
	@echo "  make                    # Build all (release)"
	@echo "  make BUILD_TYPE=debug   # Build all (debug)"
	@echo "  make dijkstra           # Build Dijkstra only"
	@echo "  make clean              # Clean build directory"
