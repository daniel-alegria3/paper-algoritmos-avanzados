module dijkstra;

import common;

fn void dijkstra_execute(
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

    int pq_size = 0;

    // Push source
    common::pq_push(pq_items, pq_priorities, &pq_size, source, 0.0f);

    while (pq_size > 0) {
        int current = common::pq_pop(pq_items, pq_priorities, &pq_size);

        if (visited[current]) continue;
        visited[current] = true;

        if (current == target) break;

        // Process neighbors using adjacency list
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

    // Reconstruct path
    *outDistance = distances[target];
    *pathLength = 0;

    if (distances[target] < common::INFINITY_VAL) {
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
}
