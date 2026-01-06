// Shortest Path Algorithms with C3 WebAssembly Implementations

class AlgorithmResult {
    constructor(algorithmName, complexity) {
        this.algorithm = algorithmName;
        this.complexity = complexity;
        this.path = [];
        this.distance = Infinity;
        this.executionTime = 0;
    }
}

// Initialize WASM modules from hooks
async function initializeWasmModules() {
    try {
        await initializeDijkstraModule();
        await initializeRan2025Module();
        console.log('WASM modules loaded successfully');
    } catch (error) {
        console.error('Failed to load WASM modules:', error);
        throw error;
    }
}

// Helper: Create mapping from OSM node IDs to indices and build edge array with adjacency info
function buildNodeMappingAndEdges(graph) {
    const nodeIdToIndex = new Map();
    const edges = [];
    const adjacencyOffset = new Array(graph.nodeCount);
    const adjacencyCount = new Array(graph.nodeCount);
    let index = 0;
    
    // First pass: map all node IDs to indices
    for (const nodeId of graph.nodes.keys()) {
        nodeIdToIndex.set(nodeId, index);
        index++;
    }
    
    // Second pass: build edges using mapped indices and adjacency lists
    let edgeIndex = 0;
    for (const [fromId, node] of graph.nodes) {
        const fromIdx = nodeIdToIndex.get(fromId);
        adjacencyOffset[fromIdx] = edgeIndex;
        adjacencyCount[fromIdx] = node.edges.size;
        
        for (const [toId, edgeData] of node.edges) {
            const toIdx = nodeIdToIndex.get(toId);
            edges.push({ from: fromIdx, to: toIdx, weight: edgeData.weight });
            edgeIndex++;
        }
    }
    
    return { nodeIdToIndex, edges, adjacencyOffset, adjacencyCount };
}



// Helper: Read result and path from WASM memory
function readResultFromWasm(wasmModule, pathOffset, pathLength, outDistanceOffset, nodeCount) {
    const memory = wasmModule.instance.exports.memory;
    const buffer = new DataView(memory.buffer);
    
    try {
        // Read output values
        const distance = buffer.getFloat32(outDistanceOffset, true);
        
        // Read path array
        const path = [];
        for (let i = 0; i < pathLength; i++) {
            path.push(buffer.getInt32(pathOffset + i * 4, true));
        }
        
        return { distance, pathLength, path };
    } catch (error) {
        console.error('Error reading result from WASM memory:', error);
        return {
            distance: Infinity,
            pathLength: 0,
            path: []
        };
    }
}

// Dijkstra using C3 WebAssembly
function dijkstra(graph, source, target) {
    const { nodeIdToIndex, edges, adjacencyOffset, adjacencyCount } = buildNodeMappingAndEdges(graph);
    return runWasmAlgorithmDijkstra(nodeIdToIndex, edges, adjacencyOffset, adjacencyCount, graph, source, target, readResultFromWasm, buildNodeMappingAndEdges);
}

// Ran et al. 2025 using C3 WebAssembly
function ran2025Algorithm(graph, source, target) {
    const { nodeIdToIndex, edges, adjacencyOffset, adjacencyCount } = buildNodeMappingAndEdges(graph);
    return runWasmAlgorithmRan2025(nodeIdToIndex, edges, adjacencyOffset, adjacencyCount, graph, source, target, readResultFromWasm, buildNodeMappingAndEdges);
}

// Algorithm registry
const algorithms = {
    dijkstra: {
        fn: dijkstra,
        name: 'Dijkstra (Binary Heap)',
        description: 'Classic shortest path algorithm with binary heap priority queue'
    },
    ran2025: {
        fn: ran2025Algorithm,
        name: 'Ran et al. (2025)',
        description: 'Divide-and-conquer with frontier reduction, O(m log^(2/3) n)'
    }
};

// Run a single algorithm
function runAlgorithm(algorithmName, graph, source, target) {
    const algo = algorithms[algorithmName];
    if (!algo) {
        throw new Error(`Algorithm '${algorithmName}' not found`);
    }
    return algo.fn(graph, source, target);
}

// Run all algorithms for comparison
function compareAlgorithms(graph, source, target) {
    const results = [];
    for (const [name, algo] of Object.entries(algorithms)) {
        try {
            const result = algo.fn(graph, source, target);
            results.push(result);
        } catch (error) {
            console.error(`Error running ${name}:`, error);
        }
    }
    return results;
}

// Register a new algorithm
function registerAlgorithm(name, fn, displayName, description) {
    algorithms[name] = {
        fn: fn,
        name: displayName || name,
        description: description || ''
    };
}

// Get list of available algorithms
function getAvailableAlgorithms() {
    return Object.entries(algorithms).map(([key, algo]) => ({
        key: key,
        name: algo.name,
        description: algo.description
    }));
}
