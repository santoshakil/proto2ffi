use serde::{Deserialize, Serialize};
use std::time::Instant;

#[derive(Serialize, Deserialize, Clone)]
pub struct MemoryOverhead {
    pub name: String,
    pub category: String,
    pub base_size_bytes: usize,
    pub actual_size_bytes: usize,
    pub overhead_bytes: usize,
    pub overhead_percent: f64,
    pub allocations: usize,
    pub total_allocated_mb: f64,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct MemoryBenchmarkResult {
    pub name: String,
    pub category: String,
    pub operations: u64,
    pub allocations_per_sec: f64,
    pub bytes_per_sec: f64,
    pub latency_ns: f64,
    pub peak_memory_mb: f64,
}

pub struct MemoryBenchmarks;

impl MemoryBenchmarks {
    pub fn run_overhead_analysis() -> Vec<MemoryOverhead> {
        let mut results = Vec::new();

        println!("\n=== MEMORY OVERHEAD ANALYSIS ===\n");

        results.push(Self::analyze_struct_overhead::<u64>("u64", 1_000_000));
        results.push(Self::analyze_struct_overhead::<[u64; 8]>("[u64; 8]", 100_000));
        results.push(Self::analyze_struct_overhead::<[u64; 64]>("[u64; 64]", 10_000));
        results.push(Self::analyze_struct_overhead::<[u64; 256]>("[u64; 256]", 1_000));

        for overhead in &results {
            println!("{}: Base={} bytes, Actual={} bytes, Overhead={} bytes ({:.2}%)",
                overhead.name,
                overhead.base_size_bytes,
                overhead.actual_size_bytes,
                overhead.overhead_bytes,
                overhead.overhead_percent
            );
        }

        results
    }

    fn analyze_struct_overhead<T>(name: &str, count: usize) -> MemoryOverhead {
        let base_size = std::mem::size_of::<T>();
        let actual_size = std::mem::size_of::<T>();
        let overhead = actual_size.saturating_sub(base_size);
        let overhead_percent = if base_size > 0 {
            (overhead as f64 / base_size as f64) * 100.0
        } else {
            0.0
        };

        MemoryOverhead {
            name: name.to_string(),
            category: "memory_overhead".to_string(),
            base_size_bytes: base_size,
            actual_size_bytes: actual_size,
            overhead_bytes: overhead,
            overhead_percent,
            allocations: count,
            total_allocated_mb: (actual_size * count) as f64 / 1_048_576.0,
        }
    }

    pub fn run_allocation_patterns() -> Vec<MemoryBenchmarkResult> {
        let mut results = Vec::new();

        println!("\n=== MEMORY ALLOCATION PATTERNS ===\n");

        results.push(Self::bench_stack_allocation());
        results.push(Self::bench_heap_allocation());
        results.push(Self::bench_vector_allocation());
        results.push(Self::bench_boxed_allocation());

        for result in &results {
            println!("{}: {:.0} allocs/sec, {:.2} ns/op, {:.2} MB/s",
                result.name,
                result.allocations_per_sec,
                result.latency_ns,
                result.bytes_per_sec / 1_048_576.0
            );
        }

        results
    }

    fn bench_stack_allocation() -> MemoryBenchmarkResult {
        let ops = 10_000_000u64;
        let start = Instant::now();

        for i in 0..ops {
            let data = [i; 64];
            std::hint::black_box(&data);
        }

        let duration = start.elapsed();
        let bytes_allocated = ops * std::mem::size_of::<[u64; 64]>() as u64;

        MemoryBenchmarkResult {
            name: "Stack allocation (512B)".to_string(),
            category: "memory_patterns".to_string(),
            operations: ops,
            allocations_per_sec: ops as f64 / duration.as_secs_f64(),
            bytes_per_sec: bytes_allocated as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            peak_memory_mb: (bytes_allocated as f64) / 1_048_576.0,
        }
    }

    fn bench_heap_allocation() -> MemoryBenchmarkResult {
        let ops = 100_000u64;
        let start = Instant::now();

        for i in 0..ops {
            let data = Box::new([i; 64]);
            std::hint::black_box(data);
        }

        let duration = start.elapsed();
        let bytes_allocated = ops * std::mem::size_of::<[u64; 64]>() as u64;

        MemoryBenchmarkResult {
            name: "Heap allocation (Box, 512B)".to_string(),
            category: "memory_patterns".to_string(),
            operations: ops,
            allocations_per_sec: ops as f64 / duration.as_secs_f64(),
            bytes_per_sec: bytes_allocated as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            peak_memory_mb: (bytes_allocated as f64) / 1_048_576.0,
        }
    }

    fn bench_vector_allocation() -> MemoryBenchmarkResult {
        let ops = 100_000u64;
        let start = Instant::now();

        for _ in 0..ops {
            let mut v = Vec::with_capacity(64);
            for i in 0..64 {
                v.push(i);
            }
            std::hint::black_box(&v);
        }

        let duration = start.elapsed();
        let bytes_allocated = ops * (std::mem::size_of::<u64>() * 64) as u64;

        MemoryBenchmarkResult {
            name: "Vector allocation (64 elements)".to_string(),
            category: "memory_patterns".to_string(),
            operations: ops,
            allocations_per_sec: ops as f64 / duration.as_secs_f64(),
            bytes_per_sec: bytes_allocated as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            peak_memory_mb: (bytes_allocated as f64) / 1_048_576.0,
        }
    }

    fn bench_boxed_allocation() -> MemoryBenchmarkResult {
        let ops = 1_000_000u64;
        let start = Instant::now();

        for i in 0..ops {
            let data = Box::new(i);
            std::hint::black_box(data);
        }

        let duration = start.elapsed();
        let bytes_allocated = ops * std::mem::size_of::<u64>() as u64;

        MemoryBenchmarkResult {
            name: "Boxed allocation (8B)".to_string(),
            category: "memory_patterns".to_string(),
            operations: ops,
            allocations_per_sec: ops as f64 / duration.as_secs_f64(),
            bytes_per_sec: bytes_allocated as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            peak_memory_mb: (bytes_allocated as f64) / 1_048_576.0,
        }
    }
}
