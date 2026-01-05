# Shortest Path Algorithms in C3 (WebAssembly)

This directory contains C3 implementations of shortest path algorithms compiled to WebAssembly modules.

## Files

- **common.c3** - Shared data structures and priority queue implementation
  - Edge struct, constants (MAX_NODES, MAX_EDGES, INFINITY_VAL)
  - Binary heap priority queue (pq_push, pq_pop functions)

- **dijkstra.c3** - Dijkstra's algorithm with binary heap priority queue
  - Complexity: O((m + n) log n)
  - Classic shortest path algorithm using binary heap

- **ran2025.c3** - Shortest path algorithm (Ran et al. 2025 inspired)
  - Complexity: O(m log^(2/3) n) theoretical target
  - Current implementation: Single-source shortest path with binary heap
  - Future: divide-and-conquer with frontier reduction

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
    float* distances,
    int* previous,
    bool* visited,
    int* adjacency_offset,
    int* adjacency_count,
    int* pq_items,
    float* pq_priorities,
    int* path,
    int* pathLength,
    float* outDistance
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
    float* distances,
    int* previous,
    bool* visited,
    int* adjacency_offset,
    int* adjacency_count,
    int* pq_items,
    float* pq_priorities,
    int* path,
    int* pathLength,
    float* outDistance
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

## Metrics Tracking

Metrics collection has been moved to JavaScript for cleaner separation of concerns:
- C3 modules focus purely on algorithm implementation (distance computation and path reconstruction)
- JavaScript layer handles timing measurements and performance analysis
- This keeps the WebAssembly modules lean and focused on core algorithm logic

## Compilation Details

The Makefile uses:
- `--target wasm32` - Compile to WebAssembly target
- `--use-stdlib=no` - No standard library (lightweight modules)
- `--no-entry` - No main function (library mode)
- `-O3` (release) or `-O0 -g` (debug) - Optimization levels
- Compiles all modules together (`*.c3` files) so module imports are resolved

For detailed C3 compiler documentation, see: https://c3-lang.org/

## Limitations

- No support for negative edge weights (Dijkstra/Ran2025 requirement)
- Fixed array sizes (change MAX_NODES/MAX_EDGES constants if needed)
- Linear edge lookup in current implementation (could optimize with adjacency lists)
