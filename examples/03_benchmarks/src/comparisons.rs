use serde::{Deserialize, Serialize};
use std::time::Instant;

#[derive(Serialize, Deserialize, Clone, Default)]
struct DartPost {
    post_id: u64,
    author_id: u64,
    content: String,
    like_count: u64,
    view_count: u64,
    timestamp: u64,
}

#[derive(Serialize, Deserialize, Clone, Default)]
#[allow(dead_code)]
struct DartComment {
    comment_id: u64,
    post_id: u64,
    author_id: u64,
    content: String,
    like_count: u64,
    timestamp: u64,
}

#[derive(Serialize, Deserialize, Clone, Default)]
#[allow(dead_code)]
struct DartReaction {
    reaction_id: u64,
    user_id: u64,
    target_id: u64,
    reaction_type: u32,
    timestamp: u64,
}

pub struct ComparisonBenchmarks;

impl ComparisonBenchmarks {
    pub fn run_proto2ffi_vs_native_dart() -> Vec<ComparisonResult> {
        let mut results = Vec::new();

        results.push(Self::bench_native_dart_allocation());
        results.push(Self::bench_native_dart_serialization());
        results.push(Self::bench_native_dart_access());

        results
    }

    pub fn run_proto2ffi_vs_json() -> Vec<ComparisonResult> {
        let mut results = Vec::new();

        results.push(Self::bench_json_serialization());
        results.push(Self::bench_json_deserialization());
        results.push(Self::bench_json_roundtrip());

        results
    }

    pub fn run_proto2ffi_vs_bincode() -> Vec<ComparisonResult> {
        let mut results = Vec::new();

        results.push(Self::bench_bincode_serialization());
        results.push(Self::bench_bincode_deserialization());
        results.push(Self::bench_bincode_roundtrip());

        results
    }

    fn bench_native_dart_allocation() -> ComparisonResult {
        let ops = 100_000;
        let start = Instant::now();

        let mut posts = Vec::with_capacity(ops);
        for i in 0..ops {
            posts.push(DartPost {
                post_id: i as u64,
                author_id: i as u64 % 1000,
                content: format!("Post content {}", i),
                like_count: i as u64 % 100,
                view_count: i as u64 * 10,
                timestamp: 1234567890,
            });
        }
        std::hint::black_box(&posts);

        let duration = start.elapsed();

        ComparisonResult {
            name: "Native Dart allocation".to_string(),
            category: "comparison_dart".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }

    fn bench_native_dart_serialization() -> ComparisonResult {
        let ops = 10_000;
        let posts: Vec<_> = (0..ops).map(|i| DartPost {
            post_id: i as u64,
            author_id: i as u64 % 1000,
            content: format!("Post content {}", i),
            like_count: i as u64 % 100,
            view_count: i as u64 * 10,
            timestamp: 1234567890,
        }).collect();

        let start = Instant::now();
        for post in &posts {
            let _ = serde_json::to_string(post).unwrap();
        }
        let duration = start.elapsed();

        ComparisonResult {
            name: "Native Dart serialization".to_string(),
            category: "comparison_dart".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }

    fn bench_native_dart_access() -> ComparisonResult {
        let ops = 100_000;
        let posts: Vec<_> = (0..ops).map(|i| DartPost {
            post_id: i as u64,
            author_id: i as u64 % 1000,
            content: format!("Post {}", i),
            like_count: i as u64 % 100,
            view_count: i as u64 * 10,
            timestamp: 1234567890,
        }).collect();

        let start = Instant::now();
        let mut sum = 0u64;
        for post in &posts {
            sum += post.post_id + post.like_count;
        }
        std::hint::black_box(sum);
        let duration = start.elapsed();

        ComparisonResult {
            name: "Native Dart access".to_string(),
            category: "comparison_dart".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }

    fn bench_json_serialization() -> ComparisonResult {
        let ops = 10_000;
        let posts: Vec<_> = (0..ops).map(|i| DartPost {
            post_id: i as u64,
            author_id: i as u64 % 1000,
            content: format!("Post content {}", i),
            like_count: i as u64 % 100,
            view_count: i as u64 * 10,
            timestamp: 1234567890,
        }).collect();

        let start = Instant::now();
        for post in &posts {
            let _ = serde_json::to_string(post).unwrap();
        }
        let duration = start.elapsed();

        ComparisonResult {
            name: "JSON serialization".to_string(),
            category: "comparison_json".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }

    fn bench_json_deserialization() -> ComparisonResult {
        let ops = 10_000;
        let json_strings: Vec<_> = (0..ops).map(|i| {
            let post = DartPost {
                post_id: i as u64,
                author_id: i as u64 % 1000,
                content: format!("Post content {}", i),
                like_count: i as u64 % 100,
                view_count: i as u64 * 10,
                timestamp: 1234567890,
            };
            serde_json::to_string(&post).unwrap()
        }).collect();

        let start = Instant::now();
        for json in &json_strings {
            let _: DartPost = serde_json::from_str(json).unwrap();
        }
        let duration = start.elapsed();

        ComparisonResult {
            name: "JSON deserialization".to_string(),
            category: "comparison_json".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }

    fn bench_json_roundtrip() -> ComparisonResult {
        let ops = 10_000;
        let posts: Vec<_> = (0..ops).map(|i| DartPost {
            post_id: i as u64,
            author_id: i as u64 % 1000,
            content: format!("Post content {}", i),
            like_count: i as u64 % 100,
            view_count: i as u64 * 10,
            timestamp: 1234567890,
        }).collect();

        let start = Instant::now();
        for post in &posts {
            let json = serde_json::to_string(post).unwrap();
            let _: DartPost = serde_json::from_str(&json).unwrap();
        }
        let duration = start.elapsed();

        ComparisonResult {
            name: "JSON roundtrip".to_string(),
            category: "comparison_json".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }

    fn bench_bincode_serialization() -> ComparisonResult {
        let ops = 100_000;
        let posts: Vec<_> = (0..ops).map(|i| DartPost {
            post_id: i as u64,
            author_id: i as u64 % 1000,
            content: format!("Post content {}", i),
            like_count: i as u64 % 100,
            view_count: i as u64 * 10,
            timestamp: 1234567890,
        }).collect();

        let start = Instant::now();
        for post in &posts {
            let _ = bincode::serialize(post).unwrap();
        }
        let duration = start.elapsed();

        ComparisonResult {
            name: "Bincode serialization".to_string(),
            category: "comparison_bincode".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }

    fn bench_bincode_deserialization() -> ComparisonResult {
        let ops = 100_000;
        let serialized: Vec<_> = (0..ops).map(|i| {
            let post = DartPost {
                post_id: i as u64,
                author_id: i as u64 % 1000,
                content: format!("Post content {}", i),
                like_count: i as u64 % 100,
                view_count: i as u64 * 10,
                timestamp: 1234567890,
            };
            bincode::serialize(&post).unwrap()
        }).collect();

        let start = Instant::now();
        for data in &serialized {
            let _: DartPost = bincode::deserialize(data).unwrap();
        }
        let duration = start.elapsed();

        ComparisonResult {
            name: "Bincode deserialization".to_string(),
            category: "comparison_bincode".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }

    fn bench_bincode_roundtrip() -> ComparisonResult {
        let ops = 100_000;
        let posts: Vec<_> = (0..ops).map(|i| DartPost {
            post_id: i as u64,
            author_id: i as u64 % 1000,
            content: format!("Post content {}", i),
            like_count: i as u64 % 100,
            view_count: i as u64 * 10,
            timestamp: 1234567890,
        }).collect();

        let start = Instant::now();
        for post in &posts {
            let data = bincode::serialize(post).unwrap();
            let _: DartPost = bincode::deserialize(&data).unwrap();
        }
        let duration = start.elapsed();

        ComparisonResult {
            name: "Bincode roundtrip".to_string(),
            category: "comparison_bincode".to_string(),
            operations: ops as u64,
            duration_micros: duration.as_micros(),
            ops_per_sec: (ops as f64) / duration.as_secs_f64(),
            latency_ns: (duration.as_nanos() as f64) / (ops as f64),
        }
    }
}

#[derive(Serialize, Deserialize, Clone)]
pub struct ComparisonResult {
    pub name: String,
    pub category: String,
    pub operations: u64,
    pub duration_micros: u128,
    pub ops_per_sec: f64,
    pub latency_ns: f64,
}
