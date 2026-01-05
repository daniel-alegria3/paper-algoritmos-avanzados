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

## Files

### JavaScript (Web Interface)
- `index.html` - Main HTML structure
- `graph.js` - Graph data structure, MinHeap, PriorityQueue
- `algorithms.js` - WASM algorithm interface and bridge
- `app.js` - Main application logic and UI
- `styles.css` - Dark theme styling

### C3 / WebAssembly (High-Performance Implementations)
- `algorithms/` - C3 implementations compiled to WebAssembly
  - `dijkstra.c3` - Dijkstra algorithm (O((m + n) log n))
  - `ran2025.c3` - Ran et al. (2025) algorithm (O(m log^(2/3) n))
  - `Makefile` - Build configuration for WebAssembly compilation
  - `README.md` - Detailed documentation for C3 implementations

## Adding New Algorithms

Register new algorithms in `algorithms.js`:

```javascript
registerAlgorithm('myAlgorithm', function(graph, source, target) {
    const result = new AlgorithmResult('My Algorithm', 'O(...)');
    // Implementation
    return result;
}, 'My Algorithm Name', 'Description');
```

## Based on Research

- Ran et al. (2025): "Shortest Paths in O(m log^(2/3) n) Time"
- Implements concepts: divide-and-conquer, frontier reduction, BMSSP
