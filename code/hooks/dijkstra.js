// Dijkstra-specific WASM algorithm setup

let dijkstraModule = null;

// Helper: Allocate memory in WASM for edges and working arrays (Dijkstra)
function allocateMemoryInWasmDijkstra(wasmModule, edges, nodeCount, adjacencyOffset, adjacencyCount) {
    const memory = wasmModule.instance.exports.memory;
    const edgeSize = 12; // int(4) + int(4) + float(4) = 12 bytes
    
    let offset = 1000; // Start safe offset
    
    // Validate inputs
    if (nodeCount <= 0 || edges.length < 0) {
        throw new Error(`Invalid nodeCount (${nodeCount}) or edges length (${edges.length})`);
    }
    
    // Calculate required sizes (with extra space for algorithm working memory)
    const edgesMemory = edges.length * edgeSize;
    const adjacencyOffsetMemory = nodeCount * 4; // int array
    const adjacencyCountMemory = nodeCount * 4; // int array
    const distancesMemory = nodeCount * 8; // float (doubled for safety)
    const previousMemory = nodeCount * 8; // int (doubled for safety)
    const visitedMemory = nodeCount * 4; // bool (quadrupled for safety)
    const pqItemsMemory = nodeCount * 8; // int (doubled for safety)
    const pqPrioritiesMemory = nodeCount * 8; // float (doubled for safety)
    const pathMemory = nodeCount * 16; // int array (allocate more for longer paths)
    
    const totalRequired = offset + edgesMemory + adjacencyOffsetMemory + adjacencyCountMemory + distancesMemory + previousMemory + visitedMemory + pqItemsMemory + pqPrioritiesMemory + pathMemory;
    
    // Grow memory if needed (with safety margin of 2x)
    const currentMemoryPages = memory.buffer.byteLength / 65536;
    const requiredPages = Math.ceil((totalRequired * 2) / 65536);
    if (requiredPages > currentMemoryPages) {
        memory.grow(requiredPages - currentMemoryPages);
    }
    console.log(`Memory: current=${currentMemoryPages} pages, required=${requiredPages} pages, totalRequired=${totalRequired} bytes`);
    
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

// Dijkstra WASM algorithm wrapper
function runWasmAlgorithmDijkstra(nodeIdToIndex, edges, adjacencyOffset, adjacencyCount, graph, source, target, readResultFromWasm, buildNodeMappingAndEdges) {
    const AlgorithmResult = class {
        constructor(algorithmName, complexity) {
            this.algorithm = algorithmName;
            this.complexity = complexity;
            this.path = [];
            this.distance = Infinity;
            this.executionTime = 0;
        }
    };

    const result = new AlgorithmResult('Dijkstra (Binary Heap)', 'O((m + n) log n)');
    
    if (!dijkstraModule) {
        throw new Error('Dijkstra WASM module not loaded');
    }
    
    try {
        const nodeCount = graph.nodeCount;
        const edgeCount = edges.length;
        
        // Map source and target to indices
        const sourceIdx = nodeIdToIndex.get(source);
        const targetIdx = nodeIdToIndex.get(target);
        
        if (sourceIdx === undefined || targetIdx === undefined) {
            throw new Error(`Invalid source or target node ID`);
        }
        
        console.log(`Running Dijkstra with ${nodeCount} nodes, ${edgeCount} edges`);
        
        // Allocate memory (not counted in execution time)
        const { edgesOffset, adjacencyOffsetWasmOffset, adjacencyCountWasmOffset, distancesOffset, previousOffset, visitedOffset, pqItemsOffset, pqPrioritiesOffset, pathOffset } 
            = allocateMemoryInWasmDijkstra(dijkstraModule, edges, nodeCount, adjacencyOffset, adjacencyCount);
        
        // Allocate output parameter locations (must match pathMemory size in allocateMemoryInWasm)
        const outDistanceOffset = pathOffset + nodeCount * 16;
        const pathLengthOffset = outDistanceOffset + 4;
        
        const memory = dijkstraModule.instance.exports.memory;
        const buffer = new DataView(memory.buffer);
        buffer.setInt32(pathLengthOffset, 0, true);
        
        // Start timer just before WASM execution
        const startTime = performance.now();
        
        // Call WASM function
        dijkstraModule.instance.exports['dijkstra__dijkstra_execute'](
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
            outDistanceOffset
        );
        
        const endTime = performance.now();
        
        // Read path length
        const pathLength = buffer.getInt32(pathLengthOffset, true);
        
        // Read result from WASM memory
        const wasmResult = readResultFromWasm(dijkstraModule, pathOffset, pathLength, outDistanceOffset, nodeCount);
        
        // Map path indices back to original node IDs (not counted in execution time)
        const indexToNodeId = new Map([...nodeIdToIndex].map(([id, idx]) => [idx, id]));
        const mappedPath = wasmResult.path.map(idx => indexToNodeId.get(idx));
        
        result.path = mappedPath;
        result.distance = wasmResult.distance;
        result.executionTime = endTime - startTime;
        
        console.log(`Dijkstra result: distance=${result.distance}, pathLength=${result.path.length}, time=${result.executionTime.toFixed(3)}ms`);
        
    } catch (error) {
        console.error(`Error in Dijkstra WASM call:`, error);
        result.distance = Infinity;
        result.path = [];
        result.executionTime = 0;
    }
    
    return result;
}

// Initialize Dijkstra WASM module
async function initializeDijkstraModule() {
    try {
        dijkstraModule = await WebAssembly.instantiateStreaming(
            fetch('algorithms/build/wasm/dijkstra.wasm')
        );
        console.log('Dijkstra exports:', Object.keys(dijkstraModule.instance.exports));
        console.log('Dijkstra WASM module loaded successfully');
    } catch (error) {
        console.error('Failed to load Dijkstra WASM module:', error);
        throw error;
    }
}

// Get Dijkstra module
function getDijkstraModule() {
    return dijkstraModule;
}
