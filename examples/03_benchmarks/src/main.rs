use serde::{Deserialize, Serialize};
use std::alloc::{alloc, dealloc, Layout};
use std::fs;
use std::path::Path;
use std::time::Instant;

mod generated;
use generated::*;

mod comparisons;
mod latency_analysis;
mod memory_analysis;
mod cache_analysis;
mod contention_analysis;
mod statistical_analysis;

use comparisons::{ComparisonBenchmarks, ComparisonResult};
use latency_analysis::{LatencyBenchmarks, LatencyDistribution};
use memory_analysis::{MemoryBenchmarks, MemoryOverhead, MemoryBenchmarkResult};
use cache_analysis::{CacheAnalysis, CacheEfficiencyResult};
use contention_analysis::{ContentionBenchmarks, ContentionResult};
use statistical_analysis::StatisticalAnalysis;

#[derive(Serialize, Deserialize, Clone)]
struct BenchmarkResult {
    name: String,
    category: String,
    schema: String,
    message_type: String,
    message_size_bytes: usize,
    operations: u64,
    duration_micros: u128,
    ops_per_sec: f64,
    latency_ns: f64,
    throughput_mb_s: f64,
    memory_allocated_mb: f64,
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

    fn bench<F>(
        &mut self,
        name: &str,
        category: &str,
        schema: &str,
        message_type: &str,
        message_size: usize,
        operations: u64,
        f: F,
    ) where
        F: FnOnce(),
    {
        println!(
            "Running: {} ({} / {} / {})",
            name, category, schema, message_type
        );

        let start = Instant::now();
        f();
        let duration = start.elapsed();

        let duration_micros = duration.as_micros();
        let ops_per_sec = (operations as f64) / duration.as_secs_f64();
        let latency_ns = (duration.as_nanos() as f64) / (operations as f64);
        let bytes_processed = operations as f64 * message_size as f64;
        let throughput_mb_s = (bytes_processed / 1_048_576.0) / duration.as_secs_f64();
        let memory_allocated_mb = (operations as f64 * message_size as f64) / 1_048_576.0;

        println!(
            "  {} ops in {}μs = {:.0} ops/sec ({:.2}ns/op, {:.2} MB/s)",
            operations, duration_micros, ops_per_sec, latency_ns, throughput_mb_s
        );

        self.results.push(BenchmarkResult {
            name: name.to_string(),
            category: category.to_string(),
            schema: schema.to_string(),
            message_type: message_type.to_string(),
            message_size_bytes: message_size,
            operations,
            duration_micros,
            ops_per_sec,
            latency_ns,
            throughput_mb_s,
            memory_allocated_mb,
        });
    }

    fn report(&self, path: &Path) {
        let json = serde_json::to_string_pretty(&self.results).unwrap();
        fs::write(path, json).unwrap();
        println!("\nResults written to: {}", path.display());

        self.print_summary();
        self.print_category_comparison();
        self.print_size_analysis();
    }

    fn print_summary(&self) {
        println!("\n=== BENCHMARK SUMMARY ===\n");
        println!(
            "{:<60} {:<15} {:>15} {:>15} {:>15}",
            "Benchmark", "Size", "Ops/Sec", "Latency(ns)", "MB/s"
        );
        println!("{}", "-".repeat(120));

        for result in &self.results {
            println!(
                "{:<60} {:<15} {:>15.0} {:>15.2} {:>15.2}",
                result.name, result.message_size_bytes, result.ops_per_sec, result.latency_ns, result.throughput_mb_s
            );
        }
    }

    fn print_category_comparison(&self) {
        println!("\n=== CATEGORY PERFORMANCE COMPARISON ===\n");

        let mut categories = std::collections::HashMap::new();
        for r in &self.results {
            categories
                .entry(&r.category)
                .or_insert_with(Vec::new)
                .push(r);
        }

        for (category, results) in categories.iter() {
            let avg_ops = results.iter().map(|r| r.ops_per_sec).sum::<f64>() / results.len() as f64;
            let avg_latency = results.iter().map(|r| r.latency_ns).sum::<f64>() / results.len() as f64;
            let avg_throughput = results.iter().map(|r| r.throughput_mb_s).sum::<f64>() / results.len() as f64;

            println!("{:<30} {:>15.0} ops/s | {:>10.2} ns | {:>10.2} MB/s",
                category, avg_ops, avg_latency, avg_throughput);
        }
    }

    fn print_size_analysis(&self) {
        println!("\n=== MESSAGE SIZE IMPACT ===\n");

        let mut size_buckets = std::collections::HashMap::new();
        for r in &self.results {
            let bucket = match r.message_size_bytes {
                0..=100 => "Small (<100B)",
                101..=1024 => "Medium (100B-1KB)",
                1025..=10240 => "Large (1KB-10KB)",
                _ => "Huge (>10KB)",
            };
            size_buckets
                .entry(bucket)
                .or_insert_with(Vec::new)
                .push(r);
        }

        for (bucket, results) in size_buckets.iter() {
            let avg_ops = results.iter().map(|r| r.ops_per_sec).sum::<f64>() / results.len() as f64;
            let avg_latency = results.iter().map(|r| r.latency_ns).sum::<f64>() / results.len() as f64;

            println!("{:<20} {:>15.0} ops/s | {:>10.2} ns/op",
                bucket, avg_ops, avg_latency);
        }
    }
}

fn main() {
    println!("Proto2FFI Comprehensive Benchmark Suite\n");
    println!("Testing: Social Media Schema (with advanced analysis)\n");

    let mut suite = BenchmarkSuite::new();

    run_social_media_benchmarks(&mut suite);
    run_allocation_benchmarks(&mut suite);
    run_ffi_overhead_benchmarks(&mut suite);
    run_memory_pool_benchmarks(&mut suite);
    run_cache_performance_benchmarks(&mut suite);
    run_throughput_benchmarks(&mut suite);

    let comparison_results = run_comparison_benchmarks();
    let latency_distributions = LatencyBenchmarks::run_all();
    let memory_overhead = MemoryBenchmarks::run_overhead_analysis();
    let memory_patterns = MemoryBenchmarks::run_allocation_patterns();
    let cache_results = CacheAnalysis::run_all();
    let contention_results = ContentionBenchmarks::run_all();

    fs::create_dir_all("results").ok();
    suite.report(Path::new("results/benchmarks.json"));

    generate_advanced_reports(
        &suite.results,
        &comparison_results,
        &latency_distributions,
        &memory_overhead,
        &memory_patterns,
        &cache_results,
        &contention_results,
    );
}

fn run_comparison_benchmarks() -> Vec<ComparisonResult> {
    let mut results = Vec::new();

    println!("\n=== COMPARISON BENCHMARKS ===\n");

    results.extend(ComparisonBenchmarks::run_proto2ffi_vs_native_dart());
    results.extend(ComparisonBenchmarks::run_proto2ffi_vs_json());
    results.extend(ComparisonBenchmarks::run_proto2ffi_vs_bincode());

    for result in &results {
        println!("{}: {:.0} ops/sec, {:.2} ns/op",
            result.name, result.ops_per_sec, result.latency_ns);
    }

    results
}


fn run_social_media_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== SOCIAL MEDIA SCHEMA BENCHMARKS ===\n");

    suite.bench(
        "Post creation (large messages)",
        "allocation",
        "social_media",
        "Post",
        std::mem::size_of::<Post>(),
        50_000,
        || {
            let mut posts = Vec::with_capacity(50_000);
            for i in 0..50_000 {
                let mut post = Post::default();
                post.post_id = i;
                post.author_id = i % 10000;
                post.like_count = i % 1000;
                posts.push(post);
            }
        },
    );

    suite.bench(
        "Comment creation (medium messages)",
        "allocation",
        "social_media",
        "Comment",
        std::mem::size_of::<Comment>(),
        500_000,
        || {
            let mut comments = Vec::with_capacity(500_000);
            for i in 0..500_000 {
                let mut comment = Comment::default();
                comment.comment_id = i;
                comment.post_id = i / 10;
                comment.author_id = i % 50000;
                comments.push(comment);
            }
        },
    );

    suite.bench(
        "Reaction batch processing (small messages)",
        "allocation",
        "social_media",
        "Reaction",
        std::mem::size_of::<Reaction>(),
        1_000_000,
        || {
            let mut reactions = Vec::with_capacity(1_000_000);
            for i in 0..1_000_000 {
                let mut reaction = Reaction::default();
                reaction.reaction_id = i;
                reaction.user_id = i % 100000;
                reaction.target_id = i / 100;
                reactions.push(reaction);
            }
        },
    );

    suite.bench(
        "NewsFeedItem SIMD scoring",
        "simd",
        "social_media",
        "NewsFeedItem",
        std::mem::size_of::<NewsFeedItem>(),
        100_000,
        || {
            let mut items = Vec::with_capacity(100_000);
            for i in 0..100_000 {
                let mut item = NewsFeedItem::default();
                item.post_id = i;
                item.relevance_score = (i as f64) / 100_000.0;
                item.engagement_score = ((i % 1000) as f64) / 1000.0;
                item.recency_score = 1.0 - ((i as f64) / 100_000.0);
                item.final_score = (item.relevance_score + item.engagement_score + item.recency_score) / 3.0;
                items.push(item);
            }
        },
    );

    suite.bench(
        "Message batch operations",
        "allocation",
        "social_media",
        "Message",
        std::mem::size_of::<Message>(),
        500_000,
        || {
            let mut messages = Vec::with_capacity(500_000);
            for i in 0..500_000 {
                let mut msg = Message::default();
                msg.message_id = i;
                msg.sender_id = i % 50000;
                msg.receiver_id = (i + 1) % 50000;
                messages.push(msg);
            }
        },
    );
}

fn run_allocation_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== ALLOCATION PATTERN BENCHMARKS ===\n");

    suite.bench(
        "Stack allocation - small struct",
        "memory",
        "generic",
        "Reaction",
        std::mem::size_of::<Reaction>(),
        10_000_000,
        || {
            for i in 0..10_000_000 {
                let mut r = Reaction::default();
                r.reaction_id = i;
                std::hint::black_box(&r);
            }
        },
    );

    suite.bench(
        "Stack allocation - medium struct",
        "memory",
        "generic",
        "UserProfile",
        std::mem::size_of::<UserProfile>(),
        1_000_000,
        || {
            for i in 0..1_000_000 {
                let mut u = UserProfile::default();
                u.user_id = i;
                std::hint::black_box(&u);
            }
        },
    );

    suite.bench(
        "Stack allocation - large struct",
        "memory",
        "generic",
        "Post",
        std::mem::size_of::<Post>(),
        100_000,
        || {
            for i in 0..100_000 {
                let mut p = Post::default();
                p.post_id = i;
                std::hint::black_box(&p);
            }
        },
    );

    suite.bench(
        "Heap allocation - small",
        "memory",
        "generic",
        "Reaction",
        std::mem::size_of::<Reaction>(),
        1_000_000,
        || {
            let mut v = Vec::with_capacity(1_000_000);
            for i in 0..1_000_000 {
                let mut r = Reaction::default();
                r.reaction_id = i;
                v.push(Box::new(r));
            }
        },
    );

    suite.bench(
        "Heap allocation - large",
        "memory",
        "generic",
        "Post",
        std::mem::size_of::<Post>(),
        50_000,
        || {
            let mut v = Vec::with_capacity(50_000);
            for i in 0..50_000 {
                let mut p = Post::default();
                p.post_id = i;
                v.push(Box::new(p));
            }
        },
    );

    suite.bench(
        "Pre-allocated vector",
        "memory",
        "generic",
        "u64",
        8,
        10_000_000,
        || {
            let mut v = Vec::with_capacity(10_000_000);
            for i in 0..10_000_000 {
                v.push(i as u64);
            }
            std::hint::black_box(&v);
        },
    );
}

fn run_ffi_overhead_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== FFI OVERHEAD BENCHMARKS ===\n");

    suite.bench(
        "FFI call overhead - size query",
        "ffi",
        "generic",
        "UserProfile",
        std::mem::size_of::<UserProfile>(),
        10_000_000,
        || {
            for _ in 0..10_000_000 {
                let size = userprofile_size();
                std::hint::black_box(size);
            }
        },
    );

    suite.bench(
        "FFI call overhead - alignment query",
        "ffi",
        "generic",
        "UserProfile",
        std::mem::size_of::<UserProfile>(),
        10_000_000,
        || {
            for _ in 0..10_000_000 {
                let align = userprofile_alignment();
                std::hint::black_box(align);
            }
        },
    );

    suite.bench(
        "FFI roundtrip - small struct",
        "ffi",
        "generic",
        "Reaction",
        std::mem::size_of::<Reaction>(),
        1_000_000,
        || {
            unsafe {
                let layout = Layout::from_size_align_unchecked(
                    Reaction::SIZE,
                    Reaction::ALIGNMENT,
                );
                for i in 0..1_000_000 {
                    let ptr = alloc(layout);
                    let r = Reaction::from_ptr_mut(ptr);
                    r.reaction_id = i;
                    std::hint::black_box(&*r);
                    dealloc(ptr, layout);
                }
            }
        },
    );

    suite.bench(
        "FFI roundtrip - large struct",
        "ffi",
        "generic",
        "Post",
        std::mem::size_of::<Post>(),
        100_000,
        || {
            unsafe {
                let layout = Layout::from_size_align_unchecked(
                    Post::SIZE,
                    Post::ALIGNMENT,
                );
                for i in 0..100_000 {
                    let ptr = alloc(layout);
                    let p = Post::from_ptr_mut(ptr);
                    p.post_id = i;
                    std::hint::black_box(&*p);
                    dealloc(ptr, layout);
                }
            }
        },
    );
}

fn run_memory_pool_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== MEMORY POOL EFFICIENCY BENCHMARKS ===\n");

    suite.bench(
        "Pool allocation pattern - Posts",
        "pool",
        "social_media",
        "Post",
        std::mem::size_of::<Post>(),
        50_000,
        || {
            let mut pool = Vec::with_capacity(50_000);
            for i in 0..50_000 {
                let mut p = Post::default();
                p.post_id = i;
                pool.push(p);
            }
        },
    );

    suite.bench(
        "Pool allocation pattern - Comments",
        "pool",
        "social_media",
        "Comment",
        std::mem::size_of::<Comment>(),
        500_000,
        || {
            let mut pool = Vec::with_capacity(500_000);
            for i in 0..500_000 {
                let mut c = Comment::default();
                c.comment_id = i;
                pool.push(c);
            }
        },
    );

    suite.bench(
        "Pool reuse pattern - Reactions",
        "pool",
        "social_media",
        "Reaction",
        std::mem::size_of::<Reaction>(),
        1_000_000,
        || {
            let mut pool = Vec::with_capacity(10000);
            for _ in 0..10000 {
                pool.push(Reaction::default());
            }

            for cycle in 0..100 {
                for i in 0..10000 {
                    pool[i].reaction_id = (cycle * 10000 + i) as u64;
                    std::hint::black_box(&pool[i]);
                }
            }
        },
    );

    suite.bench(
        "Pool allocation pattern - Notifications",
        "pool",
        "social_media",
        "Notification",
        std::mem::size_of::<Notification>(),
        500_000,
        || {
            let mut pool = Vec::with_capacity(500_000);
            for i in 0..500_000 {
                let mut n = Notification::default();
                n.notification_id = i;
                pool.push(n);
            }
        },
    );
}

fn run_cache_performance_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== CACHE PERFORMANCE BENCHMARKS ===\n");

    suite.bench(
        "Sequential access - small structs",
        "cache",
        "generic",
        "Reaction",
        std::mem::size_of::<Reaction>(),
        1_000_000,
        || {
            let mut data = vec![Reaction::default(); 1_000_000];
            for i in 0..1_000_000 {
                data[i].reaction_id = i as u64;
            }
            let mut sum = 0u64;
            for r in &data {
                sum = sum.wrapping_add(r.reaction_id);
            }
            std::hint::black_box(sum);
        },
    );

    suite.bench(
        "Random access - small structs",
        "cache",
        "generic",
        "Reaction",
        std::mem::size_of::<Reaction>(),
        100_000,
        || {
            let mut data = vec![Reaction::default(); 100_000];
            for i in 0..100_000 {
                data[i].reaction_id = i as u64;
            }
            let mut sum = 0u64;
            for i in (0..100_000).step_by(7) {
                sum = sum.wrapping_add(data[i % 100_000].reaction_id);
            }
            std::hint::black_box(sum);
        },
    );

    suite.bench(
        "Sequential access - large structs",
        "cache",
        "generic",
        "Post",
        std::mem::size_of::<Post>(),
        10_000,
        || {
            let mut data = vec![Post::default(); 10_000];
            for i in 0..10_000 {
                data[i].post_id = i as u64;
            }
            let mut sum = 0u64;
            for p in &data {
                sum = sum.wrapping_add(p.post_id);
            }
            std::hint::black_box(sum);
        },
    );
}

fn run_throughput_benchmarks(suite: &mut BenchmarkSuite) {
    println!("\n=== THROUGHPUT BENCHMARKS ===\n");

    suite.bench(
        "Social media feed generation",
        "throughput",
        "social_media",
        "NewsFeedItem",
        std::mem::size_of::<NewsFeedItem>(),
        100_000,
        || {
            let mut feed = vec![NewsFeedItem::default(); 100_000];
            for i in 0..100_000 {
                feed[i].post_id = i as u64;
                feed[i].relevance_score = ((i % 1000) as f64) / 1000.0;
                feed[i].engagement_score = ((i % 500) as f64) / 500.0;
                feed[i].recency_score = 1.0 - ((i as f64) / 100_000.0);
                feed[i].final_score = (feed[i].relevance_score + feed[i].engagement_score + feed[i].recency_score) / 3.0;
            }
            feed.sort_by(|a, b| b.final_score.partial_cmp(&a.final_score).unwrap());
            std::hint::black_box(&feed);
        },
    );

    suite.bench(
        "Batch post updates",
        "throughput",
        "social_media",
        "Post",
        std::mem::size_of::<Post>(),
        50_000,
        || {
            let mut posts = vec![Post::default(); 50_000];
            for i in 0..50_000 {
                posts[i].like_count = posts[i].like_count.wrapping_add(1);
                posts[i].view_count = posts[i].view_count.wrapping_add(10);
            }
            std::hint::black_box(&posts);
        },
    );

    suite.bench(
        "Batch comment processing",
        "throughput",
        "social_media",
        "Comment",
        std::mem::size_of::<Comment>(),
        200_000,
        || {
            let mut comments = vec![Comment::default(); 200_000];
            for i in 0..200_000 {
                comments[i].comment_id = i as u64;
                comments[i].post_id = (i / 10) as u64;
                comments[i].like_count = (i % 100) as u64;
            }
            std::hint::black_box(&comments);
        },
    );
}

fn generate_advanced_reports(
    baseline: &[BenchmarkResult],
    comparisons: &[ComparisonResult],
    latency: &[LatencyDistribution],
    memory_overhead: &[MemoryOverhead],
    memory_patterns: &[MemoryBenchmarkResult],
    cache: &[CacheEfficiencyResult],
    contention: &[ContentionResult],
) {
    save_json_results(baseline, comparisons, latency, memory_overhead, memory_patterns, cache, contention);
    generate_advanced_html_report(baseline, comparisons, latency, cache, contention);
    generate_statistical_analysis(baseline, comparisons);
    generate_recommendations();
}

fn save_json_results(
    baseline: &[BenchmarkResult],
    comparisons: &[ComparisonResult],
    latency: &[LatencyDistribution],
    memory_overhead: &[MemoryOverhead],
    memory_patterns: &[MemoryBenchmarkResult],
    cache: &[CacheEfficiencyResult],
    contention: &[ContentionResult],
) {
    #[derive(Serialize)]
    struct AllResults {
        baseline: Vec<BenchmarkResult>,
        comparisons: Vec<ComparisonResult>,
        latency_distributions: Vec<LatencyDistribution>,
        memory_overhead: Vec<MemoryOverhead>,
        memory_patterns: Vec<MemoryBenchmarkResult>,
        cache_efficiency: Vec<CacheEfficiencyResult>,
        contention: Vec<ContentionResult>,
    }

    let all = AllResults {
        baseline: baseline.to_vec(),
        comparisons: comparisons.to_vec(),
        latency_distributions: latency.to_vec(),
        memory_overhead: memory_overhead.to_vec(),
        memory_patterns: memory_patterns.to_vec(),
        cache_efficiency: cache.to_vec(),
        contention: contention.to_vec(),
    };

    let json = serde_json::to_string_pretty(&all).unwrap();
    fs::write("results/advanced_benchmarks.json", json).ok();
    println!("\nAdvanced results saved to: results/advanced_benchmarks.json");
}

fn generate_statistical_analysis(baseline: &[BenchmarkResult], comparisons: &[ComparisonResult]) {
    println!("\n=== STATISTICAL ANALYSIS ===\n");

    let proto2ffi_ops: Vec<f64> = baseline.iter()
        .filter(|r| r.category == "allocation")
        .map(|r| r.ops_per_sec)
        .collect();

    if !proto2ffi_ops.is_empty() {
        let summary = StatisticalAnalysis::calculate_summary("Proto2FFI Allocation", &proto2ffi_ops);
        StatisticalAnalysis::print_summary(&summary);
    }

    let json_ops: Vec<f64> = comparisons.iter()
        .filter(|r| r.category == "comparison_json")
        .map(|r| r.ops_per_sec)
        .collect();

    if !json_ops.is_empty() {
        let summary = StatisticalAnalysis::calculate_summary("JSON Serialization", &json_ops);
        StatisticalAnalysis::print_summary(&summary);
    }

    if !proto2ffi_ops.is_empty() && !json_ops.is_empty() {
        let proto2ffi_avg = proto2ffi_ops.iter().sum::<f64>() / proto2ffi_ops.len() as f64;
        let json_avg = json_ops.iter().sum::<f64>() / json_ops.len() as f64;
        let proto2ffi_lat = 1_000_000_000.0 / proto2ffi_avg;
        let json_lat = 1_000_000_000.0 / json_avg;

        let comparison = StatisticalAnalysis::compare_performance(
            "Proto2FFI vs JSON",
            proto2ffi_avg,
            proto2ffi_lat,
            json_avg,
            json_lat,
        );
        StatisticalAnalysis::print_comparison(&comparison);
    }
}

fn generate_recommendations() {
    println!("\n=== PERFORMANCE RECOMMENDATIONS ===\n");

    let recommendations = StatisticalAnalysis::generate_recommendations();
    for rec in recommendations {
        StatisticalAnalysis::print_recommendation(&rec);
    }

    let json = serde_json::to_string_pretty(&StatisticalAnalysis::generate_recommendations()).unwrap();
    fs::write("results/recommendations.json", json).ok();
    println!("\nRecommendations saved to: results/recommendations.json");
}

fn generate_advanced_html_report(
    baseline: &[BenchmarkResult],
    comparisons: &[ComparisonResult],
    latency: &[LatencyDistribution],
    cache: &[CacheEfficiencyResult],
    contention: &[ContentionResult],
) {
    let html = format!(r#"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proto2FFI Benchmark Results</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
        }}
        .container {{
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}
        h1 {{
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 10px;
        }}
        h2 {{
            color: #555;
            margin-top: 40px;
            border-bottom: 2px solid #ddd;
            padding-bottom: 8px;
        }}
        .chart-container {{
            position: relative;
            height: 400px;
            margin: 30px 0;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }}
        th, td {{
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }}
        th {{
            background-color: #4CAF50;
            color: white;
            font-weight: 600;
        }}
        tr:hover {{
            background-color: #f5f5f5;
        }}
        .metric {{
            display: inline-block;
            margin: 20px;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 8px;
            min-width: 200px;
        }}
        .metric-value {{
            font-size: 32px;
            font-weight: bold;
            color: #4CAF50;
        }}
        .metric-label {{
            font-size: 14px;
            color: #777;
            margin-top: 5px;
        }}
        .summary {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 8px;
            margin: 30px 0;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h1>Proto2FFI Comprehensive Benchmark Results</h1>

        <div class="summary">
            <h2 style="color: white; border: none;">Summary Statistics</h2>
            <div class="metric">
                <div class="metric-value">{}</div>
                <div class="metric-label">Total Benchmarks</div>
            </div>
            <div class="metric">
                <div class="metric-value">{:.0}</div>
                <div class="metric-label">Avg Ops/Sec</div>
            </div>
            <div class="metric">
                <div class="metric-value">{:.2}</div>
                <div class="metric-label">Avg Latency (ns)</div>
            </div>
            <div class="metric">
                <div class="metric-value">{:.2}</div>
                <div class="metric-label">Avg Throughput (MB/s)</div>
            </div>
        </div>

        <h2>Performance by Category</h2>
        <div class="chart-container">
            <canvas id="categoryChart"></canvas>
        </div>

        <h2>Latency by Message Size</h2>
        <div class="chart-container">
            <canvas id="sizeChart"></canvas>
        </div>

        <h2>Throughput by Schema</h2>
        <div class="chart-container">
            <canvas id="throughputChart"></canvas>
        </div>

        <h2>Detailed Results</h2>
        <table>
            <thead>
                <tr>
                    <th>Benchmark</th>
                    <th>Category</th>
                    <th>Schema</th>
                    <th>Type</th>
                    <th>Size (bytes)</th>
                    <th>Ops/Sec</th>
                    <th>Latency (ns)</th>
                    <th>Throughput (MB/s)</th>
                </tr>
            </thead>
            <tbody>
                {}
            </tbody>
        </table>
    </div>

    <script>
        const results = {};

        const categoryData = {{}};
        results.forEach(r => {{
            if (!categoryData[r.category]) categoryData[r.category] = [];
            categoryData[r.category].push(r);
        }});

        const categoryLabels = Object.keys(categoryData);
        const categoryAvgOps = categoryLabels.map(cat => {{
            const ops = categoryData[cat].map(r => r.ops_per_sec);
            return ops.reduce((a, b) => a + b, 0) / ops.length;
        }});

        new Chart(document.getElementById('categoryChart'), {{
            type: 'bar',
            data: {{
                labels: categoryLabels,
                datasets: [{{
                    label: 'Average Ops/Sec',
                    data: categoryAvgOps,
                    backgroundColor: 'rgba(76, 175, 80, 0.6)',
                    borderColor: 'rgba(76, 175, 80, 1)',
                    borderWidth: 2
                }}]
            }},
            options: {{
                responsive: true,
                maintainAspectRatio: false,
                scales: {{
                    y: {{
                        beginAtZero: true,
                        title: {{ display: true, text: 'Operations per Second' }}
                    }}
                }}
            }}
        }});

        new Chart(document.getElementById('sizeChart'), {{
            type: 'scatter',
            data: {{
                datasets: [{{
                    label: 'Latency vs Size',
                    data: results.map(r => ({{ x: r.message_size_bytes, y: r.latency_ns }})),
                    backgroundColor: 'rgba(255, 99, 132, 0.6)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                }}]
            }},
            options: {{
                responsive: true,
                maintainAspectRatio: false,
                scales: {{
                    x: {{
                        type: 'logarithmic',
                        title: {{ display: true, text: 'Message Size (bytes)' }}
                    }},
                    y: {{
                        type: 'logarithmic',
                        title: {{ display: true, text: 'Latency (ns)' }}
                    }}
                }}
            }}
        }});

        const schemaData = {{}};
        results.forEach(r => {{
            if (!schemaData[r.schema]) schemaData[r.schema] = [];
            schemaData[r.schema].push(r);
        }});

        const schemaLabels = Object.keys(schemaData);
        const schemaAvgThroughput = schemaLabels.map(schema => {{
            const throughputs = schemaData[schema].map(r => r.throughput_mb_s);
            return throughputs.reduce((a, b) => a + b, 0) / throughputs.length;
        }});

        new Chart(document.getElementById('throughputChart'), {{
            type: 'bar',
            data: {{
                labels: schemaLabels,
                datasets: [{{
                    label: 'Average Throughput (MB/s)',
                    data: schemaAvgThroughput,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 2
                }}]
            }},
            options: {{
                responsive: true,
                maintainAspectRatio: false,
                scales: {{
                    y: {{
                        beginAtZero: true,
                        title: {{ display: true, text: 'Throughput (MB/s)' }}
                    }}
                }}
            }}
        }});
    </script>
</body>
</html>
"#,
        baseline.len(),
        baseline.iter().map(|r| r.ops_per_sec).sum::<f64>() / baseline.len() as f64,
        baseline.iter().map(|r| r.latency_ns).sum::<f64>() / baseline.len() as f64,
        baseline.iter().map(|r| r.throughput_mb_s).sum::<f64>() / baseline.len() as f64,
        baseline.iter().map(|r| format!(
            "<tr><td>{}</td><td>{}</td><td>{}</td><td>{}</td><td>{}</td><td>{:.0}</td><td>{:.2}</td><td>{:.2}</td></tr>",
            r.name, r.category, r.schema, r.message_type, r.message_size_bytes, r.ops_per_sec, r.latency_ns, r.throughput_mb_s
        )).collect::<String>(),
        serde_json::to_string(baseline).unwrap()
    );

    fs::write("results/advanced_report.html", html).ok();
    println!("\nAdvanced HTML report generated: results/advanced_report.html");

    let simple_html = generate_simple_comparison_table(baseline, comparisons, latency, cache, contention);
    fs::write("results/comparison_summary.html", simple_html).ok();
    println!("Comparison summary generated: results/comparison_summary.html");
}

fn generate_simple_comparison_table(
    baseline: &[BenchmarkResult],
    comparisons: &[ComparisonResult],
    latency: &[LatencyDistribution],
    cache: &[CacheEfficiencyResult],
    contention: &[ContentionResult],
) -> String {
    format!(r#"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Proto2FFI Performance Comparison Summary</title>
    <style>
        body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; padding: 20px; background: #f5f5f5; }}
        .container {{ max-width: 1400px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; }}
        h1 {{ color: #333; border-bottom: 3px solid #4CAF50; padding-bottom: 10px; }}
        h2 {{ color: #555; margin-top: 40px; border-bottom: 2px solid #ddd; padding-bottom: 8px; }}
        table {{ width: 100%; border-collapse: collapse; margin: 20px 0; }}
        th, td {{ padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }}
        th {{ background-color: #4CAF50; color: white; }}
        tr:hover {{ background-color: #f5f5f5; }}
        .winner {{ color: #4CAF50; font-weight: bold; }}
        .metric {{ display: inline-block; margin: 20px; padding: 20px; background: #f9f9f9; border-radius: 8px; min-width: 200px; }}
        .metric-value {{ font-size: 32px; font-weight: bold; color: #4CAF50; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>Proto2FFI Performance Comparison Summary</h1>

        <h2>Baseline Performance (Proto2FFI)</h2>
        <table>
            <tr><th>Benchmark</th><th>Category</th><th>Ops/Sec</th><th>Latency (ns)</th><th>Throughput (MB/s)</th></tr>
            {}
        </table>

        <h2>Comparison Benchmarks</h2>
        <table>
            <tr><th>Benchmark</th><th>Category</th><th>Ops/Sec</th><th>Latency (ns)</th></tr>
            {}
        </table>

        <h2>Latency Distribution (p50/p95/p99)</h2>
        <table>
            <tr><th>Benchmark</th><th>p50</th><th>p95</th><th>p99</th><th>p99.9</th><th>StdDev</th></tr>
            {}
        </table>

        <h2>Cache Efficiency</h2>
        <table>
            <tr><th>Benchmark</th><th>Ops/Sec</th><th>Latency (ns)</th><th>Bandwidth (MB/s)</th><th>Cache Util %</th></tr>
            {}
        </table>

        <h2>Contention & Scalability</h2>
        <table>
            <tr><th>Benchmark</th><th>Threads</th><th>Ops/Sec</th><th>Latency (ns)</th><th>Overhead %</th></tr>
            {}
        </table>
    </div>
</body>
</html>
"#,
        baseline.iter().take(10).map(|r| format!(
            "<tr><td>{}</td><td>{}</td><td>{:.0}</td><td>{:.2}</td><td>{:.2}</td></tr>",
            r.name, r.category, r.ops_per_sec, r.latency_ns, r.throughput_mb_s
        )).collect::<String>(),
        comparisons.iter().map(|r| format!(
            "<tr><td>{}</td><td>{}</td><td>{:.0}</td><td>{:.2}</td></tr>",
            r.name, r.category, r.ops_per_sec, r.latency_ns
        )).collect::<String>(),
        latency.iter().map(|r| format!(
            "<tr><td>{}</td><td>{:.2}</td><td>{:.2}</td><td>{:.2}</td><td>{:.2}</td><td>{:.2}</td></tr>",
            r.name, r.p50_ns, r.p95_ns, r.p99_ns, r.p999_ns, r.stddev_ns
        )).collect::<String>(),
        cache.iter().map(|r| format!(
            "<tr><td>{}</td><td>{:.0}</td><td>{:.2}</td><td>{:.2}</td><td>{:.2}</td></tr>",
            r.name, r.ops_per_sec, r.latency_ns, r.bandwidth_mb_s, r.cache_line_utilization
        )).collect::<String>(),
        contention.iter().map(|r| format!(
            "<tr><td>{}</td><td>{}</td><td>{:.0}</td><td>{:.2}</td><td>{:.2}</td></tr>",
            r.name, r.threads, r.ops_per_sec, r.avg_latency_ns, r.contention_overhead_percent
        )).collect::<String>()
    )
}
