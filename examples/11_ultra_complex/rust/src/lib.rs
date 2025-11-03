mod generated;

pub use generated::*;

use std::collections::{HashMap, HashSet, VecDeque, BinaryHeap};
use std::cmp::Ordering;

#[no_mangle]
pub extern "C" fn graph_add_node(graph: *mut Graph, node: *const GraphNode) -> bool {
    unsafe {
        let graph = &mut *graph;
        let node = &*node;
        let mut new_node = *node;
        graph.num_nodes += 1;
        graph.nodes.push(new_node);
        true
    }
}

#[no_mangle]
pub extern "C" fn graph_add_edge(graph: *mut Graph, edge: *const GraphEdge) -> bool {
    unsafe {
        let graph = &mut *graph;
        let edge = &*edge;
        let mut new_edge = *edge;
        graph.num_edges += 1;
        graph.edges.push(new_edge);

        for i in 0..graph.nodes.len() {
            if graph.nodes[i].id == edge.source {
                graph.nodes[i].outgoing_edges.push(edge.id);
            }
            if graph.nodes[i].id == edge.target {
                graph.nodes[i].incoming_edges.push(edge.id);
            }
        }
        true
    }
}

#[no_mangle]
pub extern "C" fn graph_bfs(graph: *mut Graph, start_id: u64, visited: *mut u64, visited_len: *mut usize) {
    unsafe {
        let graph = &mut *graph;
        let visited_slice = std::slice::from_raw_parts_mut(visited, graph.nodes.len());
        let mut count = 0;

        for node in &mut graph.nodes {
            node.visited = false;
            node.distance = -1;
        }

        let mut queue = VecDeque::new();

        if let Some(start_idx) = graph.nodes.iter().position(|n| n.id == start_id) {
            graph.nodes[start_idx].visited = true;
            graph.nodes[start_idx].distance = 0;
            queue.push_back(start_id);
            visited_slice[count] = start_id;
            count += 1;

            while let Some(current_id) = queue.pop_front() {
                let current_idx = graph.nodes.iter().position(|n| n.id == current_id).unwrap();

                for &edge_id in &graph.nodes[current_idx].outgoing_edges.clone() {
                    if let Some(edge) = graph.edges.iter().find(|e| e.id == edge_id) {
                        let neighbor_id = edge.target;
                        if let Some(neighbor_idx) = graph.nodes.iter().position(|n| n.id == neighbor_id) {
                            if !graph.nodes[neighbor_idx].visited {
                                graph.nodes[neighbor_idx].visited = true;
                                graph.nodes[neighbor_idx].distance = graph.nodes[current_idx].distance + 1;
                                graph.nodes[neighbor_idx].parent = current_id;
                                queue.push_back(neighbor_id);
                                visited_slice[count] = neighbor_id;
                                count += 1;
                            }
                        }
                    }
                }
            }
        }

        *visited_len = count;
    }
}

#[no_mangle]
pub extern "C" fn graph_dfs(graph: *mut Graph, start_id: u64, visited: *mut u64, visited_len: *mut usize) {
    unsafe {
        let graph = &mut *graph;
        let visited_slice = std::slice::from_raw_parts_mut(visited, graph.nodes.len());
        let mut count = 0;

        for node in &mut graph.nodes {
            node.visited = false;
        }

        fn dfs_recursive(graph: &mut Graph, node_id: u64, visited_slice: &mut [u64], count: &mut usize) {
            if let Some(idx) = graph.nodes.iter().position(|n| n.id == node_id) {
                graph.nodes[idx].visited = true;
                visited_slice[*count] = node_id;
                *count += 1;

                for &edge_id in &graph.nodes[idx].outgoing_edges.clone() {
                    if let Some(edge) = graph.edges.iter().find(|e| e.id == edge_id) {
                        let neighbor_id = edge.target;
                        if let Some(neighbor_idx) = graph.nodes.iter().position(|n| n.id == neighbor_id) {
                            if !graph.nodes[neighbor_idx].visited {
                                dfs_recursive(graph, neighbor_id, visited_slice, count);
                            }
                        }
                    }
                }
            }
        }

        dfs_recursive(graph, start_id, visited_slice, &mut count);
        *visited_len = count;
    }
}

#[derive(Clone, Copy, PartialEq)]
struct DijkstraNode {
    id: u64,
    distance: f64,
}

impl Eq for DijkstraNode {}

impl PartialOrd for DijkstraNode {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        other.distance.partial_cmp(&self.distance)
    }
}

impl Ord for DijkstraNode {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap_or(Ordering::Equal)
    }
}

#[no_mangle]
pub extern "C" fn graph_dijkstra(graph: *mut Graph, start_id: u64, end_id: u64) -> f64 {
    unsafe {
        let graph = &mut *graph;
        let mut distances: HashMap<u64, f64> = HashMap::new();
        let mut heap = BinaryHeap::new();

        for node in &graph.nodes {
            distances.insert(node.id, f64::INFINITY);
        }

        distances.insert(start_id, 0.0);
        heap.push(DijkstraNode { id: start_id, distance: 0.0 });

        while let Some(DijkstraNode { id, distance }) = heap.pop() {
            if id == end_id {
                return distance;
            }

            if distance > *distances.get(&id).unwrap_or(&f64::INFINITY) {
                continue;
            }

            if let Some(node_idx) = graph.nodes.iter().position(|n| n.id == id) {
                for &edge_id in &graph.nodes[node_idx].outgoing_edges {
                    if let Some(edge) = graph.edges.iter().find(|e| e.id == edge_id) {
                        let next_distance = distance + edge.weight;
                        let neighbor_id = edge.target;

                        if next_distance < *distances.get(&neighbor_id).unwrap_or(&f64::INFINITY) {
                            distances.insert(neighbor_id, next_distance);
                            heap.push(DijkstraNode { id: neighbor_id, distance: next_distance });
                        }
                    }
                }
            }
        }

        f64::INFINITY
    }
}

#[no_mangle]
pub extern "C" fn graph_detect_cycle(graph: *const Graph) -> bool {
    unsafe {
        let graph = &*graph;
        let mut visited = HashSet::new();
        let mut rec_stack = HashSet::new();

        fn dfs_cycle(
            graph: &Graph,
            node_id: u64,
            visited: &mut HashSet<u64>,
            rec_stack: &mut HashSet<u64>,
        ) -> bool {
            visited.insert(node_id);
            rec_stack.insert(node_id);

            if let Some(node_idx) = graph.nodes.iter().position(|n| n.id == node_id) {
                for &edge_id in &graph.nodes[node_idx].outgoing_edges {
                    if let Some(edge) = graph.edges.iter().find(|e| e.id == edge_id) {
                        let neighbor_id = edge.target;

                        if !visited.contains(&neighbor_id) {
                            if dfs_cycle(graph, neighbor_id, visited, rec_stack) {
                                return true;
                            }
                        } else if rec_stack.contains(&neighbor_id) {
                            return true;
                        }
                    }
                }
            }

            rec_stack.remove(&node_id);
            false
        }

        for node in &graph.nodes {
            if !visited.contains(&node.id) {
                if dfs_cycle(graph, node.id, &mut visited, &mut rec_stack) {
                    return true;
                }
            }
        }

        false
    }
}

#[no_mangle]
pub extern "C" fn graph_topological_sort(graph: *const Graph, result: *mut u64, result_len: *mut usize) {
    unsafe {
        let graph = &*graph;
        let result_slice = std::slice::from_raw_parts_mut(result, graph.nodes.len());
        let mut visited = HashSet::new();
        let mut stack = Vec::new();

        fn dfs_topo(graph: &Graph, node_id: u64, visited: &mut HashSet<u64>, stack: &mut Vec<u64>) {
            visited.insert(node_id);

            if let Some(node_idx) = graph.nodes.iter().position(|n| n.id == node_id) {
                for &edge_id in &graph.nodes[node_idx].outgoing_edges {
                    if let Some(edge) = graph.edges.iter().find(|e| e.id == edge_id) {
                        if !visited.contains(&edge.target) {
                            dfs_topo(graph, edge.target, visited, stack);
                        }
                    }
                }
            }

            stack.push(node_id);
        }

        for node in &graph.nodes {
            if !visited.contains(&node.id) {
                dfs_topo(graph, node.id, &mut visited, &mut stack);
            }
        }

        stack.reverse();
        let len = stack.len().min(graph.nodes.len());
        for i in 0..len {
            result_slice[i] = stack[i];
        }
        *result_len = len;
    }
}

#[no_mangle]
pub extern "C" fn sort_i64_array(arr: *mut i64, len: usize) {
    unsafe {
        let slice = std::slice::from_raw_parts_mut(arr, len);
        slice.sort_unstable();
    }
}

#[no_mangle]
pub extern "C" fn sort_f64_array(arr: *mut f64, len: usize) {
    unsafe {
        let slice = std::slice::from_raw_parts_mut(arr, len);
        slice.sort_by(|a, b| a.partial_cmp(b).unwrap_or(Ordering::Equal));
    }
}

#[no_mangle]
pub extern "C" fn quicksort_i64(arr: *mut i64, low: isize, high: isize) {
    unsafe {
        if low < high {
            let pi = partition_i64(arr, low, high);
            quicksort_i64(arr, low, pi - 1);
            quicksort_i64(arr, pi + 1, high);
        }
    }
}

unsafe fn partition_i64(arr: *mut i64, low: isize, high: isize) -> isize {
    let pivot = *arr.offset(high);
    let mut i = low - 1;

    for j in low..high {
        if *arr.offset(j) <= pivot {
            i += 1;
            let temp = *arr.offset(i);
            *arr.offset(i) = *arr.offset(j);
            *arr.offset(j) = temp;
        }
    }

    let temp = *arr.offset(i + 1);
    *arr.offset(i + 1) = *arr.offset(high);
    *arr.offset(high) = temp;

    i + 1
}

#[no_mangle]
pub extern "C" fn merge_sort_i64(arr: *mut i64, len: usize) {
    unsafe {
        let slice = std::slice::from_raw_parts_mut(arr, len);
        let mut temp = vec![0i64; len];
        merge_sort_recursive(slice, &mut temp, 0, len);
    }
}

fn merge_sort_recursive(arr: &mut [i64], temp: &mut [i64], left: usize, right: usize) {
    if right - left <= 1 {
        return;
    }

    let mid = left + (right - left) / 2;
    merge_sort_recursive(arr, temp, left, mid);
    merge_sort_recursive(arr, temp, mid, right);
    merge(arr, temp, left, mid, right);
}

fn merge(arr: &mut [i64], temp: &mut [i64], left: usize, mid: usize, right: usize) {
    let mut i = left;
    let mut j = mid;
    let mut k = left;

    while i < mid && j < right {
        if arr[i] <= arr[j] {
            temp[k] = arr[i];
            i += 1;
        } else {
            temp[k] = arr[j];
            j += 1;
        }
        k += 1;
    }

    while i < mid {
        temp[k] = arr[i];
        i += 1;
        k += 1;
    }

    while j < right {
        temp[k] = arr[j];
        j += 1;
        k += 1;
    }

    for i in left..right {
        arr[i] = temp[i];
    }
}

#[no_mangle]
pub extern "C" fn heap_sort_i64(arr: *mut i64, len: usize) {
    unsafe {
        for i in (0..len / 2).rev() {
            heapify(arr, len, i);
        }

        for i in (1..len).rev() {
            let temp = *arr.offset(0);
            *arr.offset(0) = *arr.offset(i as isize);
            *arr.offset(i as isize) = temp;
            heapify(arr, i, 0);
        }
    }
}

unsafe fn heapify(arr: *mut i64, len: usize, i: usize) {
    let mut largest = i;
    let left = 2 * i + 1;
    let right = 2 * i + 2;

    if left < len && *arr.offset(left as isize) > *arr.offset(largest as isize) {
        largest = left;
    }

    if right < len && *arr.offset(right as isize) > *arr.offset(largest as isize) {
        largest = right;
    }

    if largest != i {
        let temp = *arr.offset(i as isize);
        *arr.offset(i as isize) = *arr.offset(largest as isize);
        *arr.offset(largest as isize) = temp;
        heapify(arr, len, largest);
    }
}

#[no_mangle]
pub extern "C" fn binary_search_i64(arr: *const i64, len: usize, target: i64) -> isize {
    unsafe {
        let slice = std::slice::from_raw_parts(arr, len);
        match slice.binary_search(&target) {
            Ok(idx) => idx as isize,
            Err(_) => -1,
        }
    }
}

#[no_mangle]
pub extern "C" fn linear_search_i64(arr: *const i64, len: usize, target: i64) -> isize {
    unsafe {
        for i in 0..len {
            if *arr.offset(i as isize) == target {
                return i as isize;
            }
        }
        -1
    }
}

#[no_mangle]
pub extern "C" fn statistics_compute(values: *const f64, len: usize, stats: *mut Statistics) {
    unsafe {
        let slice = std::slice::from_raw_parts(values, len);
        let stats = &mut *stats;

        if len == 0 {
            return;
        }

        stats.count = len as u64;
        stats.sum = slice.iter().sum();
        stats.min = slice.iter().cloned().fold(f64::INFINITY, f64::min);
        stats.max = slice.iter().cloned().fold(f64::NEG_INFINITY, f64::max);
        stats.mean = stats.sum / len as f64;

        let variance: f64 = slice.iter()
            .map(|&x| (x - stats.mean).powi(2))
            .sum::<f64>() / len as f64;
        stats.variance = variance;
        stats.std_dev = variance.sqrt();

        let mut sorted = slice.to_vec();
        sorted.sort_by(|a, b| a.partial_cmp(b).unwrap_or(Ordering::Equal));

        stats.median = if len % 2 == 0 {
            (sorted[len / 2 - 1] + sorted[len / 2]) / 2.0
        } else {
            sorted[len / 2]
        };

        let q1_idx = len / 4;
        let q3_idx = 3 * len / 4;
        stats.q1 = sorted[q1_idx];
        stats.q3 = sorted[q3_idx];
        stats.iqr = stats.q3 - stats.q1;

        let m3: f64 = slice.iter()
            .map(|&x| (x - stats.mean).powi(3))
            .sum::<f64>() / len as f64;
        stats.skewness = m3 / stats.std_dev.powi(3);

        let m4: f64 = slice.iter()
            .map(|&x| (x - stats.mean).powi(4))
            .sum::<f64>() / len as f64;
        stats.kurtosis = m4 / stats.variance.powi(2) - 3.0;
    }
}

#[no_mangle]
pub extern "C" fn histogram_compute(values: *const f64, len: usize, num_bins: u32, hist: *mut Histogram) {
    unsafe {
        let slice = std::slice::from_raw_parts(values, len);
        let hist = &mut *hist;

        if len == 0 || num_bins == 0 {
            return;
        }

        hist.min = slice.iter().cloned().fold(f64::INFINITY, f64::min);
        hist.max = slice.iter().cloned().fold(f64::NEG_INFINITY, f64::max);
        hist.num_bins = num_bins;

        let range = hist.max - hist.min;
        let bin_width = range / num_bins as f64;

        hist.bins.clear();
        hist.counts.clear();

        for i in 0..num_bins {
            hist.bins.push(hist.min + i as f64 * bin_width);
            hist.counts.push(0);
        }

        for &value in slice {
            let bin = ((value - hist.min) / bin_width).floor() as usize;
            let bin = bin.min((num_bins - 1) as usize);
            hist.counts[bin] += 1;
        }
    }
}

#[no_mangle]
pub extern "C" fn vector3_add(a: *const Vector3, b: *const Vector3, result: *mut Vector3) {
    unsafe {
        let a = &*a;
        let b = &*b;
        let result = &mut *result;
        result.x = a.x + b.x;
        result.y = a.y + b.y;
        result.z = a.z + b.z;
    }
}

#[no_mangle]
pub extern "C" fn vector3_sub(a: *const Vector3, b: *const Vector3, result: *mut Vector3) {
    unsafe {
        let a = &*a;
        let b = &*b;
        let result = &mut *result;
        result.x = a.x - b.x;
        result.y = a.y - b.y;
        result.z = a.z - b.z;
    }
}

#[no_mangle]
pub extern "C" fn vector3_dot(a: *const Vector3, b: *const Vector3) -> f32 {
    unsafe {
        let a = &*a;
        let b = &*b;
        a.x * b.x + a.y * b.y + a.z * b.z
    }
}

#[no_mangle]
pub extern "C" fn vector3_cross(a: *const Vector3, b: *const Vector3, result: *mut Vector3) {
    unsafe {
        let a = &*a;
        let b = &*b;
        let result = &mut *result;
        result.x = a.y * b.z - a.z * b.y;
        result.y = a.z * b.x - a.x * b.z;
        result.z = a.x * b.y - a.y * b.x;
    }
}

#[no_mangle]
pub extern "C" fn vector3_length(v: *const Vector3) -> f32 {
    unsafe {
        let v = &*v;
        (v.x * v.x + v.y * v.y + v.z * v.z).sqrt()
    }
}

#[no_mangle]
pub extern "C" fn vector3_normalize(v: *const Vector3, result: *mut Vector3) {
    unsafe {
        let v = &*v;
        let result = &mut *result;
        let len = vector3_length(v);
        if len > 0.0 {
            result.x = v.x / len;
            result.y = v.y / len;
            result.z = v.z / len;
        }
    }
}

#[no_mangle]
pub extern "C" fn vector3_scale(v: *const Vector3, scalar: f32, result: *mut Vector3) {
    unsafe {
        let v = &*v;
        let result = &mut *result;
        result.x = v.x * scalar;
        result.y = v.y * scalar;
        result.z = v.z * scalar;
    }
}

#[no_mangle]
pub extern "C" fn matrix4x4_multiply(a: *const Matrix4x4, b: *const Matrix4x4, result: *mut Matrix4x4) {
    unsafe {
        let a = &*a;
        let b = &*b;
        let result = &mut *result;

        result.m00 = a.m00*b.m00 + a.m01*b.m10 + a.m02*b.m20 + a.m03*b.m30;
        result.m01 = a.m00*b.m01 + a.m01*b.m11 + a.m02*b.m21 + a.m03*b.m31;
        result.m02 = a.m00*b.m02 + a.m01*b.m12 + a.m02*b.m22 + a.m03*b.m32;
        result.m03 = a.m00*b.m03 + a.m01*b.m13 + a.m02*b.m23 + a.m03*b.m33;

        result.m10 = a.m10*b.m00 + a.m11*b.m10 + a.m12*b.m20 + a.m13*b.m30;
        result.m11 = a.m10*b.m01 + a.m11*b.m11 + a.m12*b.m21 + a.m13*b.m31;
        result.m12 = a.m10*b.m02 + a.m11*b.m12 + a.m12*b.m22 + a.m13*b.m32;
        result.m13 = a.m10*b.m03 + a.m11*b.m13 + a.m12*b.m23 + a.m13*b.m33;

        result.m20 = a.m20*b.m00 + a.m21*b.m10 + a.m22*b.m20 + a.m23*b.m30;
        result.m21 = a.m20*b.m01 + a.m21*b.m11 + a.m22*b.m21 + a.m23*b.m31;
        result.m22 = a.m20*b.m02 + a.m21*b.m12 + a.m22*b.m22 + a.m23*b.m32;
        result.m23 = a.m20*b.m03 + a.m21*b.m13 + a.m22*b.m23 + a.m23*b.m33;

        result.m30 = a.m30*b.m00 + a.m31*b.m10 + a.m32*b.m20 + a.m33*b.m30;
        result.m31 = a.m30*b.m01 + a.m31*b.m11 + a.m32*b.m21 + a.m33*b.m31;
        result.m32 = a.m30*b.m02 + a.m31*b.m12 + a.m32*b.m22 + a.m33*b.m32;
        result.m33 = a.m30*b.m03 + a.m31*b.m13 + a.m32*b.m23 + a.m33*b.m33;
    }
}

#[no_mangle]
pub extern "C" fn matrix4x4_identity(result: *mut Matrix4x4) {
    unsafe {
        let result = &mut *result;
        *result = Matrix4x4::default();
        result.m00 = 1.0;
        result.m11 = 1.0;
        result.m22 = 1.0;
        result.m33 = 1.0;
    }
}

#[no_mangle]
pub extern "C" fn quaternion_multiply(a: *const Quaternion, b: *const Quaternion, result: *mut Quaternion) {
    unsafe {
        let a = &*a;
        let b = &*b;
        let result = &mut *result;
        result.w = a.w*b.w - a.x*b.x - a.y*b.y - a.z*b.z;
        result.x = a.w*b.x + a.x*b.w + a.y*b.z - a.z*b.y;
        result.y = a.w*b.y - a.x*b.z + a.y*b.w + a.z*b.x;
        result.z = a.w*b.z + a.x*b.y - a.y*b.x + a.z*b.w;
    }
}

#[no_mangle]
pub extern "C" fn quaternion_normalize(q: *const Quaternion, result: *mut Quaternion) {
    unsafe {
        let q = &*q;
        let result = &mut *result;
        let len = (q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w).sqrt();
        if len > 0.0 {
            result.x = q.x / len;
            result.y = q.y / len;
            result.z = q.z / len;
            result.w = q.w / len;
        }
    }
}

#[no_mangle]
pub extern "C" fn hash_table_insert(table: *mut HashTable, key: *const u8, key_len: usize, value: *const u8, value_len: usize) -> bool {
    unsafe {
        let table = &mut *table;
        let key_slice = std::slice::from_raw_parts(key, key_len);
        let value_slice = std::slice::from_raw_parts(value, value_len);

        let key_string = String::from_utf8_lossy(key_slice).to_string();
        let hash = simple_hash(&key_string);
        let index = (hash % table.capacity as u64) as usize;

        if index >= table.buckets.len() {
            return false;
        }

        table.buckets[index].hash = hash;
        table.buckets[index].key = key_string;
        table.buckets[index].value = value_slice.to_vec();
        table.buckets[index].occupied = true;
        table.size += 1;

        true
    }
}

#[no_mangle]
pub extern "C" fn hash_table_get(table: *const HashTable, key: *const u8, key_len: usize, value: *mut u8, value_len: *mut usize) -> bool {
    unsafe {
        let table = &*table;
        let key_slice = std::slice::from_raw_parts(key, key_len);
        let key_string = String::from_utf8_lossy(key_slice).to_string();
        let hash = simple_hash(&key_string);
        let index = (hash % table.capacity as u64) as usize;

        if index >= table.buckets.len() || !table.buckets[index].occupied {
            return false;
        }

        if table.buckets[index].key == key_string {
            let src = &table.buckets[index].value;
            let dst = std::slice::from_raw_parts_mut(value, src.len());
            dst.copy_from_slice(src);
            *value_len = src.len();
            true
        } else {
            false
        }
    }
}

fn simple_hash(s: &str) -> u64 {
    let mut hash: u64 = 5381;
    for byte in s.bytes() {
        hash = ((hash << 5).wrapping_add(hash)).wrapping_add(byte as u64);
    }
    hash
}

#[no_mangle]
pub extern "C" fn memory_intensive_operation(size: usize) -> u64 {
    let mut vec = Vec::with_capacity(size);
    for i in 0..size {
        vec.push(i as u64);
    }

    let sum: u64 = vec.iter().sum();

    for i in 0..vec.len() {
        vec[i] = vec[i].wrapping_mul(2);
    }

    vec.iter().sum::<u64>().wrapping_add(sum)
}

#[no_mangle]
pub extern "C" fn fibonacci(n: u32) -> u64 {
    if n <= 1 {
        return n as u64;
    }

    let mut a = 0u64;
    let mut b = 1u64;

    for _ in 2..=n {
        let temp = a.wrapping_add(b);
        a = b;
        b = temp;
    }

    b
}

#[no_mangle]
pub extern "C" fn factorial(n: u32) -> u64 {
    if n <= 1 {
        return 1;
    }

    let mut result = 1u64;
    for i in 2..=n {
        result = result.wrapping_mul(i as u64);
    }
    result
}

#[no_mangle]
pub extern "C" fn prime_count(n: u64) -> u64 {
    if n < 2 {
        return 0;
    }

    let mut is_prime = vec![true; (n + 1) as usize];
    is_prime[0] = false;
    is_prime[1] = false;

    let mut i = 2;
    while i * i <= n {
        if is_prime[i as usize] {
            let mut j = i * i;
            while j <= n {
                is_prime[j as usize] = false;
                j += i;
            }
        }
        i += 1;
    }

    is_prime.iter().filter(|&&x| x).count() as u64
}

#[no_mangle]
pub extern "C" fn matrix_multiply_f64(
    a: *const f64, a_rows: usize, a_cols: usize,
    b: *const f64, b_rows: usize, b_cols: usize,
    result: *mut f64
) -> bool {
    if a_cols != b_rows {
        return false;
    }

    unsafe {
        let a_slice = std::slice::from_raw_parts(a, a_rows * a_cols);
        let b_slice = std::slice::from_raw_parts(b, b_rows * b_cols);
        let result_slice = std::slice::from_raw_parts_mut(result, a_rows * b_cols);

        for i in 0..a_rows {
            for j in 0..b_cols {
                let mut sum = 0.0;
                for k in 0..a_cols {
                    sum += a_slice[i * a_cols + k] * b_slice[k * b_cols + j];
                }
                result_slice[i * b_cols + j] = sum;
            }
        }

        true
    }
}

#[no_mangle]
pub extern "C" fn convolution_1d(
    signal: *const f64, signal_len: usize,
    kernel: *const f64, kernel_len: usize,
    result: *mut f64
) {
    unsafe {
        let signal_slice = std::slice::from_raw_parts(signal, signal_len);
        let kernel_slice = std::slice::from_raw_parts(kernel, kernel_len);
        let result_len = signal_len + kernel_len - 1;
        let result_slice = std::slice::from_raw_parts_mut(result, result_len);

        for i in 0..result_len {
            result_slice[i] = 0.0;
        }

        for i in 0..signal_len {
            for j in 0..kernel_len {
                result_slice[i + j] += signal_slice[i] * kernel_slice[j];
            }
        }
    }
}

#[no_mangle]
pub extern "C" fn fft_magnitude(real: *const f64, imag: *const f64, len: usize, magnitude: *mut f64) {
    unsafe {
        let real_slice = std::slice::from_raw_parts(real, len);
        let imag_slice = std::slice::from_raw_parts(imag, len);
        let mag_slice = std::slice::from_raw_parts_mut(magnitude, len);

        for i in 0..len {
            mag_slice[i] = (real_slice[i] * real_slice[i] + imag_slice[i] * imag_slice[i]).sqrt();
        }
    }
}

#[no_mangle]
pub extern "C" fn pearson_correlation(x: *const f64, y: *const f64, len: usize) -> f64 {
    unsafe {
        let x_slice = std::slice::from_raw_parts(x, len);
        let y_slice = std::slice::from_raw_parts(y, len);

        let x_mean: f64 = x_slice.iter().sum::<f64>() / len as f64;
        let y_mean: f64 = y_slice.iter().sum::<f64>() / len as f64;

        let mut numerator = 0.0;
        let mut x_sq_sum = 0.0;
        let mut y_sq_sum = 0.0;

        for i in 0..len {
            let x_diff = x_slice[i] - x_mean;
            let y_diff = y_slice[i] - y_mean;
            numerator += x_diff * y_diff;
            x_sq_sum += x_diff * x_diff;
            y_sq_sum += y_diff * y_diff;
        }

        numerator / (x_sq_sum * y_sq_sum).sqrt()
    }
}

#[no_mangle]
pub extern "C" fn linear_regression(x: *const f64, y: *const f64, len: usize, slope: *mut f64, intercept: *mut f64) {
    unsafe {
        let x_slice = std::slice::from_raw_parts(x, len);
        let y_slice = std::slice::from_raw_parts(y, len);

        let x_mean: f64 = x_slice.iter().sum::<f64>() / len as f64;
        let y_mean: f64 = y_slice.iter().sum::<f64>() / len as f64;

        let mut numerator = 0.0;
        let mut denominator = 0.0;

        for i in 0..len {
            let x_diff = x_slice[i] - x_mean;
            numerator += x_diff * (y_slice[i] - y_mean);
            denominator += x_diff * x_diff;
        }

        *slope = numerator / denominator;
        *intercept = y_mean - (*slope * x_mean);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_sort() {
        let mut arr = vec![5, 2, 8, 1, 9];
        sort_i64_array(arr.as_mut_ptr(), arr.len());
        assert_eq!(arr, vec![1, 2, 5, 8, 9]);
    }

    #[test]
    fn test_binary_search() {
        let arr = vec![1, 2, 5, 8, 9];
        let idx = binary_search_i64(arr.as_ptr(), arr.len(), 5);
        assert_eq!(idx, 2);
    }

    #[test]
    fn test_binary_search_not_found() {
        let arr = vec![1, 2, 5, 8, 9];
        let idx = binary_search_i64(arr.as_ptr(), arr.len(), 100);
        assert_eq!(idx, -1);
    }

    #[test]
    fn test_linear_search() {
        let arr = vec![5, 2, 8, 1, 9];
        let idx = linear_search_i64(arr.as_ptr(), arr.len(), 8);
        assert_eq!(idx, 2);
    }

    #[test]
    fn test_quicksort() {
        let mut arr = vec![5, 2, 8, 1, 9];
        quicksort_i64(arr.as_mut_ptr(), 0, 4);
        assert_eq!(arr, vec![1, 2, 5, 8, 9]);
    }

    #[test]
    fn test_merge_sort() {
        let mut arr = vec![5, 2, 8, 1, 9];
        merge_sort_i64(arr.as_mut_ptr(), arr.len());
        assert_eq!(arr, vec![1, 2, 5, 8, 9]);
    }

    #[test]
    fn test_heap_sort() {
        let mut arr = vec![5, 2, 8, 1, 9];
        heap_sort_i64(arr.as_mut_ptr(), arr.len());
        assert_eq!(arr, vec![1, 2, 5, 8, 9]);
    }

    #[test]
    fn test_sort_f64() {
        let mut arr = vec![5.5, 2.2, 8.8, 1.1, 9.9];
        sort_f64_array(arr.as_mut_ptr(), arr.len());
        assert_eq!(arr, vec![1.1, 2.2, 5.5, 8.8, 9.9]);
    }

    #[test]
    fn test_vector3_add() {
        let a = Vector3 { x: 1.0, y: 2.0, z: 3.0 };
        let b = Vector3 { x: 4.0, y: 5.0, z: 6.0 };
        let mut result = Vector3 { x: 0.0, y: 0.0, z: 0.0 };
        vector3_add(&a, &b, &mut result);
        assert_eq!(result.x, 5.0);
        assert_eq!(result.y, 7.0);
        assert_eq!(result.z, 9.0);
    }

    #[test]
    fn test_vector3_sub() {
        let a = Vector3 { x: 4.0, y: 5.0, z: 6.0 };
        let b = Vector3 { x: 1.0, y: 2.0, z: 3.0 };
        let mut result = Vector3 { x: 0.0, y: 0.0, z: 0.0 };
        vector3_sub(&a, &b, &mut result);
        assert_eq!(result.x, 3.0);
        assert_eq!(result.y, 3.0);
        assert_eq!(result.z, 3.0);
    }

    #[test]
    fn test_vector3_dot() {
        let a = Vector3 { x: 1.0, y: 2.0, z: 3.0 };
        let b = Vector3 { x: 4.0, y: 5.0, z: 6.0 };
        let dot = vector3_dot(&a, &b);
        assert_eq!(dot, 32.0);
    }

    #[test]
    fn test_vector3_cross() {
        let a = Vector3 { x: 1.0, y: 0.0, z: 0.0 };
        let b = Vector3 { x: 0.0, y: 1.0, z: 0.0 };
        let mut result = Vector3 { x: 0.0, y: 0.0, z: 0.0 };
        vector3_cross(&a, &b, &mut result);
        assert_eq!(result.z, 1.0);
    }

    #[test]
    fn test_vector3_length() {
        let v = Vector3 { x: 3.0, y: 4.0, z: 0.0 };
        let len = vector3_length(&v);
        assert_eq!(len, 5.0);
    }

    #[test]
    fn test_vector3_normalize() {
        let v = Vector3 { x: 3.0, y: 4.0, z: 0.0 };
        let mut result = Vector3 { x: 0.0, y: 0.0, z: 0.0 };
        vector3_normalize(&v, &mut result);
        let len = vector3_length(&result);
        assert!((len - 1.0).abs() < 0.001);
    }

    #[test]
    fn test_vector3_scale() {
        let v = Vector3 { x: 1.0, y: 2.0, z: 3.0 };
        let mut result = Vector3 { x: 0.0, y: 0.0, z: 0.0 };
        vector3_scale(&v, 2.0, &mut result);
        assert_eq!(result.x, 2.0);
        assert_eq!(result.y, 4.0);
        assert_eq!(result.z, 6.0);
    }

    #[test]
    fn test_matrix4x4_identity() {
        let mut m = Matrix4x4::default();
        matrix4x4_identity(&mut m);
        assert_eq!(m.m00, 1.0);
        assert_eq!(m.m11, 1.0);
        assert_eq!(m.m22, 1.0);
        assert_eq!(m.m33, 1.0);
    }

    #[test]
    fn test_fibonacci() {
        assert_eq!(fibonacci(0), 0);
        assert_eq!(fibonacci(1), 1);
        assert_eq!(fibonacci(10), 55);
    }

    #[test]
    fn test_factorial() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(5), 120);
    }

    #[test]
    fn test_prime_count() {
        assert_eq!(prime_count(10), 4);
        assert_eq!(prime_count(0), 0);
    }

    #[test]
    fn test_memory_intensive() {
        let result = memory_intensive_operation(100);
        assert!(result > 0);
    }

    #[test]
    fn test_matrix_multiply() {
        let a = vec![1.0, 2.0, 3.0, 4.0];
        let b = vec![5.0, 6.0, 7.0, 8.0];
        let mut result = vec![0.0; 4];
        assert!(matrix_multiply_f64(a.as_ptr(), 2, 2, b.as_ptr(), 2, 2, result.as_mut_ptr()));
    }

    #[test]
    fn test_pearson_correlation() {
        let x = vec![1.0, 2.0, 3.0, 4.0, 5.0];
        let y = vec![2.0, 4.0, 6.0, 8.0, 10.0];
        let corr = pearson_correlation(x.as_ptr(), y.as_ptr(), 5);
        assert!((corr - 1.0).abs() < 0.001);
    }

    #[test]
    fn test_linear_regression() {
        let x = vec![1.0, 2.0, 3.0];
        let y = vec![2.0, 4.0, 6.0];
        let mut slope = 0.0;
        let mut intercept = 0.0;
        linear_regression(x.as_ptr(), y.as_ptr(), 3, &mut slope, &mut intercept);
        assert!((slope - 2.0).abs() < 0.001);
    }

    #[test]
    fn test_fft_magnitude() {
        let real = vec![1.0, 2.0, 3.0];
        let imag = vec![0.0, 0.0, 0.0];
        let mut mag = vec![0.0; 3];
        fft_magnitude(real.as_ptr(), imag.as_ptr(), 3, mag.as_mut_ptr());
        assert_eq!(mag[0], 1.0);
        assert_eq!(mag[1], 2.0);
        assert_eq!(mag[2], 3.0);
    }

    #[test]
    fn test_convolution() {
        let signal = vec![1.0, 2.0, 3.0];
        let kernel = vec![1.0, 1.0];
        let mut result = vec![0.0; 4];
        convolution_1d(signal.as_ptr(), 3, kernel.as_ptr(), 2, result.as_mut_ptr());
        assert_eq!(result[0], 1.0);
        assert_eq!(result[1], 3.0);
        assert_eq!(result[2], 5.0);
        assert_eq!(result[3], 3.0);
    }

    #[test]
    fn test_quaternion_normalize() {
        let q = Quaternion { x: 1.0, y: 1.0, z: 1.0, w: 1.0 };
        let mut result = Quaternion { x: 0.0, y: 0.0, z: 0.0, w: 0.0 };
        quaternion_normalize(&q, &mut result);
        let len = (result.x*result.x + result.y*result.y + result.z*result.z + result.w*result.w).sqrt();
        assert!((len - 1.0).abs() < 0.001);
    }
}
