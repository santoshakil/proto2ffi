use std::sync::{Arc, Mutex};
use std::sync::atomic::{AtomicU64, AtomicUsize, Ordering};
use std::thread;
use std::time::{Duration, Instant};

mod generated;
use generated::*;

pub struct ConcurrentStats {
    pub allocations: AtomicU64,
    pub frees: AtomicU64,
    pub errors: AtomicU64,
}

impl ConcurrentStats {
    pub fn new() -> Self {
        Self {
            allocations: AtomicU64::new(0),
            frees: AtomicU64::new(0),
            errors: AtomicU64::new(0),
        }
    }
}

struct PoolAllocator<T> {
    inner: Mutex<PoolAllocatorInner<T>>,
    allocated: AtomicUsize,
}

struct PoolAllocatorInner<T> {
    chunks: Vec<Box<[T; 100]>>,
    free_list: Vec<*mut T>,
}

impl<T: Copy + Default> PoolAllocator<T> {
    fn new(initial_capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (initial_capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut chunks = Vec::with_capacity(chunk_count);
        let mut free_list = Vec::with_capacity(initial_capacity);

        for _ in 0..chunk_count {
            let mut chunk: Box<[T; 100]> = Box::new([Default::default(); 100]);
            let ptr = chunk.as_mut_ptr();

            for i in 0..CHUNK_SIZE {
                unsafe {
                    free_list.push(ptr.add(i));
                }
            }

            chunks.push(chunk);
        }

        Self {
            inner: Mutex::new(PoolAllocatorInner { chunks, free_list }),
            allocated: AtomicUsize::new(0),
        }
    }

    fn allocate(&self) -> *mut T {
        let mut inner = self.inner.lock().unwrap();

        if inner.free_list.is_empty() {
            const CHUNK_SIZE: usize = 100;
            let mut chunk: Box<[T; 100]> = Box::new([Default::default(); 100]);
            let ptr = chunk.as_mut_ptr();

            for i in 0..CHUNK_SIZE {
                unsafe {
                    inner.free_list.push(ptr.add(i));
                }
            }

            inner.chunks.push(chunk);
        }

        let ptr = inner.free_list.pop().unwrap();
        self.allocated.fetch_add(1, Ordering::Relaxed);
        ptr
    }

    fn free(&self, ptr: *mut T) {
        let mut inner = self.inner.lock().unwrap();
        inner.free_list.push(ptr);
        self.allocated.fetch_sub(1, Ordering::Relaxed);
    }
}

unsafe impl<T> Send for PoolAllocator<T> {}
unsafe impl<T> Sync for PoolAllocator<T> {}

static SMALL_POOL: once_cell::sync::Lazy<PoolAllocator<SmallMessage>> =
    once_cell::sync::Lazy::new(|| PoolAllocator::new(100));
static MEDIUM_POOL: once_cell::sync::Lazy<PoolAllocator<MediumMessage>> =
    once_cell::sync::Lazy::new(|| PoolAllocator::new(1000));
static LARGE_POOL: once_cell::sync::Lazy<PoolAllocator<LargeMessage>> =
    once_cell::sync::Lazy::new(|| PoolAllocator::new(10000));
static STRESS_POOL: once_cell::sync::Lazy<PoolAllocator<StressTestMessage>> =
    once_cell::sync::Lazy::new(|| PoolAllocator::new(5000));

fn small_message_to_ffi_impl(msg: &SmallMessage) -> *const SmallMessage {
    let ptr = SMALL_POOL.allocate();
    unsafe {
        std::ptr::write(ptr, *msg);
    }
    ptr
}

fn small_message_free_ffi_impl(ptr: *const SmallMessage) {
    if !ptr.is_null() {
        SMALL_POOL.free(ptr as *mut SmallMessage);
    }
}

fn medium_message_to_ffi_impl(msg: &MediumMessage) -> *const MediumMessage {
    let ptr = MEDIUM_POOL.allocate();
    unsafe {
        std::ptr::write(ptr, *msg);
    }
    ptr
}

fn medium_message_free_ffi_impl(ptr: *const MediumMessage) {
    if !ptr.is_null() {
        MEDIUM_POOL.free(ptr as *mut MediumMessage);
    }
}

fn large_message_to_ffi_impl(msg: &LargeMessage) -> *const LargeMessage {
    let ptr = LARGE_POOL.allocate();
    unsafe {
        std::ptr::write(ptr, *msg);
    }
    ptr
}

fn large_message_free_ffi_impl(ptr: *const LargeMessage) {
    if !ptr.is_null() {
        LARGE_POOL.free(ptr as *mut LargeMessage);
    }
}

fn stress_test_message_to_ffi_impl(msg: &StressTestMessage) -> *const StressTestMessage {
    let ptr = STRESS_POOL.allocate();
    unsafe {
        std::ptr::write(ptr, *msg);
    }
    ptr
}

fn stress_test_message_free_ffi_impl(ptr: *const StressTestMessage) {
    if !ptr.is_null() {
        STRESS_POOL.free(ptr as *mut StressTestMessage);
    }
}

#[no_mangle]
pub extern "C" fn concurrent_test_small_pool(thread_count: u32, ops_per_thread: u32) -> u64 {
    let stats = Arc::new(ConcurrentStats::new());
    let mut handles = vec![];

    let start = Instant::now();

    for tid in 0..thread_count {
        let stats = Arc::clone(&stats);
        let handle = thread::spawn(move || {
            for i in 0..ops_per_thread {
                let mut msg = SmallMessage::default();
                msg.id = (tid * ops_per_thread + i) as i32;

                let ptr = small_message_to_ffi_impl(&msg);
                if ptr.is_null() {
                    stats.errors.fetch_add(1, Ordering::Relaxed);
                } else {
                    stats.allocations.fetch_add(1, Ordering::Relaxed);
                    small_message_free_ffi_impl(ptr);
                    stats.frees.fetch_add(1, Ordering::Relaxed);
                }
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    start.elapsed().as_millis() as u64
}

#[no_mangle]
pub extern "C" fn concurrent_test_medium_pool(thread_count: u32, ops_per_thread: u32) -> u64 {
    let stats = Arc::new(ConcurrentStats::new());
    let mut handles = vec![];

    let start = Instant::now();

    for tid in 0..thread_count {
        let stats = Arc::clone(&stats);
        let handle = thread::spawn(move || {
            for i in 0..ops_per_thread {
                let mut msg = MediumMessage::default();
                msg.id = (tid * ops_per_thread + i) as i32;

                let ptr = medium_message_to_ffi_impl(&msg);
                if ptr.is_null() {
                    stats.errors.fetch_add(1, Ordering::Relaxed);
                } else {
                    stats.allocations.fetch_add(1, Ordering::Relaxed);
                    medium_message_free_ffi_impl(ptr);
                    stats.frees.fetch_add(1, Ordering::Relaxed);
                }
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    start.elapsed().as_millis() as u64
}

#[no_mangle]
pub extern "C" fn concurrent_test_large_pool(thread_count: u32, ops_per_thread: u32) -> u64 {
    let stats = Arc::new(ConcurrentStats::new());
    let mut handles = vec![];

    let start = Instant::now();

    for tid in 0..thread_count {
        let stats = Arc::clone(&stats);
        let handle = thread::spawn(move || {
            for i in 0..ops_per_thread {
                let mut msg = LargeMessage::default();
                msg.id = (tid * ops_per_thread + i) as i32;

                let ptr = large_message_to_ffi_impl(&msg);
                if ptr.is_null() {
                    stats.errors.fetch_add(1, Ordering::Relaxed);
                } else {
                    stats.allocations.fetch_add(1, Ordering::Relaxed);
                    large_message_free_ffi_impl(ptr);
                    stats.frees.fetch_add(1, Ordering::Relaxed);
                }
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    start.elapsed().as_millis() as u64
}

#[no_mangle]
pub extern "C" fn stress_test_rapid_alloc_free(thread_count: u32, duration_ms: u32) -> u64 {
    let stats = Arc::new(ConcurrentStats::new());
    let mut handles = vec![];
    let duration = Duration::from_millis(duration_ms as u64);

    for tid in 0..thread_count {
        let stats = Arc::clone(&stats);
        let handle = thread::spawn(move || {
            let start = Instant::now();
            let mut seq = 0u64;

            while start.elapsed() < duration {
                let mut msg = StressTestMessage::default();
                msg.thread_id = tid as i64;
                msg.sequence = seq as i64;
                msg.timestamp = start.elapsed().as_micros() as i64;

                let ptr = stress_test_message_to_ffi_impl(&msg);
                if ptr.is_null() {
                    stats.errors.fetch_add(1, Ordering::Relaxed);
                } else {
                    stats.allocations.fetch_add(1, Ordering::Relaxed);
                    stress_test_message_free_ffi_impl(ptr);
                    stats.frees.fetch_add(1, Ordering::Relaxed);
                }

                seq += 1;
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    stats.allocations.load(Ordering::Relaxed)
}

#[no_mangle]
pub extern "C" fn test_pool_exhaustion(pool_size: u32) -> bool {
    let mut ptrs = Vec::new();

    for i in 0..pool_size + 100 {
        let mut msg = SmallMessage::default();
        msg.id = i as i32;

        let ptr = small_message_to_ffi_impl(&msg);
        if ptr.is_null() {
            break;
        }
        ptrs.push(ptr);
    }

    let exhausted = ptrs.len() > pool_size as usize;

    for ptr in ptrs {
        small_message_free_ffi_impl(ptr);
    }

    exhausted
}

#[no_mangle]
pub extern "C" fn test_free_list_integrity(iterations: u32) -> bool {
    for _ in 0..iterations {
        let msg1 = SmallMessage::default();
        let ptr1 = small_message_to_ffi_impl(&msg1);
        if ptr1.is_null() {
            return false;
        }

        let msg2 = SmallMessage::default();
        let ptr2 = small_message_to_ffi_impl(&msg2);
        if ptr2.is_null() {
            small_message_free_ffi_impl(ptr1);
            return false;
        }

        small_message_free_ffi_impl(ptr1);
        small_message_free_ffi_impl(ptr2);

        let msg3 = SmallMessage::default();
        let ptr3 = small_message_to_ffi_impl(&msg3);
        if ptr3.is_null() {
            return false;
        }

        small_message_free_ffi_impl(ptr3);
    }

    true
}

#[no_mangle]
pub extern "C" fn concurrent_test_mixed_operations(thread_count: u32, ops_per_thread: u32) -> u64 {
    let stats = Arc::new(ConcurrentStats::new());
    let mut handles = vec![];

    let start = Instant::now();

    for tid in 0..thread_count {
        let stats = Arc::clone(&stats);
        let handle = thread::spawn(move || {
            for i in 0..ops_per_thread {
                match i % 3 {
                    0 => {
                        let mut msg = SmallMessage::default();
                        msg.id = i as i32;
                        let ptr = small_message_to_ffi_impl(&msg);
                        if !ptr.is_null() {
                            stats.allocations.fetch_add(1, Ordering::Relaxed);
                            small_message_free_ffi_impl(ptr);
                            stats.frees.fetch_add(1, Ordering::Relaxed);
                        } else {
                            stats.errors.fetch_add(1, Ordering::Relaxed);
                        }
                    }
                    1 => {
                        let mut msg = MediumMessage::default();
                        msg.id = i as i32;
                        let ptr = medium_message_to_ffi_impl(&msg);
                        if !ptr.is_null() {
                            stats.allocations.fetch_add(1, Ordering::Relaxed);
                            medium_message_free_ffi_impl(ptr);
                            stats.frees.fetch_add(1, Ordering::Relaxed);
                        } else {
                            stats.errors.fetch_add(1, Ordering::Relaxed);
                        }
                    }
                    _ => {
                        let mut msg = StressTestMessage::default();
                        msg.thread_id = tid as i64;
                        msg.sequence = i as i64;
                        let ptr = stress_test_message_to_ffi_impl(&msg);
                        if !ptr.is_null() {
                            stats.allocations.fetch_add(1, Ordering::Relaxed);
                            stress_test_message_free_ffi_impl(ptr);
                            stats.frees.fetch_add(1, Ordering::Relaxed);
                        } else {
                            stats.errors.fetch_add(1, Ordering::Relaxed);
                        }
                    }
                }
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    start.elapsed().as_millis() as u64
}

#[no_mangle]
pub extern "C" fn measure_contention(thread_count: u32, shared_pool: bool) -> u64 {
    let mut handles = vec![];
    let start = Instant::now();

    for _tid in 0..thread_count {
        let handle = thread::spawn(move || {
            for i in 0..1000 {
                if shared_pool {
                    let mut msg = SmallMessage::default();
                    msg.id = i;
                    let ptr = small_message_to_ffi_impl(&msg);
                    if !ptr.is_null() {
                        small_message_free_ffi_impl(ptr);
                    }
                } else {
                    let mut msg = MediumMessage::default();
                    msg.id = i;
                    let ptr = medium_message_to_ffi_impl(&msg);
                    if !ptr.is_null() {
                        medium_message_free_ffi_impl(ptr);
                    }
                }
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    start.elapsed().as_micros() as u64
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_concurrent_small() {
        let elapsed = concurrent_test_small_pool(4, 100);
        println!("Small pool test (4 threads, 100 ops each): {} ms", elapsed);
    }

    #[test]
    fn test_basic_concurrent_medium() {
        let elapsed = concurrent_test_medium_pool(4, 100);
        println!("Medium pool test (4 threads, 100 ops each): {} ms", elapsed);
    }

    #[test]
    fn test_basic_concurrent_large() {
        let elapsed = concurrent_test_large_pool(4, 50);
        println!("Large pool test (4 threads, 50 ops each): {} ms", elapsed);
        assert!(elapsed > 0);
    }

    #[test]
    fn test_stress_10_threads() {
        let ops = stress_test_rapid_alloc_free(10, 1000);
        println!("Stress test (10 threads, 1000ms): {} total ops", ops);
        assert!(ops > 0);
    }

    #[test]
    fn test_stress_20_threads() {
        let ops = stress_test_rapid_alloc_free(20, 1000);
        println!("Stress test (20 threads, 1000ms): {} total ops", ops);
        assert!(ops > 0);
    }

    #[test]
    fn test_pool_exhaustion_handling() {
        let exhausted = test_pool_exhaustion(100);
        println!("Pool exhaustion test: growth occurred = {}", exhausted);
    }

    #[test]
    fn test_free_list_integrity_check() {
        let valid = test_free_list_integrity(1000);
        println!("Free list integrity test (1000 iterations): {}", valid);
        assert!(valid);
    }

    #[test]
    fn test_mixed_operations_concurrent() {
        let elapsed = concurrent_test_mixed_operations(8, 500);
        println!("Mixed operations test (8 threads, 500 ops each): {} ms", elapsed);
        assert!(elapsed > 0);
    }

    #[test]
    fn test_contention_measurement() {
        let shared = measure_contention(10, true);
        let isolated = measure_contention(10, false);
        println!("Contention - shared pool: {} us, isolated pools: {} us", shared, isolated);
        println!("Contention ratio: {:.2}x", shared as f64 / isolated as f64);
    }

    #[test]
    fn test_extreme_concurrency() {
        let ops = stress_test_rapid_alloc_free(50, 2000);
        println!("Extreme concurrency test (50 threads, 2000ms): {} total ops", ops);
        assert!(ops > 0);
    }
}
