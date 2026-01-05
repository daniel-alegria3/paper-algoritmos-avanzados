// Shortest Path Algorithms with C3 WebAssembly Implementations

class AlgorithmResult {
    constructor(algorithmName, complexity) {
        this.algorithm = algorithmName;
        this.complexity = complexity;
        this.path = [];
        this.distance = Infinity;
        this.executionTime = 0;
        this.metrics = {
            relaxations: 0,
            heapOperations: 0,
            nodesVisited: 0,
            edgesExamined: 0,
            recursiveCalls: 0,
            memoryEstimate: 0
        };
    }
}

// WASM module instances
let dijkstraModule = null;
let ran2025Module = null;

// Initialize WASM modules
async function initializeWasmModules() {
    try {
        // Load Dijkstra WASM
        const dijkstraResponse = await fetch('algorithms/build/wasm/dijkstra.wasm');
        const dijkstraBuffer = await dijkstraResponse.arrayBuffer();
        dijkstraModule = await WebAssembly.instantiate(dijkstraBuffer);
        console.log('Dijkstra exports:', Object.keys(dijkstraModule.instance.exports));

        // Load Ran2025 WASM
        const ran2025Response = await fetch('algorithms/build/wasm/ran2025.wasm');
        const ran2025Buffer = await ran2025Response.arrayBuffer();
        ran2025Module = await WebAssembly.instantiate(ran2025Buffer);
        console.log('Ran2025 exports:', Object.keys(ran2025Module.instance.exports));

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

// Helper: Allocate memory in WASM for edges and working arrays
function allocateMemoryInWasm(wasmModule, edges, nodeCount, adjacencyOffset, adjacencyCount) {
    const memory = wasmModule.instance.exports.memory;
    const edgeSize = 12; // int(4) + int(4) + float(4) = 12 bytes
    
    let offset = 1000; // Start safe offset
    
    // Calculate required sizes
    const edgesMemory = edges.length * edgeSize;
    const adjacencyOffsetMemory = nodeCount * 4; // int array
    const adjacencyCountMemory = nodeCount * 4; // int array
    const distancesMemory = nodeCount * 4; // float
    const previousMemory = nodeCount * 4; // int
    const visitedMemory = nodeCount * 1; // bool
    const pqItemsMemory = nodeCount * 4; // int
    const pqPrioritiesMemory = nodeCount * 4; // float
    const pathMemory = nodeCount * 4; // int
    
    const totalRequired = offset + edgesMemory + adjacencyOffsetMemory + adjacencyCountMemory + distancesMemory + previousMemory + visitedMemory + pqItemsMemory + pqPrioritiesMemory + pathMemory;
    
    // Grow memory if needed
    const currentMemoryPages = memory.buffer.byteLength / 65536;
    const requiredPages = Math.ceil(totalRequired / 65536);
    if (requiredPages > currentMemoryPages) {
        memory.grow(requiredPages - currentMemoryPages);
    }
    
    const buffer = new DataView(memory.buffer);
    
    // Write edges
    const edgesOffset = offset;
    for (let i = 0; i < edges.length; i++) {
        const edgeOffset = edgesOffset + i * edgeSize;
        buffer.setInt32(edgeOffset, edges[i].from, true);
        buffer.setInt32(edgeOffset + 4, edges[i].to, true);
        buffer.setFloat32(edgeOffset + 8, edges[i].weight, true);
    }
    
    // Write adjacency arrays
    const adjacencyOffsetWasmOffset = edgesOffset + edgesMemory;
    const adjacencyCountWasmOffset = adjacencyOffsetWasmOffset + adjacencyOffsetMemory;
    
    for (let i = 0; i < nodeCount; i++) {
        buffer.setInt32(adjacencyOffsetWasmOffset + i * 4, adjacencyOffset[i], true);
        buffer.setInt32(adjacencyCountWasmOffset + i * 4, adjacencyCount[i], true);
    }
    
    // Calculate offsets for working arrays
    const distancesOffset = adjacencyCountWasmOffset + adjacencyCountMemory;
    const previousOffset = distancesOffset + distancesMemory;
    const visitedOffset = previousOffset + previousMemory;
    const pqItemsOffset = visitedOffset + visitedMemory;
    const pqPrioritiesOffset = pqItemsOffset + pqItemsMemory;
    const pathOffset = pqPrioritiesOffset + pqPrioritiesMemory;
    
    // Initialize arrays to zero
    for (let i = 0; i < distancesMemory; i += 4) {
        buffer.setInt32(distancesOffset + i, 0, true);
    }
    for (let i = 0; i < previousMemory; i += 4) {
        buffer.setInt32(previousOffset + i, 0, true);
    }
    for (let i = 0; i < visitedMemory; i++) {
        buffer.setUint8(visitedOffset + i, 0);
    }
    
    return { edgesOffset, adjacencyOffsetWasmOffset, adjacencyCountWasmOffset, distancesOffset, previousOffset, visitedOffset, pqItemsOffset, pqPrioritiesOffset, pathOffset };
}

// Helper: Read result and path from WASM memory
function readResultFromWasm(wasmModule, pathOffset, pathLength, outDistanceOffset, outMetricsOffset, nodeCount) {
    const memory = wasmModule.instance.exports.memory;
    const buffer = new DataView(memory.buffer);
    
    try {
        // Read output values
        const distance = buffer.getFloat32(outDistanceOffset, true);
        
        // Read metrics struct (5 ints)
        const metrics = {
            relaxations: buffer.getInt32(outMetricsOffset, true),
            heapOperations: buffer.getInt32(outMetricsOffset + 4, true),
            nodesVisited: buffer.getInt32(outMetricsOffset + 8, true),
            edgesExamined: buffer.getInt32(outMetricsOffset + 12, true),
            recursiveCalls: buffer.getInt32(outMetricsOffset + 16, true),
            memoryEstimate: buffer.getInt32(outMetricsOffset + 20, true)
        };
        
        // Read path array
        const path = [];
        const maxPathLength = Math.min(pathLength, nodeCount);
        for (let i = 0; i < maxPathLength; i++) {
            path.push(buffer.getInt32(pathOffset + i * 4, true));
        }
        
        return { distance, pathLength, path, metrics };
    } catch (error) {
        console.error('Error reading result from WASM memory:', error);
        return {
            distance: Infinity,
            pathLength: 0,
            path: [],
            metrics: {
                relaxations: 0,
                heapOperations: 0,
                nodesVisited: 0,
                edgesExamined: 0,
                recursiveCalls: 0,
                memoryEstimate: 0
            }
        };
    }
}

// Generic WASM algorithm wrapper
function runWasmAlgorithm(wasmModule, wasmFunctionName, algorithmName, complexity, graph, source, target, logPrefix) {
    const result = new AlgorithmResult(algorithmName, complexity);
    
    if (!wasmModule) {
        throw new Error(`${algorithmName} WASM module not loaded`);
    }
    
    try {
        // Build node mapping and edges (not counted in execution time)
        const { nodeIdToIndex, edges, adjacencyOffset, adjacencyCount } = buildNodeMappingAndEdges(graph);
        const nodeCount = graph.nodeCount;
        const edgeCount = edges.length;
        
        // Map source and target to indices
        const sourceIdx = nodeIdToIndex.get(source);
        const targetIdx = nodeIdToIndex.get(target);
        
        if (sourceIdx === undefined || targetIdx === undefined) {
            throw new Error(`Invalid source or target node ID`);
        }
        
        console.log(`Running ${logPrefix} with ${nodeCount} nodes, ${edgeCount} edges`);
        
        // Allocate memory (not counted in execution time)
        const { edgesOffset, adjacencyOffsetWasmOffset, adjacencyCountWasmOffset, distancesOffset, previousOffset, visitedOffset, pqItemsOffset, pqPrioritiesOffset, pathOffset } 
            = allocateMemoryInWasm(wasmModule, edges, nodeCount, adjacencyOffset, adjacencyCount);
        
        // Allocate output parameter locations
        const outDistanceOffset = pathOffset + nodeCount * 4;
        const outMetricsOffset = outDistanceOffset + 4;
        const pathLengthOffset = outMetricsOffset + 24;
        
        const memory = wasmModule.instance.exports.memory;
        const buffer = new DataView(memory.buffer);
        buffer.setInt32(pathLengthOffset, 0, true);
        
        // Start timer just before WASM execution
        const startTime = performance.now();
        
        // Call WASM function dynamically
        const wasmFunction = wasmModule.instance.exports[wasmFunctionName];
        
        wasmFunction(
            nodeCount,
            edgeCount,
            edgesOffset,
            sourceIdx,
            targetIdx,
            distancesOffset,
            previousOffset,
            visitedOffset,
            adjacencyOffsetWasmOffset,
            adjacencyCountWasmOffset,
            pqItemsOffset,
            pqPrioritiesOffset,
            pathOffset,
            pathLengthOffset,
            outDistanceOffset,
            outMetricsOffset
        );
        
        const endTime = performance.now();
        
        // Read path length
        const pathLength = buffer.getInt32(pathLengthOffset, true);
        
        // Read result from WASM memory
        const wasmResult = readResultFromWasm(wasmModule, pathOffset, pathLength, outDistanceOffset, outMetricsOffset, nodeCount);
        
        // Map path indices back to original node IDs (not counted in execution time)
        const indexToNodeId = new Map([...nodeIdToIndex].map(([id, idx]) => [idx, id]));
        const mappedPath = wasmResult.path.map(idx => indexToNodeId.get(idx));
        
        result.path = mappedPath;
        result.distance = wasmResult.distance;
        result.metrics = wasmResult.metrics;
        result.executionTime = endTime - startTime;
        
        console.log(`${logPrefix} result: distance=${result.distance}, pathLength=${result.path.length}, time=${result.executionTime.toFixed(3)}ms`);
        
    } catch (error) {
        console.error(`Error in ${logPrefix} WASM call:`, error);
        result.distance = Infinity;
        result.path = [];
        result.executionTime = 0;
    }
    
    return result;
}

// Dijkstra using C3 WebAssembly
function dijkstra(graph, source, target) {
    return runWasmAlgorithm(
        dijkstraModule,
        'dijkstra__dijkstra_execute',
        'Dijkstra (Binary Heap)',
        'O((m + n) log n)',
        graph,
        source,
        target,
        'Dijkstra'
    );
}

// Ran et al. 2025 using C3 WebAssembly
function ran2025Algorithm(graph, source, target) {
    return runWasmAlgorithm(
        ran2025Module,
        'ran2025__ran2025_execute',
        'Ran et al. (2025)',
        'O(m log^(2/3) n)',
        graph,
        source,
        target,
        'Ran2025'
    );
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
