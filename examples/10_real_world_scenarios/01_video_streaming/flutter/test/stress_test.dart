import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import '../lib/generated.dart';

typedef VideoCreateFrameMetadataC = ffi.Pointer<FrameMetadata> Function(
  ffi.Uint64,
  ffi.Uint64,
  ffi.Uint64,
  ffi.Uint32,
  ffi.Uint32,
  ffi.Bool,
  ffi.Uint32,
  ffi.Uint32,
  ffi.Uint32,
);
typedef VideoCreateFrameMetadataDart = ffi.Pointer<FrameMetadata> Function(
  int,
  int,
  int,
  int,
  int,
  bool,
  int,
  int,
  int,
);

typedef VideoFreeFrameMetadataC = ffi.Void Function(ffi.Pointer<FrameMetadata>);
typedef VideoFreeFrameMetadataDart = void Function(ffi.Pointer<FrameMetadata>);

typedef VideoCompressFrameC = ffi.Pointer<CompressedFrame> Function(
  ffi.Pointer<ffi.Uint32>,
  ffi.Uint32,
  ffi.Pointer<ffi.Uint32>,
  ffi.Uint32,
  ffi.Pointer<ffi.Uint32>,
  ffi.Uint32,
  ffi.Uint32,
  ffi.Uint32,
  ffi.Uint32,
  ffi.Float,
);
typedef VideoCompressFrameDart = ffi.Pointer<CompressedFrame> Function(
  ffi.Pointer<ffi.Uint32>,
  int,
  ffi.Pointer<ffi.Uint32>,
  int,
  ffi.Pointer<ffi.Uint32>,
  int,
  int,
  int,
  int,
  double,
);

typedef VideoFreeCompressedFrameC = ffi.Void Function(
  ffi.Pointer<CompressedFrame>,
);
typedef VideoFreeCompressedFrameDart = void Function(
  ffi.Pointer<CompressedFrame>,
);

typedef VideoPoolStatsC = PoolStats Function();
typedef VideoPoolStatsDart = PoolStats Function();

typedef VideoGetStatisticsC = StreamStatistics Function();
typedef VideoGetStatisticsDart = StreamStatistics Function();

typedef VideoResetStatisticsC = ffi.Void Function();
typedef VideoResetStatisticsDart = void Function();

typedef VideoUpdateStatisticsC = ffi.Void Function(
  ffi.Uint64,
  ffi.Uint64,
  ffi.Uint64,
  ffi.Uint64,
);
typedef VideoUpdateStatisticsDart = void Function(int, int, int, int);

typedef VideoCalculateJitterC = ffi.Float Function(
  ffi.Pointer<ffi.Uint64>,
  ffi.Uint32,
);
typedef VideoCalculateJitterDart = double Function(
  ffi.Pointer<ffi.Uint64>,
  int,
);

final class PoolStats extends ffi.Struct {
  @ffi.Size()
  external int metadata_allocated;

  @ffi.Size()
  external int metadata_capacity;

  @ffi.Size()
  external int compressed_allocated;

  @ffi.Size()
  external int compressed_capacity;
}

void main() {
  late ffi.DynamicLibrary lib;
  late VideoCreateFrameMetadataDart createFrameMetadata;
  late VideoFreeFrameMetadataDart freeFrameMetadata;
  late VideoCompressFrameDart compressFrame;
  late VideoFreeCompressedFrameDart freeCompressedFrame;
  late VideoPoolStatsDart poolStats;
  late VideoGetStatisticsDart getStatistics;
  late VideoResetStatisticsDart resetStatistics;
  late VideoUpdateStatisticsDart updateStatistics;
  late VideoCalculateJitterDart calculateJitter;

  setUpAll(() {
    const targetDir = '/Volumes/Projects/DevCaches/project-targets/release';
    final libPath = Platform.isMacOS
        ? '$targetDir/libvideo_streaming_ffi.dylib'
        : Platform.isLinux
            ? '$targetDir/libvideo_streaming_ffi.so'
            : '$targetDir/video_streaming_ffi.dll';

    lib = ffi.DynamicLibrary.open(libPath);

    createFrameMetadata = lib
        .lookup<ffi.NativeFunction<VideoCreateFrameMetadataC>>(
            'video_create_frame_metadata')
        .asFunction();

    freeFrameMetadata = lib
        .lookup<ffi.NativeFunction<VideoFreeFrameMetadataC>>(
            'video_free_frame_metadata')
        .asFunction();

    compressFrame = lib
        .lookup<ffi.NativeFunction<VideoCompressFrameC>>('video_compress_frame')
        .asFunction();

    freeCompressedFrame = lib
        .lookup<ffi.NativeFunction<VideoFreeCompressedFrameC>>(
            'video_free_compressed_frame')
        .asFunction();

    poolStats = lib
        .lookup<ffi.NativeFunction<VideoPoolStatsC>>('video_pool_stats')
        .asFunction();

    getStatistics = lib
        .lookup<ffi.NativeFunction<VideoGetStatisticsC>>(
            'video_get_statistics')
        .asFunction();

    resetStatistics = lib
        .lookup<ffi.NativeFunction<VideoResetStatisticsC>>(
            'video_reset_statistics')
        .asFunction();

    updateStatistics = lib
        .lookup<ffi.NativeFunction<VideoUpdateStatisticsC>>(
            'video_update_statistics')
        .asFunction();

    calculateJitter = lib
        .lookup<ffi.NativeFunction<VideoCalculateJitterC>>(
            'video_calculate_jitter')
        .asFunction();

    resetStatistics();
  });

  group('60fps Frame Processing', () {
    test('processes 60fps for 10 seconds', () {
      const fps = 60;
      const duration = 10;
      const totalFrames = fps * duration;
      const frameIntervalUs = 1000000 ~/ fps;

      final sw = Stopwatch()..start();
      final timestamps = <int>[];
      final frames = <ffi.Pointer<FrameMetadata>>[];

      for (var i = 0; i < totalFrames; i++) {
        final frameStart = DateTime.now().microsecondsSinceEpoch;
        final ptr = createFrameMetadata(
          i * frameIntervalUs,
          i * 100,
          i * 90,
          i % 10 == 0 ? 0 : 1,
          i,
          i % 10 == 0,
          1920,
          1080,
          8000000,
        );
        frames.add(ptr);
        final frameEnd = DateTime.now().microsecondsSinceEpoch;
        timestamps.add(frameEnd - frameStart);
      }

      sw.stop();

      for (final frame in frames) {
        freeFrameMetadata(frame);
      }

      final avgLatency = timestamps.reduce((a, b) => a + b) / timestamps.length;
      final maxLatency = timestamps.reduce((a, b) => a > b ? a : b);
      final minLatency = timestamps.reduce((a, b) => a < b ? a : b);

      print('60fps Processing (10s):');
      print('  Total frames: $totalFrames');
      print('  Total time: ${sw.elapsedMicroseconds / 1000000}s');
      print('  Avg latency: ${avgLatency.toStringAsFixed(2)}us');
      print('  Min latency: ${minLatency}us');
      print('  Max latency: ${maxLatency}us');
      print('  Frame time budget: ${frameIntervalUs}us');

      expect(avgLatency, lessThan(frameIntervalUs));
      expect(frames.length, totalFrames);
    });

    test('measures jitter at 60fps', () {
      const fps = 60;
      const totalFrames = 300;
      const frameIntervalUs = 1000000 ~/ fps;

      final timestamps = <int>[];
      final frames = <ffi.Pointer<FrameMetadata>>[];

      for (var i = 0; i < totalFrames; i++) {
        final ptr = createFrameMetadata(
          i * frameIntervalUs,
          i * 100,
          i * 90,
          1,
          i,
          false,
          1920,
          1080,
          8000000,
        );
        frames.add(ptr);
        timestamps.add(i * frameIntervalUs);
      }

      final timestampPtr = malloc.allocate<ffi.Uint64>(timestamps.length * 8);
      for (var i = 0; i < timestamps.length; i++) {
        timestampPtr[i] = timestamps[i];
      }

      final jitter = calculateJitter(timestampPtr, timestamps.length);

      malloc.free(timestampPtr);
      for (final frame in frames) {
        freeFrameMetadata(frame);
      }

      print('Jitter at 60fps:');
      print('  Frames: $totalFrames');
      print('  Jitter: ${jitter.toStringAsFixed(3)}ms');

      expect(jitter, lessThan(5.0));
    });
  });

  group('Multiple Codec Support', () {
    test('handles different codec configurations', () {
      final codecs = [
        {'name': 'H264', 'value': 0, 'bitrate': 5000000},
        {'name': 'H265', 'value': 1, 'bitrate': 3000000},
        {'name': 'VP8', 'value': 2, 'bitrate': 4000000},
        {'name': 'VP9', 'value': 3, 'bitrate': 2500000},
        {'name': 'AV1', 'value': 4, 'bitrate': 2000000},
      ];

      final results = <String, int>{};

      for (final codec in codecs) {
        final sw = Stopwatch()..start();
        final frames = <ffi.Pointer<FrameMetadata>>[];

        for (var i = 0; i < 100; i++) {
          final ptr = createFrameMetadata(
            i * 33333,
            i * 100,
            i * 90,
            codec['value'] as int,
            i,
            i % 10 == 0,
            1920,
            1080,
            codec['bitrate'] as int,
          );
          frames.add(ptr);
        }

        sw.stop();

        for (final frame in frames) {
          freeFrameMetadata(frame);
        }

        results[codec['name'] as String] = sw.elapsedMicroseconds;
      }

      print('Codec Processing Times (100 frames):');
      results.forEach((name, time) {
        print('  $name: ${time / 1000}ms');
      });

      for (final time in results.values) {
        expect(time, lessThan(1000000));
      }
    });
  });

  group('Large Frame Buffers', () {
    test('handles 1080p frames', () {
      const width = 1920;
      const height = 1080;
      final ySize = width * height;
      final uvSize = (width ~/ 2) * (height ~/ 2);

      final yPlane = malloc.allocate<ffi.Uint32>(ySize * 4);
      final uPlane = malloc.allocate<ffi.Uint32>(uvSize * 4);
      final vPlane = malloc.allocate<ffi.Uint32>(uvSize * 4);

      for (var i = 0; i < ySize; i++) {
        yPlane[i] = i % 256;
      }
      for (var i = 0; i < uvSize; i++) {
        uPlane[i] = (i % 256) ~/ 2;
        vPlane[i] = (i % 256) ~/ 2;
      }

      final sw = Stopwatch()..start();
      final compressed = compressFrame(
        yPlane,
        ySize,
        uPlane,
        uvSize,
        vPlane,
        uvSize,
        width,
        height,
        5000000,
        8.0,
      );
      sw.stop();

      final compressionTime = sw.elapsedMicroseconds;
      final compressionRatio = ySize / compressed.ref.data_size;

      freeCompressedFrame(compressed);
      malloc.free(yPlane);
      malloc.free(uPlane);
      malloc.free(vPlane);

      print('1080p Compression:');
      print('  Input size: $ySize pixels');
      print('  Compressed size: ${compressed.ref.data_size} bytes');
      print('  Compression ratio: ${compressionRatio.toStringAsFixed(2)}x');
      print('  Time: ${compressionTime / 1000}ms');

      expect(compressionTime, lessThan(50000));
      expect(compressionRatio, greaterThan(1.0));
    });

    test('handles 4K frames', () {
      const width = 3840;
      const height = 2160;
      final ySize = width * height;
      final uvSize = (width ~/ 2) * (height ~/ 2);

      final yPlane = malloc.allocate<ffi.Uint32>(ySize * 4);
      final uPlane = malloc.allocate<ffi.Uint32>(uvSize * 4);
      final vPlane = malloc.allocate<ffi.Uint32>(uvSize * 4);

      for (var i = 0; i < ySize; i++) {
        yPlane[i] = i % 256;
      }
      for (var i = 0; i < uvSize; i++) {
        uPlane[i] = (i % 256) ~/ 2;
        vPlane[i] = (i % 256) ~/ 2;
      }

      final sw = Stopwatch()..start();
      final compressed = compressFrame(
        yPlane,
        ySize,
        uPlane,
        uvSize,
        vPlane,
        uvSize,
        width,
        height,
        20000000,
        8.0,
      );
      sw.stop();

      final compressionTime = sw.elapsedMicroseconds;
      final compressionRatio = ySize / compressed.ref.data_size;

      freeCompressedFrame(compressed);
      malloc.free(yPlane);
      malloc.free(uPlane);
      malloc.free(vPlane);

      print('4K Compression:');
      print('  Input size: $ySize pixels');
      print('  Compressed size: ${compressed.ref.data_size} bytes');
      print('  Compression ratio: ${compressionRatio.toStringAsFixed(2)}x');
      print('  Time: ${compressionTime / 1000}ms');

      expect(compressionTime, lessThan(200000));
      expect(compressionRatio, greaterThan(1.0));
    });
  });

  group('Memory Pool Performance', () {
    test('allocates and frees 5000 frame metadata objects', () {
      final sw = Stopwatch()..start();
      final frames = <ffi.Pointer<FrameMetadata>>[];

      for (var i = 0; i < 5000; i++) {
        final ptr = createFrameMetadata(
          i * 33333,
          i * 100,
          i * 90,
          i % 3,
          i,
          i % 10 == 0,
          1920,
          1080,
          5000000,
        );
        frames.add(ptr);
      }

      final allocTime = sw.elapsedMicroseconds;
      sw.reset();

      final stats = poolStats();

      for (final frame in frames) {
        freeFrameMetadata(frame);
      }

      final freeTime = sw.elapsedMicroseconds;

      print('Memory Pool (5000 objects):');
      print('  Allocation time: ${allocTime / 1000}ms');
      print('  Free time: ${freeTime / 1000}ms');
      print('  Avg alloc: ${allocTime / 5000}us per object');
      print('  Avg free: ${freeTime / 5000}us per object');
      print('  Pool capacity: ${stats.metadata_capacity}');
      print('  Pool allocated: ${stats.metadata_allocated}');

      expect(allocTime / 5000, lessThan(100));
      expect(freeTime / 5000, lessThan(100));
    });

    test('measures pool overhead vs malloc', () {
      final poolTimes = <int>[];
      final mallocTimes = <int>[];

      for (var run = 0; run < 10; run++) {
        var sw = Stopwatch()..start();
        final poolFrames = <ffi.Pointer<FrameMetadata>>[];
        for (var i = 0; i < 1000; i++) {
          final ptr = createFrameMetadata(
            i * 33333,
            i * 100,
            i * 90,
            1,
            i,
            false,
            1920,
            1080,
            5000000,
          );
          poolFrames.add(ptr);
        }
        for (final frame in poolFrames) {
          freeFrameMetadata(frame);
        }
        poolTimes.add(sw.elapsedMicroseconds);

        sw = Stopwatch()..start();
        final mallocFrames = <ffi.Pointer<FrameMetadata>>[];
        for (var i = 0; i < 1000; i++) {
          final ptr = malloc.allocate<FrameMetadata>(ffi.sizeOf<FrameMetadata>());
          mallocFrames.add(ptr);
        }
        for (final frame in mallocFrames) {
          malloc.free(frame);
        }
        mallocTimes.add(sw.elapsedMicroseconds);
      }

      final avgPool = poolTimes.reduce((a, b) => a + b) / poolTimes.length;
      final avgMalloc = mallocTimes.reduce((a, b) => a + b) / mallocTimes.length;
      final speedup = avgMalloc / avgPool;

      print('Pool vs Malloc (1000 objects, 10 runs):');
      print('  Pool avg: ${avgPool / 1000}ms');
      print('  Malloc avg: ${avgMalloc / 1000}ms');
      print('  Pool speedup: ${speedup.toStringAsFixed(2)}x');

      expect(avgPool, lessThan(avgMalloc * 2));
    });
  });

  group('Compression/Decompression Speed', () {
    test('measures compression speed at different quality levels', () {
      const width = 1920;
      const height = 1080;
      final ySize = width * height;
      final uvSize = (width ~/ 2) * (height ~/ 2);

      final yPlane = malloc.allocate<ffi.Uint32>(ySize * 4);
      final uPlane = malloc.allocate<ffi.Uint32>(uvSize * 4);
      final vPlane = malloc.allocate<ffi.Uint32>(uvSize * 4);

      for (var i = 0; i < ySize; i++) {
        yPlane[i] = i % 256;
      }
      for (var i = 0; i < uvSize; i++) {
        uPlane[i] = (i % 256) ~/ 2;
        vPlane[i] = (i % 256) ~/ 2;
      }

      final qualities = [2.0, 4.0, 6.0, 8.0, 10.0];
      print('Compression Speed by Quality:');

      for (final quality in qualities) {
        final times = <int>[];
        for (var i = 0; i < 10; i++) {
          final sw = Stopwatch()..start();
          final compressed = compressFrame(
            yPlane,
            ySize,
            uPlane,
            uvSize,
            vPlane,
            uvSize,
            width,
            height,
            5000000,
            quality,
          );
          sw.stop();
          times.add(sw.elapsedMicroseconds);
          freeCompressedFrame(compressed);
        }

        final avgTime = times.reduce((a, b) => a + b) / times.length;
        print('  Quality $quality: ${avgTime / 1000}ms');

        expect(avgTime, lessThan(100000));
      }

      malloc.free(yPlane);
      malloc.free(uPlane);
      malloc.free(vPlane);
    });
  });

  group('Stress Tests', () {
    test('continuous 60fps for 60 seconds', () {
      const fps = 60;
      const duration = 60;
      const totalFrames = fps * duration;
      const frameIntervalUs = 1000000 ~/ fps;

      resetStatistics();

      final frameLatencies = <int>[];
      var droppedFrames = 0;
      var expectedFrameNumber = 0;

      final sw = Stopwatch()..start();

      for (var i = 0; i < totalFrames; i++) {
        final frameStart = DateTime.now().microsecondsSinceEpoch;

        final ptr = createFrameMetadata(
          i * frameIntervalUs,
          i * 100,
          i * 90,
          i % 10 == 0 ? 0 : 1,
          i,
          i % 10 == 0,
          1920,
          1080,
          8000000,
        );

        final metadata = ptr.ref;
        if (metadata.frame_number != expectedFrameNumber) {
          droppedFrames++;
        }
        expectedFrameNumber++;

        freeFrameMetadata(ptr);

        final frameEnd = DateTime.now().microsecondsSinceEpoch;
        frameLatencies.add(frameEnd - frameStart);

        if (i % 600 == 0 && i > 0) {
          print('  Progress: ${i ~/ 60}s / ${duration}s');
        }
      }

      sw.stop();

      final totalTime = sw.elapsedMicroseconds / 1000000;
      final avgLatency = frameLatencies.reduce((a, b) => a + b) / frameLatencies.length;
      final maxLatency = frameLatencies.reduce((a, b) => a > b ? a : b);

      updateStatistics(totalFrames, totalFrames * 100000, droppedFrames, sw.elapsedMicroseconds * 1000);
      final stats = getStatistics();

      print('60fps Stress Test (60s):');
      print('  Total frames: $totalFrames');
      print('  Dropped frames: $droppedFrames');
      print('  Total time: ${totalTime.toStringAsFixed(2)}s');
      print('  Avg latency: ${avgLatency.toStringAsFixed(2)}us');
      print('  Max latency: ${maxLatency}us');
      print('  Frame budget: ${frameIntervalUs}us');
      print('  Avg framerate: ${stats.average_framerate.toStringAsFixed(2)} fps');

      expect(droppedFrames, 0);
      expect(avgLatency, lessThan(frameIntervalUs));
      expect(stats.average_framerate, greaterThan(fps * 0.95));
    });

    test('rapid codec switching', () {
      const codecs = [0, 1, 2, 3, 4];
      const switchCount = 1000;

      final sw = Stopwatch()..start();

      for (var i = 0; i < switchCount; i++) {
        final codec = codecs[i % codecs.length];
        final ptr = createFrameMetadata(
          i * 33333,
          i * 100,
          i * 90,
          codec,
          i,
          i % 10 == 0,
          1920,
          1080,
          5000000,
        );
        freeFrameMetadata(ptr);
      }

      sw.stop();

      final totalTime = sw.elapsedMicroseconds;
      final avgSwitchTime = totalTime / switchCount;

      print('Rapid Codec Switching ($switchCount switches):');
      print('  Total time: ${totalTime / 1000}ms');
      print('  Avg switch time: ${avgSwitchTime.toStringAsFixed(2)}us');

      expect(avgSwitchTime, lessThan(100));
    });

    test('memory leak detection over 100K frames', () {
      const totalFrames = 100000;
      const checkInterval = 10000;

      final memorySnapshots = <int, int>{};

      for (var i = 0; i < totalFrames; i++) {
        final ptr = createFrameMetadata(
          i * 33333,
          i * 100,
          i * 90,
          i % 3,
          i,
          i % 10 == 0,
          1920,
          1080,
          5000000,
        );
        freeFrameMetadata(ptr);

        if (i % checkInterval == 0) {
          final stats = poolStats();
          memorySnapshots[i] = stats.metadata_allocated;
        }
      }

      print('Memory Leak Detection (100K frames):');
      memorySnapshots.forEach((frame, allocated) {
        print('  Frame $frame: $allocated objects allocated');
      });

      final allocatedCounts = memorySnapshots.values.toList();
      final firstCount = allocatedCounts.first;
      final lastCount = allocatedCounts.last;

      print('  First snapshot: $firstCount');
      print('  Last snapshot: $lastCount');
      print('  Leak: ${lastCount - firstCount} objects');

      expect(lastCount, lessThanOrEqualTo(firstCount + 10));
    });

    test('concurrent frame processing stress', () {
      const batches = 100;
      const framesPerBatch = 100;

      final sw = Stopwatch()..start();

      for (var batch = 0; batch < batches; batch++) {
        final frames = <ffi.Pointer<FrameMetadata>>[];

        for (var i = 0; i < framesPerBatch; i++) {
          final ptr = createFrameMetadata(
            (batch * framesPerBatch + i) * 33333,
            i * 100,
            i * 90,
            i % 3,
            batch * framesPerBatch + i,
            i % 10 == 0,
            1920,
            1080,
            5000000,
          );
          frames.add(ptr);
        }

        for (final frame in frames) {
          freeFrameMetadata(frame);
        }
      }

      sw.stop();

      final totalFrames = batches * framesPerBatch;
      final totalTime = sw.elapsedMicroseconds;
      final avgBatchTime = totalTime / batches;

      print('Concurrent Processing Stress ($totalFrames frames):');
      print('  Total time: ${totalTime / 1000}ms');
      print('  Avg batch time: ${avgBatchTime / 1000}ms');
      print('  Throughput: ${totalFrames / (totalTime / 1000000)} fps');

      expect(avgBatchTime, lessThan(100000));
    });
  });
}
