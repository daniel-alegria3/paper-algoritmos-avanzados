# SSSP Algorithm Visualizer

Interactive visualization tool for comparing Single-Source Shortest Path algorithms on OpenStreetMap.

## Features

- **OpenStreetMap Integration**: Select any region on the map to generate a graph
- **Interactive Node Selection**: Click on the map to select source and target nodes
- **Multiple Algorithms**:
  - Dijkstra with Binary Heap - O((m + n) log n)
  - Ran et al. (2025) - O(m log^(2/3) n) inspired divide-and-conquer
- **Performance Metrics**: Detailed statistics including execution time, relaxations, heap operations
- **Algorithm Comparison**: Run all algorithms and compare side-by-side

## Usage

1. Open `index.html` in a modern web browser
2. Click "Select Region" and drag on the map to define the graph area
3. Adjust the number of nodes and edge density as desired
4. Click "Select Nodes" and click on two nodes (source and target)
5. Choose an algorithm and click "Run Algorithm"

## Files

- `index.html` - Main HTML structure
- `graph.js` - Graph data structure, MinHeap, PriorityQueue
- `algorithms.js` - Algorithm implementations with metrics
- `app.js` - Main application logic and UI
- `styles.css` - Dark theme styling

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
