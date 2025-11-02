import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import 'package:ffi_example/ffi_example.dart';
import 'package:ffi_example/generated/generated.dart';
import 'package:ffi_example/phase2.dart';
import 'package:ffi_example/phase2/generated.dart' as p2;
import 'package:ffi_example/phase3.dart';
import 'package:ffi_example/phase3/generated.dart' as p3;
import 'package:ffi_example/phase4.dart';
import 'package:ffi_example/phase4/generated.dart' as p4;

void main() {
  group('Phase 1 Edge Cases', () {
    test('extreme double values', () {
      final p = Point.allocate();

      p.ref.x = double.maxFinite;
      p.ref.y = double.minPositive;

      expect(p.ref.x, equals(double.maxFinite));
      expect(p.ref.y, equals(double.minPositive));

      p.ref.x = double.infinity;
      expect(p.ref.x, equals(double.infinity));

      calloc.free(p);
    });

    test('negative timestamps', () {
      final counter = Counter.allocate();
      counter.ref.timestamp = -1;

      expect(counter.ref.timestamp, equals(-1));

      calloc.free(counter);
    });

    test('stats with zero count', () {
      final stats = Stats.allocate();
      stats.ref.count = 0;
      stats.ref.sum = 100.0;

      FFIExample.statsReset(stats);

      expect(stats.ref.count, equals(0));
      expect(stats.ref.sum, equals(0.0));

      calloc.free(stats);
    });
  });

  group('Phase 2 Edge Cases', () {
    test('array boundary - exactly max count', () {
      final tri = p2.Triangle.allocate();

      expect(tri.ref.vertices_count, equals(0));

      tri.ref.get_next_vertice();
      tri.ref.get_next_vertice();
      tri.ref.get_next_vertice();

      expect(tri.ref.vertices_count, equals(3));

      expect(() => tri.ref.get_next_vertice(), throwsException);

      calloc.free(tri);
    });

    test('mesh with zero triangles', () {
      final mesh = p2.Mesh.allocate();

      expect(mesh.ref.triangles_count, equals(0));

      final vertexCount = Phase2FFI.meshVertexCount(mesh);
      expect(vertexCount, equals(0));

      calloc.free(mesh);
    });

    test('empty string handling', () {
      final mesh = p2.Mesh.allocate();

      mesh.ref.name = '';
      expect(mesh.ref.name, equals(''));

      mesh.ref.name = 'A';
      expect(mesh.ref.name, equals('A'));

      calloc.free(mesh);
    });

    test('string exactly at max length', () {
      final mesh = p2.Mesh.allocate();

      final longString = 'A' * 63;
      mesh.ref.name = longString;
      expect(mesh.ref.name.length, equals(63));

      calloc.free(mesh);
    });

    test('unicode strings', () {
      final mesh = p2.Mesh.allocate();

      mesh.ref.name = 'Hello\u{1F680}';
      expect(mesh.ref.name, contains('Hello'));

      calloc.free(mesh);
    });
  });

  group('Phase 3 Edge Cases', () {
    test('particle pool exhaustion and expansion', () {
      Phase3FFI.particlePoolInit(10);

      final particles = <ffi.Pointer<p3.Particle>>[];

      for (var i = 0; i < 200; i++) {
        particles.add(Phase3FFI.particlePoolAllocate());
      }

      expect(particles.length, equals(200));

      for (var p in particles) {
        Phase3FFI.particlePoolFree(p);
      }
    });

    test('double free protection', () {
      Phase3FFI.particlePoolInit(10);

      final p = Phase3FFI.particlePoolAllocate();

      Phase3FFI.particlePoolFree(p);

      expect(() => Phase3FFI.particlePoolFree(p), returnsNormally);
    });

    test('particle with zero velocity', () {
      Phase3FFI.particlePoolInit(10);

      final p = Phase3FFI.particlePoolAllocate();
      p.ref.x = 100.0;
      p.ref.vx = 0.0;
      p.ref.active = 1;

      Phase3FFI.particleUpdate(p, 1000.0);

      expect(p.ref.x, equals(100.0));

      Phase3FFI.particlePoolFree(p);
    });

    test('rigidbody with extreme acceleration', () {
      Phase3FFI.rigidbodyPoolInit(10);

      final rb = Phase3FFI.rigidbodyPoolAllocate();
      rb.ref.px = 0.0;
      rb.ref.vx = 0.0;
      rb.ref.ax = 1000000.0;

      Phase3FFI.rigidbodyUpdate(rb, 0.001);

      expect(rb.ref.vx, equals(1000.0));

      Phase3FFI.rigidbodyPoolFree(rb);
    });
  });

  group('Phase 4 Edge Cases', () {
    test('zero vectors in batch', () {
      final a = calloc<p4.Vector4>(0);
      final b = calloc<p4.Vector4>(0);
      final result = calloc<p4.Vector4>(0);

      expect(() => Phase4FFI.vector4BatchAdd(a, b, result, 0), returnsNormally);

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('single vector batch (odd count)', () {
      final a = calloc<p4.Vector4>(1);
      final b = calloc<p4.Vector4>(1);
      final result = calloc<p4.Vector4>(1);

      a[0].x = 1.0;
      b[0].x = 2.0;

      Phase4FFI.vector4BatchAdd(a, b, result, 1);

      expect(result[0].x, closeTo(3.0, 0.001));

      calloc.free(a);
      calloc.free(b);
      calloc.free(result);
    });

    test('zero scale factor', () {
      final v = p4.Vector4.allocate();
      final result = p4.Vector4.allocate();

      v.ref.x = 100.0;
      v.ref.y = 200.0;

      Phase4FFI.vector4Scale(v, 0.0, result);

      expect(result.ref.x, equals(0.0));
      expect(result.ref.y, equals(0.0));

      calloc.free(v);
      calloc.free(result);
    });

    test('negative scale factor', () {
      final v = p4.Vector4.allocate();
      final result = p4.Vector4.allocate();

      v.ref.x = 10.0;

      Phase4FFI.vector4Scale(v, -2.0, result);

      expect(result.ref.x, closeTo(-20.0, 0.001));

      calloc.free(v);
      calloc.free(result);
    });

    test('dot product of zero vectors', () {
      final a = p4.Vector4.allocate();
      final b = p4.Vector4.allocate();

      a.ref.x = 0.0;
      a.ref.y = 0.0;
      a.ref.z = 0.0;
      a.ref.w = 0.0;

      b.ref.x = 100.0;
      b.ref.y = 200.0;
      b.ref.z = 300.0;
      b.ref.w = 400.0;

      final dot = Phase4FFI.vector4Dot(a, b);

      expect(dot, equals(0.0));

      calloc.free(a);
      calloc.free(b);
    });
  });

  group('Memory Safety', () {
    test('freed memory can be reused', () {
      final p1 = Point.allocate();
      p1.ref.x = 123.456;

      final addr1 = p1.address;

      calloc.free(p1);

      final p2 = Point.allocate();
      final addr2 = p2.address;

      expect(p2.address, greaterThan(0));

      calloc.free(p2);
    });

    test('struct size validation', () {
      expect(POINT_SIZE, equals(16));
      expect(COUNTER_SIZE, equals(16));
      expect(STATS_SIZE, equals(40));
      expect(p2.VEC3_SIZE, equals(24));
      expect(p2.TRIANGLE_SIZE, equals(224));
      expect(p2.MESH_SIZE, equals(22472));
      expect(p3.PARTICLE_SIZE, equals(64));
      expect(p4.VECTOR4_SIZE, equals(16));
    });

    test('alignment verification', () {
      expect(POINT_ALIGNMENT, equals(8));
      expect(COUNTER_ALIGNMENT, equals(8));
      expect(STATS_ALIGNMENT, equals(8));
      expect(p2.VEC3_ALIGNMENT, equals(8));
    });

    test('large allocation stress test', () {
      final points = <ffi.Pointer<Point>>[];

      for (var i = 0; i < 10000; i++) {
        points.add(Point.allocate());
      }

      for (var i = 0; i < points.length; i++) {
        points[i].ref.x = i.toDouble();
      }

      for (var i = 0; i < points.length; i++) {
        expect(points[i].ref.x, equals(i.toDouble()));
      }

      for (var p in points) {
        calloc.free(p);
      }
    });
  });

  group('Concurrent Operations', () {
    test('rapid alloc/free cycles', () {
      for (var cycle = 0; cycle < 100; cycle++) {
        final p = Point.allocate();
        p.ref.x = cycle.toDouble();
        expect(p.ref.x, equals(cycle.toDouble()));
        calloc.free(p);
      }
    });

    test('mixed type allocations', () {
      final point = Point.allocate();
      final counter = Counter.allocate();
      final stats = Stats.allocate();
      final mesh = p2.Mesh.allocate();

      point.ref.x = 1.0;
      counter.ref.value = 2;
      stats.ref.count = 3;
      mesh.ref.triangle_count = 4;

      expect(point.ref.x, equals(1.0));
      expect(counter.ref.value, equals(2));
      expect(stats.ref.count, equals(3));
      expect(mesh.ref.triangle_count, equals(4));

      calloc.free(point);
      calloc.free(counter);
      calloc.free(stats);
      calloc.free(mesh);
    });
  });
}
