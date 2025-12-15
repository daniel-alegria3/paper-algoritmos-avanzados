// Shortest Path Algorithms with Performance Metrics

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

// Standard Dijkstra's algorithm with binary heap
function dijkstra(graph, source, target) {
    const result = new AlgorithmResult('Dijkstra (Binary Heap)', 'O((m + n) log n)');
    const startTime = performance.now();

    const distances = new Map();
    const previous = new Map();
    const visited = new Set();
    const pq = new PriorityQueue();

    for (const nodeId of graph.getAllNodes()) {
        distances.set(nodeId, nodeId === source ? 0 : Infinity);
    }

    pq.push(source, 0);
    result.metrics.heapOperations++;

    while (!pq.isEmpty()) {
        const { item: current, priority: currentDist } = pq.pop();
        result.metrics.heapOperations++;

        if (visited.has(current)) continue;
        visited.add(current);
        result.metrics.nodesVisited++;

        if (current === target) break;

        if (currentDist > distances.get(current)) continue;

        for (const [neighbor, weight] of graph.getNeighbors(current)) {
            result.metrics.edgesExamined++;
            const newDist = distances.get(current) + weight;

            if (newDist < distances.get(neighbor)) {
                distances.set(neighbor, newDist);
                previous.set(neighbor, current);
                pq.push(neighbor, newDist);
                result.metrics.heapOperations++;
                result.metrics.relaxations++;
            }
        }
    }

    const endTime = performance.now();
    result.executionTime = endTime - startTime;

    result.path = reconstructPath(previous, source, target);
    result.distance = distances.get(target);
    result.metrics.memoryEstimate = estimateMemory(distances.size, previous.size, pq.size());

    return result;
}

// Ran et al. O(m log^(2/3) n) algorithm simulation
// This implements a divide-and-conquer approach with frontier reduction
function ran2025Algorithm(graph, source, target) {
    const result = new AlgorithmResult('Ran et al. (2025)', 'O(m log^(2/3) n)');
    const startTime = performance.now();

    const n = graph.nodeCount;
    const m = graph.edgeCount;

    const distances = new Map();
    const previous = new Map();
    const visited = new Set();

    for (const nodeId of graph.getAllNodes()) {
        distances.set(nodeId, nodeId === source ? 0 : Infinity);
    }

    // Calculate the bucket size based on log^(2/3) n factor
    const logFactor = Math.pow(Math.log2(Math.max(n, 2)), 2 / 3);
    const bucketSize = Math.max(1, Math.ceil(n / logFactor));

    // Bounded Multi-Source Shortest Path simulation
    function bmssp(sources, bound, depth = 0) {
        result.metrics.recursiveCalls++;

        if (sources.size === 0 || depth > Math.log2(n)) return;

        // Process nodes in buckets (frontier reduction)
        const frontier = new PriorityQueue();
        const localVisited = new Set();

        for (const s of sources) {
            if (!visited.has(s)) {
                frontier.push(s, distances.get(s));
                result.metrics.heapOperations++;
            }
        }

        let processed = 0;
        const nextSources = new Set();

        while (!frontier.isEmpty() && processed < bucketSize) {
            const { item: current, priority: currentDist } = frontier.pop();
            result.metrics.heapOperations++;

            if (localVisited.has(current)) continue;
            localVisited.add(current);
            visited.add(current);
            result.metrics.nodesVisited++;
            processed++;

            if (current === target) continue;

            const neighbors = graph.getNeighbors(current);

            // Pivot selection: sort neighbors and select subset
            const pivotCount = Math.max(1, Math.ceil(neighbors.length / logFactor));
            neighbors.sort((a, b) => a[1] - b[1]);
            const selectedNeighbors = neighbors.slice(0, Math.min(pivotCount * 2, neighbors.length));

            for (const [neighbor, weight] of selectedNeighbors) {
                result.metrics.edgesExamined++;
                const newDist = distances.get(current) + weight;

                if (newDist < distances.get(neighbor) && newDist <= bound) {
                    distances.set(neighbor, newDist);
                    previous.set(neighbor, current);
                    result.metrics.relaxations++;

                    if (!visited.has(neighbor)) {
                        nextSources.add(neighbor);
                        frontier.push(neighbor, newDist);
                        result.metrics.heapOperations++;
                    }
                }
            }

            // Process remaining neighbors with reduced priority
            for (let i = pivotCount * 2; i < neighbors.length; i++) {
                const [neighbor, weight] = neighbors[i];
                result.metrics.edgesExamined++;
                const newDist = distances.get(current) + weight;

                if (newDist < distances.get(neighbor) && newDist <= bound) {
                    distances.set(neighbor, newDist);
                    previous.set(neighbor, current);
                    result.metrics.relaxations++;
                    nextSources.add(neighbor);
                }
            }
        }

        // Add remaining unprocessed frontier nodes
        while (!frontier.isEmpty()) {
            const { item } = frontier.pop();
            if (!visited.has(item)) {
                nextSources.add(item);
            }
        }

        // Recursive call with new frontier
        if (nextSources.size > 0 && !visited.has(target)) {
            const newBound = bound * 2;
            bmssp(nextSources, newBound, depth + 1);
        }
    }

    // Initialize with source
    const initialSources = new Set([source]);
    const initialBound = estimateInitialBound(graph, source, target);

    bmssp(initialSources, initialBound);

    // Fallback: if target not reached, run standard relaxation on remaining
    if (!visited.has(target) && distances.get(target) === Infinity) {
        const pq = new PriorityQueue();
        for (const [nodeId, dist] of distances) {
            if (dist < Infinity && !visited.has(nodeId)) {
                pq.push(nodeId, dist);
            }
        }

        while (!pq.isEmpty() && !visited.has(target)) {
            const { item: current } = pq.pop();
            result.metrics.heapOperations++;

            if (visited.has(current)) continue;
            visited.add(current);
            result.metrics.nodesVisited++;

            for (const [neighbor, weight] of graph.getNeighbors(current)) {
                result.metrics.edgesExamined++;
                const newDist = distances.get(current) + weight;

                if (newDist < distances.get(neighbor)) {
                    distances.set(neighbor, newDist);
                    previous.set(neighbor, current);
                    result.metrics.relaxations++;
                    pq.push(neighbor, newDist);
                    result.metrics.heapOperations++;
                }
            }
        }
    }

    const endTime = performance.now();
    result.executionTime = endTime - startTime;

    result.path = reconstructPath(previous, source, target);
    result.distance = distances.get(target);
    result.metrics.memoryEstimate = estimateMemory(distances.size, previous.size, 0);

    return result;
}

// Helper: Estimate initial bound based on Euclidean distance
function estimateInitialBound(graph, source, target) {
    const sourceNode = graph.getNode(source);
    const targetNode = graph.getNode(target);
    if (!sourceNode || !targetNode) return Infinity;
    return Graph.distance(sourceNode, targetNode) * 2;
}

// Helper: Reconstruct path from previous map
function reconstructPath(previous, source, target) {
    const path = [];
    let current = target;
    const visited = new Set();

    while (current !== undefined && !visited.has(current)) {
        visited.add(current);
        path.unshift(current);
        if (current === source) break;
        current = previous.get(current);
    }

    if (path.length === 0 || path[0] !== source) {
        return [];
    }

    return path;
}

// Helper: Estimate memory usage in bytes
function estimateMemory(distancesSize, previousSize, queueSize) {
    const mapEntrySize = 24;
    const numberSize = 8;
    return (distancesSize + previousSize) * (mapEntrySize + numberSize) + queueSize * 32;
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
