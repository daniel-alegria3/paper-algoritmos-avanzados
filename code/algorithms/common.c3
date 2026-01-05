module common;

const int MAX_NODES = 10000000;
const int MAX_EDGES = 20000000;
const float INFINITY_VAL = 1e9f;

struct Edge {
    int from;
    int to;
    float weight;
}

fn void pq_push(int* items, float* priorities, int* size, int item, float priority) {
    if (*size >= 10000000) return;

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
