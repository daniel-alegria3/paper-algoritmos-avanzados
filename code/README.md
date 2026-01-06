# SSSP Algorithm Visualizer

Interactive visualization tool for comparing Single-Source Shortest Path algorithms on OpenStreetMap.

## Features

- **OpenStreetMap Integration**: Select any region on the map to generate a graph
- **Interactive Node Selection**: Click on the map to select source and target nodes
- **Multiple Algorithms**:
  - Dijkstra with Binary Heap - O((m + n) log n)
  - Ran et al. (2025) - O(m log^(2/3) n) inspired divide-and-conquer
- **Performance Metrics**: Execution time comparison for algorithm analysis
- **Algorithm Comparison**: Run all algorithms and compare side-by-side

## Usage

1. Open `index.html` in a modern web browser
2. Click "Select Region" and drag on the map to define the graph area
3. Adjust the number of nodes and edge density as desired
4. Click "Select Nodes" and click on two nodes (source and target)
5. Choose an algorithm and click "Run Algorithm"

## Project Structure

### Web Interface
- `index.html` - Main HTML structure
- `app.js` - Main application logic and UI management
- `graph.js` - Graph data structure, MinHeap, PriorityQueue implementations
- `styles.css` - Dark theme styling

### Algorithm Integration
- `algorithms.js` - Algorithm registry and WASM interface coordination
- `hooks/` - WASM module initialization and execution
  - `dijkstra.js` - Dijkstra algorithm execution hook
  - `ran2025.js` - Ran2025 algorithm execution hook

### C3 / WebAssembly (High-Performance Implementations)
- `algorithms/` - C3 implementations compiled to WebAssembly
  - `dijkstra.c3` - Dijkstra algorithm with binary heap priority queue
  - `ran2025.c3` - Ran et al. (2025) inspired algorithm
  - `common.c3` - Shared data structures and priority queue implementation
  - `Makefile` - Build configuration for WebAssembly compilation
  - `build/` - Compiled WebAssembly modules

## Architecture

The project uses a hybrid architecture for optimal performance:

1. **JavaScript Layer** (`app.js`, `algorithms.js`) - Handles UI, graph loading, and algorithm coordination
2. **WASM Hooks** (`hooks/`) - Manages WebAssembly module initialization, memory allocation, and parameter marshaling
3. **High-Performance Core** (`algorithms/`) - C3 algorithms compiled to WebAssembly for fast computation

## Building WebAssembly Modules

From the `algorithms/` directory:

```bash
make                    # Build all modules (release mode)
make BUILD_TYPE=debug   # Build with debug symbols
make dijkstra          # Build specific algorithm
make clean             # Clean build artifacts
```

Requires C3 compiler (c3c) version 1.0+

## Adding New Algorithms

To add a new algorithm:

1. Implement in C3: Create `algorithms/myalgorithm.c3` with function `void myalgorithm_execute(...)`
2. Create hook: Add `hooks/myalgorithm.js` with `initializeMyalgorithmModule()` function
3. Register: In `algorithms.js`, call:
   ```javascript
   registerAlgorithm('myalgorithm', myalgorithmFunction, 'My Algorithm Name', 'Description');
   ```

## Based on Research

- Ran et al. (2025): "Shortest Paths in O(m log^(2/3) n) Time"
- Implements concepts: divide-and-conquer, frontier reduction, BMSSP
