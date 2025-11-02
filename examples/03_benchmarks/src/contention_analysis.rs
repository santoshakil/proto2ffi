use serde::{Deserialize, Serialize};
use std::sync::{Arc, Mutex, RwLock};
use std::thread;
use std::time::Instant;

#[derive(Serialize, Deserialize, Clone)]
pub struct ContentionResult {
    pub name: String,
    pub category: String,
    pub threads: usize,
    pub operations_per_thread: u64,
    pub total_operations: u64,
    pub total_duration_ms: u128,
    pub ops_per_sec: f64,
    pub avg_latency_ns: f64,
    pub contention_overhead_percent: f64,
}

pub struct ContentionBenchmarks;

impl ContentionBenchmarks {
    pub fn run_all() -> Vec<ContentionResult> {
        let mut results = Vec::new();

        println!("\n=== CONTENTION & THROUGHPUT ANALYSIS ===\n");

        results.push(Self::bench_single_threaded());
        results.push(Self::bench_mutex_contention(2));
        results.push(Self::bench_mutex_contention(4));
        results.push(Self::bench_mutex_contention(8));
        results.push(Self::bench_rwlock_contention(2));
        results.push(Self::bench_rwlock_contention(4));
        results.push(Self::bench_rwlock_contention(8));
        results.push(Self::bench_lock_free(4));
        results.push(Self::bench_lock_free(8));

        for result in &results {
            println!("{}: {:.0} ops/sec, {:.2} ns/op, {:.2}% overhead",
                result.name,
                result.ops_per_sec,
                result.avg_latency_ns,
                result.contention_overhead_percent
            );
        }

        results
    }

    fn bench_single_threaded() -> ContentionResult {
        let ops = 1_000_000u64;
        let start = Instant::now();

        let mut counter = 0u64;
        for _ in 0..ops {
            counter = counter.wrapping_add(1);
            std::hint::black_box(counter);
        }

        let duration = start.elapsed();

        ContentionResult {
            name: "Single-threaded baseline".to_string(),
            category: "contention".to_string(),
            threads: 1,
            operations_per_thread: ops,
            total_operations: ops,
            total_duration_ms: duration.as_millis(),
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            avg_latency_ns: duration.as_nanos() as f64 / ops as f64,
            contention_overhead_percent: 0.0,
        }
    }

    fn bench_mutex_contention(num_threads: usize) -> ContentionResult {
        let ops_per_thread = 100_000u64;
        let counter = Arc::new(Mutex::new(0u64));
        let start = Instant::now();

        let handles: Vec<_> = (0..num_threads)
            .map(|_| {
                let counter = Arc::clone(&counter);
                thread::spawn(move || {
                    for _ in 0..ops_per_thread {
                        let mut c = counter.lock().unwrap();
                        *c = c.wrapping_add(1);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }

        let duration = start.elapsed();
        let total_ops = ops_per_thread * num_threads as u64;

        let baseline_latency = 10.0;
        let actual_latency = duration.as_nanos() as f64 / total_ops as f64;
        let overhead = ((actual_latency - baseline_latency) / baseline_latency) * 100.0;

        ContentionResult {
            name: format!("Mutex contention ({} threads)", num_threads),
            category: "contention".to_string(),
            threads: num_threads,
            operations_per_thread: ops_per_thread,
            total_operations: total_ops,
            total_duration_ms: duration.as_millis(),
            ops_per_sec: total_ops as f64 / duration.as_secs_f64(),
            avg_latency_ns: actual_latency,
            contention_overhead_percent: overhead.max(0.0),
        }
    }

    fn bench_rwlock_contention(num_threads: usize) -> ContentionResult {
        let ops_per_thread = 100_000u64;
        let counter = Arc::new(RwLock::new(0u64));
        let start = Instant::now();

        let handles: Vec<_> = (0..num_threads)
            .map(|_| {
                let counter = Arc::clone(&counter);
                thread::spawn(move || {
                    for _ in 0..ops_per_thread {
                        let mut c = counter.write().unwrap();
                        *c = c.wrapping_add(1);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }

        let duration = start.elapsed();
        let total_ops = ops_per_thread * num_threads as u64;

        let baseline_latency = 10.0;
        let actual_latency = duration.as_nanos() as f64 / total_ops as f64;
        let overhead = ((actual_latency - baseline_latency) / baseline_latency) * 100.0;

        ContentionResult {
            name: format!("RwLock contention ({} threads)", num_threads),
            category: "contention".to_string(),
            threads: num_threads,
            operations_per_thread: ops_per_thread,
            total_operations: total_ops,
            total_duration_ms: duration.as_millis(),
            ops_per_sec: total_ops as f64 / duration.as_secs_f64(),
            avg_latency_ns: actual_latency,
            contention_overhead_percent: overhead.max(0.0),
        }
    }

    fn bench_lock_free(num_threads: usize) -> ContentionResult {
        let ops_per_thread = 1_000_000u64;
        let start = Instant::now();

        let handles: Vec<_> = (0..num_threads)
            .map(|_| {
                thread::spawn(move || {
                    let mut counter = 0u64;
                    for _ in 0..ops_per_thread {
                        counter = counter.wrapping_add(1);
                        std::hint::black_box(counter);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }

        let duration = start.elapsed();
        let total_ops = ops_per_thread * num_threads as u64;

        let baseline_latency = 10.0;
        let actual_latency = duration.as_nanos() as f64 / total_ops as f64;
        let overhead = ((actual_latency - baseline_latency) / baseline_latency) * 100.0;

        ContentionResult {
            name: format!("Lock-free ({} threads)", num_threads),
            category: "contention".to_string(),
            threads: num_threads,
            operations_per_thread: ops_per_thread,
            total_operations: total_ops,
            total_duration_ms: duration.as_millis(),
            ops_per_sec: total_ops as f64 / duration.as_secs_f64(),
            avg_latency_ns: actual_latency,
            contention_overhead_percent: overhead.max(0.0),
        }
    }
}
