# Shortest Path Algorithms in C3 (WebAssembly)

This directory contains C3 implementations of shortest path algorithms compiled to WebAssembly modules.

## Files

- **dijkstra.c3** - Dijkstra's algorithm with binary heap priority queue
  - Complexity: O((m + n) log n)
  - Classic shortest path algorithm using binary heap

- **ran2025.c3** - Ran et al. (2025) divide-and-conquer algorithm
  - Complexity: O(m log^(2/3) n)
  - Frontier reduction with bucket-based processing

- **Makefile** - Build configuration for compiling to WebAssembly

## Building

### Prerequisites

- C3 compiler (c3c) installed and in PATH
- For WASM target support: C3 1.0+

### Build Commands

```bash
# Build all modules (release mode)
make

# Build all modules (debug mode with symbols)
make BUILD_TYPE=debug

# Build specific algorithm
make dijkstra
make ran2025

# Clean build artifacts
make clean
```

## Output

Compiled WebAssembly modules are generated in `build/wasm/`:
- `dijkstra.wasm`
- `ran2025.wasm`

## C3 Implementation Notes

### Data Structures

Both implementations use array-based data structures to ensure predictable memory layout for WASM:

- **Graph**: Arrays of edges with `from`, `to`, and `weight` fields
- **Priority Queue**: Binary heap implemented with arrays (no dynamic allocation)
- **Distances/Previous Maps**: Fixed-size arrays indexed by node ID

### Constraints

- **MAX_NODES**: 1000 (configurable in header)
- **MAX_EDGES**: 10000 (configurable in header)
- **Node IDs**: Must be in range [0, nodeCount-1]

### Key Functions

#### dijkstra.c3

```c3
fn void dijkstra_execute(
    int nodeCount,
    int edgeCount,
    Edge* edges,
    int source,
    int target,
    Result* result
)
```

#### ran2025.c3

```c3
fn void ran2025_execute(
    int nodeCount,
    int edgeCount,
    Edge* edges,
    int source,
    int target,
    Result* result
)
```

## Using from JavaScript

Load and instantiate the WASM modules in your web application:

```javascript
// Load module
const response = await fetch('build/wasm/dijkstra.wasm');
const buffer = await response.arrayBuffer();
const instance = await WebAssembly.instantiate(buffer);

// Call dijkstra_execute via instance.exports
```

## Performance Characteristics

### Dijkstra

- Better for sparse graphs
- Standard implementation with proven O((m + n) log n) complexity
- Single-source shortest path

### Ran2025

- Experimental divide-and-conquer approach
- Attempts to achieve O(m log^(2/3) n) through frontier reduction
- Bucket-based processing for pivot selection
- Includes fallback relaxation for unreached targets

## Metrics Tracked

Both algorithms track:
- **relaxations**: Number of edge weight updates
- **heapOperations**: Priority queue push/pop count
- **nodesVisited**: Nodes processed
- **edgesExamined**: Edges checked
- **recursiveCalls**: (Ran2025 only) Recursive BMSSP calls
- **memoryEstimate**: Approximate memory usage in bytes

## Compilation Details

The Makefile uses:
- `--target wasm` - Compile to WebAssembly target
- `--no-backtrace` - Reduce WASM module size
- `-O3` (release) or `-O0 -g` (debug) - Optimization levels

For detailed C3 compiler documentation, see: https://c3-lang.org/

## Limitations

- No support for negative edge weights (Dijkstra/Ran2025 requirement)
- Fixed array sizes (change MAX_NODES/MAX_EDGES constants if needed)
- Linear edge lookup in current implementation (could optimize with adjacency lists)
