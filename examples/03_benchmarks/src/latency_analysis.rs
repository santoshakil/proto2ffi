use serde::{Deserialize, Serialize};
use std::time::Instant;

#[derive(Serialize, Deserialize, Clone)]
pub struct LatencyDistribution {
    pub name: String,
    pub category: String,
    pub min_ns: f64,
    pub max_ns: f64,
    pub mean_ns: f64,
    pub median_ns: f64,
    pub p50_ns: f64,
    pub p95_ns: f64,
    pub p99_ns: f64,
    pub p999_ns: f64,
    pub stddev_ns: f64,
    pub samples: usize,
}

impl LatencyDistribution {
    pub fn measure<F>(name: &str, category: &str, iterations: usize, mut f: F) -> Self
    where
        F: FnMut(),
    {
        let mut latencies = Vec::with_capacity(iterations);

        for _ in 0..iterations {
            let start = Instant::now();
            f();
            let duration = start.elapsed();
            latencies.push(duration.as_nanos() as f64);
        }

        latencies.sort_by(|a, b| a.partial_cmp(b).unwrap());

        let min_ns = latencies[0];
        let max_ns = latencies[latencies.len() - 1];
        let mean_ns = latencies.iter().sum::<f64>() / latencies.len() as f64;
        let median_ns = latencies[latencies.len() / 2];

        let p50_ns = Self::percentile(&latencies, 50.0);
        let p95_ns = Self::percentile(&latencies, 95.0);
        let p99_ns = Self::percentile(&latencies, 99.0);
        let p999_ns = Self::percentile(&latencies, 99.9);

        let variance = latencies
            .iter()
            .map(|&x| {
                let diff = x - mean_ns;
                diff * diff
            })
            .sum::<f64>() / latencies.len() as f64;
        let stddev_ns = variance.sqrt();

        LatencyDistribution {
            name: name.to_string(),
            category: category.to_string(),
            min_ns,
            max_ns,
            mean_ns,
            median_ns,
            p50_ns,
            p95_ns,
            p99_ns,
            p999_ns,
            stddev_ns,
            samples: latencies.len(),
        }
    }

    fn percentile(sorted_data: &[f64], percentile: f64) -> f64 {
        let idx = ((percentile / 100.0) * sorted_data.len() as f64) as usize;
        let idx = idx.min(sorted_data.len() - 1);
        sorted_data[idx]
    }

    pub fn print_summary(&self) {
        println!("\n{} - Latency Distribution:", self.name);
        println!("  Samples: {}", self.samples);
        println!("  Min:     {:.2} ns", self.min_ns);
        println!("  Mean:    {:.2} ns", self.mean_ns);
        println!("  Median:  {:.2} ns", self.median_ns);
        println!("  p50:     {:.2} ns", self.p50_ns);
        println!("  p95:     {:.2} ns", self.p95_ns);
        println!("  p99:     {:.2} ns", self.p99_ns);
        println!("  p99.9:   {:.2} ns", self.p999_ns);
        println!("  Max:     {:.2} ns", self.max_ns);
        println!("  StdDev:  {:.2} ns", self.stddev_ns);
    }
}

pub struct LatencyBenchmarks;

impl LatencyBenchmarks {
    pub fn run_all() -> Vec<LatencyDistribution> {
        let mut results = Vec::new();

        println!("\n=== LATENCY DISTRIBUTION ANALYSIS ===\n");

        results.push(LatencyDistribution::measure(
            "FFI call latency",
            "ffi_latency",
            100_000,
            || {
                std::hint::black_box(42);
            },
        ));

        results.push(LatencyDistribution::measure(
            "Small allocation latency",
            "allocation_latency",
            10_000,
            || {
                let v = vec![0u64; 10];
                std::hint::black_box(v);
            },
        ));

        results.push(LatencyDistribution::measure(
            "Medium allocation latency",
            "allocation_latency",
            10_000,
            || {
                let v = vec![0u64; 256];
                std::hint::black_box(v);
            },
        ));

        results.push(LatencyDistribution::measure(
            "Large allocation latency",
            "allocation_latency",
            10_000,
            || {
                let v = vec![0u64; 1024];
                std::hint::black_box(v);
            },
        ));

        for dist in &results {
            dist.print_summary();
        }

        results
    }
}
