import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'generated/generated.dart';

class FFIExample {
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

  static final _pointDistance = _dylib.lookupFunction<
    ffi.Double Function(ffi.Pointer<Point>, ffi.Pointer<Point>),
    double Function(ffi.Pointer<Point>, ffi.Pointer<Point>)
  >('point_distance');

  static final _pointMidpoint = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Point>, ffi.Pointer<Point>, ffi.Pointer<Point>),
    void Function(ffi.Pointer<Point>, ffi.Pointer<Point>, ffi.Pointer<Point>)
  >('point_midpoint');

  static final _counterIncrement = _dylib.lookupFunction<
    ffi.Int64 Function(ffi.Pointer<Counter>),
    int Function(ffi.Pointer<Counter>)
  >('counter_increment');

  static final _counterAdd = _dylib.lookupFunction<
    ffi.Int64 Function(ffi.Pointer<Counter>, ffi.Int64),
    int Function(ffi.Pointer<Counter>, int)
  >('counter_add');

  static final _statsUpdate = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Stats>, ffi.Double),
    void Function(ffi.Pointer<Stats>, double)
  >('stats_update');

  static final _statsReset = _dylib.lookupFunction<
    ffi.Void Function(ffi.Pointer<Stats>),
    void Function(ffi.Pointer<Stats>)
  >('stats_reset');

  static double pointDistance(ffi.Pointer<Point> p1, ffi.Pointer<Point> p2) {
    return _pointDistance(p1, p2);
  }

  static ffi.Pointer<Point> pointMidpoint(ffi.Pointer<Point> p1, ffi.Pointer<Point> p2) {
    final result = Point.allocate();
    _pointMidpoint(p1, p2, result);
    return result;
  }

  static int counterIncrement(ffi.Pointer<Counter> counter) {
    return _counterIncrement(counter);
  }

  static int counterAdd(ffi.Pointer<Counter> counter, int amount) {
    return _counterAdd(counter, amount);
  }

  static void statsUpdate(ffi.Pointer<Stats> stats, double value) {
    _statsUpdate(stats, value);
  }

  static void statsReset(ffi.Pointer<Stats> stats) {
    _statsReset(stats);
  }
}
