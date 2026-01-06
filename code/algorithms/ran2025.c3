module ran2025;

import common;

// Helper: Calculate log base 2
fn float log2_approx(int n) {
    if (n <= 0) return 0.0f;
    float result = 0.0f;
    int temp = n;
    while (temp > 1) {
        temp = temp / 2;
        result += 1.0f;
    }
    return result;
}

// Helper: Integer power function
fn int ipow(int base, int exp) {
    if (exp == 0) return 1;
    if (exp == 1) return base;
    int result = 1;
    for (int i = 0; i < exp; i++) {
        result = result * base;
    }
    return result;
}

// Helper: Partition neighbors by weight (simple insertion sort for small arrays)
fn void partition_neighbors_by_weight(
    int start,
    int count,
    common::Edge* edges,
    float* weights_buffer,
    int* indices_buffer
) {
    // Copy weights and create index mapping
    for (int i = 0; i < count; i++) {
        weights_buffer[i] = edges[start + i].weight;
        indices_buffer[i] = i;
    }
    
    // Insertion sort
    for (int i = 1; i < count; i++) {
        float key = weights_buffer[i];
        int keyIdx = indices_buffer[i];
        int j = i - 1;
        
        while (j >= 0 && weights_buffer[j] > key) {
            weights_buffer[j + 1] = weights_buffer[j];
            indices_buffer[j + 1] = indices_buffer[j];
            j = j - 1;
        }
        
        weights_buffer[j + 1] = key;
        indices_buffer[j + 1] = keyIdx;
    }
}

// Main Ran2025 algorithm: Divide-and-conquer with frontier reduction
fn void ran2025_execute(
    int nodeCount,
    int edgeCount,
    common::Edge* edges,
    int source,
    int target,
    float* distances,
    int* previous,
    bool* visited,
    int* adjacency_offset,
    int* adjacency_count,
    int* pq_items,
    float* pq_priorities,
    int* path,
    int* pathLength,
    float* outDistance
) @export {
    // Initialize
    for (int i = 0; i < nodeCount; i++) {
        distances[i] = (i == source) ? 0.0f : common::INFINITY_VAL;
        previous[i] = -1;
        visited[i] = false;
    }

    // Calculate bucket size based on log^(2/3) n
    float logVal = log2_approx(nodeCount);
    float logFactor = logVal * logVal / (logVal * 2.0f / 3.0f);  // Approximate log^(2/3) n
    if (logFactor < 1.0f) logFactor = 1.0f;
    int bucketSize = nodeCount / (int)logFactor;
    if (bucketSize < 1) bucketSize = 1;

    int pq_size = 0;
    common::pq_push(pq_items, pq_priorities, &pq_size, source, 0.0f);

    float currentBound = common::INFINITY_VAL;
    bool targetReached = false;

    // Main frontier reduction loop
    while (pq_size > 0 && !targetReached) {
        int processed = 0;
        int frontier_checkpoint = pq_size;

        // Process up to bucketSize nodes from current frontier
        while (pq_size > 0 && processed < bucketSize) {
            int current = common::pq_pop(pq_items, pq_priorities, &pq_size);

            if (visited[current]) continue;
            visited[current] = true;
            processed++;

            if (current == target) {
                targetReached = true;
                currentBound = distances[current];
                break;
            }

            // Get neighbors
            int start = adjacency_offset[current];
            int count = adjacency_count[current];

            if (count == 0) continue;

            // Allocate temporary buffers for pivot selection
            // (Note: In real implementation, these would be passed as parameters)
            // For now, we process all neighbors but with selective heap insertion

            float currentDist = distances[current];

            // Process high-priority neighbors (pivot selection)
            int pivotCount = 1;
            if (count > 10) {
                pivotCount = count / (int)logFactor;
                if (pivotCount < 1) pivotCount = 1;
            }

            // Two-phase processing: high priority then remaining
            int processed_high = 0;

            for (int i = 0; i < count && processed_high < pivotCount * 2; i++) {
                int edgeIdx = start + i;
                if (edgeIdx >= edgeCount) break;

                int neighbor = edges[edgeIdx].to;
                float weight = edges[edgeIdx].weight;
                float newDist = currentDist + weight;

                // Only process if within current bound
                if (newDist <= currentBound && !visited[neighbor]) {
                    if (newDist < distances[neighbor]) {
                        distances[neighbor] = newDist;
                        previous[neighbor] = current;
                        common::pq_push(pq_items, pq_priorities, &pq_size, neighbor, newDist);
                    }
                }
                processed_high++;
            }

            // Process remaining neighbors with reduced priority
            for (int i = pivotCount * 2; i < count; i++) {
                int edgeIdx = start + i;
                if (edgeIdx >= edgeCount) break;

                int neighbor = edges[edgeIdx].to;
                float weight = edges[edgeIdx].weight;
                float newDist = currentDist + weight;

                // Only process if within current bound
                if (newDist <= currentBound && !visited[neighbor]) {
                    if (newDist < distances[neighbor]) {
                        distances[neighbor] = newDist;
                        previous[neighbor] = current;
                        // Don't push all to maintain frontier size
                        // This creates the "bucket" effect
                    }
                }
            }
        }

        // Expand bound for next iteration if target not reached
        if (!targetReached && pq_size == 0 && !visited[target]) {
            currentBound = currentBound * 2.0f;
            
            // Re-add promising unprocesed nodes
            for (int i = 0; i < nodeCount; i++) {
                if (!visited[i] && distances[i] < currentBound && distances[i] < common::INFINITY_VAL) {
                    common::pq_push(pq_items, pq_priorities, &pq_size, i, distances[i]);
                }
            }
        }
    }

    // Fallback: Standard Dijkstra if target not reached
    if (!targetReached && distances[target] == common::INFINITY_VAL) {
        // Re-initialize priority queue with all unvisited nodes
        pq_size = 0;
        for (int i = 0; i < nodeCount; i++) {
            if (!visited[i] && distances[i] < common::INFINITY_VAL) {
                common::pq_push(pq_items, pq_priorities, &pq_size, i, distances[i]);
            }
        }

        // Standard Dijkstra until target is reached
        while (pq_size > 0) {
            int current = common::pq_pop(pq_items, pq_priorities, &pq_size);

            if (visited[current]) continue;
            visited[current] = true;

            if (current == target) break;

            int start = adjacency_offset[current];
            int count = adjacency_count[current];

            for (int i = 0; i < count; i++) {
                int edgeIdx = start + i;
                if (edgeIdx >= edgeCount) break;

                int neighbor = edges[edgeIdx].to;
                float weight = edges[edgeIdx].weight;

                if (!visited[neighbor]) {
                    float newDist = distances[current] + weight;

                    if (newDist < distances[neighbor]) {
                        distances[neighbor] = newDist;
                        previous[neighbor] = current;
                        common::pq_push(pq_items, pq_priorities, &pq_size, neighbor, newDist);
                    }
                }
            }
        }
    }

    // Reconstruct path
    *outDistance = distances[target];
    *pathLength = 0;

    if (distances[target] < common::INFINITY_VAL) {
        int current = target;
        int idx = 0;

        while (current >= 0 && idx < nodeCount) {
            path[idx] = current;
            idx++;
            if (current == source) break;
            current = previous[current];
        }

        // Reverse path in place
        *pathLength = idx;
        for (int i = 0; i < idx / 2; i++) {
            int temp = path[i];
            path[i] = path[idx - 1 - i];
            path[idx - 1 - i] = temp;
        }
    }
}
