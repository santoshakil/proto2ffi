import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import 'package:ffi_example/phase2.dart';
import 'package:ffi_example/phase2/generated.dart';

void main() {
  group('Vec3 operations', () {
    test('allocation and field access', () {
      final v = Vec3.allocate();
      v.ref.x = 1.0;
      v.ref.y = 2.0;
      v.ref.z = 3.0;

      expect(v.ref.x, equals(1.0));
      expect(v.ref.y, equals(2.0));
      expect(v.ref.z, equals(3.0));

      calloc.free(v);
    });

    test('memory layout verification', () {
      expect(VEC3_SIZE, equals(24));
      expect(VEC3_ALIGNMENT, equals(8));
    });
  });

  group('Color operations', () {
    test('RGBA values', () {
      final c = Color.allocate();
      c.ref.r = 255;
      c.ref.g = 128;
      c.ref.b = 64;
      c.ref.a = 255;

      expect(c.ref.r, equals(255));
      expect(c.ref.g, equals(128));
      expect(c.ref.b, equals(64));
      expect(c.ref.a, equals(255));

      calloc.free(c);
    });
  });

  group('Vertex operations', () {
    test('nested struct access', () {
      final v = Vertex.allocate();

      v.ref.position.x = 1.0;
      v.ref.position.y = 2.0;
      v.ref.position.z = 3.0;

      v.ref.normal.x = 0.0;
      v.ref.normal.y = 1.0;
      v.ref.normal.z = 0.0;

      v.ref.color.r = 255;
      v.ref.color.g = 0;
      v.ref.color.b = 0;
      v.ref.color.a = 255;

      expect(v.ref.position.x, equals(1.0));
      expect(v.ref.normal.y, equals(1.0));
      expect(v.ref.color.r, equals(255));

      expect(VERTEX_SIZE, equals(64));

      calloc.free(v);
    });
  });

  group('Triangle operations', () {
    test('repeated field - add vertices', () {
      final tri = Triangle.allocate();

      expect(tri.ref.vertices_count, equals(0));

      final v1 = tri.ref.get_next_vertice();
      v1.position.x = 0.0;
      v1.position.y = 0.0;
      v1.position.z = 0.0;
      expect(tri.ref.vertices_count, equals(1));

      final v2 = tri.ref.get_next_vertice();
      v2.position.x = 1.0;
      expect(tri.ref.vertices_count, equals(2));

      final v3 = tri.ref.get_next_vertice();
      v3.position.x = 2.0;
      expect(tri.ref.vertices_count, equals(3));

      final vertices = tri.ref.vertices;
      expect(vertices.length, equals(3));
      expect(vertices[0].position.x, equals(0.0));
      expect(vertices[1].position.x, equals(1.0));
      expect(vertices[2].position.x, equals(2.0));

      expect(() => tri.ref.get_next_vertice(), throwsException);

      expect(TRIANGLE_SIZE, equals(224));

      calloc.free(tri);
    });
  });

  group('Mesh operations', () {
    test('create cube', () {
      final mesh = Mesh.allocate();

      Phase2FFI.meshCreateCube(mesh, 2.0);

      expect(mesh.ref.triangles_count, equals(12));
      expect(mesh.ref.triangle_count, equals(12));

      final vertexCount = Phase2FFI.meshVertexCount(mesh);
      expect(vertexCount, equals(36));

      expect(MESH_SIZE, equals(22472));

      calloc.free(mesh);
    });

    test('calculate bounds', () {
      final mesh = Mesh.allocate();
      Phase2FFI.meshCreateCube(mesh, 2.0);

      final bounds = BoundingBox.allocate();
      Phase2FFI.meshCalculateBounds(mesh, bounds);

      expect(bounds.ref.min.x, equals(-1.0));
      expect(bounds.ref.min.y, equals(-1.0));
      expect(bounds.ref.min.z, equals(-1.0));
      expect(bounds.ref.max.x, equals(1.0));
      expect(bounds.ref.max.y, equals(1.0));
      expect(bounds.ref.max.z, equals(1.0));

      calloc.free(mesh);
      calloc.free(bounds);
    });

    test('transform mesh', () {
      final mesh = Mesh.allocate();
      Phase2FFI.meshCreateCube(mesh, 2.0);

      final offset = Vec3.allocate();
      offset.ref.x = 10.0;
      offset.ref.y = 20.0;
      offset.ref.z = 30.0;

      Phase2FFI.meshTransform(mesh, 2.0, offset);

      final bounds = BoundingBox.allocate();
      Phase2FFI.meshCalculateBounds(mesh, bounds);

      expect(bounds.ref.min.x, equals(8.0));
      expect(bounds.ref.min.y, equals(18.0));
      expect(bounds.ref.min.z, equals(28.0));
      expect(bounds.ref.max.x, equals(12.0));
      expect(bounds.ref.max.y, equals(22.0));
      expect(bounds.ref.max.z, equals(32.0));

      calloc.free(mesh);
      calloc.free(offset);
      calloc.free(bounds);
    });

    test('string field - name', () {
      final mesh = Mesh.allocate();

      mesh.ref.name = 'CubeMesh';
      expect(mesh.ref.name, equals('CubeMesh'));

      mesh.ref.name = 'A' * 70;
      expect(mesh.ref.name.length, lessThanOrEqualTo(63));

      calloc.free(mesh);
    });
  });

  group('Model operations', () {
    test('create model', () {
      final model = Model.allocate();
      final name = 'TestModel';

      Phase2FFI.modelCreate(model, name);

      expect(model.ref.id, greaterThan(0));

      expect(MODEL_SIZE, equals(22528));

      calloc.free(model);
    });

    test('full workflow - model with mesh', () {
      final model = Model.allocate();
      Phase2FFI.modelCreate(model, 'GameCube');

      final meshPtr = ffi.Pointer<Mesh>.fromAddress(model.address);
      Phase2FFI.meshCreateCube(meshPtr, 4.0);

      final vertexCount = Phase2FFI.meshVertexCount(meshPtr);
      expect(vertexCount, equals(36));

      final boundsOffset = MESH_SIZE;
      final boundsPtr = ffi.Pointer<BoundingBox>.fromAddress(model.address + boundsOffset);
      Phase2FFI.meshCalculateBounds(meshPtr, boundsPtr);

      expect(model.ref.bounds.min.x, equals(-2.0));
      expect(model.ref.bounds.max.x, equals(2.0));

      calloc.free(model);
    });

    test('performance - 100 triangle mesh', () {
      final mesh = Mesh.allocate();

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100; i++) {
        final tri = mesh.ref.get_next_triangle();
        tri.normal.x = 0.0;
        tri.normal.y = 1.0;
        tri.normal.z = 0.0;

        for (int j = 0; j < 3; j++) {
          final v = tri.get_next_vertice();
          v.position.x = i.toDouble();
          v.position.y = j.toDouble();
          v.position.z = 0.0;
        }
      }

      stopwatch.stop();
      print('Created ${mesh.ref.triangles_count} triangles in ${stopwatch.elapsedMicroseconds}μs');

      expect(mesh.ref.triangles_count, equals(100));

      calloc.free(mesh);
    });
  });

  group('Zero-copy verification', () {
    test('nested struct memory sharing', () {
      final mesh = Mesh.allocate();
      Phase2FFI.meshCreateCube(mesh, 2.0);

      final triangles = mesh.ref.triangles;
      final firstTriangle = triangles[0];
      final originalNormalX = firstTriangle.normal.x;

      final trianglesOffset = 8;
      final firstTriPtr = ffi.Pointer<Triangle>.fromAddress(mesh.address + trianglesOffset);
      firstTriPtr.ref.normal.x = 999.0;

      final newTriangles = mesh.ref.triangles;
      expect(newTriangles[0].normal.x, equals(999.0));

      calloc.free(mesh);
    });

    test('array access - direct memory', () {
      final mesh = Mesh.allocate();
      Phase2FFI.meshCreateCube(mesh, 2.0);

      final ptr = mesh.cast<ffi.Uint8>();
      final bytes = ptr.asTypedList(MESH_SIZE);

      final initialBytes = List<int>.from(bytes.take(100));

      mesh.ref.triangles_count = 0;

      final newBytes = ptr.asTypedList(MESH_SIZE);
      expect(newBytes.take(4).toList(), isNot(equals(initialBytes.take(4).toList())));

      calloc.free(mesh);
    });
  });
}
