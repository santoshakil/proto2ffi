import 'dart:ffi' as ffi;
import 'dart:io';
import 'generated.dart';

class UltraComplexFFI {
  static final ffi.DynamicLibrary _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('rust/target/release/libultra_complex_ffi.dylib');
    } else if (Platform.isLinux) {
      return ffi.DynamicLibrary.open('rust/target/release/libultra_complex_ffi.so');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('rust/target/release/ultra_complex_ffi.dll');
    }
    throw UnsupportedError('Unsupported platform');
  }

  static final _graphAddNode = _dylib.lookupFunction<
      ffi.Bool Function(ffi.Pointer<Graph>, ffi.Pointer<GraphNode>),
      bool Function(ffi.Pointer<Graph>, ffi.Pointer<GraphNode>)>('graph_add_node');

  static final _graphAddEdge = _dylib.lookupFunction<
      ffi.Bool Function(ffi.Pointer<Graph>, ffi.Pointer<GraphEdge>),
      bool Function(ffi.Pointer<Graph>, ffi.Pointer<GraphEdge>)>('graph_add_edge');

  static final _graphBfs = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Graph>, ffi.Uint64, ffi.Pointer<ffi.Uint64>, ffi.Pointer<ffi.Size>),
      void Function(ffi.Pointer<Graph>, int, ffi.Pointer<ffi.Uint64>, ffi.Pointer<ffi.Size>)>('graph_bfs');

  static final _graphDfs = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Graph>, ffi.Uint64, ffi.Pointer<ffi.Uint64>, ffi.Pointer<ffi.Size>),
      void Function(ffi.Pointer<Graph>, int, ffi.Pointer<ffi.Uint64>, ffi.Pointer<ffi.Size>)>('graph_dfs');

  static final _graphDijkstra = _dylib.lookupFunction<
      ffi.Double Function(ffi.Pointer<Graph>, ffi.Uint64, ffi.Uint64),
      double Function(ffi.Pointer<Graph>, int, int)>('graph_dijkstra');

  static final _graphDetectCycle = _dylib.lookupFunction<
      ffi.Bool Function(ffi.Pointer<Graph>),
      bool Function(ffi.Pointer<Graph>)>('graph_detect_cycle');

  static final _graphTopologicalSort = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Graph>, ffi.Pointer<ffi.Uint64>, ffi.Pointer<ffi.Size>),
      void Function(ffi.Pointer<Graph>, ffi.Pointer<ffi.Uint64>, ffi.Pointer<ffi.Size>)>('graph_topological_sort');

  static final _sortI64Array = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Int64>, ffi.Size),
      void Function(ffi.Pointer<ffi.Int64>, int)>('sort_i64_array');

  static final _sortF64Array = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Double>, ffi.Size),
      void Function(ffi.Pointer<ffi.Double>, int)>('sort_f64_array');

  static final _quicksortI64 = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Int64>, ffi.IntPtr, ffi.IntPtr),
      void Function(ffi.Pointer<ffi.Int64>, int, int)>('quicksort_i64');

  static final _mergeSortI64 = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Int64>, ffi.Size),
      void Function(ffi.Pointer<ffi.Int64>, int)>('merge_sort_i64');

  static final _heapSortI64 = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Int64>, ffi.Size),
      void Function(ffi.Pointer<ffi.Int64>, int)>('heap_sort_i64');

  static final _binarySearchI64 = _dylib.lookupFunction<
      ffi.IntPtr Function(ffi.Pointer<ffi.Int64>, ffi.Size, ffi.Int64),
      int Function(ffi.Pointer<ffi.Int64>, int, int)>('binary_search_i64');

  static final _linearSearchI64 = _dylib.lookupFunction<
      ffi.IntPtr Function(ffi.Pointer<ffi.Int64>, ffi.Size, ffi.Int64),
      int Function(ffi.Pointer<ffi.Int64>, int, int)>('linear_search_i64');

  static final _statisticsCompute = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Double>, ffi.Size, ffi.Pointer<Statistics>),
      void Function(ffi.Pointer<ffi.Double>, int, ffi.Pointer<Statistics>)>('statistics_compute');

  static final _histogramCompute = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Double>, ffi.Size, ffi.Uint32, ffi.Pointer<Histogram>),
      void Function(ffi.Pointer<ffi.Double>, int, int, ffi.Pointer<Histogram>)>('histogram_compute');

  static final _vector3Add = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>, ffi.Pointer<Vector3>),
      void Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>, ffi.Pointer<Vector3>)>('vector3_add');

  static final _vector3Sub = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>, ffi.Pointer<Vector3>),
      void Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>, ffi.Pointer<Vector3>)>('vector3_sub');

  static final _vector3Dot = _dylib.lookupFunction<
      ffi.Float Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>),
      double Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>)>('vector3_dot');

  static final _vector3Cross = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>, ffi.Pointer<Vector3>),
      void Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>, ffi.Pointer<Vector3>)>('vector3_cross');

  static final _vector3Length = _dylib.lookupFunction<
      ffi.Float Function(ffi.Pointer<Vector3>),
      double Function(ffi.Pointer<Vector3>)>('vector3_length');

  static final _vector3Normalize = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>),
      void Function(ffi.Pointer<Vector3>, ffi.Pointer<Vector3>)>('vector3_normalize');

  static final _vector3Scale = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Vector3>, ffi.Float, ffi.Pointer<Vector3>),
      void Function(ffi.Pointer<Vector3>, double, ffi.Pointer<Vector3>)>('vector3_scale');

  static final _matrix4x4Multiply = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Matrix4x4>, ffi.Pointer<Matrix4x4>, ffi.Pointer<Matrix4x4>),
      void Function(ffi.Pointer<Matrix4x4>, ffi.Pointer<Matrix4x4>, ffi.Pointer<Matrix4x4>)>('matrix4x4_multiply');

  static final _matrix4x4Identity = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Matrix4x4>),
      void Function(ffi.Pointer<Matrix4x4>)>('matrix4x4_identity');

  static final _quaternionMultiply = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Quaternion>, ffi.Pointer<Quaternion>, ffi.Pointer<Quaternion>),
      void Function(ffi.Pointer<Quaternion>, ffi.Pointer<Quaternion>, ffi.Pointer<Quaternion>)>('quaternion_multiply');

  static final _quaternionNormalize = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<Quaternion>, ffi.Pointer<Quaternion>),
      void Function(ffi.Pointer<Quaternion>, ffi.Pointer<Quaternion>)>('quaternion_normalize');

  static final _memoryIntensiveOperation = _dylib.lookupFunction<
      ffi.Uint64 Function(ffi.Size),
      int Function(int)>('memory_intensive_operation');

  static final _fibonacci = _dylib.lookupFunction<
      ffi.Uint64 Function(ffi.Uint32),
      int Function(int)>('fibonacci');

  static final _factorial = _dylib.lookupFunction<
      ffi.Uint64 Function(ffi.Uint32),
      int Function(int)>('factorial');

  static final _primeCount = _dylib.lookupFunction<
      ffi.Uint64 Function(ffi.Uint64),
      int Function(int)>('prime_count');

  static final _matrixMultiplyF64 = _dylib.lookupFunction<
      ffi.Bool Function(ffi.Pointer<ffi.Double>, ffi.Size, ffi.Size, ffi.Pointer<ffi.Double>, ffi.Size, ffi.Size, ffi.Pointer<ffi.Double>),
      bool Function(ffi.Pointer<ffi.Double>, int, int, ffi.Pointer<ffi.Double>, int, int, ffi.Pointer<ffi.Double>)>('matrix_multiply_f64');

  static final _convolution1d = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Double>, ffi.Size, ffi.Pointer<ffi.Double>, ffi.Size, ffi.Pointer<ffi.Double>),
      void Function(ffi.Pointer<ffi.Double>, int, ffi.Pointer<ffi.Double>, int, ffi.Pointer<ffi.Double>)>('convolution_1d');

  static final _fftMagnitude = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>, ffi.Size, ffi.Pointer<ffi.Double>),
      void Function(ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>, int, ffi.Pointer<ffi.Double>)>('fft_magnitude');

  static final _pearsonCorrelation = _dylib.lookupFunction<
      ffi.Double Function(ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>, ffi.Size),
      double Function(ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>, int)>('pearson_correlation');

  static final _linearRegression = _dylib.lookupFunction<
      ffi.Void Function(ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>, ffi.Size, ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>),
      void Function(ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>, int, ffi.Pointer<ffi.Double>, ffi.Pointer<ffi.Double>)>('linear_regression');

  static bool graphAddNode(ffi.Pointer<Graph> graph, ffi.Pointer<GraphNode> node) => _graphAddNode(graph, node);
  static bool graphAddEdge(ffi.Pointer<Graph> graph, ffi.Pointer<GraphEdge> edge) => _graphAddEdge(graph, edge);
  static void graphBfs(ffi.Pointer<Graph> graph, int startId, ffi.Pointer<ffi.Uint64> visited, ffi.Pointer<ffi.Size> len) => _graphBfs(graph, startId, visited, len);
  static void graphDfs(ffi.Pointer<Graph> graph, int startId, ffi.Pointer<ffi.Uint64> visited, ffi.Pointer<ffi.Size> len) => _graphDfs(graph, startId, visited, len);
  static double graphDijkstra(ffi.Pointer<Graph> graph, int startId, int endId) => _graphDijkstra(graph, startId, endId);
  static bool graphDetectCycle(ffi.Pointer<Graph> graph) => _graphDetectCycle(graph);
  static void graphTopologicalSort(ffi.Pointer<Graph> graph, ffi.Pointer<ffi.Uint64> result, ffi.Pointer<ffi.Size> len) => _graphTopologicalSort(graph, result, len);
  static void sortI64Array(ffi.Pointer<ffi.Int64> arr, int len) => _sortI64Array(arr, len);
  static void sortF64Array(ffi.Pointer<ffi.Double> arr, int len) => _sortF64Array(arr, len);
  static void quicksortI64(ffi.Pointer<ffi.Int64> arr, int low, int high) => _quicksortI64(arr, low, high);
  static void mergeSortI64(ffi.Pointer<ffi.Int64> arr, int len) => _mergeSortI64(arr, len);
  static void heapSortI64(ffi.Pointer<ffi.Int64> arr, int len) => _heapSortI64(arr, len);
  static int binarySearchI64(ffi.Pointer<ffi.Int64> arr, int len, int target) => _binarySearchI64(arr, len, target);
  static int linearSearchI64(ffi.Pointer<ffi.Int64> arr, int len, int target) => _linearSearchI64(arr, len, target);
  static void statisticsCompute(ffi.Pointer<ffi.Double> values, int len, ffi.Pointer<Statistics> stats) => _statisticsCompute(values, len, stats);
  static void histogramCompute(ffi.Pointer<ffi.Double> values, int len, int numBins, ffi.Pointer<Histogram> hist) => _histogramCompute(values, len, numBins, hist);
  static void vector3Add(ffi.Pointer<Vector3> a, ffi.Pointer<Vector3> b, ffi.Pointer<Vector3> result) => _vector3Add(a, b, result);
  static void vector3Sub(ffi.Pointer<Vector3> a, ffi.Pointer<Vector3> b, ffi.Pointer<Vector3> result) => _vector3Sub(a, b, result);
  static double vector3Dot(ffi.Pointer<Vector3> a, ffi.Pointer<Vector3> b) => _vector3Dot(a, b);
  static void vector3Cross(ffi.Pointer<Vector3> a, ffi.Pointer<Vector3> b, ffi.Pointer<Vector3> result) => _vector3Cross(a, b, result);
  static double vector3Length(ffi.Pointer<Vector3> v) => _vector3Length(v);
  static void vector3Normalize(ffi.Pointer<Vector3> v, ffi.Pointer<Vector3> result) => _vector3Normalize(v, result);
  static void vector3Scale(ffi.Pointer<Vector3> v, double scalar, ffi.Pointer<Vector3> result) => _vector3Scale(v, scalar, result);
  static void matrix4x4Multiply(ffi.Pointer<Matrix4x4> a, ffi.Pointer<Matrix4x4> b, ffi.Pointer<Matrix4x4> result) => _matrix4x4Multiply(a, b, result);
  static void matrix4x4Identity(ffi.Pointer<Matrix4x4> result) => _matrix4x4Identity(result);
  static void quaternionMultiply(ffi.Pointer<Quaternion> a, ffi.Pointer<Quaternion> b, ffi.Pointer<Quaternion> result) => _quaternionMultiply(a, b, result);
  static void quaternionNormalize(ffi.Pointer<Quaternion> q, ffi.Pointer<Quaternion> result) => _quaternionNormalize(q, result);
  static int memoryIntensiveOperation(int size) => _memoryIntensiveOperation(size);
  static int fibonacci(int n) => _fibonacci(n);
  static int factorial(int n) => _factorial(n);
  static int primeCount(int n) => _primeCount(n);
  static bool matrixMultiplyF64(ffi.Pointer<ffi.Double> a, int aRows, int aCols, ffi.Pointer<ffi.Double> b, int bRows, int bCols, ffi.Pointer<ffi.Double> result) => _matrixMultiplyF64(a, aRows, aCols, b, bRows, bCols, result);
  static void convolution1d(ffi.Pointer<ffi.Double> signal, int signalLen, ffi.Pointer<ffi.Double> kernel, int kernelLen, ffi.Pointer<ffi.Double> result) => _convolution1d(signal, signalLen, kernel, kernelLen, result);
  static void fftMagnitude(ffi.Pointer<ffi.Double> real, ffi.Pointer<ffi.Double> imag, int len, ffi.Pointer<ffi.Double> magnitude) => _fftMagnitude(real, imag, len, magnitude);
  static double pearsonCorrelation(ffi.Pointer<ffi.Double> x, ffi.Pointer<ffi.Double> y, int len) => _pearsonCorrelation(x, y, len);
  static void linearRegression(ffi.Pointer<ffi.Double> x, ffi.Pointer<ffi.Double> y, int len, ffi.Pointer<ffi.Double> slope, ffi.Pointer<ffi.Double> intercept) => _linearRegression(x, y, len, slope, intercept);
}
