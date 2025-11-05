import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

class PooledBuffer {
  final Pointer<Uint8> ptr;
  final int capacity;
  final BufferPool _pool;

  PooledBuffer._(this.ptr, this.capacity, this._pool);

  Uint8List asTypedList(int length) {
    if (length > capacity) {
      throw ArgumentError('Requested length $length exceeds capacity $capacity');
    }
    return ptr.asTypedList(length);
  }

  void release() {
    _pool._release(this);
  }
}

class BufferPool {
  final List<Pointer<Uint8>> _availableBuffers = [];
  final List<int> _bufferSizes = [];
  final int _maxPoolSize;
  int _totalAllocated = 0;

  BufferPool({int maxPoolSize = 20}) : _maxPoolSize = maxPoolSize;

  PooledBuffer acquire(int minSize) {
    for (var i = 0; i < _availableBuffers.length; i++) {
      if (_bufferSizes[i] >= minSize) {
        final ptr = _availableBuffers.removeAt(i);
        final size = _bufferSizes.removeAt(i);
        return PooledBuffer._(ptr, size, this);
      }
    }

    final size = _roundUpToNextPowerOfTwo(minSize);
    final ptr = calloc<Uint8>(size);
    _totalAllocated++;

    return PooledBuffer._(ptr, size, this);
  }

  void _release(PooledBuffer buffer) {
    if (_availableBuffers.length < _maxPoolSize) {
      _availableBuffers.add(buffer.ptr);
      _bufferSizes.add(buffer.capacity);
    } else {
      calloc.free(buffer.ptr);
    }
  }

  void clear() {
    for (final ptr in _availableBuffers) {
      calloc.free(ptr);
    }
    _availableBuffers.clear();
    _bufferSizes.clear();
  }

  int _roundUpToNextPowerOfTwo(int n) {
    if (n <= 0) return 1;
    n--;
    n |= n >> 1;
    n |= n >> 2;
    n |= n >> 4;
    n |= n >> 8;
    n |= n >> 16;
    return n + 1;
  }

  int get poolSize => _availableBuffers.length;
  int get totalAllocated => _totalAllocated;
}

class GlobalBufferPool {
  static final _instance = BufferPool(maxPoolSize: 50);

  static PooledBuffer acquire(int minSize) => _instance.acquire(minSize);

  static int get poolSize => _instance.poolSize;
  static int get totalAllocated => _instance.totalAllocated;

  static void clear() => _instance.clear();
}
