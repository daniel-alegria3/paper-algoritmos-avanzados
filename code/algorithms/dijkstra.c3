module dijkstra;

const int MAX_NODES = 100000;
const int MAX_EDGES = 200000;
const float INFINITY_VAL = 1e9f;

struct Edge {
    int from;
    int to;
    float weight;
}

struct Metrics {
    int relaxations;
    int heapOperations;
    int nodesVisited;
    int edgesExamined;
    int memoryEstimate;
}

fn void pq_push(int* items, float* priorities, int* size, int item, float priority) {
    if (*size >= 100000) return;

    int idx = *size;
    items[idx] = item;
    priorities[idx] = priority;
    (*size)++;

    // Bubble up
    while (idx > 0) {
        int parent = (idx - 1) / 2;
        if (priorities[idx] < priorities[parent]) {
            // Swap
            int tmpItem = items[idx];
            float tmpPrio = priorities[idx];
            items[idx] = items[parent];
            priorities[idx] = priorities[parent];
            items[parent] = tmpItem;
            priorities[parent] = tmpPrio;
            idx = parent;
        } else {
            break;
        }
    }
}

fn int pq_pop(int* items, float* priorities, int* size) {
    if (*size == 0) return -1;

    int item = items[0];
    (*size)--;
    
    if (*size > 0) {
        items[0] = items[*size];
        priorities[0] = priorities[*size];

        // Bubble down
        int idx = 0;
        while (idx * 2 + 1 < *size) {
            int left = idx * 2 + 1;
            int right = idx * 2 + 2;
            int smallest = idx;

            if (priorities[left] < priorities[smallest]) {
                smallest = left;
            }
            if (right < *size && priorities[right] < priorities[smallest]) {
                smallest = right;
            }

            if (smallest != idx) {
                int tmpItem = items[idx];
                float tmpPrio = priorities[idx];
                items[idx] = items[smallest];
                priorities[idx] = priorities[smallest];
                items[smallest] = tmpItem;
                priorities[smallest] = tmpPrio;
                idx = smallest;
            } else {
                break;
            }
        }
    }

    return item;
}

fn void dijkstra_execute(
    int nodeCount,
    int edgeCount,
    Edge* edges,
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
    float* outDistance,
    Metrics* outMetrics
) @export {
    Metrics metrics;
    metrics.heapOperations = 0;
    metrics.nodesVisited = 0;
    metrics.edgesExamined = 0;
    metrics.relaxations = 0;

    // Initialize
    for (int i = 0; i < nodeCount; i++) {
        distances[i] = (i == source) ? 0.0f : INFINITY_VAL;
        previous[i] = -1;
        visited[i] = false;
    }

    int pq_size = 0;

    // Push source
    pq_push(pq_items, pq_priorities, &pq_size, source, 0.0f);

    while (pq_size > 0) {
        int current = pq_pop(pq_items, pq_priorities, &pq_size);

        if (visited[current]) continue;
        visited[current] = true;
        metrics.nodesVisited++;

        if (current == target) break;

        // Process neighbors using adjacency list
        int start = adjacency_offset[current];
        int count = adjacency_count[current];
        
        for (int i = 0; i < count; i++) {
            int edgeIdx = start + i;
            if (edgeIdx >= edgeCount) break;
            
            int neighbor = edges[edgeIdx].to;
            float weight = edges[edgeIdx].weight;
            metrics.edgesExamined++;

            if (!visited[neighbor]) {
                float newDist = distances[current] + weight;

                if (newDist < distances[neighbor]) {
                    distances[neighbor] = newDist;
                    previous[neighbor] = current;
                    pq_push(pq_items, pq_priorities, &pq_size, neighbor, newDist);
                    metrics.relaxations++;
                }
            }
        }
    }

    // Reconstruct path
    *outDistance = distances[target];
    *pathLength = 0;

    if (distances[target] < INFINITY_VAL) {
        int current = target;
        int idx = 0;

        while (current >= 0 && idx < 100000) {
            pq_items[idx] = current;
            idx++;
            if (current == source) break;
            current = previous[current];
        }

        // Reverse and copy
        *pathLength = idx;
        for (int i = 0; i < idx; i++) {
            path[i] = pq_items[idx - 1 - i];
        }
    }

    *outMetrics = metrics;
    outMetrics.memoryEstimate = (nodeCount + edgeCount) * 32;
}
