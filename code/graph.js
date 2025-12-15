// Graph data structure and OSM utilities

class Graph {
    constructor() {
        this.nodes = new Map();
        this.nodeCount = 0;
        this.edgeCount = 0;
        this.oneWayEdges = 0;
        this.twoWayEdges = 0;
    }

    addNode(id, lat, lng) {
        if (!this.nodes.has(id)) {
            this.nodes.set(id, {
                id: id,
                lat: lat,
                lng: lng,
                edges: new Map()
            });
            this.nodeCount++;
        }
    }

    addEdge(fromId, toId, weight, wayId = null) {
        if (this.nodes.has(fromId) && this.nodes.has(toId)) {
            const from = this.nodes.get(fromId);
            if (!from.edges.has(toId)) {
                from.edges.set(toId, { weight, wayId });
                this.edgeCount++;
            }
        }
    }

    addBidirectionalEdge(id1, id2, weight, wayId = null) {
        this.addEdge(id1, id2, weight, wayId);
        this.addEdge(id2, id1, weight, wayId);
    }

    getNode(id) {
        return this.nodes.get(id);
    }

    getNeighbors(id) {
        const node = this.nodes.get(id);
        if (!node) return [];
        return Array.from(node.edges.entries()).map(([toId, data]) => [toId, data.weight]);
    }

    getEdgeWeight(fromId, toId) {
        const node = this.nodes.get(fromId);
        if (!node || !node.edges.has(toId)) return Infinity;
        return node.edges.get(toId).weight;
    }

    getAllNodes() {
        return Array.from(this.nodes.keys());
    }

    getAllNodesData() {
        return Array.from(this.nodes.values());
    }

    static distance(node1, node2) {
        const R = 6371000;
        const lat1 = node1.lat * Math.PI / 180;
        const lat2 = node2.lat * Math.PI / 180;
        const dLat = (node2.lat - node1.lat) * Math.PI / 180;
        const dLng = (node2.lng - node1.lng) * Math.PI / 180;
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1) * Math.cos(lat2) *
            Math.sin(dLng / 2) * Math.sin(dLng / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    findNearestNode(lat, lng) {
        let nearest = null;
        let minDist = Infinity;

        for (const [id, node] of this.nodes) {
            const dist = Graph.distance({ lat, lng }, node);
            if (dist < minDist) {
                minDist = dist;
                nearest = id;
            }
        }

        return nearest;
    }

    // Fetch real road network from OpenStreetMap
    static async fetchFromOSM(bounds, onProgress = null) {
        const { south, west, north, east } = bounds;

        if (onProgress) onProgress('Fetching road data from OpenStreetMap...');

        // Overpass API query for roads/streets
        const query = `
            [out:json][timeout:30];
            (
                way["highway"~"^(motorway|trunk|primary|secondary|tertiary|unclassified|residential|living_street|pedestrian|road|service)$"](${south},${west},${north},${east});
            );
            out body;
            >;
            out skel qt;
        `;

        const url = 'https://overpass-api.de/api/interpreter';

        try {
            const response = await fetch(url, {
                method: 'POST',
                body: `data=${encodeURIComponent(query)}`,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            });

            if (!response.ok) {
                throw new Error(`OSM API error: ${response.status}`);
            }

            const data = await response.json();

            if (onProgress) onProgress('Processing road network...');

            return Graph.parseOSMData(data, onProgress);
        } catch (error) {
            console.error('Failed to fetch OSM data:', error);
            throw error;
        }
    }

    static parseOSMData(osmData, onProgress = null) {
        const graph = new Graph();
        const osmNodes = new Map();
        const nodeUsage = new Map();

        // First pass: collect all nodes
        for (const element of osmData.elements) {
            if (element.type === 'node') {
                osmNodes.set(element.id, {
                    lat: element.lat,
                    lng: element.lon
                });
            }
        }

        // Second pass: count node usage in ways (to identify intersections)
        for (const element of osmData.elements) {
            if (element.type === 'way' && element.nodes) {
                for (const nodeId of element.nodes) {
                    nodeUsage.set(nodeId, (nodeUsage.get(nodeId) || 0) + 1);
                }
            }
        }

        // Third pass: build graph from ways
        const ways = osmData.elements.filter(e => e.type === 'way');
        let processedWays = 0;

        for (const way of ways) {
            if (!way.nodes || way.nodes.length < 2) continue;

            const tags = way.tags || {};
            const isOneway = Graph.isOneWay(tags);
            const isReversed = tags.oneway === '-1';

            // Get all nodes in this way
            const wayNodes = way.nodes
                .filter(id => osmNodes.has(id))
                .map(id => ({ id, ...osmNodes.get(id) }));

            if (wayNodes.length < 2) continue;

            // Add nodes that are intersections or endpoints
            for (let i = 0; i < wayNodes.length; i++) {
                const node = wayNodes[i];
                const isEndpoint = i === 0 || i === wayNodes.length - 1;
                const isIntersection = nodeUsage.get(node.id) > 1;

                if (isEndpoint || isIntersection) {
                    graph.addNode(node.id, node.lat, node.lng);
                }
            }

            // Create edges between consecutive intersection/endpoint nodes
            let lastIntersection = null;
            let accumulatedDistance = 0;

            for (let i = 0; i < wayNodes.length; i++) {
                const node = wayNodes[i];
                const isEndpoint = i === 0 || i === wayNodes.length - 1;
                const isIntersection = nodeUsage.get(node.id) > 1;

                if (i > 0) {
                    const prevNode = wayNodes[i - 1];
                    accumulatedDistance += Graph.distance(
                        { lat: prevNode.lat, lng: prevNode.lng },
                        { lat: node.lat, lng: node.lng }
                    );
                }

                if (isEndpoint || isIntersection) {
                    if (lastIntersection !== null) {
                        const fromId = lastIntersection.id;
                        const toId = node.id;

                        if (isOneway) {
                            if (isReversed) {
                                graph.addEdge(toId, fromId, accumulatedDistance, way.id);
                            } else {
                                graph.addEdge(fromId, toId, accumulatedDistance, way.id);
                            }
                            graph.oneWayEdges++;
                        } else {
                            graph.addBidirectionalEdge(fromId, toId, accumulatedDistance, way.id);
                            graph.twoWayEdges++;
                        }
                    }
                    lastIntersection = node;
                    accumulatedDistance = 0;
                }
            }

            processedWays++;
            if (onProgress && processedWays % 100 === 0) {
                onProgress(`Processing ways: ${processedWays}/${ways.length}`);
            }
        }

        if (onProgress) onProgress('Road network ready!');

        return graph;
    }

    static isOneWay(tags) {
        if (!tags) return false;

        // Explicit oneway tag
        if (tags.oneway === 'yes' || tags.oneway === '1' || tags.oneway === '-1') {
            return true;
        }

        // Motorways and their links are typically one-way
        if (tags.highway === 'motorway' || tags.highway === 'motorway_link') {
            return tags.oneway !== 'no';
        }

        // Roundabouts are one-way
        if (tags.junction === 'roundabout') {
            return true;
        }

        return false;
    }

    // Generate a sample graph (fallback if OSM fails)
    static generateSampleGraph(bounds, numNodes = 100, edgeDensity = 3) {
        const graph = new Graph();
        const { north, south, east, west } = bounds;

        for (let i = 0; i < numNodes; i++) {
            const lat = south + Math.random() * (north - south);
            const lng = west + Math.random() * (east - west);
            graph.addNode(i, lat, lng);
        }

        const nodesData = graph.getAllNodesData();

        for (let i = 0; i < nodesData.length; i++) {
            const distances = [];
            for (let j = 0; j < nodesData.length; j++) {
                if (i !== j) {
                    distances.push({
                        id: nodesData[j].id,
                        dist: Graph.distance(nodesData[i], nodesData[j])
                    });
                }
            }
            distances.sort((a, b) => a.dist - b.dist);

            const numEdges = Math.min(
                Math.floor(Math.random() * edgeDensity) + 1,
                distances.length
            );

            for (let k = 0; k < numEdges; k++) {
                graph.addBidirectionalEdge(nodesData[i].id, distances[k].id, distances[k].dist);
            }
        }

        graph.twoWayEdges = graph.edgeCount / 2;

        return graph;
    }
}

class MinHeap {
    constructor() {
        this.heap = [];
        this.positions = new Map();
    }

    size() {
        return this.heap.length;
    }

    isEmpty() {
        return this.heap.length === 0;
    }

    push(item, priority) {
        const node = { item, priority };
        this.heap.push(node);
        const index = this.heap.length - 1;
        this.positions.set(item, index);
        this._bubbleUp(index);
    }

    pop() {
        if (this.isEmpty()) return null;

        const root = this.heap[0];
        this.positions.delete(root.item);

        const last = this.heap.pop();
        if (this.heap.length > 0) {
            this.heap[0] = last;
            this.positions.set(last.item, 0);
            this._sinkDown(0);
        }

        return root;
    }

    decreaseKey(item, newPriority) {
        const index = this.positions.get(item);
        if (index !== undefined && newPriority < this.heap[index].priority) {
            this.heap[index].priority = newPriority;
            this._bubbleUp(index);
            return true;
        }
        return false;
    }

    contains(item) {
        return this.positions.has(item);
    }

    _bubbleUp(index) {
        while (index > 0) {
            const parentIndex = Math.floor((index - 1) / 2);
            if (this.heap[parentIndex].priority <= this.heap[index].priority) break;
            this._swap(parentIndex, index);
            index = parentIndex;
        }
    }

    _sinkDown(index) {
        const length = this.heap.length;
        while (true) {
            const left = 2 * index + 1;
            const right = 2 * index + 2;
            let smallest = index;

            if (left < length && this.heap[left].priority < this.heap[smallest].priority) {
                smallest = left;
            }
            if (right < length && this.heap[right].priority < this.heap[smallest].priority) {
                smallest = right;
            }
            if (smallest === index) break;

            this._swap(index, smallest);
            index = smallest;
        }
    }

    _swap(i, j) {
        [this.heap[i], this.heap[j]] = [this.heap[j], this.heap[i]];
        this.positions.set(this.heap[i].item, i);
        this.positions.set(this.heap[j].item, j);
    }
}

class PriorityQueue {
    constructor() {
        this.heap = [];
    }

    push(item, priority) {
        this.heap.push({ item, priority });
        this._bubbleUp(this.heap.length - 1);
    }

    pop() {
        if (this.heap.length === 0) return null;
        const root = this.heap[0];
        const last = this.heap.pop();
        if (this.heap.length > 0) {
            this.heap[0] = last;
            this._sinkDown(0);
        }
        return root;
    }

    isEmpty() {
        return this.heap.length === 0;
    }

    size() {
        return this.heap.length;
    }

    _bubbleUp(index) {
        while (index > 0) {
            const parentIndex = Math.floor((index - 1) / 2);
            if (this.heap[parentIndex].priority <= this.heap[index].priority) break;
            [this.heap[parentIndex], this.heap[index]] = [this.heap[index], this.heap[parentIndex]];
            index = parentIndex;
        }
    }

    _sinkDown(index) {
        const length = this.heap.length;
        while (true) {
            const left = 2 * index + 1;
            const right = 2 * index + 2;
            let smallest = index;

            if (left < length && this.heap[left].priority < this.heap[smallest].priority) {
                smallest = left;
            }
            if (right < length && this.heap[right].priority < this.heap[smallest].priority) {
                smallest = right;
            }
            if (smallest === index) break;

            [this.heap[index], this.heap[smallest]] = [this.heap[smallest], this.heap[index]];
            index = smallest;
        }
    }
}
