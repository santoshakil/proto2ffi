import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import '../lib/generated.dart';

typedef VideoCreateFrameMetadataC = ffi.Pointer<FrameMetadata> Function(
  ffi.Uint64 timestampUs,
  ffi.Uint64 pts,
  ffi.Uint64 dts,
  ffi.Uint32 frameType,
  ffi.Uint32 frameNumber,
  ffi.Bool isKeyframe,
  ffi.Uint32 width,
  ffi.Uint32 height,
  ffi.Uint32 bitrate,
);
typedef VideoCreateFrameMetadataDart = ffi.Pointer<FrameMetadata> Function(
  int timestampUs,
  int pts,
  int dts,
  int frameType,
  int frameNumber,
  bool isKeyframe,
  int width,
  int height,
  int bitrate,
);

typedef VideoFreeFrameMetadataC = ffi.Void Function(ffi.Pointer<FrameMetadata>);
typedef VideoFreeFrameMetadataDart = void Function(ffi.Pointer<FrameMetadata>);

typedef VideoCalculateBitrateC = ffi.Uint32 Function(ffi.Uint32, ffi.Uint64);
typedef VideoCalculateBitrateDart = int Function(int, int);

typedef VideoSyncTimestampsC = TimestampSync Function(
  ffi.Uint64,
  ffi.Uint64,
  ffi.Uint64,
  ffi.Uint64,
);
typedef VideoSyncTimestampsDart = TimestampSync Function(int, int, int, int);

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

typedef VideoDetectFrameDropC = ffi.Bool Function(ffi.Uint32, ffi.Uint32);
typedef VideoDetectFrameDropDart = bool Function(int, int);

void main() {
  late ffi.DynamicLibrary lib;
  late VideoCreateFrameMetadataDart createFrameMetadata;
  late VideoFreeFrameMetadataDart freeFrameMetadata;
  late VideoCalculateBitrateDart calculateBitrate;
  late VideoSyncTimestampsDart syncTimestamps;
  late VideoGetStatisticsDart getStatistics;
  late VideoResetStatisticsDart resetStatistics;
  late VideoUpdateStatisticsDart updateStatistics;
  late VideoCalculateJitterDart calculateJitter;
  late VideoDetectFrameDropDart detectFrameDrop;

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

    calculateBitrate = lib
        .lookup<ffi.NativeFunction<VideoCalculateBitrateC>>(
            'video_calculate_bitrate')
        .asFunction();

    syncTimestamps = lib
        .lookup<ffi.NativeFunction<VideoSyncTimestampsC>>(
            'video_sync_timestamps')
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

    detectFrameDrop = lib
        .lookup<ffi.NativeFunction<VideoDetectFrameDropC>>(
            'video_detect_frame_drop')
        .asFunction();

    resetStatistics();
  });

  group('Frame Metadata', () {
    test('creates and frees frame metadata', () {
      final ptr = createFrameMetadata(
        1000000,
        100,
        90,
        0,
        1,
        true,
        1920,
        1080,
        5000000,
      );

      expect(ptr.address, isNot(0));

      final metadata = ptr.ref;
      expect(metadata.timestamp_us, 1000000);
      expect(metadata.pts, 100);
      expect(metadata.dts, 90);
      expect(metadata.frame_type, 0);
      expect(metadata.frame_number, 1);
      expect(metadata.keyframe, 1);
      expect(metadata.width, 1920);
      expect(metadata.height, 1080);
      expect(metadata.bitrate, 5000000);

      freeFrameMetadata(ptr);
    });

    test('creates multiple frames from pool', () {
      final frames = <ffi.Pointer<FrameMetadata>>[];

      for (var i = 0; i < 100; i++) {
        final ptr = createFrameMetadata(
          1000000 + i * 33333,
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
        expect(ptr.ref.frame_number, i);
      }

      for (final frame in frames) {
        freeFrameMetadata(frame);
      }
    });
  });

  group('Bitrate Calculation', () {
    test('calculates bitrate correctly', () {
      final bitrate = calculateBitrate(125000, 1000000);
      expect(bitrate, 1000000);
    });

    test('handles zero duration', () {
      final bitrate = calculateBitrate(125000, 0);
      expect(bitrate, 0);
    });

    test('calculates for different frame sizes', () {
      final bitrate1 = calculateBitrate(250000, 1000000);
      expect(bitrate1, 2000000);

      final bitrate2 = calculateBitrate(500000, 2000000);
      expect(bitrate2, 2000000);
    });
  });

  group('Timestamp Synchronization', () {
    test('syncs timestamps correctly', () {
      final sync = syncTimestamps(
        1000000,
        999000,
        998000,
        1000100,
      );

      expect(sync.presentation_time, 1000000);
      expect(sync.decode_time, 999000);
      expect(sync.capture_time, 998000);
      expect(sync.render_time, 1000100);
      expect(sync.av_offset_us, -100);
    });

    test('calculates drift compensation', () {
      final sync = syncTimestamps(
        1000000,
        1005000,
        998000,
        1000000,
      );

      expect(sync.drift_compensation, 5000);
    });
  });

  group('Stream Statistics', () {
    test('updates and retrieves statistics', () {
      resetStatistics();

      updateStatistics(100, 1000000, 5, 1000000000);

      final stats = getStatistics();
      expect(stats.frames_processed, 100);
      expect(stats.bytes_processed, 1000000);
      expect(stats.frames_dropped, 5);
      expect(stats.average_bitrate, greaterThan(0));
      expect(stats.average_framerate, greaterThan(0));
    });

    test('accumulates statistics over multiple updates', () {
      resetStatistics();

      updateStatistics(50, 500000, 2, 500000000);
      updateStatistics(50, 500000, 3, 500000000);

      final stats = getStatistics();
      expect(stats.frames_processed, 100);
      expect(stats.bytes_processed, 1000000);
      expect(stats.frames_dropped, 5);
    });

    test('resets statistics', () {
      updateStatistics(100, 1000000, 5, 1000000000);
      resetStatistics();

      final stats = getStatistics();
      expect(stats.frames_processed, 0);
      expect(stats.bytes_processed, 0);
      expect(stats.frames_dropped, 0);
    });
  });

  group('Jitter Calculation', () {
    test('calculates jitter from timestamp array', () {
      final timestamps = [
        1000000,
        1033333,
        1066666,
        1100100,
        1133500,
        1166666,
        1200200,
      ];

      final ptr = malloc.allocate<ffi.Uint64>(timestamps.length * 8);
      for (var i = 0; i < timestamps.length; i++) {
        ptr[i] = timestamps[i];
      }

      final jitter = calculateJitter(ptr, timestamps.length);
      expect(jitter, greaterThanOrEqualTo(0));

      malloc.free(ptr);
    });

    test('returns zero for insufficient data', () {
      final ptr = malloc.allocate<ffi.Uint64>(8);
      ptr[0] = 1000000;

      final jitter = calculateJitter(ptr, 1);
      expect(jitter, 0);

      malloc.free(ptr);
    });
  });

  group('Frame Drop Detection', () {
    test('detects no frame drop', () {
      expect(detectFrameDrop(10, 10), false);
    });

    test('detects frame drop', () {
      expect(detectFrameDrop(12, 10), true);
      expect(detectFrameDrop(10, 12), true);
    });
  });

  group('Codec Parameters', () {
    test('creates codec parameters', () {
      final ptr = malloc.allocate<CodecParameters>(ffi.sizeOf<CodecParameters>());
      final params = ptr.ref;

      params.codec = CodecType.H264.value;
      params.width = 1920;
      params.height = 1080;
      params.bitrate = 5000000;
      params.framerate = 30;
      params.gop_size = 30;
      params.chroma = ChromaSubsampling.YUV420.value;
      params.bit_depth = 8;

      expect(params.codec, CodecType.H264.value);
      expect(params.width, 1920);
      expect(params.height, 1080);
      expect(params.bitrate, 5000000);
      expect(params.framerate, 30);

      malloc.free(ptr);
    });
  });

  group('Real-World Scenario: 60fps Streaming', () {
    test('handles high frame rate streaming', () {
      resetStatistics();
      final frames = <ffi.Pointer<FrameMetadata>>[];
      const fps = 60;
      const duration = 1;
      const totalFrames = fps * duration;
      const frameInterval = 1000000 ~/ fps;

      for (var i = 0; i < totalFrames; i++) {
        final ptr = createFrameMetadata(
          i * frameInterval,
          i * 100,
          i * 90,
          i % 10 == 0 ? FrameType.I_FRAME.value : FrameType.P_FRAME.value,
          i,
          i % 10 == 0,
          1920,
          1080,
          8000000,
        );
        frames.add(ptr);
      }

      updateStatistics(totalFrames, totalFrames * 100000, 0, 1000000000);

      final stats = getStatistics();
      expect(stats.frames_processed, totalFrames);
      expect(stats.frames_dropped, 0);
      expect(stats.average_framerate, closeTo(fps, 10));

      for (final frame in frames) {
        freeFrameMetadata(frame);
      }
    });
  });

  group('Real-World Scenario: Network Jitter', () {
    test('measures network jitter impact', () {
      final timestamps = List.generate(
        100,
        (i) => 1000000 + i * 33333 + (i % 2 == 0 ? 500 : -500),
      );

      final ptr = malloc.allocate<ffi.Uint64>(timestamps.length * 8);
      for (var i = 0; i < timestamps.length; i++) {
        ptr[i] = timestamps[i];
      }

      final jitter = calculateJitter(ptr, timestamps.length);
      expect(jitter, greaterThan(0));

      malloc.free(ptr);
    });
  });

  group('Real-World Scenario: Frame Drops Under Load', () {
    test('tracks frame drops during congestion', () {
      resetStatistics();

      for (var i = 0; i < 10; i++) {
        final droppedFrames = i % 3 == 0 ? 5 : 0;
        updateStatistics(30, 300000, droppedFrames, 100000000);
      }

      final stats = getStatistics();
      expect(stats.frames_dropped, greaterThan(0));
      expect(stats.frames_processed, 300);
    });
  });
}
