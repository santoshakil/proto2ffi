import 'dart:io';
import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:proto_benchmark/generated_pb/benchmark_simple_pb.pb.dart' as pb;
import 'package:path/path.dart' as path;

// Import FFI generated code
import 'package:proto_benchmark/generated_ffi/proto.dart' as ffi_proto;
import 'package:proto_benchmark/generated_ffi/wrapper.dart' as ffi_wrapper;
import 'package:proto_benchmark/generated_ffi/ffi.dart' as ffi_types;

// FFI function typedefs
typedef EchoUserNative = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);
typedef EchoUserDart = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);

typedef EchoPostNative = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);
typedef EchoPostDart = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);

void main() {
  print('═══════════════════════════════════════════════════════════');
  print('   SINGLE OPERATION: FFI vs Protobuf (Real-World Test)');
  print('═══════════════════════════════════════════════════════════\n');
  print('Testing individual message processing (not bulk)');
  print('This shows the REAL overhead per operation\n');

  // Load FFI library
  final libraryPath = path.join(
    Directory.current.parent.path,
    'dart_ffi/lib',
    'libbenchmark_ffi.dylib',
  );

  print('Loading FFI library from: $libraryPath');
  final dylib = ffi.DynamicLibrary.open(libraryPath);
  print('✅ FFI Library loaded\n');

  // Setup FFI wrapper
  final userAPI = ffi_wrapper.UserAPI(dylib);
  final postAPI = ffi_wrapper.PostAPI(dylib);

  // Get echo functions
  final echoUser = dylib.lookupFunction<EchoUserNative, EchoUserDart>('echo_user');
  final echoPost = dylib.lookupFunction<EchoPostNative, EchoPostDart>('echo_post');

  // Warm up JIT - important for accurate single-op measurements
  print('Warming up JIT compiler (1000 iterations)...');
  for (var i = 0; i < 1000; i++) {
    final userPb = createUserPB(1);
    userPb.writeToBuffer();
    pb.UserPB.fromBuffer(userPb.writeToBuffer());

    final userFfi = createUserFFI(1);
    final ptr = userAPI.send(userFfi);
    userAPI.free(ptr);
  }
  print('✅ Warmup complete\n');

  // Run single operation benchmarks
  benchmarkSingleUserOperation(userAPI, echoUser);
  benchmarkSinglePostOperation(postAPI, echoPost);

  print('\n═══════════════════════════════════════════════════════════');
  print('                    BENCHMARK COMPLETE');
  print('═══════════════════════════════════════════════════════════');
}

void benchmarkSingleUserOperation(ffi_wrapper.UserAPI userAPI, EchoUserDart echoUser) {
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  TEST 1: User Message - SINGLE OPERATION');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final samples = 1000;
  final times = <double>[];

  // ═══ PROTOBUF BENCHMARK ═══
  print('📦 PROTOBUF (Serialization):');
  print('   ─────────────────────────────────────');

  final userPb = createUserPB(1);
  final pbSize = userPb.writeToBuffer().length;
  print('   Serialized size: $pbSize bytes\n');

  print('   Running $samples individual operations...');

  // Measure each single operation
  final pbTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    // SINGLE OPERATION: Encode
    final bytes = userPb.writeToBuffer();

    // SINGLE OPERATION: Decode
    final decoded = pb.UserPB.fromBuffer(bytes);

    sw.stop();
    pbTimes.add(sw.elapsedMicroseconds.toDouble());
  }

  // Calculate statistics
  pbTimes.sort();
  final pbMin = pbTimes.first;
  final pbMax = pbTimes.last;
  final pbMedian = pbTimes[samples ~/ 2];
  final pbAvg = pbTimes.reduce((a, b) => a + b) / pbTimes.length;
  final pbP95 = pbTimes[(samples * 0.95).floor()];
  final pbP99 = pbTimes[(samples * 0.99).floor()];

  print('   Min:     ${pbMin.toStringAsFixed(2)} μs');
  print('   Median:  ${pbMedian.toStringAsFixed(2)} μs');
  print('   Average: ${pbAvg.toStringAsFixed(2)} μs');
  print('   P95:     ${pbP95.toStringAsFixed(2)} μs');
  print('   P99:     ${pbP99.toStringAsFixed(2)} μs');
  print('   Max:     ${pbMax.toStringAsFixed(2)} μs');
  print('   Throughput: ${(1000000 / pbAvg).round()} ops/sec\n');

  // ═══ FFI BENCHMARK ═══
  print('⚡ PROTO2FFI (Direct FFI):');
  print('   ─────────────────────────────────────');

  final userFfi = createUserFFI(1);
  print('   FFI struct size: ${ffi_types.USER_SIZE} bytes\n');

  print('   Running $samples individual operations...');

  final ffiTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    // SINGLE OPERATION: Send to FFI
    final ptr = userAPI.send(userFfi);

    // SINGLE OPERATION: FFI call
    final resultPtr = echoUser(ptr.cast());

    // SINGLE OPERATION: Receive from FFI
    final decoded = userAPI.receive(resultPtr.cast());

    // Cleanup
    userAPI.free(ptr);
    userAPI.free(resultPtr.cast());

    sw.stop();
    ffiTimes.add(sw.elapsedMicroseconds.toDouble());
  }

  // Calculate statistics
  ffiTimes.sort();
  final ffiMin = ffiTimes.first;
  final ffiMax = ffiTimes.last;
  final ffiMedian = ffiTimes[samples ~/ 2];
  final ffiAvg = ffiTimes.reduce((a, b) => a + b) / ffiTimes.length;
  final ffiP95 = ffiTimes[(samples * 0.95).floor()];
  final ffiP99 = ffiTimes[(samples * 0.99).floor()];

  print('   Min:     ${ffiMin.toStringAsFixed(2)} μs');
  print('   Median:  ${ffiMedian.toStringAsFixed(2)} μs');
  print('   Average: ${ffiAvg.toStringAsFixed(2)} μs');
  print('   P95:     ${ffiP95.toStringAsFixed(2)} μs');
  print('   P99:     ${ffiP99.toStringAsFixed(2)} μs');
  print('   Max:     ${ffiMax.toStringAsFixed(2)} μs');
  print('   Throughput: ${(1000000 / ffiAvg).round()} ops/sec\n');

  // ═══ COMPARISON ═══
  print('📊 SINGLE OPERATION COMPARISON:');
  print('   ─────────────────────────────────────');
  print('   Metric          Protobuf      FFI         Winner');
  print('   ────────────────────────────────────────────────');
  print('   Min:            ${pbMin.toStringAsFixed(2)} μs      ${ffiMin.toStringAsFixed(2)} μs      ${ffiMin < pbMin ? "FFI" : "Protobuf"}');
  print('   Median:         ${pbMedian.toStringAsFixed(2)} μs      ${ffiMedian.toStringAsFixed(2)} μs      ${ffiMedian < pbMedian ? "FFI" : "Protobuf"}');
  print('   Average:        ${pbAvg.toStringAsFixed(2)} μs      ${ffiAvg.toStringAsFixed(2)} μs      ${ffiAvg < pbAvg ? "FFI" : "Protobuf"}');
  print('   P95:            ${pbP95.toStringAsFixed(2)} μs      ${ffiP95.toStringAsFixed(2)} μs      ${ffiP95 < pbP95 ? "FFI" : "Protobuf"}');
  print('   P99:            ${pbP99.toStringAsFixed(2)} μs      ${ffiP99.toStringAsFixed(2)} μs      ${ffiP99 < pbP99 ? "FFI" : "Protobuf"}');
  print('');

  final speedupAvg = pbAvg / ffiAvg;
  final speedupMedian = pbMedian / ffiMedian;

  print('   Average speedup: ${speedupAvg.toStringAsFixed(2)}x');
  print('   Median speedup:  ${speedupMedian.toStringAsFixed(2)}x\n');

  if (speedupAvg > 1) {
    print('   🏆 Proto2FFI is ${speedupAvg.toStringAsFixed(1)}x faster on average!');
  } else {
    print('   ⚠️  Protobuf is ${(1 / speedupAvg).toStringAsFixed(1)}x faster on average');
  }
  print('');
}

void benchmarkSinglePostOperation(ffi_wrapper.PostAPI postAPI, EchoPostDart echoPost) {
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  TEST 2: Post Message - SINGLE OPERATION');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final samples = 1000;

  // ═══ PROTOBUF BENCHMARK ═══
  print('📦 PROTOBUF (Serialization):');
  print('   ─────────────────────────────────────');

  final postPb = createPostPB(1, 1);
  final pbSize = postPb.writeToBuffer().length;
  print('   Serialized size: $pbSize bytes\n');

  print('   Running $samples individual operations...');

  final pbTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final bytes = postPb.writeToBuffer();
    final decoded = pb.PostPB.fromBuffer(bytes);

    sw.stop();
    pbTimes.add(sw.elapsedMicroseconds.toDouble());
  }

  pbTimes.sort();
  final pbMin = pbTimes.first;
  final pbMax = pbTimes.last;
  final pbMedian = pbTimes[samples ~/ 2];
  final pbAvg = pbTimes.reduce((a, b) => a + b) / pbTimes.length;
  final pbP95 = pbTimes[(samples * 0.95).floor()];
  final pbP99 = pbTimes[(samples * 0.99).floor()];

  print('   Min:     ${pbMin.toStringAsFixed(2)} μs');
  print('   Median:  ${pbMedian.toStringAsFixed(2)} μs');
  print('   Average: ${pbAvg.toStringAsFixed(2)} μs');
  print('   P95:     ${pbP95.toStringAsFixed(2)} μs');
  print('   P99:     ${pbP99.toStringAsFixed(2)} μs');
  print('   Max:     ${pbMax.toStringAsFixed(2)} μs');
  print('   Throughput: ${(1000000 / pbAvg).round()} ops/sec\n');

  // ═══ FFI BENCHMARK ═══
  print('⚡ PROTO2FFI (Direct FFI):');
  print('   ─────────────────────────────────────');

  final postFfi = createPostFFI(1, 1);
  print('   FFI struct size: ${ffi_types.POST_SIZE} bytes\n');

  print('   Running $samples individual operations...');

  final ffiTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final ptr = postAPI.send(postFfi);
    final resultPtr = echoPost(ptr.cast());
    final decoded = postAPI.receive(resultPtr.cast());

    postAPI.free(ptr);
    postAPI.free(resultPtr.cast());

    sw.stop();
    ffiTimes.add(sw.elapsedMicroseconds.toDouble());
  }

  ffiTimes.sort();
  final ffiMin = ffiTimes.first;
  final ffiMax = ffiTimes.last;
  final ffiMedian = ffiTimes[samples ~/ 2];
  final ffiAvg = ffiTimes.reduce((a, b) => a + b) / ffiTimes.length;
  final ffiP95 = ffiTimes[(samples * 0.95).floor()];
  final ffiP99 = ffiTimes[(samples * 0.99).floor()];

  print('   Min:     ${ffiMin.toStringAsFixed(2)} μs');
  print('   Median:  ${ffiMedian.toStringAsFixed(2)} μs');
  print('   Average: ${ffiAvg.toStringAsFixed(2)} μs');
  print('   P95:     ${ffiP95.toStringAsFixed(2)} μs');
  print('   P99:     ${ffiP99.toStringAsFixed(2)} μs');
  print('   Max:     ${ffiMax.toStringAsFixed(2)} μs');
  print('   Throughput: ${(1000000 / ffiAvg).round()} ops/sec\n');

  // ═══ COMPARISON ═══
  print('📊 SINGLE OPERATION COMPARISON:');
  print('   ─────────────────────────────────────');
  print('   Metric          Protobuf      FFI         Winner');
  print('   ────────────────────────────────────────────────');
  print('   Min:            ${pbMin.toStringAsFixed(2)} μs      ${ffiMin.toStringAsFixed(2)} μs      ${ffiMin < pbMin ? "FFI" : "Protobuf"}');
  print('   Median:         ${pbMedian.toStringAsFixed(2)} μs      ${ffiMedian.toStringAsFixed(2)} μs      ${ffiMedian < pbMedian ? "FFI" : "Protobuf"}');
  print('   Average:        ${pbAvg.toStringAsFixed(2)} μs      ${ffiAvg.toStringAsFixed(2)} μs      ${ffiAvg < pbAvg ? "FFI" : "Protobuf"}');
  print('   P95:            ${pbP95.toStringAsFixed(2)} μs      ${ffiP95.toStringAsFixed(2)} μs      ${ffiP95 < pbP95 ? "FFI" : "Protobuf"}');
  print('   P99:            ${pbP99.toStringAsFixed(2)} μs      ${ffiP99.toStringAsFixed(2)} μs      ${ffiP99 < pbP99 ? "FFI" : "Protobuf"}');
  print('');

  final speedupAvg = pbAvg / ffiAvg;
  final speedupMedian = pbMedian / ffiMedian;

  print('   Average speedup: ${speedupAvg.toStringAsFixed(2)}x');
  print('   Median speedup:  ${speedupMedian.toStringAsFixed(2)}x\n');

  if (speedupAvg > 1) {
    print('   🏆 Proto2FFI is ${speedupAvg.toStringAsFixed(1)}x faster on average!');
  } else {
    print('   ⚠️  Protobuf is ${(1 / speedupAvg).toStringAsFixed(1)}x faster on average');
  }
  print('');
}

// Helper functions

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

pb.PostPB createPostPB(int id, int userId) {
  return pb.PostPB()
    ..postId = Int64(id)
    ..userId = Int64(userId)
    ..username = 'user$userId'
    ..title = 'This is an interesting post title #$id'
    ..content = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt '
        'ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco '
        'laboris nisi ut aliquip ex ea commodo consequat.'
    ..createdAt = Int64(DateTime.now().millisecondsSinceEpoch - (id * 3600000))
    ..updatedAt = Int64(DateTime.now().millisecondsSinceEpoch)
    ..viewCount = Int64(id * 100)
    ..likeCount = Int64(id * 10)
    ..commentCount = Int64(id * 5)
    ..isEdited = false
    ..isPinned = false;
}

ffi_proto.Post createPostFFI(int id, int userId) {
  return ffi_proto.Post(
    post_id: id,
    user_id: userId,
    username: 'user$userId',
    title: 'This is an interesting post title #$id',
    content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt '
        'ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco '
        'laboris nisi ut aliquip ex ea commodo consequat.',
    created_at: DateTime.now().millisecondsSinceEpoch - (id * 3600000),
    updated_at: DateTime.now().millisecondsSinceEpoch,
    view_count: id * 100,
    like_count: id * 10,
    comment_count: id * 5,
    is_edited: 0,
    is_pinned: 0,
  );
}
