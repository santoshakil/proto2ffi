mod memory_pool;
mod task_store;
mod generated;

use generated::*;
use memory_pool::MemoryPool;
use parking_lot::RwLock;
use std::sync::Arc;
use std::time::{Instant, SystemTime, UNIX_EPOCH};

static STORE: once_cell::sync::Lazy<Arc<RwLock<TaskStore>>> =
    once_cell::sync::Lazy::new(|| Arc::new(RwLock::new(TaskStore::new())));

struct TaskStore {
    tasks: Vec<TaskData>,
    next_id: u64,
    memory_pool: MemoryPool,
    total_ops: u64,
    pool_hits: u64,
    pool_misses: u64,
}

struct TaskData {
    id: u64,
    title: String,
    description: String,
    priority: u32,
    completed: bool,
    created_at: u64,
    updated_at: u64,
    tags: Vec<String>,
}

fn str_from_fixed(buf: &[u8; 256]) -> String {
    buf.iter()
        .take_while(|&&c| c != 0)
        .map(|&c| c as char)
        .collect()
}

fn str_to_fixed(s: &str, buf: &mut [u8; 256]) {
    let bytes = s.as_bytes();
    let len = bytes.len().min(255);
    buf[..len].copy_from_slice(&bytes[..len]);
    buf[len] = 0;
}

impl TaskStore {
    fn new() -> Self {
        Self {
            tasks: Vec::with_capacity(1000),
            next_id: 1,
            memory_pool: MemoryPool::new(4096, 1000),
            total_ops: 0,
            pool_hits: 0,
            pool_misses: 0,
        }
    }

    fn alloc_task(&mut self, task: &TaskData) -> u64 {
        self.total_ops += 1;

        let size = std::mem::size_of::<TaskData>()
            + task.title.len()
            + task.description.len()
            + task.tags.iter().map(|t| t.len()).sum::<usize>();

        match self.memory_pool.allocate(size) {
            Some(_) => {
                self.pool_hits += 1;
            }
            None => {
                self.pool_misses += 1;
            }
        }

        size as u64
    }

    fn dealloc_task(&mut self, size: usize) {
        self.memory_pool.deallocate(size);
    }

    fn create(&mut self, task: &Task) -> u64 {
        let id = self.next_id;
        self.next_id += 1;

        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_millis() as u64;

        let task_data = TaskData {
            id,
            title: str_from_fixed(&task.title),
            description: str_from_fixed(&task.description),
            priority: task.priority,
            completed: task.completed != 0,
            created_at: now,
            updated_at: now,
            tags: Vec::new(),
        };

        self.alloc_task(&task_data);
        self.tasks.push(task_data);
        id
    }

    fn get(&self, id: u64) -> Option<Task> {
        self.tasks.iter().find(|t| t.id == id).map(|t| {
            let mut task = Task::default();
            task.id = t.id;
            str_to_fixed(&t.title, &mut task.title);
            str_to_fixed(&t.description, &mut task.description);
            task.priority = t.priority;
            task.completed = if t.completed { 1 } else { 0 };
            task.created_at = t.created_at;
            task.updated_at = t.updated_at;
            task.tags = std::ptr::null();
            task
        })
    }

    fn update(&mut self, task: &Task) -> bool {
        if let Some(idx) = self.tasks.iter().position(|t| t.id == task.id) {
            let old_size = std::mem::size_of::<TaskData>()
                + self.tasks[idx].title.len()
                + self.tasks[idx].description.len()
                + self.tasks[idx].tags.iter().map(|t| t.len()).sum::<usize>();

            self.dealloc_task(old_size);

            let now = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap()
                .as_millis() as u64;

            let task_data = TaskData {
                id: task.id,
                title: str_from_fixed(&task.title),
                description: str_from_fixed(&task.description),
                priority: task.priority,
                completed: task.completed != 0,
                created_at: self.tasks[idx].created_at,
                updated_at: now,
                tags: Vec::new(),
            };

            self.alloc_task(&task_data);
            self.tasks[idx] = task_data;
            true
        } else {
            false
        }
    }

    fn delete(&mut self, id: u64) -> bool {
        if let Some(idx) = self.tasks.iter().position(|t| t.id == id) {
            let task = &self.tasks[idx];
            let size = std::mem::size_of::<TaskData>()
                + task.title.len()
                + task.description.len()
                + task.tags.iter().map(|t| t.len()).sum::<usize>();

            self.dealloc_task(size);
            self.tasks.remove(idx);
            true
        } else {
            false
        }
    }

    fn list(&self, filter: &TaskFilter) -> Vec<Task> {
        self.tasks
            .iter()
            .filter(|t| {
                if filter.filter_by_completed != 0 {
                    let completed_val = filter.completed_value != 0;
                    if t.completed != completed_val {
                        return false;
                    }
                }
                if filter.filter_by_priority != 0 {
                    if t.priority < filter.min_priority || t.priority > filter.max_priority {
                        return false;
                    }
                }
                true
            })
            .map(|t| {
                let mut task = Task::default();
                task.id = t.id;
                str_to_fixed(&t.title, &mut task.title);
                str_to_fixed(&t.description, &mut task.description);
                task.priority = t.priority;
                task.completed = if t.completed { 1 } else { 0 };
                task.created_at = t.created_at;
                task.updated_at = t.updated_at;
                task.tags = std::ptr::null();
                task
            })
            .collect()
    }

    fn search(&self, query: &str, limit: u32, offset: u32) -> (Vec<Task>, u64) {
        let query_lower = query.to_lowercase();
        let start = Instant::now();

        let matches: Vec<Task> = self.tasks
            .iter()
            .filter(|t| {
                t.title.to_lowercase().contains(&query_lower)
                    || t.description.to_lowercase().contains(&query_lower)
            })
            .skip(offset as usize)
            .take(limit as usize)
            .map(|t| {
                let mut task = Task::default();
                task.id = t.id;
                str_to_fixed(&t.title, &mut task.title);
                str_to_fixed(&t.description, &mut task.description);
                task.priority = t.priority;
                task.completed = if t.completed { 1 } else { 0 };
                task.created_at = t.created_at;
                task.updated_at = t.updated_at;
                task.tags = std::ptr::null();
                task
            })
            .collect();

        let search_time = start.elapsed().as_micros() as u64;
        (matches, search_time)
    }

    fn stats(&self) -> TaskStats {
        let total = self.tasks.len() as u64;
        let completed = self.tasks.iter().filter(|t| t.completed).count() as u64;
        let pending = total - completed;
        let high_priority = self.tasks.iter().filter(|t| t.priority >= 7).count() as u64;

        let completion_rate = if total > 0 {
            (completed as f64 / total as f64) * 100.0
        } else {
            0.0
        };

        let completed_tasks_with_time: Vec<u64> = self.tasks
            .iter()
            .filter(|t| t.completed && t.updated_at > t.created_at)
            .map(|t| t.updated_at - t.created_at)
            .collect();

        let avg_completion_time = if !completed_tasks_with_time.is_empty() {
            completed_tasks_with_time.iter().sum::<u64>() / completed_tasks_with_time.len() as u64
        } else {
            0
        };

        TaskStats {
            total_tasks: total,
            completed_tasks: completed,
            pending_tasks: pending,
            high_priority_tasks: high_priority,
            completion_rate,
            avg_completion_time_ms: avg_completion_time,
            total_memory_used: self.memory_pool.allocated(),
            pool_allocations: self.pool_hits + self.pool_misses,
        }
    }

    fn clear(&mut self) -> u64 {
        let count = self.tasks.len() as u64;
        self.tasks.clear();
        self.memory_pool = MemoryPool::new(4096, 1000);
        self.total_ops = 0;
        self.pool_hits = 0;
        self.pool_misses = 0;
        count
    }

    fn compact(&mut self) -> u64 {
        let before = self.memory_pool.allocated();
        self.memory_pool.compact();
        let after = self.memory_pool.allocated();
        before.saturating_sub(after)
    }
}

#[no_mangle]
pub extern "C" fn create_task(task: *const Task) -> u64 {
    let task = unsafe { &*task };
    let mut store = STORE.write();
    store.create(task)
}

#[no_mangle]
pub extern "C" fn get_task(id: u64, out: *mut Task) -> bool {
    let store = STORE.read();
    if let Some(task) = store.get(id) {
        unsafe { *out = task };
        true
    } else {
        false
    }
}

#[no_mangle]
pub extern "C" fn update_task(task: *const Task) -> bool {
    let task = unsafe { &*task };
    let mut store = STORE.write();
    store.update(task)
}

#[no_mangle]
pub extern "C" fn delete_task(id: u64) -> bool {
    let mut store = STORE.write();
    store.delete(id)
}

#[no_mangle]
pub extern "C" fn list_tasks(filter: *const TaskFilter, out: *mut *mut Task, out_len: *mut usize) {
    let filter = unsafe { &*filter };
    let store = STORE.read();
    let tasks = store.list(filter);

    let len = tasks.len();
    if len == 0 {
        unsafe {
            *out = std::ptr::null_mut();
            *out_len = 0;
        }
        return;
    }

    let boxed = tasks.into_boxed_slice();
    let ptr = Box::into_raw(boxed);
    unsafe {
        *out = ptr as *mut Task;
        *out_len = len;
    }
}

#[no_mangle]
pub extern "C" fn search_tasks(request: *const TaskSearchRequest, out: *mut TaskSearchResponse) {
    let request = unsafe { &*request };
    let query = str_from_fixed(&request.query);
    let store = STORE.read();

    let (tasks, search_time) = store.search(&query, request.limit, request.offset);
    let total_matches = tasks.len() as u64;

    let boxed = tasks.into_boxed_slice();
    let ptr = Box::into_raw(boxed) as *mut Task;

    let response = TaskSearchResponse {
        tasks: ptr,
        total_matches,
        search_time_us: search_time,
    };

    unsafe { *out = response };
}

#[no_mangle]
pub extern "C" fn batch_create(request: *const BatchTaskRequest, out: *mut BatchTaskResponse) {
    let request = unsafe { &*request };
    let mut store = STORE.write();

    let mut task_ids = Vec::new();
    let mut success_count = 0u64;

    if !request.tasks.is_null() {
        let tasks_slice = unsafe { std::slice::from_raw_parts(request.tasks, 100) };
        for task in tasks_slice {
            if task.id == 0 && task.title[0] == 0 {
                break;
            }
            let id = store.create(task);
            task_ids.push(id);
            success_count += 1;
        }
    }

    let boxed = task_ids.into_boxed_slice();
    let ptr = Box::into_raw(boxed) as *mut u64;

    let response = BatchTaskResponse {
        task_ids: ptr,
        success_count,
        error_count: 0,
    };

    unsafe { *out = response };
}

#[no_mangle]
pub extern "C" fn batch_update(request: *const BatchTaskRequest, out: *mut BatchTaskResponse) {
    let request = unsafe { &*request };
    let mut store = STORE.write();

    let mut task_ids = Vec::new();
    let mut success_count = 0u64;
    let mut error_count = 0u64;

    if !request.tasks.is_null() {
        let tasks_slice = unsafe { std::slice::from_raw_parts(request.tasks, 100) };
        for task in tasks_slice {
            if task.id == 0 && task.title[0] == 0 {
                break;
            }
            if store.update(task) {
                task_ids.push(task.id);
                success_count += 1;
            } else {
                error_count += 1;
            }
        }
    }

    let boxed = task_ids.into_boxed_slice();
    let ptr = Box::into_raw(boxed) as *mut u64;

    let response = BatchTaskResponse {
        task_ids: ptr,
        success_count,
        error_count,
    };

    unsafe { *out = response };
}

#[no_mangle]
pub extern "C" fn batch_delete(ids: *const u64, len: usize) -> u64 {
    let ids = unsafe { std::slice::from_raw_parts(ids, len) };
    let mut store = STORE.write();

    let mut deleted = 0u64;
    for &id in ids {
        if store.delete(id) {
            deleted += 1;
        }
    }
    deleted
}

#[no_mangle]
pub extern "C" fn get_statistics(out: *mut TaskStats) {
    let store = STORE.read();
    let stats = store.stats();
    unsafe { *out = stats };
}

#[no_mangle]
pub extern "C" fn get_performance_metrics(out: *mut PerformanceMetrics) {
    let store = STORE.read();

    let metrics = PerformanceMetrics {
        operation_duration_ns: 0,
        memory_allocated_bytes: store.memory_pool.allocated(),
        pool_hits: store.pool_hits,
        pool_misses: store.pool_misses,
        cpu_usage_percent: 0.0,
    };

    unsafe { *out = metrics };
}

#[no_mangle]
pub extern "C" fn clear_all_tasks() -> u64 {
    let mut store = STORE.write();
    store.clear()
}

#[no_mangle]
pub extern "C" fn compact_memory() -> u64 {
    let mut store = STORE.write();
    store.compact()
}

#[no_mangle]
pub extern "C" fn free_task_list(ptr: *mut Task, len: usize) {
    if !ptr.is_null() && len > 0 {
        unsafe {
            let _ = Box::from_raw(std::slice::from_raw_parts_mut(ptr, len));
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn create_test_task(title: &str, priority: u32) -> Task {
        let mut task = Task::default();
        str_to_fixed(title, &mut task.title);
        str_to_fixed("Test description", &mut task.description);
        task.priority = priority;
        task.completed = 0;
        task
    }

    #[test]
    fn test_create_task() {
        clear_all_tasks();
        let task = create_test_task("Test Task", 1);
        let id = create_task(&task as *const Task);
        assert!(id > 0);
    }

    #[test]
    fn test_get_task() {
        clear_all_tasks();
        let task = create_test_task("Get Test", 2);
        let id = create_task(&task as *const Task);

        let mut retrieved = Task::default();
        assert!(get_task(id, &mut retrieved as *mut Task));
        assert_eq!(retrieved.id, id);
        assert_eq!(retrieved.priority, 2);
    }

    #[test]
    fn test_get_nonexistent_task() {
        clear_all_tasks();
        let mut task = Task::default();
        assert!(!get_task(99999, &mut task as *mut Task));
    }

    #[test]
    fn test_update_nonexistent_task() {
        clear_all_tasks();
        let mut task = create_test_task("Nonexistent", 1);
        task.id = 99999;
        assert!(!update_task(&task as *const Task));
    }

    #[test]
    fn test_delete_task() {
        clear_all_tasks();
        let task = create_test_task("To Delete", 1);
        let id = create_task(&task as *const Task);
        assert!(delete_task(id));

        let mut retrieved = Task::default();
        assert!(!get_task(id, &mut retrieved as *mut Task));
    }

    #[test]
    fn test_delete_nonexistent_task() {
        clear_all_tasks();
        assert!(!delete_task(99999));
    }


    #[test]
    fn test_get_statistics() {
        let mut stats = TaskStats::default();
        get_statistics(&mut stats as *mut TaskStats);
        assert!(stats.total_tasks >= 0);
    }

    #[test]
    fn test_get_performance_metrics() {
        clear_all_tasks();
        create_task(&create_test_task("Task", 1) as *const Task);

        let mut metrics = PerformanceMetrics::default();
        get_performance_metrics(&mut metrics as *mut PerformanceMetrics);
        assert!(metrics.pool_hits > 0 || metrics.pool_misses > 0);
    }

    #[test]
    fn test_clear_all_tasks() {
        clear_all_tasks();
        let id = create_task(&create_test_task("Task 1", 1) as *const Task);
        create_task(&create_test_task("Task 2", 2) as *const Task);

        let cleared = clear_all_tasks();
        assert!(cleared >= 1);

        let mut task = Task::default();
        assert!(!get_task(id, &mut task as *mut Task));
    }


    #[test]
    fn test_compact_memory() {
        clear_all_tasks();
        create_task(&create_test_task("Task", 1) as *const Task);
        let freed = compact_memory();
        assert!(freed >= 0);
    }

    #[test]
    fn test_str_from_fixed() {
        let mut buf = [0u8; 256];
        str_to_fixed("Hello", &mut buf);
        let result = str_from_fixed(&buf);
        assert_eq!(result, "Hello");
    }

    #[test]
    fn test_str_to_fixed_truncation() {
        let mut buf = [0u8; 256];
        let long_str = "a".repeat(300);
        str_to_fixed(&long_str, &mut buf);
        let result = str_from_fixed(&buf);
        assert_eq!(result.len(), 255);
    }

    #[test]
    fn test_multiple_updates() {
        clear_all_tasks();
        let task = create_test_task("Task", 1);
        let id = create_task(&task as *const Task);

        for priority in 1..5 {
            let mut updated = create_test_task("Updated", priority);
            updated.id = id;
            update_task(&updated as *const Task);
        }

        let mut retrieved = Task::default();
        get_task(id, &mut retrieved as *mut Task);
        assert_eq!(retrieved.priority, 4);
    }
}
