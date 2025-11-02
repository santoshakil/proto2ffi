use serde::{Deserialize, Serialize};
use std::fs;
use std::path::Path;
use std::time::Instant;

#[derive(Serialize, Deserialize)]
struct BenchmarkResult {
    name: String,
    category: String,
    operations: u64,
    duration_micros: u128,
    ops_per_sec: f64,
    latency_ns: f64,
}

struct BenchmarkSuite {
    results: Vec<BenchmarkResult>,
}

impl BenchmarkSuite {
    fn new() -> Self {
        Self {
            results: Vec::new(),
        }
    }

    fn bench<F>(&mut self, name: &str, category: &str, operations: u64, f: F)
    where
        F: FnOnce(),
    {
        println!("Running: {} ({})", name, category);

        let start = Instant::now();
        f();
        let duration = start.elapsed();

        let duration_micros = duration.as_micros();
        let ops_per_sec = (operations as f64) / duration.as_secs_f64();
        let latency_ns = (duration.as_nanos() as f64) / (operations as f64);

        println!(
            "  {} ops in {}μs = {:.0} ops/sec ({:.2}ns per op)",
            operations, duration_micros, ops_per_sec, latency_ns
        );

        self.results.push(BenchmarkResult {
            name: name.to_string(),
            category: category.to_string(),
            operations,
            duration_micros,
            ops_per_sec,
            latency_ns,
        });
    }

    fn report(&self, path: &Path) {
        let json = serde_json::to_string_pretty(&self.results).unwrap();
        fs::write(path, json).unwrap();
        println!("\nResults written to: {}", path.display());

        println!("\n=== Summary ===\n");
        println!("{:<50} {:>15} {:>15}", "Benchmark", "Ops/Sec", "Latency(ns)");
        println!("{}", "-".repeat(82));

        for result in &self.results {
            println!(
                "{:<50} {:>15.0} {:>15.2}",
                result.name, result.ops_per_sec, result.latency_ns
            );
        }
    }
}

fn main() {
    println!("Proto2FFI Benchmark Suite\n");

    let mut suite = BenchmarkSuite::new();

    // Run all benchmarks
    run_memory_benchmarks(&mut suite);
    run_allocation_benchmarks(&mut suite);
    run_throughput_benchmarks(&mut suite);

    // Save results
    fs::create_dir_all("results").ok();
    suite.report(Path::new("results/benchmarks.json"));
}

fn run_memory_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== Memory Operations ===\n");

    // Simulate struct allocation patterns
    suite.bench("Stack allocation - small struct", "memory", 10_000_000, || {
        for _ in 0..10_000_000 {
            let _ = [0u8; 16]; // 16 bytes like Point
        }
    });

    suite.bench("Stack allocation - medium struct", "memory", 5_000_000, || {
        for _ in 0..5_000_000 {
            let _ = [0u8; 64]; // 64 bytes like Particle
        }
    });

    suite.bench("Stack allocation - large struct", "memory", 1_000_000, || {
        for _ in 0..1_000_000 {
            let _ = [0u8; 224]; // 224 bytes like Triangle
        }
    });
}

fn run_allocation_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== Allocation Patterns ===\n");

    suite.bench("Heap allocation - small", "allocation", 1_000_000, || {
        let mut v = Vec::with_capacity(1_000_000);
        for _ in 0..1_000_000 {
            v.push(Box::new([0u8; 16]));
        }
    });

    suite.bench("Heap allocation - medium", "allocation", 500_000, || {
        let mut v = Vec::with_capacity(500_000);
        for _ in 0..500_000 {
            v.push(Box::new([0u8; 64]));
        }
    });

    suite.bench("Pre-allocated vector", "allocation", 10_000_000, || {
        let mut v = Vec::with_capacity(10_000_000);
        for i in 0..10_000_000 {
            v.push(i as u64);
        }
    });
}

fn run_throughput_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== Throughput Patterns ===\n");

    // Simulate physics update patterns
    suite.bench("Sequential updates - 1M particles", "throughput", 1_000_000, || {
        let mut particles = vec![[0.0f32; 6]; 1_000_000];
        for p in &mut particles {
            p[0] += p[3] * 0.016; // x += vx * dt
            p[1] += p[4] * 0.016; // y += vy * dt
            p[2] += p[5] * 0.016; // z += vz * dt
        }
    });

    // Simulate batch operations
    suite.bench("Batch processing - 1M vectors", "throughput", 1_000_000, || {
        let mut data = vec![[0.0f32; 4]; 1_000_000];
        for v in &mut data {
            v[0] = v[0] * 2.0 + 1.0;
            v[1] = v[1] * 2.0 + 1.0;
            v[2] = v[2] * 2.0 + 1.0;
            v[3] = v[3] * 2.0 + 1.0;
        }
    });

    // Simulate data structure traversal
    suite.bench("Tree traversal - 100K nodes", "throughput", 100_000, || {
        let data = vec![0u64; 100_000];
        let mut sum = 0u64;
        for &v in &data {
            sum = sum.wrapping_add(v);
        }
        std::hint::black_box(sum);
    });

    // Simulate string operations
    suite.bench("String copying - 1M operations", "throughput", 1_000_000, || {
        let source = "TestString123";
        let mut dest = vec![0u8; 64];
        for _ in 0..1_000_000 {
            let bytes = source.as_bytes();
            let len = bytes.len().min(63);
            dest[..len].copy_from_slice(&bytes[..len]);
            dest[len] = 0;
        }
    });
}
