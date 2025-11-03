import 'dart:io';
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:fixnum/fixnum.dart';
import 'package:proto_benchmark/generated_pb/benchmark_simple_pb.pb.dart' as pb;
import 'package:path/path.dart' as path;

import 'package:proto_benchmark/generated_ffi/proto.dart' as ffi_proto;
import 'package:proto_benchmark/generated_ffi/wrapper.dart' as ffi_wrapper;
import 'package:proto_benchmark/generated_ffi/ffi.dart' as ffi_types;

final class ByteBuffer extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Size()
  external int len;

  @ffi.Size()
  external int cap;
}

typedef EchoUserProtoNative = ByteBuffer Function(ffi.Pointer<ffi.Uint8>, ffi.Size);
typedef EchoUserProtoDart = ByteBuffer Function(ffi.Pointer<ffi.Uint8>, int);

typedef EchoPostProtoNative = ByteBuffer Function(ffi.Pointer<ffi.Uint8>, ffi.Size);
typedef EchoPostProtoDart = ByteBuffer Function(ffi.Pointer<ffi.Uint8>, int);

typedef FreeByteBufferNative = ffi.Void Function(ByteBuffer);
typedef FreeByteBufferDart = void Function(ByteBuffer);

typedef EchoUserNative = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);
typedef EchoUserDart = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);

void main() {
  print('═══════════════════════════════════════════════════════════');
  print('   PROTOBUF-OVER-FFI vs RAW FFI vs PURE PROTOBUF');
  print('═══════════════════════════════════════════════════════════\n');
  print('Testing 3 approaches:');
  print('  1. Pure Protobuf (encode/decode in Dart only)');
  print('  2. Protobuf-over-FFI (encode/decode on both sides)');
  print('  3. Raw FFI (struct-based, no encoding)\n');

  final libraryPath = path.join(
    Directory.current.parent.path,
    'dart_ffi/lib',
    'libbenchmark_ffi.dylib',
  );

  print('Loading FFI library from: $libraryPath');
  final dylib = ffi.DynamicLibrary.open(libraryPath);
  print('✅ FFI Library loaded\n');

  final userAPI = ffi_wrapper.UserAPI(dylib);
  final echoUser = dylib.lookupFunction<EchoUserNative, EchoUserDart>('echo_user');
  final echoUserProto = dylib.lookupFunction<EchoUserProtoNative, EchoUserProtoDart>('echo_user_proto');
  final freeByteBuffer = dylib.lookupFunction<FreeByteBufferNative, FreeByteBufferDart>('free_byte_buffer');

  print('Warming up JIT compiler (1000 iterations)...');
  for (var i = 0; i < 1000; i++) {
    final userPb = createUserPB(1);
    final bytes = userPb.writeToBuffer();
    pb.UserPB.fromBuffer(bytes);

    final userFfi = createUserFFI(1);
    final ptr = userAPI.send(userFfi);
    userAPI.free(ptr);
  }
  print('✅ Warmup complete\n');

  runSingleOperationBenchmark(userAPI, echoUser, echoUserProto, freeByteBuffer);
  runBulkOperationBenchmark(userAPI, echoUser, echoUserProto, freeByteBuffer);

  print('\n═══════════════════════════════════════════════════════════');
  print('                    BENCHMARK COMPLETE');
  print('═══════════════════════════════════════════════════════════');
}

void runSingleOperationBenchmark(
  ffi_wrapper.UserAPI userAPI,
  EchoUserDart echoUser,
  EchoUserProtoDart echoUserProto,
  FreeByteBufferDart freeByteBuffer,
) {
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  SINGLE OPERATION (1000 samples)');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final samples = 1000;
  final userPb = createUserPB(1);
  final userFfi = createUserFFI(1);

  // ═══ PURE PROTOBUF ═══
  print('📦 PURE PROTOBUF (Dart only):');
  print('   ─────────────────────────────────────');

  final purePbTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final bytes = userPb.writeToBuffer();
    final decoded = pb.UserPB.fromBuffer(bytes);

    sw.stop();
    purePbTimes.add(sw.elapsedMicroseconds.toDouble());
  }

  purePbTimes.sort();
  printStats('Pure Protobuf', purePbTimes, samples);

  // ═══ PROTOBUF-OVER-FFI ═══
  print('\n⚡ PROTOBUF-OVER-FFI (Hybrid):');
  print('   ─────────────────────────────────────');
  print('   (Dart encode → FFI → Rust decode → Rust encode → FFI → Dart decode)\n');

  final protoFFITimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final bytes = userPb.writeToBuffer();
    final bytesPtr = malloc.allocate<ffi.Uint8>(bytes.length);
    bytesPtr.asTypedList(bytes.length).setAll(0, bytes);

    final result = echoUserProto(bytesPtr, bytes.length);

    if (result.ptr != ffi.nullptr) {
      final resultBytes = result.ptr.asTypedList(result.len);
      final decoded = pb.UserPB.fromBuffer(resultBytes);
      freeByteBuffer(result);
    }

    malloc.free(bytesPtr);

    sw.stop();
    protoFFITimes.add(sw.elapsedMicroseconds.toDouble());
  }

  protoFFITimes.sort();
  printStats('Protobuf-over-FFI', protoFFITimes, samples);

  // ═══ RAW FFI ═══
  print('\n🔧 RAW FFI (Struct-based):');
  print('   ─────────────────────────────────────');
  print('   (Dart struct → FFI → Rust struct → FFI → Dart struct)\n');

  final rawFFITimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final ptr = userAPI.send(userFfi);
    final resultPtr = echoUser(ptr.cast());
    userAPI.free(ptr);
    if (resultPtr != ffi.nullptr) {
      final result = userAPI.receive(resultPtr.cast());
      userAPI.free(resultPtr.cast());
    }

    sw.stop();
    rawFFITimes.add(sw.elapsedMicroseconds.toDouble());
  }

  rawFFITimes.sort();
  printStats('Raw FFI', rawFFITimes, samples);

  // ═══ COMPARISON ═══
  print('\n📊 SINGLE OPERATION COMPARISON:');
  print('   ─────────────────────────────────────');

  final pbAvg = purePbTimes.reduce((a, b) => a + b) / purePbTimes.length;
  final protoFFIAvg = protoFFITimes.reduce((a, b) => a + b) / protoFFITimes.length;
  final rawFFIAvg = rawFFITimes.reduce((a, b) => a + b) / rawFFITimes.length;

  final pbMedian = purePbTimes[samples ~/ 2];
  final protoFFIMedian = protoFFITimes[samples ~/ 2];
  final rawFFIMedian = rawFFITimes[samples ~/ 2];

  print('   Metric          Pure PB    Proto-FFI  Raw FFI');
  print('   ────────────────────────────────────────────────────');
  print('   Median:         ${pbMedian.toStringAsFixed(2).padLeft(7)} μs  ${protoFFIMedian.toStringAsFixed(2).padLeft(7)} μs  ${rawFFIMedian.toStringAsFixed(2).padLeft(7)} μs');
  print('   Average:        ${pbAvg.toStringAsFixed(2).padLeft(7)} μs  ${protoFFIAvg.toStringAsFixed(2).padLeft(7)} μs  ${rawFFIAvg.toStringAsFixed(2).padLeft(7)} μs');

  print('\n   Proto-FFI vs Pure PB:  ${(protoFFIAvg / pbAvg).toStringAsFixed(2)}x');
  print('   Raw FFI vs Pure PB:    ${(rawFFIAvg / pbAvg).toStringAsFixed(2)}x');
  print('   Proto-FFI vs Raw FFI:  ${(protoFFIAvg / rawFFIAvg).toStringAsFixed(2)}x');
}

void runBulkOperationBenchmark(
  ffi_wrapper.UserAPI userAPI,
  EchoUserDart echoUser,
  EchoUserProtoDart echoUserProto,
  FreeByteBufferDart freeByteBuffer,
) {
  print('\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  BULK OPERATION (1000 messages, 100 samples)');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final listSize = 1000;
  final samples = 100;

  final usersPb = List.generate(listSize, (i) => createUserPB(i));
  final usersFFI = List.generate(listSize, (i) => createUserFFI(i));

  // ═══ PURE PROTOBUF ═══
  print('📦 PURE PROTOBUF (Dart only):');
  print('   ─────────────────────────────────────');

  final purePbTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final allBytes = <List<int>>[];
    for (final user in usersPb) {
      allBytes.add(user.writeToBuffer());
    }

    for (final bytes in allBytes) {
      pb.UserPB.fromBuffer(bytes);
    }

    sw.stop();
    purePbTimes.add(sw.elapsedMicroseconds.toDouble());
  }

  purePbTimes.sort();
  printBulkStats('Pure Protobuf', purePbTimes, samples, listSize);

  // ═══ PROTOBUF-OVER-FFI ═══
  print('\n⚡ PROTOBUF-OVER-FFI (Hybrid):');
  print('   ─────────────────────────────────────');

  final protoFFITimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    for (final user in usersPb) {
      final bytes = user.writeToBuffer();
      final bytesPtr = malloc.allocate<ffi.Uint8>(bytes.length);
      bytesPtr.asTypedList(bytes.length).setAll(0, bytes);

      final result = echoUserProto(bytesPtr, bytes.length);

      if (result.ptr != ffi.nullptr) {
        final resultBytes = result.ptr.asTypedList(result.len);
        pb.UserPB.fromBuffer(resultBytes);
        freeByteBuffer(result);
      }

      malloc.free(bytesPtr);
    }

    sw.stop();
    protoFFITimes.add(sw.elapsedMicroseconds.toDouble());
  }

  protoFFITimes.sort();
  printBulkStats('Protobuf-over-FFI', protoFFITimes, samples, listSize);

  // ═══ RAW FFI ═══
  print('\n🔧 RAW FFI (Struct-based):');
  print('   ─────────────────────────────────────');

  final rawFFITimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    for (final user in usersFFI) {
      final ptr = userAPI.send(user);
      final resultPtr = echoUser(ptr.cast());
      userAPI.free(ptr);
      if (resultPtr != ffi.nullptr) {
        final result = userAPI.receive(resultPtr.cast());
        userAPI.free(resultPtr.cast());
      }
    }

    sw.stop();
    rawFFITimes.add(sw.elapsedMicroseconds.toDouble());
  }

  rawFFITimes.sort();
  printBulkStats('Raw FFI', rawFFITimes, samples, listSize);

  // ═══ COMPARISON ═══
  print('\n📊 BULK OPERATION COMPARISON:');
  print('   ─────────────────────────────────────');

  final pbAvg = purePbTimes.reduce((a, b) => a + b) / purePbTimes.length;
  final protoFFIAvg = protoFFITimes.reduce((a, b) => a + b) / protoFFITimes.length;
  final rawFFIAvg = rawFFITimes.reduce((a, b) => a + b) / rawFFITimes.length;

  print('   Pure PB:     ${pbAvg.toStringAsFixed(2)} μs (${(pbAvg / listSize).toStringAsFixed(2)} μs/msg)');
  print('   Proto-FFI:   ${protoFFIAvg.toStringAsFixed(2)} μs (${(protoFFIAvg / listSize).toStringAsFixed(2)} μs/msg)');
  print('   Raw FFI:     ${rawFFIAvg.toStringAsFixed(2)} μs (${(rawFFIAvg / listSize).toStringAsFixed(2)} μs/msg)');

  print('\n   Proto-FFI vs Pure PB:  ${(protoFFIAvg / pbAvg).toStringAsFixed(2)}x');
  print('   Raw FFI vs Pure PB:    ${(rawFFIAvg / pbAvg).toStringAsFixed(2)}x');
  print('   Proto-FFI vs Raw FFI:  ${(protoFFIAvg / rawFFIAvg).toStringAsFixed(2)}x');
}

void printStats(String label, List<double> times, int samples) {
  final min = times.first;
  final max = times.last;
  final median = times[samples ~/ 2];
  final avg = times.reduce((a, b) => a + b) / times.length;
  final p95 = times[(samples * 0.95).floor()];
  final p99 = times[(samples * 0.99).floor()];

  print('   Min:     ${min.toStringAsFixed(2)} μs');
  print('   Median:  ${median.toStringAsFixed(2)} μs');
  print('   Average: ${avg.toStringAsFixed(2)} μs');
  print('   P95:     ${p95.toStringAsFixed(2)} μs');
  print('   P99:     ${p99.toStringAsFixed(2)} μs');
  print('   Max:     ${max.toStringAsFixed(2)} μs');
}

void printBulkStats(String label, List<double> times, int samples, int listSize) {
  final min = times.first;
  final median = times[samples ~/ 2];
  final avg = times.reduce((a, b) => a + b) / times.length;
  final p95 = times[(samples * 0.95).floor()];

  print('   Median:  ${median.toStringAsFixed(2)} μs (${(median / listSize).toStringAsFixed(2)} μs/msg)');
  print('   Average: ${avg.toStringAsFixed(2)} μs (${(avg / listSize).toStringAsFixed(2)} μs/msg)');
  print('   P95:     ${p95.toStringAsFixed(2)} μs (${(p95 / listSize).toStringAsFixed(2)} μs/msg)');
}

pb.UserPB createUserPB(int id) {
  return pb.UserPB()
    ..userId = Int64(id)
    ..username = 'user$id'
    ..email = 'user$id@example.com'
    ..firstName = 'First$id'
    ..lastName = 'Last$id'
    ..displayName = 'User $id'
    ..bio = 'This is a comprehensive bio for user $id. The user has interests in technology and coding.'
    ..avatarUrl = 'https://example.com/avatars/user$id.jpg'
    ..dateOfBirth = Int64(DateTime(1990 + (id % 30), 1, 1).millisecondsSinceEpoch)
    ..isVerified = id % 10 == 0
    ..isPremium = id % 5 == 0
    ..createdAt = Int64(DateTime.now().millisecondsSinceEpoch - (id * 86400000))
    ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch)
    ..accountBalance = id * 10.50
    ..reputationScore = id * 10;
}

ffi_proto.User createUserFFI(int id) {
  return ffi_proto.User(
    user_id: id,
    username: 'user$id',
    email: 'user$id@example.com',
    first_name: 'First$id',
    last_name: 'Last$id',
    display_name: 'User $id',
    bio: 'This is a comprehensive bio for user $id. The user has interests in technology and coding.',
    avatar_url: 'https://example.com/avatars/user$id.jpg',
    date_of_birth: DateTime(1990 + (id % 30), 1, 1).millisecondsSinceEpoch,
    is_verified: (id % 10 == 0) ? 1 : 0,
    is_premium: (id % 5 == 0) ? 1 : 0,
    created_at: DateTime.now().millisecondsSinceEpoch - (id * 86400000),
    updated_at: DateTime.now().millisecondsSinceEpoch,
    account_balance: id * 10.50,
    reputation_score: id * 10,
  );
}
