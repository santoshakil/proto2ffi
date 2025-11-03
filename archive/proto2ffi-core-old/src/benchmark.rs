use std::time::{Duration, Instant};

#[derive(Debug, Clone)]
pub struct BenchmarkResult {
    pub name: String,
    pub duration: Duration,
    pub iterations: usize,
    pub ops_per_sec: f64,
}

impl BenchmarkResult {
    pub fn new(name: String, duration: Duration, iterations: usize) -> Self {
        let ops_per_sec = if duration.as_secs_f64() > 0.0 {
            iterations as f64 / duration.as_secs_f64()
        } else {
            0.0
        };

        Self {
            name,
            duration,
            iterations,
            ops_per_sec,
        }
    }
}

pub struct Benchmark {
    pub results: Vec<BenchmarkResult>,
}

impl Benchmark {
    pub fn new() -> Self {
        Self {
            results: Vec::new(),
        }
    }

    pub fn run<F>(&mut self, name: &str, iterations: usize, mut f: F)
    where
        F: FnMut(),
    {
        let start = Instant::now();
        for _ in 0..iterations {
            f();
        }
        let duration = start.elapsed();

        self.results.push(BenchmarkResult::new(
            name.to_string(),
            duration,
            iterations,
        ));
    }

    pub fn run_with_warmup<F>(&mut self, name: &str, warmup: usize, iterations: usize, mut f: F)
    where
        F: FnMut(),
    {
        for _ in 0..warmup {
            f();
        }

        let start = Instant::now();
        for _ in 0..iterations {
            f();
        }
        let duration = start.elapsed();

        self.results.push(BenchmarkResult::new(
            name.to_string(),
            duration,
            iterations,
        ));
    }

    pub fn report(&self) -> String {
        let mut output = String::new();
        output.push_str("Benchmark Results:\n");
        output.push_str("=================\n\n");

        for result in &self.results {
            output.push_str(&format!("{}\n", result.name));
            output.push_str(&format!("  Duration:    {:?}\n", result.duration));
            output.push_str(&format!("  Iterations:  {}\n", result.iterations));
            output.push_str(&format!("  Ops/sec:     {:.2}\n", result.ops_per_sec));
            output.push_str(&format!(
                "  Avg time:    {:?}\n",
                result.duration / result.iterations as u32
            ));
            output.push_str("\n");
        }

        output
    }

    pub fn fastest(&self) -> Option<&BenchmarkResult> {
        self.results.iter().max_by(|a, b| {
            a.ops_per_sec.partial_cmp(&b.ops_per_sec).unwrap()
        })
    }

    pub fn slowest(&self) -> Option<&BenchmarkResult> {
        self.results.iter().min_by(|a, b| {
            a.ops_per_sec.partial_cmp(&b.ops_per_sec).unwrap()
        })
    }
}

impl Default for Benchmark {
    fn default() -> Self {
        Self::new()
    }
}

#[macro_export]
macro_rules! bench {
    ($bench:expr, $name:expr, $iterations:expr, $code:block) => {
        $bench.run($name, $iterations, || $code);
    };
}

#[macro_export]
macro_rules! bench_warmup {
    ($bench:expr, $name:expr, $warmup:expr, $iterations:expr, $code:block) => {
        $bench.run_with_warmup($name, $warmup, $iterations, || $code);
    };
}
