import 'dart:ffi' as ffi;
import 'package:test/test.dart';
import 'package:ffi/ffi.dart';
import 'package:ffi_example/phase3.dart';
import 'package:ffi_example/phase3/generated.dart';

void main() {
  group('Particle Pool', () {
    setUp(() {
      Phase3FFI.poolResetStats();
    });

    test('initialization and allocation', () {
      Phase3FFI.particlePoolInit(100);

      final p1 = Phase3FFI.particlePoolAllocate();
      final p2 = Phase3FFI.particlePoolAllocate();

      expect(p1.address, isNot(equals(0)));
      expect(p2.address, isNot(equals(0)));
      expect(p1.address, isNot(equals(p2.address)));

      Phase3FFI.particlePoolFree(p1);
      Phase3FFI.particlePoolFree(p2);
    });

    test('reuse freed particles', () {
      Phase3FFI.particlePoolInit(10);

      final p1 = Phase3FFI.particlePoolAllocate();
      final addr1 = p1.address;

      Phase3FFI.particlePoolFree(p1);

      final p2 = Phase3FFI.particlePoolAllocate();
      final addr2 = p2.address;

      expect(addr2, equals(addr1));

      Phase3FFI.particlePoolFree(p2);
    });

    test('stats tracking', () {
      Phase3FFI.particlePoolInit(100);

      final stats = PoolStats.allocate();

      Phase3FFI.poolGetStats(stats);
      final initialAllocations = stats.ref.total_allocations;

      final p1 = Phase3FFI.particlePoolAllocate();
      final p2 = Phase3FFI.particlePoolAllocate();

      Phase3FFI.poolGetStats(stats);
      expect(stats.ref.total_allocations, equals(initialAllocations + 2));
      expect(stats.ref.active_objects, greaterThan(0));

      Phase3FFI.particlePoolFree(p1);
      Phase3FFI.particlePoolFree(p2);

      Phase3FFI.poolGetStats(stats);
      expect(stats.ref.total_frees, greaterThan(0));

      calloc.free(stats);
    });

    test('mass allocation and free', () {
      Phase3FFI.particlePoolInit(1000);

      final particles = <ffi.Pointer<Particle>>[];

      for (var i = 0; i < 500; i++) {
        particles.add(Phase3FFI.particlePoolAllocate());
      }

      expect(particles.length, equals(500));

      for (var p in particles) {
        Phase3FFI.particlePoolFree(p);
      }

      final stats = PoolStats.allocate();
      Phase3FFI.poolGetStats(stats);
      expect(stats.ref.total_allocations, greaterThanOrEqualTo(500));
      calloc.free(stats);
    });
  });

  group('RigidBody Pool', () {
    setUp(() {
      Phase3FFI.poolResetStats();
    });

    test('initialization and allocation', () {
      Phase3FFI.rigidbodyPoolInit(50);

      final rb1 = Phase3FFI.rigidbodyPoolAllocate();
      final rb2 = Phase3FFI.rigidbodyPoolAllocate();

      expect(rb1.address, isNot(equals(0)));
      expect(rb2.address, isNot(equals(0)));
      expect(rb1.address, isNot(equals(rb2.address)));

      Phase3FFI.rigidbodyPoolFree(rb1);
      Phase3FFI.rigidbodyPoolFree(rb2);
    });

    test('reuse freed bodies', () {
      Phase3FFI.rigidbodyPoolInit(10);

      final rb1 = Phase3FFI.rigidbodyPoolAllocate();
      final addr1 = rb1.address;

      rb1.ref.id = 12345;

      Phase3FFI.rigidbodyPoolFree(rb1);

      final rb2 = Phase3FFI.rigidbodyPoolAllocate();
      final addr2 = rb2.address;

      expect(addr2, equals(addr1));

      Phase3FFI.rigidbodyPoolFree(rb2);
    });
  });

  group('Particle Physics', () {
    test('particle update', () {
      Phase3FFI.particlePoolInit(10);

      final p = Phase3FFI.particlePoolAllocate();

      p.ref.x = 0.0;
      p.ref.y = 0.0;
      p.ref.z = 0.0;
      p.ref.vx = 10.0;
      p.ref.vy = 5.0;
      p.ref.vz = 2.0;
      p.ref.active = 1;

      Phase3FFI.particleUpdate(p, 1.0);

      expect(p.ref.x, equals(10.0));
      expect(p.ref.y, equals(5.0));
      expect(p.ref.z, equals(2.0));

      Phase3FFI.particleUpdate(p, 0.5);

      expect(p.ref.x, equals(15.0));
      expect(p.ref.y, equals(7.5));
      expect(p.ref.z, equals(3.0));

      Phase3FFI.particlePoolFree(p);
    });

    test('inactive particle not updated', () {
      Phase3FFI.particlePoolInit(10);

      final p = Phase3FFI.particlePoolAllocate();

      p.ref.x = 0.0;
      p.ref.vx = 10.0;
      p.ref.active = 0;

      Phase3FFI.particleUpdate(p, 1.0);

      expect(p.ref.x, equals(0.0));

      Phase3FFI.particlePoolFree(p);
    });

    test('simulation - 100 particles', () {
      Phase3FFI.particlePoolInit(100);

      final particles = <ffi.Pointer<Particle>>[];

      for (var i = 0; i < 100; i++) {
        final p = Phase3FFI.particlePoolAllocate();
        p.ref.x = 0.0;
        p.ref.y = 0.0;
        p.ref.z = 0.0;
        p.ref.vx = i.toDouble();
        p.ref.vy = i.toDouble() * 2;
        p.ref.vz = i.toDouble() * 3;
        p.ref.active = 1;
        particles.add(p);
      }

      final stopwatch = Stopwatch()..start();

      for (var step = 0; step < 100; step++) {
        for (var p in particles) {
          Phase3FFI.particleUpdate(p, 0.1);
        }
      }

      stopwatch.stop();
      print('100 particles, 100 steps: ${stopwatch.elapsedMicroseconds}μs');

      for (var i = 0; i < particles.length; i++) {
        expect(particles[i].ref.x, closeTo(i * 10.0, 0.001));
      }

      for (var p in particles) {
        Phase3FFI.particlePoolFree(p);
      }
    });
  });

  group('RigidBody Physics', () {
    test('rigidbody update', () {
      Phase3FFI.rigidbodyPoolInit(10);

      final rb = Phase3FFI.rigidbodyPoolAllocate();

      rb.ref.px = 0.0;
      rb.ref.py = 0.0;
      rb.ref.pz = 0.0;
      rb.ref.vx = 0.0;
      rb.ref.vy = 0.0;
      rb.ref.vz = 0.0;
      rb.ref.ax = 0.0;
      rb.ref.ay = -9.8;
      rb.ref.az = 0.0;

      Phase3FFI.rigidbodyUpdate(rb, 1.0);

      expect(rb.ref.vy, equals(-9.8));
      expect(rb.ref.py, equals(-9.8));

      Phase3FFI.rigidbodyUpdate(rb, 1.0);

      expect(rb.ref.vy, closeTo(-19.6, 0.001));
      expect(rb.ref.py, closeTo(-29.4, 0.001));

      Phase3FFI.rigidbodyPoolFree(rb);
    });
  });

  group('Performance Benchmarks', () {
    test('pool vs malloc - 1K allocations', () {
      final result = Phase3FFI.benchmarkPoolVsMalloc(1000, 10);

      print(result.toString());

      expect(result.poolTimeMicros, greaterThan(0));
      expect(result.mallocTimeMicros, greaterThan(0));
      expect(result.speedup, greaterThan(0));
    });

    test('pool vs malloc - 10K allocations', () {
      final result = Phase3FFI.benchmarkPoolVsMalloc(10000, 5);

      print(result.toString());

      expect(result.speedup, greaterThan(0.5));
    });

    test('pool allocation performance', () {
      Phase3FFI.particlePoolInit(10000);

      final stopwatch = Stopwatch()..start();

      final particles = <ffi.Pointer<Particle>>[];
      for (var i = 0; i < 10000; i++) {
        particles.add(Phase3FFI.particlePoolAllocate());
      }

      stopwatch.stop();
      print('10K pool allocations: ${stopwatch.elapsedMicroseconds}μs (${(stopwatch.elapsedMicroseconds / 10000).toStringAsFixed(2)}μs per allocation)');

      for (var p in particles) {
        Phase3FFI.particlePoolFree(p);
      }

      expect(stopwatch.elapsedMicroseconds, lessThan(10000));
    });

    test('calloc allocation performance baseline', () {
      final stopwatch = Stopwatch()..start();

      final particles = <ffi.Pointer<Particle>>[];
      for (var i = 0; i < 10000; i++) {
        particles.add(Particle.allocate());
      }

      stopwatch.stop();
      print('10K calloc allocations: ${stopwatch.elapsedMicroseconds}μs (${(stopwatch.elapsedMicroseconds / 10000).toStringAsFixed(2)}μs per allocation)');

      for (var p in particles) {
        calloc.free(p);
      }
    });

    test('zero-allocation physics loop', () {
      Phase3FFI.particlePoolInit(1000);

      final particles = <ffi.Pointer<Particle>>[];
      for (var i = 0; i < 1000; i++) {
        final p = Phase3FFI.particlePoolAllocate();
        p.ref.x = 0.0;
        p.ref.vx = 1.0;
        p.ref.active = 1;
        particles.add(p);
      }

      final stopwatch = Stopwatch()..start();

      for (var step = 0; step < 1000; step++) {
        for (var p in particles) {
          Phase3FFI.particleUpdate(p, 0.01);
        }
      }

      stopwatch.stop();
      print('1K particles, 1K steps (1M updates): ${stopwatch.elapsedMicroseconds}μs (${(stopwatch.elapsedMicroseconds / 1000000).toStringAsFixed(3)}μs per update)');

      expect(stopwatch.elapsedMicroseconds, lessThan(100000));

      for (var p in particles) {
        Phase3FFI.particlePoolFree(p);
      }
    });
  });

  group('Memory Safety', () {
    test('null pointer handling', () {
      final nullParticle = ffi.Pointer<Particle>.fromAddress(0);

      expect(() => Phase3FFI.particleUpdate(nullParticle, 1.0), returnsNormally);

      expect(() => Phase3FFI.particlePoolFree(nullParticle), returnsNormally);
    });

    test('pool stats after reset', () {
      Phase3FFI.particlePoolInit(10);

      final p = Phase3FFI.particlePoolAllocate();
      Phase3FFI.particlePoolFree(p);

      Phase3FFI.poolResetStats();

      final stats = PoolStats.allocate();
      Phase3FFI.poolGetStats(stats);

      expect(stats.ref.total_allocations, equals(0));
      expect(stats.ref.total_frees, equals(0));

      calloc.free(stats);
    });
  });
}
