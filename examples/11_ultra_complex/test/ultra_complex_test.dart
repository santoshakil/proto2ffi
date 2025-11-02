import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import 'package:ultra_complex_ffi/ultra_complex.dart';
import 'package:ultra_complex_ffi/generated.dart';

void main() {
  group('Graph Algorithms', () {
    test('graph creation and node addition', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;
      graph.ref.directed = true;
      graph.ref.weighted = true;

      final node1 = GraphNode.allocate();
      node1.ref.id = 1;
      node1.ref.weight = 1.0;

      final node2 = GraphNode.allocate();
      node2.ref.id = 2;
      node2.ref.weight = 2.0;

      UltraComplexFFI.graphAddNode(graph, node1);
      UltraComplexFFI.graphAddNode(graph, node2);

      expect(graph.ref.num_nodes, equals(2));

      calloc.free(node1);
      calloc.free(node2);
      calloc.free(graph);
    });

    test('graph edge addition', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;

      final node1 = GraphNode.allocate();
      node1.ref.id = 1;
      final node2 = GraphNode.allocate();
      node2.ref.id = 2;

      UltraComplexFFI.graphAddNode(graph, node1);
      UltraComplexFFI.graphAddNode(graph, node2);

      final edge = GraphEdge.allocate();
      edge.ref.id = 1;
      edge.ref.source = 1;
      edge.ref.target = 2;
      edge.ref.weight = 5.0;
      edge.ref.directed = true;

      UltraComplexFFI.graphAddEdge(graph, edge);

      expect(graph.ref.num_edges, equals(1));

      calloc.free(node1);
      calloc.free(node2);
      calloc.free(edge);
      calloc.free(graph);
    });

    test('BFS traversal - simple graph', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;

      for (var i = 1; i <= 5; i++) {
        final node = GraphNode.allocate();
        node.ref.id = i;
        UltraComplexFFI.graphAddNode(graph, node);
        calloc.free(node);
      }

      final edges = [
        [1, 2],
        [1, 3],
        [2, 4],
        [3, 5],
      ];

      for (var i = 0; i < edges.length; i++) {
        final edge = GraphEdge.allocate();
        edge.ref.id = i + 1;
        edge.ref.source = edges[i][0];
        edge.ref.target = edges[i][1];
        edge.ref.weight = 1.0;
        UltraComplexFFI.graphAddEdge(graph, edge);
        calloc.free(edge);
      }

      final visited = calloc<ffi.Uint64>(5);
      final visitedLen = calloc<ffi.Size>();

      UltraComplexFFI.graphBfs(graph, 1, visited, visitedLen);

      expect(visitedLen.value, equals(5));
      expect(visited[0], equals(1));

      calloc.free(visited);
      calloc.free(visitedLen);
      calloc.free(graph);
    });

    test('DFS traversal - simple graph', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;

      for (var i = 1; i <= 5; i++) {
        final node = GraphNode.allocate();
        node.ref.id = i;
        UltraComplexFFI.graphAddNode(graph, node);
        calloc.free(node);
      }

      final edges = [
        [1, 2],
        [1, 3],
        [2, 4],
        [3, 5],
      ];

      for (var i = 0; i < edges.length; i++) {
        final edge = GraphEdge.allocate();
        edge.ref.id = i + 1;
        edge.ref.source = edges[i][0];
        edge.ref.target = edges[i][1];
        edge.ref.weight = 1.0;
        UltraComplexFFI.graphAddEdge(graph, edge);
        calloc.free(edge);
      }

      final visited = calloc<ffi.Uint64>(5);
      final visitedLen = calloc<ffi.Size>();

      UltraComplexFFI.graphDfs(graph, 1, visited, visitedLen);

      expect(visitedLen.value, equals(5));
      expect(visited[0], equals(1));

      calloc.free(visited);
      calloc.free(visitedLen);
      calloc.free(graph);
    });

    test('Dijkstra shortest path', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;

      for (var i = 1; i <= 4; i++) {
        final node = GraphNode.allocate();
        node.ref.id = i;
        UltraComplexFFI.graphAddNode(graph, node);
        calloc.free(node);
      }

      final edges = [
        [1, 2, 1.0],
        [1, 3, 4.0],
        [2, 3, 2.0],
        [2, 4, 5.0],
        [3, 4, 1.0],
      ];

      for (var i = 0; i < edges.length; i++) {
        final edge = GraphEdge.allocate();
        edge.ref.id = i + 1;
        edge.ref.source = edges[i][0] as int;
        edge.ref.target = edges[i][1] as int;
        edge.ref.weight = edges[i][2] as double;
        UltraComplexFFI.graphAddEdge(graph, edge);
        calloc.free(edge);
      }

      final distance = UltraComplexFFI.graphDijkstra(graph, 1, 4);

      expect(distance, closeTo(4.0, 0.001));

      calloc.free(graph);
    });

    test('cycle detection - no cycle', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;
      graph.ref.directed = true;

      for (var i = 1; i <= 3; i++) {
        final node = GraphNode.allocate();
        node.ref.id = i;
        UltraComplexFFI.graphAddNode(graph, node);
        calloc.free(node);
      }

      final edge1 = GraphEdge.allocate();
      edge1.ref.id = 1;
      edge1.ref.source = 1;
      edge1.ref.target = 2;
      UltraComplexFFI.graphAddEdge(graph, edge1);

      final edge2 = GraphEdge.allocate();
      edge2.ref.id = 2;
      edge2.ref.source = 2;
      edge2.ref.target = 3;
      UltraComplexFFI.graphAddEdge(graph, edge2);

      final hasCycle = UltraComplexFFI.graphDetectCycle(graph);

      expect(hasCycle, isFalse);

      calloc.free(edge1);
      calloc.free(edge2);
      calloc.free(graph);
    });

    test('cycle detection - with cycle', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;
      graph.ref.directed = true;

      for (var i = 1; i <= 3; i++) {
        final node = GraphNode.allocate();
        node.ref.id = i;
        UltraComplexFFI.graphAddNode(graph, node);
        calloc.free(node);
      }

      final edges = [
        [1, 2],
        [2, 3],
        [3, 1],
      ];

      for (var i = 0; i < edges.length; i++) {
        final edge = GraphEdge.allocate();
        edge.ref.id = i + 1;
        edge.ref.source = edges[i][0];
        edge.ref.target = edges[i][1];
        UltraComplexFFI.graphAddEdge(graph, edge);
        calloc.free(edge);
      }

      final hasCycle = UltraComplexFFI.graphDetectCycle(graph);

      expect(hasCycle, isTrue);

      calloc.free(graph);
    });

    test('topological sort', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;
      graph.ref.directed = true;

      for (var i = 1; i <= 4; i++) {
        final node = GraphNode.allocate();
        node.ref.id = i;
        UltraComplexFFI.graphAddNode(graph, node);
        calloc.free(node);
      }

      final edges = [
        [1, 2],
        [1, 3],
        [2, 4],
        [3, 4],
      ];

      for (var i = 0; i < edges.length; i++) {
        final edge = GraphEdge.allocate();
        edge.ref.id = i + 1;
        edge.ref.source = edges[i][0];
        edge.ref.target = edges[i][1];
        UltraComplexFFI.graphAddEdge(graph, edge);
        calloc.free(edge);
      }

      final result = calloc<ffi.Uint64>(4);
      final resultLen = calloc<ffi.Size>();

      UltraComplexFFI.graphTopologicalSort(graph, result, resultLen);

      expect(resultLen.value, equals(4));

      calloc.free(result);
      calloc.free(resultLen);
      calloc.free(graph);
    });
  });

  group('Sorting Algorithms', () {
    test('standard sort - 100 elements', () {
      final arr = calloc<ffi.Int64>(100);
      for (var i = 0; i < 100; i++) {
        arr[i] = 100 - i;
      }

      UltraComplexFFI.sortI64Array(arr, 100);

      for (var i = 0; i < 99; i++) {
        expect(arr[i] <= arr[i + 1], isTrue);
      }

      calloc.free(arr);
    });

    test('quicksort - 1000 elements', () {
      final arr = calloc<ffi.Int64>(1000);
      for (var i = 0; i < 1000; i++) {
        arr[i] = 1000 - i;
      }

      UltraComplexFFI.quicksortI64(arr, 0, 999);

      for (var i = 0; i < 999; i++) {
        expect(arr[i] <= arr[i + 1], isTrue);
      }

      calloc.free(arr);
    });

    test('merge sort - 10000 elements', () {
      final arr = calloc<ffi.Int64>(10000);
      for (var i = 0; i < 10000; i++) {
        arr[i] = 10000 - i;
      }

      final sw = Stopwatch()..start();
      UltraComplexFFI.mergeSortI64(arr, 10000);
      sw.stop();

      print('Merge sort 10K elements: ${sw.elapsedMicroseconds}μs');

      for (var i = 0; i < 9999; i++) {
        expect(arr[i] <= arr[i + 1], isTrue);
      }

      calloc.free(arr);
    });

    test('heap sort - 5000 elements', () {
      final arr = calloc<ffi.Int64>(5000);
      for (var i = 0; i < 5000; i++) {
        arr[i] = 5000 - i;
      }

      UltraComplexFFI.heapSortI64(arr, 5000);

      for (var i = 0; i < 4999; i++) {
        expect(arr[i] <= arr[i + 1], isTrue);
      }

      calloc.free(arr);
    });

    test('sort f64 array - with precision', () {
      final arr = calloc<ffi.Double>(100);
      for (var i = 0; i < 100; i++) {
        arr[i] = 100.5 - i * 0.7;
      }

      UltraComplexFFI.sortF64Array(arr, 100);

      for (var i = 0; i < 99; i++) {
        expect(arr[i] <= arr[i + 1], isTrue);
      }

      calloc.free(arr);
    });
  });

  group('Search Algorithms', () {
    test('binary search - found', () {
      final arr = calloc<ffi.Int64>(100);
      for (var i = 0; i < 100; i++) {
        arr[i] = i * 2;
      }

      final idx = UltraComplexFFI.binarySearchI64(arr, 100, 50);

      expect(idx, equals(25));

      calloc.free(arr);
    });

    test('binary search - not found', () {
      final arr = calloc<ffi.Int64>(100);
      for (var i = 0; i < 100; i++) {
        arr[i] = i * 2;
      }

      final idx = UltraComplexFFI.binarySearchI64(arr, 100, 51);

      expect(idx, equals(-1));

      calloc.free(arr);
    });

    test('linear search - found', () {
      final arr = calloc<ffi.Int64>(100);
      for (var i = 0; i < 100; i++) {
        arr[i] = i * 3;
      }

      final idx = UltraComplexFFI.linearSearchI64(arr, 100, 75);

      expect(idx, equals(25));

      calloc.free(arr);
    });

    test('linear search - not found', () {
      final arr = calloc<ffi.Int64>(100);
      for (var i = 0; i < 100; i++) {
        arr[i] = i * 3;
      }

      final idx = UltraComplexFFI.linearSearchI64(arr, 100, 76);

      expect(idx, equals(-1));

      calloc.free(arr);
    });
  });

  group('Statistics', () {
    test('compute basic statistics', () {
      final values = calloc<ffi.Double>(100);
      for (var i = 0; i < 100; i++) {
        values[i] = i.toDouble();
      }

      final stats = Statistics.allocate();
      UltraComplexFFI.statisticsCompute(values, 100, stats);

      expect(stats.ref.count, equals(100));
      expect(stats.ref.sum, closeTo(4950.0, 0.001));
      expect(stats.ref.min, closeTo(0.0, 0.001));
      expect(stats.ref.max, closeTo(99.0, 0.001));
      expect(stats.ref.mean, closeTo(49.5, 0.001));

      calloc.free(values);
      calloc.free(stats);
    });

    test('statistics with real data', () {
      final values = calloc<ffi.Double>(1000);
      for (var i = 0; i < 1000; i++) {
        values[i] = (i % 100).toDouble() * 1.5;
      }

      final stats = Statistics.allocate();
      UltraComplexFFI.statisticsCompute(values, 1000, stats);

      expect(stats.ref.count, equals(1000));
      expect(stats.ref.variance, greaterThan(0));
      expect(stats.ref.std_dev, greaterThan(0));

      calloc.free(values);
      calloc.free(stats);
    });

    test('histogram generation', () {
      final values = calloc<ffi.Double>(1000);
      for (var i = 0; i < 1000; i++) {
        values[i] = i.toDouble();
      }

      final hist = Histogram.allocate();
      UltraComplexFFI.histogramCompute(values, 1000, 10, hist);

      expect(hist.ref.num_bins, equals(10));
      expect(hist.ref.min, closeTo(0.0, 0.001));
      expect(hist.ref.max, closeTo(999.0, 0.001));

      calloc.free(values);
      calloc.free(hist);
    });
  });

  group('Vector Operations', () {
    test('vector3 addition', () {
      final a = Vector3.allocate();
      a.ref.x = 1.0;
      a.ref.y = 2.0;
      a.ref.z = 3.0;

      final b = Vector3.allocate();
      b.ref.x = 4.0;
      b.ref.y = 5.0;
      b.ref.z = 6.0;

      final result = Vector3.allocate();
      UltraComplexFFI.vector3Add(a, b, result);

      expect(result.ref.x, closeTo(5.0, 0.001));
      expect(result.ref.y, closeTo(7.0, 0.001));
      expect(result.ref.z, closeTo(9.0, 0.001));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('vector3 subtraction', () {
      final a = Vector3.allocate();
      a.ref.x = 10.0;
      a.ref.y = 8.0;
      a.ref.z = 6.0;

      final b = Vector3.allocate();
      b.ref.x = 1.0;
      b.ref.y = 2.0;
      b.ref.z = 3.0;

      final result = Vector3.allocate();
      UltraComplexFFI.vector3Sub(a, b, result);

      expect(result.ref.x, closeTo(9.0, 0.001));
      expect(result.ref.y, closeTo(6.0, 0.001));
      expect(result.ref.z, closeTo(3.0, 0.001));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('vector3 dot product', () {
      final a = Vector3.allocate();
      a.ref.x = 1.0;
      a.ref.y = 2.0;
      a.ref.z = 3.0;

      final b = Vector3.allocate();
      b.ref.x = 4.0;
      b.ref.y = 5.0;
      b.ref.z = 6.0;

      final dot = UltraComplexFFI.vector3Dot(a, b);

      expect(dot, closeTo(32.0, 0.001));

      calloc.free(a);
      calloc.free(b);
    });

    test('vector3 cross product', () {
      final a = Vector3.allocate();
      a.ref.x = 1.0;
      a.ref.y = 0.0;
      a.ref.z = 0.0;

      final b = Vector3.allocate();
      b.ref.x = 0.0;
      b.ref.y = 1.0;
      b.ref.z = 0.0;

      final result = Vector3.allocate();
      UltraComplexFFI.vector3Cross(a, b, result);

      expect(result.ref.x, closeTo(0.0, 0.001));
      expect(result.ref.y, closeTo(0.0, 0.001));
      expect(result.ref.z, closeTo(1.0, 0.001));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('vector3 length', () {
      final v = Vector3.allocate();
      v.ref.x = 3.0;
      v.ref.y = 4.0;
      v.ref.z = 0.0;

      final length = UltraComplexFFI.vector3Length(v);

      expect(length, closeTo(5.0, 0.001));

      calloc.free(v);
    });

    test('vector3 normalize', () {
      final v = Vector3.allocate();
      v.ref.x = 3.0;
      v.ref.y = 4.0;
      v.ref.z = 0.0;

      final result = Vector3.allocate();
      UltraComplexFFI.vector3Normalize(v, result);

      expect(result.ref.x, closeTo(0.6, 0.001));
      expect(result.ref.y, closeTo(0.8, 0.001));

      calloc.free(v);
      calloc.free(result);
    });

    test('vector3 scale', () {
      final v = Vector3.allocate();
      v.ref.x = 1.0;
      v.ref.y = 2.0;
      v.ref.z = 3.0;

      final result = Vector3.allocate();
      UltraComplexFFI.vector3Scale(v, 2.5, result);

      expect(result.ref.x, closeTo(2.5, 0.001));
      expect(result.ref.y, closeTo(5.0, 0.001));
      expect(result.ref.z, closeTo(7.5, 0.001));

      calloc.free(v);
      calloc.free(result);
    });
  });

  group('Matrix Operations', () {
    test('matrix4x4 identity', () {
      final mat = Matrix4x4.allocate();
      UltraComplexFFI.matrix4x4Identity(mat);

      expect(mat.ref.m00, closeTo(1.0, 0.001));
      expect(mat.ref.m11, closeTo(1.0, 0.001));
      expect(mat.ref.m22, closeTo(1.0, 0.001));
      expect(mat.ref.m33, closeTo(1.0, 0.001));
      expect(mat.ref.m01, closeTo(0.0, 0.001));
      expect(mat.ref.m10, closeTo(0.0, 0.001));

      calloc.free(mat);
    });

    test('matrix4x4 multiplication', () {
      final a = Matrix4x4.allocate();
      UltraComplexFFI.matrix4x4Identity(a);

      final b = Matrix4x4.allocate();
      UltraComplexFFI.matrix4x4Identity(b);

      final result = Matrix4x4.allocate();
      UltraComplexFFI.matrix4x4Multiply(a, b, result);

      expect(result.ref.m00, closeTo(1.0, 0.001));
      expect(result.ref.m11, closeTo(1.0, 0.001));
      expect(result.ref.m22, closeTo(1.0, 0.001));
      expect(result.ref.m33, closeTo(1.0, 0.001));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });
  });

  group('Quaternion Operations', () {
    test('quaternion multiplication', () {
      final a = Quaternion.allocate();
      a.ref.x = 0.0;
      a.ref.y = 0.0;
      a.ref.z = 0.0;
      a.ref.w = 1.0;

      final b = Quaternion.allocate();
      b.ref.x = 0.0;
      b.ref.y = 0.0;
      b.ref.z = 0.0;
      b.ref.w = 1.0;

      final result = Quaternion.allocate();
      UltraComplexFFI.quaternionMultiply(a, b, result);

      expect(result.ref.w, closeTo(1.0, 0.001));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('quaternion normalize', () {
      final q = Quaternion.allocate();
      q.ref.x = 1.0;
      q.ref.y = 1.0;
      q.ref.z = 1.0;
      q.ref.w = 1.0;

      final result = Quaternion.allocate();
      UltraComplexFFI.quaternionNormalize(q, result);

      final len = (result.ref.x * result.ref.x +
          result.ref.y * result.ref.y +
          result.ref.z * result.ref.z +
          result.ref.w * result.ref.w);
      expect(len, closeTo(1.0, 0.001));

      calloc.free(q);
      calloc.free(result);
    });
  });

  group('Mathematical Functions', () {
    test('fibonacci sequence', () {
      expect(UltraComplexFFI.fibonacci(0), equals(0));
      expect(UltraComplexFFI.fibonacci(1), equals(1));
      expect(UltraComplexFFI.fibonacci(10), equals(55));
      expect(UltraComplexFFI.fibonacci(20), equals(6765));
    });

    test('factorial', () {
      expect(UltraComplexFFI.factorial(0), equals(1));
      expect(UltraComplexFFI.factorial(1), equals(1));
      expect(UltraComplexFFI.factorial(5), equals(120));
      expect(UltraComplexFFI.factorial(10), equals(3628800));
    });

    test('prime counting', () {
      expect(UltraComplexFFI.primeCount(10), equals(4));
      expect(UltraComplexFFI.primeCount(100), equals(25));
      expect(UltraComplexFFI.primeCount(1000), equals(168));
    });
  });

  group('Advanced Math', () {
    test('matrix multiplication f64', () {
      final a = calloc<ffi.Double>(6);
      a[0] = 1.0;
      a[1] = 2.0;
      a[2] = 3.0;
      a[3] = 4.0;
      a[4] = 5.0;
      a[5] = 6.0;

      final b = calloc<ffi.Double>(6);
      b[0] = 7.0;
      b[1] = 8.0;
      b[2] = 9.0;
      b[3] = 10.0;
      b[4] = 11.0;
      b[5] = 12.0;

      final result = calloc<ffi.Double>(4);

      final success = UltraComplexFFI.matrixMultiplyF64(a, 2, 3, b, 3, 2, result);

      expect(success, isTrue);

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('convolution 1D', () {
      final signal = calloc<ffi.Double>(5);
      for (var i = 0; i < 5; i++) {
        signal[i] = i.toDouble();
      }

      final kernel = calloc<ffi.Double>(3);
      kernel[0] = 1.0;
      kernel[1] = 0.0;
      kernel[2] = -1.0;

      final result = calloc<ffi.Double>(7);

      UltraComplexFFI.convolution1d(signal, 5, kernel, 3, result);

      calloc.free(signal);
      calloc.free(kernel);
      calloc.free(result);
    });

    test('FFT magnitude', () {
      final real = calloc<ffi.Double>(8);
      final imag = calloc<ffi.Double>(8);
      final mag = calloc<ffi.Double>(8);

      for (var i = 0; i < 8; i++) {
        real[i] = i.toDouble();
        imag[i] = i.toDouble();
      }

      UltraComplexFFI.fftMagnitude(real, imag, 8, mag);

      for (var i = 0; i < 8; i++) {
        expect(mag[i], greaterThan(0));
      }

      calloc.free(real);
      calloc.free(imag);
      calloc.free(mag);
    });

    test('Pearson correlation', () {
      final x = calloc<ffi.Double>(10);
      final y = calloc<ffi.Double>(10);

      for (var i = 0; i < 10; i++) {
        x[i] = i.toDouble();
        y[i] = i.toDouble() * 2.0;
      }

      final corr = UltraComplexFFI.pearsonCorrelation(x, y, 10);

      expect(corr, closeTo(1.0, 0.001));

      calloc.free(x);
      calloc.free(y);
    });

    test('linear regression', () {
      final x = calloc<ffi.Double>(10);
      final y = calloc<ffi.Double>(10);

      for (var i = 0; i < 10; i++) {
        x[i] = i.toDouble();
        y[i] = 2.0 * i.toDouble() + 3.0;
      }

      final slope = calloc<ffi.Double>();
      final intercept = calloc<ffi.Double>();

      UltraComplexFFI.linearRegression(x, y, 10, slope, intercept);

      expect(slope.value, closeTo(2.0, 0.001));
      expect(intercept.value, closeTo(3.0, 0.001));

      calloc.free(x);
      calloc.free(y);
      calloc.free(slope);
      calloc.free(intercept);
    });
  });

  group('Performance Benchmarks', () {
    test('sort 100K elements', () {
      final arr = calloc<ffi.Int64>(100000);
      for (var i = 0; i < 100000; i++) {
        arr[i] = 100000 - i;
      }

      final sw = Stopwatch()..start();
      UltraComplexFFI.mergeSortI64(arr, 100000);
      sw.stop();

      print('Sort 100K elements: ${sw.elapsedMicroseconds}μs');
      expect(sw.elapsedMicroseconds, lessThan(100000));

      calloc.free(arr);
    });

    test('binary search 1M elements', () {
      final arr = calloc<ffi.Int64>(1000000);
      for (var i = 0; i < 1000000; i++) {
        arr[i] = i;
      }

      final sw = Stopwatch()..start();
      for (var i = 0; i < 1000; i++) {
        UltraComplexFFI.binarySearchI64(arr, 1000000, i * 1000);
      }
      sw.stop();

      print('1000 binary searches in 1M elements: ${sw.elapsedMicroseconds}μs');

      calloc.free(arr);
    });

    test('statistics on 1M values', () {
      final values = calloc<ffi.Double>(1000000);
      for (var i = 0; i < 1000000; i++) {
        values[i] = (i % 10000).toDouble();
      }

      final stats = Statistics.allocate();

      final sw = Stopwatch()..start();
      UltraComplexFFI.statisticsCompute(values, 1000000, stats);
      sw.stop();

      print('Statistics on 1M values: ${sw.elapsedMicroseconds}μs');
      expect(stats.ref.count, equals(1000000));

      calloc.free(values);
      calloc.free(stats);
    });

    test('memory intensive operation', () {
      final sw = Stopwatch()..start();
      final result = UltraComplexFFI.memoryIntensiveOperation(1000000);
      sw.stop();

      print('Memory intensive (1M elements): ${sw.elapsedMicroseconds}μs');
      expect(result, greaterThan(0));
    });
  });

  group('Memory Stress Tests', () {
    test('allocate and free large graph', () {
      final graph = Graph.allocate();
      graph.ref.num_nodes = 0;
      graph.ref.num_edges = 0;

      for (var i = 0; i < 1000; i++) {
        final node = GraphNode.allocate();
        node.ref.id = i;
        UltraComplexFFI.graphAddNode(graph, node);
        calloc.free(node);
      }

      expect(graph.ref.num_nodes, equals(1000));

      calloc.free(graph);
    });

    test('multiple large array allocations', () {
      final arrays = <ffi.Pointer<ffi.Int64>>[];

      for (var i = 0; i < 10; i++) {
        final arr = calloc<ffi.Int64>(10000);
        for (var j = 0; j < 10000; j++) {
          arr[j] = j;
        }
        arrays.add(arr);
      }

      for (var arr in arrays) {
        calloc.free(arr);
      }
    });
  });

  group('Edge Cases', () {
    test('empty array sort', () {
      final arr = calloc<ffi.Int64>(1);
      UltraComplexFFI.sortI64Array(arr, 0);
      calloc.free(arr);
    });

    test('single element sort', () {
      final arr = calloc<ffi.Int64>(1);
      arr[0] = 42;
      UltraComplexFFI.sortI64Array(arr, 1);
      expect(arr[0], equals(42));
      calloc.free(arr);
    });

    test('statistics on single value', () {
      final values = calloc<ffi.Double>(1);
      values[0] = 42.0;

      final stats = Statistics.allocate();
      UltraComplexFFI.statisticsCompute(values, 1, stats);

      expect(stats.ref.count, equals(1));
      expect(stats.ref.mean, closeTo(42.0, 0.001));
      expect(stats.ref.min, closeTo(42.0, 0.001));
      expect(stats.ref.max, closeTo(42.0, 0.001));

      calloc.free(values);
      calloc.free(stats);
    });

    test('zero vector length', () {
      final v = Vector3.allocate();
      v.ref.x = 0.0;
      v.ref.y = 0.0;
      v.ref.z = 0.0;

      final length = UltraComplexFFI.vector3Length(v);

      expect(length, closeTo(0.0, 0.001));

      calloc.free(v);
    });
  });
}
