// Ran2025-specific WASM algorithm setup

let ran2025Module = null;

// Helper: Allocate memory in WASM for edges and working arrays (Ran2025 with frontier reduction)
function allocateMemoryInWasmRan2025(wasmModule, edges, nodeCount, adjacencyOffset, adjacencyCount) {
    const memory = wasmModule.instance.exports.memory;
    const edgeSize = 12; // int(4) + int(4) + float(4) = 12 bytes
    
    let offset = 1000; // Start safe offset
    
    // Validate inputs
    if (nodeCount <= 0 || edges.length < 0) {
        throw new Error(`Invalid nodeCount (${nodeCount}) or edges length (${edges.length})`);
    }
    
    // Calculate required sizes (with extra space for Ran2025 frontier reduction algorithm)
    const edgesMemory = edges.length * edgeSize;
    const adjacencyOffsetMemory = nodeCount * 4; // int array
    const adjacencyCountMemory = nodeCount * 4; // int array
    const distancesMemory = nodeCount * 8; // float (doubled for safety)
    const previousMemory = nodeCount * 8; // int (doubled for safety)
    const visitedMemory = nodeCount * 4; // bool (quadrupled for safety)
    const pqItemsMemory = nodeCount * 16; // int (4x for frontier reduction tracking)
    const pqPrioritiesMemory = nodeCount * 16; // float (4x for frontier reduction tracking)
    const pathMemory = nodeCount * 16; // int array (allocate more for longer paths)
    // Additional buffers for pivot selection and frontier tracking
    const weightsBufferMemory = nodeCount * 8; // float array for weight sorting
    const indicesBufferMemory = nodeCount * 8; // int array for index mapping
    
    const totalRequired = offset + edgesMemory + adjacencyOffsetMemory + adjacencyCountMemory + distancesMemory + previousMemory + visitedMemory + pqItemsMemory + pqPrioritiesMemory + pathMemory + weightsBufferMemory + indicesBufferMemory;
    
    // Grow memory if needed (with safety margin of 2x)
    const currentMemoryPages = memory.buffer.byteLength / 65536;
    const requiredPages = Math.ceil((totalRequired * 2) / 65536);
    if (requiredPages > currentMemoryPages) {
        memory.grow(requiredPages - currentMemoryPages);
    }
    console.log(`Memory (Ran2025): current=${currentMemoryPages} pages, required=${requiredPages} pages, totalRequired=${totalRequired} bytes (includes frontier reduction buffers)`);
    
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
    const weightsBufferOffset = pathOffset + pathMemory;
    const indicesBufferOffset = weightsBufferOffset + weightsBufferMemory;
    
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
    
    return { edgesOffset, adjacencyOffsetWasmOffset, adjacencyCountWasmOffset, distancesOffset, previousOffset, visitedOffset, pqItemsOffset, pqPrioritiesOffset, pathOffset, weightsBufferOffset, indicesBufferOffset };
}

// Ran2025 WASM algorithm wrapper
function runWasmAlgorithmRan2025(nodeIdToIndex, edges, adjacencyOffset, adjacencyCount, graph, source, target, readResultFromWasm, buildNodeMappingAndEdges) {
    const AlgorithmResult = class {
        constructor(algorithmName, complexity) {
            this.algorithm = algorithmName;
            this.complexity = complexity;
            this.path = [];
            this.distance = Infinity;
            this.executionTime = 0;
        }
    };

    const result = new AlgorithmResult('Ran et al. (2025)', 'O(m log^(2/3) n)');
    
    if (!ran2025Module) {
        throw new Error('Ran2025 WASM module not loaded');
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
        
        console.log(`Running Ran2025 with ${nodeCount} nodes, ${edgeCount} edges`);
        
        // Allocate memory (not counted in execution time)
        const { edgesOffset, adjacencyOffsetWasmOffset, adjacencyCountWasmOffset, distancesOffset, previousOffset, visitedOffset, pqItemsOffset, pqPrioritiesOffset, pathOffset, weightsBufferOffset, indicesBufferOffset } 
            = allocateMemoryInWasmRan2025(ran2025Module, edges, nodeCount, adjacencyOffset, adjacencyCount);
        
        // Allocate output parameter locations (must match pathMemory size in allocateMemoryInWasm)
        const outDistanceOffset = pathOffset + nodeCount * 16;
        const pathLengthOffset = outDistanceOffset + 4;
        
        const memory = ran2025Module.instance.exports.memory;
        const buffer = new DataView(memory.buffer);
        buffer.setInt32(pathLengthOffset, 0, true);
        
        // Start timer just before WASM execution
        const startTime = performance.now();
        
        // Call WASM function
        ran2025Module.instance.exports['ran2025__ran2025_execute'](
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
        const wasmResult = readResultFromWasm(ran2025Module, pathOffset, pathLength, outDistanceOffset, nodeCount);
        
        // Map path indices back to original node IDs (not counted in execution time)
        const indexToNodeId = new Map([...nodeIdToIndex].map(([id, idx]) => [idx, id]));
        const mappedPath = wasmResult.path.map(idx => indexToNodeId.get(idx));
        
        result.path = mappedPath;
        result.distance = wasmResult.distance;
        result.executionTime = endTime - startTime;
        
        console.log(`Ran2025 result: distance=${result.distance}, pathLength=${result.path.length}, time=${result.executionTime.toFixed(3)}ms`);
        
    } catch (error) {
        console.error(`Error in Ran2025 WASM call:`, error);
        result.distance = Infinity;
        result.path = [];
        result.executionTime = 0;
    }
    
    return result;
}

// Initialize Ran2025 WASM module
async function initializeRan2025Module() {
    try {
        ran2025Module = await WebAssembly.instantiateStreaming(
            fetch('public/algorithms/ran2025.wasm')
        );
        console.log('Ran2025 exports:', Object.keys(ran2025Module.instance.exports));
        console.log('Ran2025 WASM module loaded successfully');
    } catch (error) {
        console.error('Failed to load Ran2025 WASM module:', error);
        throw error;
    }
}

// Get Ran2025 module
function getRan2025Module() {
    return ran2025Module;
}
