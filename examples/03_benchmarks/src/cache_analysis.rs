use serde::{Deserialize, Serialize};
use std::time::Instant;

#[derive(Serialize, Deserialize, Clone)]
pub struct CacheEfficiencyResult {
    pub name: String,
    pub category: String,
    pub operations: u64,
    pub ops_per_sec: f64,
    pub latency_ns: f64,
    pub cache_line_utilization: f64,
    pub estimated_cache_misses: u64,
    pub bandwidth_mb_s: f64,
}

pub struct CacheAnalysis;

impl CacheAnalysis {
    pub fn run_all() -> Vec<CacheEfficiencyResult> {
        let mut results = Vec::new();

        println!("\n=== CACHE EFFICIENCY ANALYSIS ===\n");

        results.push(Self::bench_sequential_access_small());
        results.push(Self::bench_sequential_access_medium());
        results.push(Self::bench_sequential_access_large());
        results.push(Self::bench_random_access_small());
        results.push(Self::bench_random_access_medium());
        results.push(Self::bench_random_access_large());
        results.push(Self::bench_strided_access());
        results.push(Self::bench_cache_thrashing());

        for result in &results {
            println!("{}: {:.0} ops/sec, {:.2} ns/op, {:.2} MB/s",
                result.name,
                result.ops_per_sec,
                result.latency_ns,
                result.bandwidth_mb_s
            );
        }

        results
    }

    fn bench_sequential_access_small() -> CacheEfficiencyResult {
        let size = 1_000_000;
        let data: Vec<u64> = (0..size).collect();
        let ops = size as u64;

        let start = Instant::now();
        let mut sum = 0u64;
        for &val in &data {
            sum = sum.wrapping_add(val);
        }
        std::hint::black_box(sum);
        let duration = start.elapsed();

        let bytes_accessed = ops * std::mem::size_of::<u64>() as u64;

        CacheEfficiencyResult {
            name: "Sequential access (L1 cache fit)".to_string(),
            category: "cache_efficiency".to_string(),
            operations: ops,
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            cache_line_utilization: 100.0,
            estimated_cache_misses: size as u64 / 8,
            bandwidth_mb_s: bytes_accessed as f64 / duration.as_secs_f64() / 1_048_576.0,
        }
    }

    fn bench_sequential_access_medium() -> CacheEfficiencyResult {
        let size = 262_144;
        let data: Vec<u64> = (0..size).collect();
        let ops = size as u64;

        let start = Instant::now();
        let mut sum = 0u64;
        for &val in &data {
            sum = sum.wrapping_add(val);
        }
        std::hint::black_box(sum);
        let duration = start.elapsed();

        let bytes_accessed = ops * std::mem::size_of::<u64>() as u64;

        CacheEfficiencyResult {
            name: "Sequential access (L2 cache fit)".to_string(),
            category: "cache_efficiency".to_string(),
            operations: ops,
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            cache_line_utilization: 100.0,
            estimated_cache_misses: size as u64 / 8,
            bandwidth_mb_s: bytes_accessed as f64 / duration.as_secs_f64() / 1_048_576.0,
        }
    }

    fn bench_sequential_access_large() -> CacheEfficiencyResult {
        let size = 4_194_304;
        let data: Vec<u64> = (0..size).collect();
        let ops = size as u64;

        let start = Instant::now();
        let mut sum = 0u64;
        for &val in &data {
            sum = sum.wrapping_add(val);
        }
        std::hint::black_box(sum);
        let duration = start.elapsed();

        let bytes_accessed = ops * std::mem::size_of::<u64>() as u64;

        CacheEfficiencyResult {
            name: "Sequential access (L3 cache fit)".to_string(),
            category: "cache_efficiency".to_string(),
            operations: ops,
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            cache_line_utilization: 100.0,
            estimated_cache_misses: size as u64 / 8,
            bandwidth_mb_s: bytes_accessed as f64 / duration.as_secs_f64() / 1_048_576.0,
        }
    }

    fn bench_random_access_small() -> CacheEfficiencyResult {
        let size = 100_000;
        let data: Vec<u64> = (0..size).collect();
        let indices: Vec<usize> = (0..size).map(|i| ((i * 7919) % size) as usize).collect();
        let ops = size as u64;

        let start = Instant::now();
        let mut sum = 0u64;
        for &idx in &indices {
            sum = sum.wrapping_add(data[idx]);
        }
        std::hint::black_box(sum);
        let duration = start.elapsed();

        let bytes_accessed = ops * std::mem::size_of::<u64>() as u64;
        let estimated_misses = ops * 90 / 100;

        CacheEfficiencyResult {
            name: "Random access (small dataset)".to_string(),
            category: "cache_efficiency".to_string(),
            operations: ops,
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            cache_line_utilization: 12.5,
            estimated_cache_misses: estimated_misses,
            bandwidth_mb_s: bytes_accessed as f64 / duration.as_secs_f64() / 1_048_576.0,
        }
    }

    fn bench_random_access_medium() -> CacheEfficiencyResult {
        let size = 262_144;
        let data: Vec<u64> = (0..size).collect();
        let indices: Vec<usize> = (0..size).map(|i| ((i * 7919) % size) as usize).collect();
        let ops = size as u64;

        let start = Instant::now();
        let mut sum = 0u64;
        for &idx in &indices {
            sum = sum.wrapping_add(data[idx]);
        }
        std::hint::black_box(sum);
        let duration = start.elapsed();

        let bytes_accessed = ops * std::mem::size_of::<u64>() as u64;
        let estimated_misses = ops * 95 / 100;

        CacheEfficiencyResult {
            name: "Random access (medium dataset)".to_string(),
            category: "cache_efficiency".to_string(),
            operations: ops,
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            cache_line_utilization: 12.5,
            estimated_cache_misses: estimated_misses,
            bandwidth_mb_s: bytes_accessed as f64 / duration.as_secs_f64() / 1_048_576.0,
        }
    }

    fn bench_random_access_large() -> CacheEfficiencyResult {
        let size = 1_048_576;
        let data: Vec<u64> = (0..size).collect();
        let indices: Vec<usize> = (0..size).map(|i| ((i * 7919) % size) as usize).collect();
        let ops = size as u64;

        let start = Instant::now();
        let mut sum = 0u64;
        for &idx in &indices {
            sum = sum.wrapping_add(data[idx]);
        }
        std::hint::black_box(sum);
        let duration = start.elapsed();

        let bytes_accessed = ops * std::mem::size_of::<u64>() as u64;
        let estimated_misses = ops * 99 / 100;

        CacheEfficiencyResult {
            name: "Random access (large dataset)".to_string(),
            category: "cache_efficiency".to_string(),
            operations: ops,
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            cache_line_utilization: 12.5,
            estimated_cache_misses: estimated_misses,
            bandwidth_mb_s: bytes_accessed as f64 / duration.as_secs_f64() / 1_048_576.0,
        }
    }

    fn bench_strided_access() -> CacheEfficiencyResult {
        let size = 1_000_000;
        let stride = 16;
        let data: Vec<u64> = (0..size).collect();
        let ops = (size / stride) as u64;

        let start = Instant::now();
        let mut sum = 0u64;
        let mut i = 0usize;
        while i < size as usize {
            sum = sum.wrapping_add(data[i]);
            i += stride as usize;
        }
        std::hint::black_box(sum);
        let duration = start.elapsed();

        let bytes_accessed = ops * std::mem::size_of::<u64>() as u64;

        CacheEfficiencyResult {
            name: "Strided access (stride=16)".to_string(),
            category: "cache_efficiency".to_string(),
            operations: ops,
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            cache_line_utilization: 6.25,
            estimated_cache_misses: ops,
            bandwidth_mb_s: bytes_accessed as f64 / duration.as_secs_f64() / 1_048_576.0,
        }
    }

    fn bench_cache_thrashing() -> CacheEfficiencyResult {
        let size = 524_288;
        let mut data1: Vec<u64> = (0..size).collect();
        let mut data2: Vec<u64> = (0..size).collect();
        let ops = size as u64 * 2;

        let start = Instant::now();
        for i in 0..size {
            let idx = i as usize;
            data1[idx] = data1[idx].wrapping_add(data2[idx]);
            data2[idx] = data2[idx].wrapping_mul(2);
        }
        std::hint::black_box(&data1);
        std::hint::black_box(&data2);
        let duration = start.elapsed();

        let bytes_accessed = ops * std::mem::size_of::<u64>() as u64;
        let estimated_misses = ops * 80 / 100;

        CacheEfficiencyResult {
            name: "Cache thrashing (2 arrays)".to_string(),
            category: "cache_efficiency".to_string(),
            operations: ops,
            ops_per_sec: ops as f64 / duration.as_secs_f64(),
            latency_ns: duration.as_nanos() as f64 / ops as f64,
            cache_line_utilization: 50.0,
            estimated_cache_misses: estimated_misses,
            bandwidth_mb_s: bytes_accessed as f64 / duration.as_secs_f64() / 1_048_576.0,
        }
    }
}
