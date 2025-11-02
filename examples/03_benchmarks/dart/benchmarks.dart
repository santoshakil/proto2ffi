import 'dart:ffi' as ffi;
import 'dart:io';
import 'generated.dart';
import 'package:ffi/ffi.dart';

class BenchmarkResult {
  final String name;
  final String category;
  final String schema;
  final String messageType;
  final int messageSizeBytes;
  final int operations;
  final Duration duration;
  final double opsPerSec;
  final double latencyNs;
  final double throughputMbS;

  BenchmarkResult({
    required this.name,
    required this.category,
    required this.schema,
    required this.messageType,
    required this.messageSizeBytes,
    required this.operations,
    required this.duration,
  })  : opsPerSec = operations / duration.inMicroseconds * 1000000,
        latencyNs = duration.inMicroseconds * 1000 / operations,
        throughputMbS = (operations * messageSizeBytes) /
            duration.inMicroseconds /
            1.048576;

  @override
  String toString() {
    return '$name: ${opsPerSec.toStringAsFixed(0)} ops/s, ${latencyNs.toStringAsFixed(2)} ns/op, ${throughputMbS.toStringAsFixed(2)} MB/s';
  }
}

class BenchmarkSuite {
  final List<BenchmarkResult> results = [];

  void bench(
    String name,
    String category,
    String schema,
    String messageType,
    int messageSize,
    int operations,
    void Function() fn,
  ) {
    print('Running: $name ($category / $schema / $messageType)');

    final sw = Stopwatch()..start();
    fn();
    sw.stop();

    final result = BenchmarkResult(
      name: name,
      category: category,
      schema: schema,
      messageType: messageType,
      messageSizeBytes: messageSize,
      operations: operations,
      duration: sw.elapsed,
    );

    print(
        '  $operations ops in ${sw.elapsedMicroseconds}μs = ${result.opsPerSec.toStringAsFixed(0)} ops/sec (${result.latencyNs.toStringAsFixed(2)}ns/op, ${result.throughputMbS.toStringAsFixed(2)} MB/s)');

    results.add(result);
  }

  void report() {
    print('\n=== BENCHMARK SUMMARY ===\n');
    print(
        '${'Benchmark'.padRight(60)} ${'Size'.padRight(15)} ${'Ops/Sec'.padLeft(15)} ${'Latency(ns)'.padLeft(15)} ${'MB/s'.padLeft(15)}');
    print('-' * 120);

    for (final r in results) {
      print(
          '${r.name.padRight(60)} ${r.messageSizeBytes.toString().padRight(15)} ${r.opsPerSec.toStringAsFixed(0).padLeft(15)} ${r.latencyNs.toStringAsFixed(2).padLeft(15)} ${r.throughputMbS.toStringAsFixed(2).padLeft(15)}');
    }

    _printCategoryComparison();
    _printSizeAnalysis();
  }

  void _printCategoryComparison() {
    print('\n=== CATEGORY PERFORMANCE COMPARISON ===\n');

    final categories = <String, List<BenchmarkResult>>{};
    for (final r in results) {
      categories.putIfAbsent(r.category, () => []).add(r);
    }

    for (final entry in categories.entries) {
      final avgOps =
          entry.value.map((r) => r.opsPerSec).reduce((a, b) => a + b) /
              entry.value.length;
      final avgLatency =
          entry.value.map((r) => r.latencyNs).reduce((a, b) => a + b) /
              entry.value.length;
      final avgThroughput =
          entry.value.map((r) => r.throughputMbS).reduce((a, b) => a + b) /
              entry.value.length;

      print(
          '${entry.key.padRight(30)} ${avgOps.toStringAsFixed(0).padLeft(15)} ops/s | ${avgLatency.toStringAsFixed(2).padLeft(10)} ns | ${avgThroughput.toStringAsFixed(2).padLeft(10)} MB/s');
    }
  }

  void _printSizeAnalysis() {
    print('\n=== MESSAGE SIZE IMPACT ===\n');

    final buckets = <String, List<BenchmarkResult>>{};
    for (final r in results) {
      final bucket = switch (r.messageSizeBytes) {
        <= 100 => 'Small (<100B)',
        <= 1024 => 'Medium (100B-1KB)',
        <= 10240 => 'Large (1KB-10KB)',
        _ => 'Huge (>10KB)',
      };
      buckets.putIfAbsent(bucket, () => []).add(r);
    }

    for (final entry in buckets.entries) {
      final avgOps =
          entry.value.map((r) => r.opsPerSec).reduce((a, b) => a + b) /
              entry.value.length;
      final avgLatency =
          entry.value.map((r) => r.latencyNs).reduce((a, b) => a + b) /
              entry.value.length;

      print(
          '${entry.key.padRight(20)} ${avgOps.toStringAsFixed(0).padLeft(15)} ops/s | ${avgLatency.toStringAsFixed(2).padLeft(10)} ns/op');
    }
  }
}

void main() {
  print('Proto2FFI Dart Benchmark Suite\n');
  print('Testing: Social Media Schema (Dart FFI)\n');

  final suite = BenchmarkSuite();

  runSocialMediaBenchmarks(suite);
  runAllocationBenchmarks(suite);
  runFfiOverheadBenchmarks(suite);
  runRoundtripBenchmarks(suite);
  runThroughputBenchmarks(suite);

  suite.report();
}

void runSocialMediaBenchmarks(BenchmarkSuite suite) {
  print('\n=== SOCIAL MEDIA SCHEMA BENCHMARKS ===\n');

  suite.bench(
    'Post allocation (Dart)',
    'allocation',
    'social_media',
    'Post',
    POST_SIZE,
    10000,
    () {
      final posts = <ffi.Pointer<Post>>[];
      for (var i = 0; i < 10000; i++) {
        final p = Post.allocate();
        p.ref.post_id = i;
        p.ref.author_id = i % 1000;
        posts.add(p);
      }
      for (final p in posts) {
        calloc.free(p);
      }
    },
  );

  suite.bench(
    'Comment allocation (Dart)',
    'allocation',
    'social_media',
    'Comment',
    COMMENT_SIZE,
    50000,
    () {
      final comments = <ffi.Pointer<Comment>>[];
      for (var i = 0; i < 50000; i++) {
        final c = Comment.allocate();
        c.ref.comment_id = i;
        c.ref.post_id = i ~/ 10;
        comments.add(c);
      }
      for (final c in comments) {
        calloc.free(c);
      }
    },
  );

  suite.bench(
    'Reaction allocation (Dart)',
    'allocation',
    'social_media',
    'Reaction',
    REACTION_SIZE,
    100000,
    () {
      final reactions = <ffi.Pointer<Reaction>>[];
      for (var i = 0; i < 100000; i++) {
        final r = Reaction.allocate();
        r.ref.reaction_id = i;
        r.ref.user_id = i % 10000;
        reactions.add(r);
      }
      for (final r in reactions) {
        calloc.free(r);
      }
    },
  );
}

void runAllocationBenchmarks(BenchmarkSuite suite) {
  print('\n=== ALLOCATION PATTERN BENCHMARKS ===\n');

  suite.bench(
    'Calloc allocation - small',
    'memory',
    'generic',
    'Reaction',
    REACTION_SIZE,
    50000,
    () {
      final items = <ffi.Pointer<Reaction>>[];
      for (var i = 0; i < 50000; i++) {
        items.add(calloc<Reaction>());
      }
      for (final item in items) {
        calloc.free(item);
      }
    },
  );

  suite.bench(
    'Calloc allocation - medium',
    'memory',
    'generic',
    'UserProfile',
    USERPROFILE_SIZE,
    10000,
    () {
      final items = <ffi.Pointer<UserProfile>>[];
      for (var i = 0; i < 10000; i++) {
        items.add(calloc<UserProfile>());
      }
      for (final item in items) {
        calloc.free(item);
      }
    },
  );

  suite.bench(
    'Calloc allocation - large',
    'memory',
    'generic',
    'Post',
    POST_SIZE,
    5000,
    () {
      final items = <ffi.Pointer<Post>>[];
      for (var i = 0; i < 5000; i++) {
        items.add(calloc<Post>());
      }
      for (final item in items) {
        calloc.free(item);
      }
    },
  );
}

void runFfiOverheadBenchmarks(BenchmarkSuite suite) {
  print('\n=== FFI OVERHEAD BENCHMARKS ===\n');

  final bindings = FFIBindings();

  suite.bench(
    'FFI call - size query',
    'ffi',
    'generic',
    'UserProfile',
    USERPROFILE_SIZE,
    1000000,
    () {
      for (var i = 0; i < 1000000; i++) {
        final _ = bindings.userprofile_size();
      }
    },
  );

  suite.bench(
    'FFI call - alignment query',
    'ffi',
    'generic',
    'UserProfile',
    USERPROFILE_SIZE,
    1000000,
    () {
      for (var i = 0; i < 1000000; i++) {
        final _ = bindings.userprofile_alignment();
      }
    },
  );
}

void runRoundtripBenchmarks(BenchmarkSuite suite) {
  print('\n=== ROUNDTRIP BENCHMARKS ===\n');

  suite.bench(
    'Roundtrip - small struct (Reaction)',
    'roundtrip',
    'social_media',
    'Reaction',
    REACTION_SIZE,
    100000,
    () {
      for (var i = 0; i < 100000; i++) {
        final r = Reaction.allocate();
        r.ref.reaction_id = i;
        r.ref.user_id = i % 1000;
        r.ref.target_id = i ~/ 10;
        final id = r.ref.reaction_id;
        calloc.free(r);
      }
    },
  );

  suite.bench(
    'Roundtrip - medium struct (Comment)',
    'roundtrip',
    'social_media',
    'Comment',
    COMMENT_SIZE,
    50000,
    () {
      for (var i = 0; i < 50000; i++) {
        final c = Comment.allocate();
        c.ref.comment_id = i;
        c.ref.post_id = i ~/ 10;
        c.ref.like_count = i % 100;
        final id = c.ref.comment_id;
        calloc.free(c);
      }
    },
  );

  suite.bench(
    'Roundtrip - large struct (Post)',
    'roundtrip',
    'social_media',
    'Post',
    POST_SIZE,
    10000,
    () {
      for (var i = 0; i < 10000; i++) {
        final p = Post.allocate();
        p.ref.post_id = i;
        p.ref.author_id = i % 1000;
        p.ref.like_count = i % 500;
        final id = p.ref.post_id;
        calloc.free(p);
      }
    },
  );
}

void runThroughputBenchmarks(BenchmarkSuite suite) {
  print('\n=== THROUGHPUT BENCHMARKS ===\n');

  suite.bench(
    'Bulk post processing',
    'throughput',
    'social_media',
    'Post',
    POST_SIZE,
    10000,
    () {
      final posts = <ffi.Pointer<Post>>[];
      for (var i = 0; i < 10000; i++) {
        final p = Post.allocate();
        p.ref.post_id = i;
        p.ref.like_count = i % 100;
        p.ref.view_count = i * 10;
        posts.add(p);
      }

      for (final p in posts) {
        p.ref.like_count += 1;
        p.ref.view_count += 10;
      }

      for (final p in posts) {
        calloc.free(p);
      }
    },
  );

  suite.bench(
    'Bulk reaction processing',
    'throughput',
    'social_media',
    'Reaction',
    REACTION_SIZE,
    100000,
    () {
      final reactions = <ffi.Pointer<Reaction>>[];
      for (var i = 0; i < 100000; i++) {
        final r = Reaction.allocate();
        r.ref.reaction_id = i;
        r.ref.user_id = i % 10000;
        reactions.add(r);
      }

      var sum = 0;
      for (final r in reactions) {
        sum += r.ref.reaction_id;
      }

      for (final r in reactions) {
        calloc.free(r);
      }
    },
  );
}
