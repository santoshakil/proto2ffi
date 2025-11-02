import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'phase3/generated.dart';

class Phase3FFI {
  static final ffi.DynamicLibrary _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/libffi_example.dylib');
    } else if (Platform.isLinux) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/libffi_example.so');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/ffi_example.dll');
    }
    throw UnsupportedError('Unsupported platform');
  }

  static final _particlePoolInit = _dylib.lookupFunction<
    ffi.Void Function(ffi.Size),
    void Function(int)
  >('particle_pool_init');

  static final _particlePoolAllocate = _dylib.lookupFunction<
    ffi.Pointer<Particle> Function(),
    ffi.Pointer<Particle> Function()
  >('particle_pool_allocate');

  static final _particlePoolFree = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Particle>),
    void Function(ffi.Pointer<Particle>)
  >('particle_pool_free');

  static final _rigidbodyPoolInit = _dylib.lookupFunction<
    ffi.Void Function(ffi.Size),
    void Function(int)
  >('rigidbody_pool_init');

  static final _rigidbodyPoolAllocate = _dylib.lookupFunction<
    ffi.Pointer<RigidBody> Function(),
    ffi.Pointer<RigidBody> Function()
  >('rigidbody_pool_allocate');

  static final _rigidbodyPoolFree = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<RigidBody>),
    void Function(ffi.Pointer<RigidBody>)
  >('rigidbody_pool_free');

  static final _poolGetStats = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<PoolStats>),
    void Function(ffi.Pointer<PoolStats>)
  >('pool_get_stats');

  static final _poolResetStats = _dylib.lookupFunction<
    ffi.Void Function(),
    void Function()
  >('pool_reset_stats');

  static final _particleUpdate = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Particle>, ffi.Double),
    void Function(ffi.Pointer<Particle>, double)
  >('particle_update');

  static final _rigidbodyUpdate = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<RigidBody>, ffi.Double),
    void Function(ffi.Pointer<RigidBody>, double)
  >('rigidbody_update');

  static final _benchmarkPoolVsMalloc = _dylib.lookupFunction<
    ffi.Void Function(ffi.Size, ffi.Size, ffi.Pointer<ffi.Uint64>, ffi.Pointer<ffi.Uint64>),
    void Function(int, int, ffi.Pointer<ffi.Uint64>, ffi.Pointer<ffi.Uint64>)
  >('benchmark_pool_vs_malloc');

  static void particlePoolInit(int capacity) {
    _particlePoolInit(capacity);
  }

  static ffi.Pointer<Particle> particlePoolAllocate() {
    return _particlePoolAllocate();
  }

  static void particlePoolFree(ffi.Pointer<Particle> ptr) {
    _particlePoolFree(ptr);
  }

  static void rigidbodyPoolInit(int capacity) {
    _rigidbodyPoolInit(capacity);
  }

  static ffi.Pointer<RigidBody> rigidbodyPoolAllocate() {
    return _rigidbodyPoolAllocate();
  }

  static void rigidbodyPoolFree(ffi.Pointer<RigidBody> ptr) {
    _rigidbodyPoolFree(ptr);
  }

  static void poolGetStats(ffi.Pointer<PoolStats> stats) {
    _poolGetStats(stats);
  }

  static void poolResetStats() {
    _poolResetStats();
  }

  static void particleUpdate(ffi.Pointer<Particle> p, double dt) {
    _particleUpdate(p, dt);
  }

  static void rigidbodyUpdate(ffi.Pointer<RigidBody> rb, double dt) {
    _rigidbodyUpdate(rb, dt);
  }

  static BenchmarkResult benchmarkPoolVsMalloc(int count, int iterations) {
    final poolTimePtr = calloc<ffi.Uint64>();
    final mallocTimePtr = calloc<ffi.Uint64>();

    _benchmarkPoolVsMalloc(count, iterations, poolTimePtr, mallocTimePtr);

    final poolTime = poolTimePtr.value;
    final mallocTime = mallocTimePtr.value;

    calloc.free(poolTimePtr);
    calloc.free(mallocTimePtr);

    return BenchmarkResult(poolTime, mallocTime);
  }
}

class BenchmarkResult {
  final int poolTimeMicros;
  final int mallocTimeMicros;

  BenchmarkResult(this.poolTimeMicros, this.mallocTimeMicros);

  double get speedup => mallocTimeMicros / poolTimeMicros;

  @override
  String toString() {
    return 'Pool: ${poolTimeMicros}μs, Malloc: ${mallocTimeMicros}μs, Speedup: ${speedup.toStringAsFixed(2)}x';
  }
}
