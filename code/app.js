// Main application logic

class GraphVisualizer {
    constructor() {
        this.map = null;
        this.graph = null;
        this.selectedBounds = null;
        this.selectionRectangle = null;
        this.isSelecting = false;
        this.isSelectingNodes = false;
        this.startPoint = null;
        this.nodeMarkers = [];
        this.edgePolylines = [];
        this.pathPolylines = [];
        this.sourceMarker = null;
        this.targetMarker = null;
        this.selectingNodeType = null;
        this.isLoading = false;
        this.sourceNodeId = null;
        this.targetNodeId = null;
        this.maxVisibleNodes = 150;
        this.maxVisibleEdges = 300;

        this.initMap();
        this.initEventListeners();
    }

    initMap() {
        this.map = L.map('map').setView([-13.5170, -71.9785], 15); // Cusco, Peru

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors',
            maxZoom: 19
        }).addTo(this.map);

        this.map.on('mousedown', (e) => this.handleMouseDown(e));
        this.map.on('mousemove', (e) => this.handleMouseMove(e));
        this.map.on('mouseup', (e) => this.handleMouseUp(e));
        this.map.on('click', (e) => this.handleMapClick(e));
        this.map.on('zoomend', () => this.updateVisibleElements());
        this.map.on('moveend', () => this.updateVisibleElements());
    }

    initEventListeners() {
        document.getElementById('select-region').addEventListener('click', () => {
            this.enableRegionSelection();
        });

        document.getElementById('clear-selection').addEventListener('click', () => {
            this.clearAll();
        });

        document.getElementById('pick-source').addEventListener('click', () => {
            this.enableNodePicking('source');
        });

        document.getElementById('pick-target').addEventListener('click', () => {
            this.enableNodePicking('target');
        });

        document.getElementById('run-algorithm').addEventListener('click', () => {
            this.runSelectedAlgorithm();
        });

        document.getElementById('source-node').addEventListener('input', () => {
            this.validateInputs();
        });

        document.getElementById('target-node').addEventListener('input', () => {
            this.validateInputs();
        });

        document.getElementById('algorithm-select').addEventListener('change', (e) => {
            const comparisonSection = document.getElementById('comparison-section');
            comparisonSection.style.display = e.target.value === 'compare' ? 'block' : 'none';
        });

        document.getElementById('use-random').addEventListener('change', (e) => {
            const randomOptions = document.getElementById('random-options');
            randomOptions.style.display = e.target.checked ? 'block' : 'none';
        });

        document.getElementById('edge-density').addEventListener('input', (e) => {
            document.getElementById('edge-density-value').textContent = e.target.value;
        });
    }

    enableNodePicking(type) {
        this.isSelectingNodes = true;
        this.selectingNodeType = type;
        this.map.getContainer().style.cursor = 'crosshair';
        
        // Update button states
        document.getElementById('pick-source').classList.toggle('active', type === 'source');
        document.getElementById('pick-target').classList.toggle('active', type === 'target');
        
        this.updateHint(`Click on map to select ${type.toUpperCase()}`);
    }

    disableNodePicking() {
        this.isSelectingNodes = false;
        this.selectingNodeType = null;
        this.map.getContainer().style.cursor = '';
        document.getElementById('pick-source').classList.remove('active');
        document.getElementById('pick-target').classList.remove('active');
        this.updateHint('');
    }

    enablePickButtons() {
        document.getElementById('pick-source').disabled = false;
        document.getElementById('pick-target').disabled = false;
    }

    disablePickButtons() {
        document.getElementById('pick-source').disabled = true;
        document.getElementById('pick-target').disabled = true;
    }

    enableRegionSelection() {
        if (this.isLoading) return;
        this.isSelecting = true;
        this.isSelectingNodes = false;
        this.map.dragging.disable();
        this.map.getContainer().style.cursor = 'crosshair';
        this.updateHint('Click and drag to select a region');
    }



    handleMouseDown(e) {
        if (!this.isSelecting) return;
        this.startPoint = e.latlng;
        this.clearSelectionRectangle();
    }

    handleMouseMove(e) {
        if (!this.isSelecting || !this.startPoint) return;

        this.clearSelectionRectangle();
        const bounds = L.latLngBounds(this.startPoint, e.latlng);
        this.selectionRectangle = L.rectangle(bounds, {
            color: '#3498db',
            weight: 2,
            fillColor: '#3498db',
            fillOpacity: 0.15
        }).addTo(this.map);
    }

    handleMouseUp(e) {
        if (!this.isSelecting || !this.startPoint) return;

        this.isSelecting = false;
        this.map.dragging.enable();
        this.map.getContainer().style.cursor = '';

        const bounds = L.latLngBounds(this.startPoint, e.latlng);
        this.selectedBounds = {
            north: bounds.getNorth(),
            south: bounds.getSouth(),
            east: bounds.getEast(),
            west: bounds.getWest()
        };

        this.startPoint = null;
        this.fetchGraph();
    }

    handleMapClick(e) {
        if (!this.isSelectingNodes || !this.graph) return;

        const nearestNode = this.graph.findNearestNode(e.latlng.lat, e.latlng.lng);
        if (nearestNode === null) return;

        if (this.selectingNodeType === 'source') {
            document.getElementById('source-node').value = nearestNode;
            this.sourceNodeId = nearestNode;
            this.updateSourceMarker(nearestNode);
        } else if (this.selectingNodeType === 'target') {
            document.getElementById('target-node').value = nearestNode;
            this.targetNodeId = nearestNode;
            this.updateTargetMarker(nearestNode);
        }

        this.disableNodePicking();
        this.validateInputs();
        this.updateVisibleElements();
    }

    updateSourceMarker(nodeId) {
        if (this.sourceMarker) {
            this.map.removeLayer(this.sourceMarker);
            this.sourceMarker = null;
        }

        if (!this.graph) return;
        const node = this.graph.getNode(nodeId);
        if (!node) return;

        const radius = this.getNodeRadius() + 5;
        this.sourceMarker = L.circleMarker([node.lat, node.lng], {
            color: '#ffffff',
            radius: radius,
            fillColor: '#27ae60',
            fillOpacity: 1,
            weight: 3
        }).addTo(this.map);
        this.sourceMarker.bindTooltip('Source', { permanent: false, direction: 'top' });
    }

    updateTargetMarker(nodeId) {
        if (this.targetMarker) {
            this.map.removeLayer(this.targetMarker);
            this.targetMarker = null;
        }

        if (!this.graph) return;
        const node = this.graph.getNode(nodeId);
        if (!node) return;

        const radius = this.getNodeRadius() + 5;
        this.targetMarker = L.circleMarker([node.lat, node.lng], {
            color: '#ffffff',
            radius: radius,
            fillColor: '#e74c3c',
            fillOpacity: 1,
            weight: 3
        }).addTo(this.map);
        this.targetMarker.bindTooltip('Target', { permanent: false, direction: 'top' });
    }

    updateEndpointMarkers() {
        // Update source marker size
        if (this.sourceMarker && this.sourceNodeId !== null) {
            const radius = this.getNodeRadius() + 5;
            this.sourceMarker.setRadius(radius);
        }
        // Update target marker size
        if (this.targetMarker && this.targetNodeId !== null) {
            const radius = this.getNodeRadius() + 5;
            this.targetMarker.setRadius(radius);
        }
    }

    updateHint(text) {
        document.getElementById('selection-hint').textContent = text;
    }

    setLoading(loading, message = '') {
        this.isLoading = loading;
        const overlay = document.getElementById('loading-overlay');
        const loadingText = document.getElementById('loading-text');

        if (loading) {
            overlay.style.display = 'flex';
            loadingText.textContent = message || 'Loading...';
        } else {
            overlay.style.display = 'none';
        }
    }

    async fetchGraph() {
        if (!this.selectedBounds) return;

        const useRandom = document.getElementById('use-random').checked;

        if (useRandom) {
            const nodeCount = parseInt(document.getElementById('node-count').value) || 100;
            const edgeDensity = parseInt(document.getElementById('edge-density').value) || 3;
            this.graph = Graph.generateSampleGraph(this.selectedBounds, nodeCount, edgeDensity);
            this.visualizeGraph();
            this.updateGraphStats();
            this.enablePickButtons();
            this.validateInputs();
            return;
        }

        this.setLoading(true, 'Fetching road data from OpenStreetMap...');

        try {
            this.graph = await Graph.fetchFromOSM(this.selectedBounds, (msg) => {
                document.getElementById('loading-text').textContent = msg;
            });

            if (this.graph.nodeCount === 0) {
                throw new Error('No roads found in selected area. Try a larger region or different location.');
            }

            this.visualizeGraph();
            this.updateGraphStats();
            this.enablePickButtons();
            this.validateInputs();
            this.updateHint('Use 📍 and 🎯 buttons to pick source and target');

        } catch (error) {
            console.error('Failed to fetch graph:', error);
            this.updateHint(`Error: ${error.message}`);
            document.getElementById('graph-stats').innerHTML = `<p class="error">${error.message}</p>`;
        } finally {
            this.setLoading(false);
        }
    }

    clearAll() {
        this.clearSelectionRectangle();
        this.clearGraphVisualization();
        this.clearPath();
        this.selectedBounds = null;
        this.graph = null;
        this.isSelecting = false;
        this.isSelectingNodes = false;
        this.map.dragging.enable();
        this.map.getContainer().style.cursor = '';

        document.getElementById('run-algorithm').disabled = true;
        this.disablePickButtons();
        document.getElementById('source-node').value = '';
        document.getElementById('target-node').value = '';
        document.getElementById('path-display').innerHTML = '';
        document.getElementById('performance-display').innerHTML = '';
        document.getElementById('comparison-display').innerHTML = '';
        document.getElementById('graph-stats').innerHTML = '<p>No graph generated</p>';
        this.sourceNodeId = null;
        this.targetNodeId = null;
        this.updateHint('');
    }

    clearSelectionRectangle() {
        if (this.selectionRectangle) {
            this.map.removeLayer(this.selectionRectangle);
            this.selectionRectangle = null;
        }
    }

    clearGraphVisualization() {
        this.nodeMarkers.forEach(marker => this.map.removeLayer(marker));
        this.edgePolylines.forEach(polyline => this.map.removeLayer(polyline));
        this.nodeMarkers = [];
        this.edgePolylines = [];

        if (this.sourceMarker) {
            this.map.removeLayer(this.sourceMarker);
            this.sourceMarker = null;
        }
        if (this.targetMarker) {
            this.map.removeLayer(this.targetMarker);
            this.targetMarker = null;
        }
    }

    clearPath() {
        this.pathPolylines.forEach(polyline => this.map.removeLayer(polyline));
        this.pathPolylines = [];
    }

    visualizeGraph() {
        this.clearGraphVisualization();
        this.updateVisibleElements();
    }

    getNodeRadius() {
        const zoom = this.map.getZoom();
        // Scale radius: smaller when zoomed out, larger when zoomed in
        // Zoom typically ranges from 10-19 for street-level
        const baseRadius = 3;
        const scaleFactor = Math.max(0.5, (zoom - 12) * 0.4);
        return Math.max(2, Math.min(8, baseRadius + scaleFactor));
    }

    getEdgeWeight() {
        const zoom = this.map.getZoom();
        return Math.max(1, Math.min(4, (zoom - 12) * 0.3 + 1.5));
    }

    updateVisibleElements() {
        if (!this.graph || this._skipVisibilityUpdate) return;

        // Clear existing markers and edges (but not path or source/target)
        this.nodeMarkers.forEach(marker => this.map.removeLayer(marker));
        this.edgePolylines.forEach(polyline => this.map.removeLayer(polyline));
        this.nodeMarkers = [];
        this.edgePolylines = [];

        const bounds = this.map.getBounds();
        const visibleNodes = [];
        const nodeRadius = this.getNodeRadius();
        const edgeWeight = this.getEdgeWeight();

        // Collect nodes in current viewport
        for (const [nodeId, node] of this.graph.nodes) {
            if (bounds.contains([node.lat, node.lng])) {
                visibleNodes.push({ id: nodeId, node });
            }
        }

        // Sample nodes if too many (but always include source/target)
        let nodesToShow = visibleNodes;
        const importantNodes = new Set();
        if (this.sourceNodeId !== null) importantNodes.add(this.sourceNodeId);
        if (this.targetNodeId !== null) importantNodes.add(this.targetNodeId);

        if (visibleNodes.length > this.maxVisibleNodes) {
            // Keep important nodes, sample the rest
            const important = visibleNodes.filter(n => importantNodes.has(n.id));
            const others = visibleNodes.filter(n => !importantNodes.has(n.id));
            
            // Uniform sampling
            const sampleCount = Math.max(0, this.maxVisibleNodes - important.length);
            if (sampleCount > 0 && others.length > 0) {
                const step = Math.max(1, Math.floor(others.length / sampleCount));
                const sampled = others.filter((_, i) => i % step === 0).slice(0, sampleCount);
                nodesToShow = [...important, ...sampled];
            } else {
                nodesToShow = important.slice(0, this.maxVisibleNodes);
            }
        }

        const nodeIdsToShow = new Set(nodesToShow.map(n => n.id));

        // Draw edges for visible nodes
        const drawnEdges = new Set();
        let edgeCount = 0;

        for (const { id: fromId, node } of nodesToShow) {
            if (edgeCount >= this.maxVisibleEdges) break;

            for (const [toId, data] of node.edges) {
                if (edgeCount >= this.maxVisibleEdges) break;
                if (!nodeIdsToShow.has(toId)) continue;

                const edgeKey = [Math.min(fromId, toId), Math.max(fromId, toId)].join('-');
                const toNode = this.graph.getNode(toId);
                if (!toNode) continue;

                const reverseExists = this.graph.nodes.get(toId)?.edges.has(fromId);

                let color;
                if (reverseExists) {
                    if (drawnEdges.has(edgeKey)) continue;
                    color = '#5dade2';
                    drawnEdges.add(edgeKey);
                } else {
                    color = '#e67e22';
                }

                const polyline = L.polyline([
                    [node.lat, node.lng],
                    [toNode.lat, toNode.lng]
                ], {
                    color: color,
                    weight: edgeWeight,
                    opacity: 0.7
                }).addTo(this.map);

                if (!reverseExists) {
                    this.addArrowToPolyline(polyline, node, toNode);
                }

                this.edgePolylines.push(polyline);
                edgeCount++;
            }
        }

        // Draw nodes
        for (const { id: nodeId, node } of nodesToShow) {
            const isImportant = importantNodes.has(nodeId);
            const radius = isImportant ? nodeRadius + 3 : nodeRadius;
            const marker = L.circleMarker([node.lat, node.lng], {
                color: isImportant ? '#f1c40f' : '#2c3e50',
                radius: radius,
                fillColor: isImportant ? '#f1c40f' : '#ecf0f1',
                fillOpacity: 0.9,
                weight: isImportant ? 2 : 1
            }).addTo(this.map);

            marker.bindTooltip(`Node ${nodeId}`, { permanent: false, direction: 'top' });
            marker.nodeId = nodeId;
            this.nodeMarkers.push(marker);
        }

        // Update visible count in stats
        const statsExtra = document.getElementById('visible-stats');
        if (statsExtra) {
            statsExtra.textContent = `Showing: ${nodesToShow.length} nodes, ${edgeCount} edges`;
        }

        // Update endpoint marker sizes and bring to front
        this.updateEndpointMarkers();
        
        // Ensure path and source/target markers stay on top
        this.pathPolylines.forEach(p => {
            if (p.bringToFront) p.bringToFront();
        });
        if (this.sourceMarker) this.sourceMarker.bringToFront();
        if (this.targetMarker) this.targetMarker.bringToFront();
    }

    addArrowToPolyline(polyline, fromNode, toNode) {
        const midLat = (fromNode.lat + toNode.lat) / 2;
        const midLng = (fromNode.lng + toNode.lng) / 2;

        const angle = Math.atan2(
            toNode.lat - fromNode.lat,
            toNode.lng - fromNode.lng
        ) * 180 / Math.PI;

        const arrow = L.marker([midLat, midLng], {
            icon: L.divIcon({
                className: 'arrow-marker',
                html: `<div style="transform: rotate(${90 - angle}deg); color: #e67e22; font-size: 12px;">▶</div>`,
                iconSize: [12, 12],
                iconAnchor: [6, 6]
            })
        }).addTo(this.map);

        this.edgePolylines.push(arrow);
    }

    updateGraphStats() {
        const stats = document.getElementById('graph-stats');
        const avgDegree = this.graph.nodeCount > 0 ? 
            (this.graph.edgeCount / this.graph.nodeCount).toFixed(2) : 0;

        stats.innerHTML = `
            <p><strong>Intersections:</strong> ${this.graph.nodeCount}</p>
            <p><strong>Road Segments:</strong> ${this.graph.edgeCount}</p>
            <p><strong>Avg Degree:</strong> ${avgDegree}</p>
            <p><strong>Two-way:</strong> ${this.graph.twoWayEdges} <span style="color:#5dade2">●</span></p>
            <p><strong>One-way:</strong> ${this.graph.oneWayEdges} <span style="color:#e67e22">●</span></p>
            <p id="visible-stats" style="margin-top:5px;color:#90a4ae;font-size:11px;"></p>
        `;
    }

    validateInputs() {
        const sourceInput = document.getElementById('source-node');
        const targetInput = document.getElementById('target-node');
        const runButton = document.getElementById('run-algorithm');

        const source = parseInt(sourceInput.value) || sourceInput.value;
        const target = parseInt(targetInput.value) || targetInput.value;

        const isValid = this.graph &&
            this.graph.nodes.has(source) &&
            this.graph.nodes.has(target) &&
            source !== target;

        runButton.disabled = !isValid;
    }

    runSelectedAlgorithm() {
        const algorithmSelect = document.getElementById('algorithm-select');
        const algorithm = algorithmSelect.value;
        const source = parseInt(document.getElementById('source-node').value) || 
                       document.getElementById('source-node').value;
        const target = parseInt(document.getElementById('target-node').value) || 
                       document.getElementById('target-node').value;

        this.clearPath();

        try {
            if (algorithm === 'compare') {
                const results = compareAlgorithms(this.graph, source, target);
                this.displayComparisonResults(results);
                if (results.length > 0 && results[0].path.length > 0) {
                    this.visualizePath(results[0].path, '#27ae60');
                }
            } else {
                const result = runAlgorithm(algorithm, this.graph, source, target);
                this.displayResults(result);
                this.visualizePath(result.path, '#27ae60');
            }
        } catch (error) {
            console.error('Algorithm execution failed:', error);
            document.getElementById('performance-display').innerHTML =
                `<p class="error">Error: ${error.message}</p>`;
        }
    }

    displayResults(result) {
        const pathDisplay = document.getElementById('path-display');
        const performanceDisplay = document.getElementById('performance-display');

        if (result.path.length === 0 || result.distance === Infinity) {
            pathDisplay.innerHTML = `<p class="error">No path found! The target may not be reachable (check one-way streets).</p>`;
        } else {
            const distanceKm = (result.distance / 1000).toFixed(2);

            pathDisplay.innerHTML = `
                <p><strong>Distance:</strong> ${distanceKm} km (${result.distance.toFixed(0)} m)</p>
                <p><strong>Intersections:</strong> ${result.path.length}</p>
                <p><strong>Segments:</strong> ${result.path.length - 1}</p>
            `;
        }

        performanceDisplay.innerHTML = `
            <p><strong>Algorithm:</strong> ${result.algorithm}</p>
            <p><strong>Complexity:</strong> ${result.complexity}</p>
            <p><strong>Time:</strong> ${result.executionTime.toFixed(3)} ms</p>
            <hr>
            <p><strong>Nodes Visited:</strong> ${result.metrics.nodesVisited}</p>
            <p><strong>Edges Examined:</strong> ${result.metrics.edgesExamined}</p>
            <p><strong>Relaxations:</strong> ${result.metrics.relaxations}</p>
            <p><strong>Heap Ops:</strong> ${result.metrics.heapOperations}</p>
            ${result.metrics.recursiveCalls > 0 ? `<p><strong>Recursive Calls:</strong> ${result.metrics.recursiveCalls}</p>` : ''}
            <p><strong>Memory Est.:</strong> ${formatBytes(result.metrics.memoryEstimate)}</p>
        `;
    }

    displayComparisonResults(results) {
        const pathDisplay = document.getElementById('path-display');
        const performanceDisplay = document.getElementById('performance-display');
        const comparisonDisplay = document.getElementById('comparison-display');

        if (results.length === 0) {
            pathDisplay.innerHTML = '<p class="error">No results</p>';
            return;
        }

        const first = results[0];
        if (first.path.length === 0 || first.distance === Infinity) {
            pathDisplay.innerHTML = `<p class="error">No path found!</p>`;
        } else {
            const distanceKm = (first.distance / 1000).toFixed(2);
            pathDisplay.innerHTML = `
                <p><strong>Distance:</strong> ${distanceKm} km</p>
                <p><strong>Intersections:</strong> ${first.path.length}</p>
            `;
        }

        performanceDisplay.innerHTML = '<p>See comparison below</p>';

        let comparisonHTML = '<table class="comparison-table"><thead><tr>' +
            '<th>Algorithm</th><th>Time (ms)</th><th>Nodes</th><th>Edges</th><th>Relaxations</th></tr></thead><tbody>';

        const fastestTime = Math.min(...results.map(r => r.executionTime));

        for (const result of results) {
            const isFastest = result.executionTime === fastestTime;
            const speedup = result.executionTime > 0 ? (result.executionTime / fastestTime).toFixed(2) : '-';

            comparisonHTML += `
                <tr${isFastest ? ' class="fastest"' : ''}>
                    <td>${result.algorithm}</td>
                    <td>${result.executionTime.toFixed(3)} ${isFastest ? '⚡' : `(${speedup}x)`}</td>
                    <td>${result.metrics.nodesVisited}</td>
                    <td>${result.metrics.edgesExamined}</td>
                    <td>${result.metrics.relaxations}</td>
                </tr>
            `;
        }

        comparisonHTML += '</tbody></table>';
        comparisonDisplay.innerHTML = comparisonHTML;
    }

    visualizePath(path, color) {
        if (path.length < 2) return;

        const latlngs = path.map(nodeId => {
            const node = this.graph.getNode(nodeId);
            return [node.lat, node.lng];
        });

        // Main path line
        const polyline = L.polyline(latlngs, {
            color: color,
            weight: 6,
            opacity: 0.9
        }).addTo(this.map);

        this.pathPolylines.push(polyline);

        // Add start/end circles on the path
        const startCircle = L.circleMarker(latlngs[0], {
            color: '#27ae60',
            radius: 10,
            fillColor: '#2ecc71',
            fillOpacity: 1,
            weight: 3
        }).addTo(this.map);

        const endCircle = L.circleMarker(latlngs[latlngs.length - 1], {
            color: '#c0392b',
            radius: 10,
            fillColor: '#e74c3c',
            fillOpacity: 1,
            weight: 3
        }).addTo(this.map);

        this.pathPolylines.push(startCircle, endCircle);

        // Fit map to show the path (temporarily disable updateVisibleElements)
        this._skipVisibilityUpdate = true;
        this.map.fitBounds(polyline.getBounds(), { padding: [50, 50] });
        setTimeout(() => {
            this._skipVisibilityUpdate = false;
            this.updateVisibleElements();
        }, 100);
    }
}

function formatBytes(bytes) {
    if (bytes < 1024) return bytes + ' B';
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
    return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
}

document.addEventListener('DOMContentLoaded', () => {
    new GraphVisualizer();
});
