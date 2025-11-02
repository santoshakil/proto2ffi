import 'dart:ffi';
import 'dart:io';

final String _libPath = Platform.isLinux
    ? '/Volumes/Projects/DevCaches/project-targets/release/libconcurrent_pools.so'
    : Platform.isMacOS
        ? '/Volumes/Projects/DevCaches/project-targets/release/libconcurrent_pools.dylib'
        : '/Volumes/Projects/DevCaches/project-targets/release/concurrent_pools.dll';

final _lib = DynamicLibrary.open(_libPath);

typedef ConcurrentTestSmallPoolNative = Uint64 Function(Uint32 threadCount, Uint32 opsPerThread);
typedef ConcurrentTestSmallPoolDart = int Function(int threadCount, int opsPerThread);

typedef ConcurrentTestMediumPoolNative = Uint64 Function(Uint32 threadCount, Uint32 opsPerThread);
typedef ConcurrentTestMediumPoolDart = int Function(int threadCount, int opsPerThread);

typedef ConcurrentTestLargePoolNative = Uint64 Function(Uint32 threadCount, Uint32 opsPerThread);
typedef ConcurrentTestLargePoolDart = int Function(int threadCount, int opsPerThread);

typedef StressTestRapidAllocFreeNative = Uint64 Function(Uint32 threadCount, Uint32 durationMs);
typedef StressTestRapidAllocFreeDart = int Function(int threadCount, int durationMs);

typedef TestPoolExhaustionNative = Bool Function(Uint32 poolSize);
typedef TestPoolExhaustionDart = bool Function(int poolSize);

typedef TestFreeListIntegrityNative = Bool Function(Uint32 iterations);
typedef TestFreeListIntegrityDart = bool Function(int iterations);

typedef ConcurrentTestMixedOperationsNative = Uint64 Function(Uint32 threadCount, Uint32 opsPerThread);
typedef ConcurrentTestMixedOperationsDart = int Function(int threadCount, int opsPerThread);

typedef MeasureContentionNative = Uint64 Function(Uint32 threadCount, Bool sharedPool);
typedef MeasureContentionDart = int Function(int threadCount, bool sharedPool);

final concurrentTestSmallPool = _lib
    .lookup<NativeFunction<ConcurrentTestSmallPoolNative>>('concurrent_test_small_pool')
    .asFunction<ConcurrentTestSmallPoolDart>();

final concurrentTestMediumPool = _lib
    .lookup<NativeFunction<ConcurrentTestMediumPoolNative>>('concurrent_test_medium_pool')
    .asFunction<ConcurrentTestMediumPoolDart>();

final concurrentTestLargePool = _lib
    .lookup<NativeFunction<ConcurrentTestLargePoolNative>>('concurrent_test_large_pool')
    .asFunction<ConcurrentTestLargePoolDart>();

final stressTestRapidAllocFree = _lib
    .lookup<NativeFunction<StressTestRapidAllocFreeNative>>('stress_test_rapid_alloc_free')
    .asFunction<StressTestRapidAllocFreeDart>();

final testPoolExhaustion = _lib
    .lookup<NativeFunction<TestPoolExhaustionNative>>('test_pool_exhaustion')
    .asFunction<TestPoolExhaustionDart>();

final testFreeListIntegrity = _lib
    .lookup<NativeFunction<TestFreeListIntegrityNative>>('test_free_list_integrity')
    .asFunction<TestFreeListIntegrityDart>();

final concurrentTestMixedOperations = _lib
    .lookup<NativeFunction<ConcurrentTestMixedOperationsNative>>('concurrent_test_mixed_operations')
    .asFunction<ConcurrentTestMixedOperationsDart>();

final measureContention = _lib
    .lookup<NativeFunction<MeasureContentionNative>>('measure_contention')
    .asFunction<MeasureContentionDart>();
