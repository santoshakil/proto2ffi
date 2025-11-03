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
  print('    FFI (Proto2FFI) vs Protobuf Performance Comparison');
  print('═══════════════════════════════════════════════════════════\n');

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

  // Warm up JIT
  print('Warming up JIT compiler...');
  for (var i = 0; i < 100; i++) {
    // Protobuf warmup
    final userPb = createUserPB(1);
    userPb.writeToBuffer();
    pb.UserPB.fromBuffer(userPb.writeToBuffer());

    // FFI warmup
    final userFfi = createUserFFI(1);
    final ptr = userAPI.send(userFfi);
    userAPI.free(ptr);
  }
  print('✅ Warmup complete\n');

  // Run benchmarks
  benchmarkUserComparison(userAPI, echoUser);
  benchmarkPostComparison(postAPI, echoPost);

  print('\n═══════════════════════════════════════════════════════════');
  print('                    BENCHMARK COMPLETE');
  print('═══════════════════════════════════════════════════════════');
}

void benchmarkUserComparison(ffi_wrapper.UserAPI userAPI, EchoUserDart echoUser) {
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  TEST 1: User Message (~15 fields, ~600 bytes)');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final iterations = 10000;

  // ═══ PROTOBUF BENCHMARK ═══
  print('📦 PROTOBUF (Standard Serialization):');
  print('   ─────────────────────────────────────');

  final userPb = createUserPB(1);
  final pbSize = userPb.writeToBuffer().length;
  print('   Serialized size: $pbSize bytes');

  // Encode
  final pbEncodeWatch = Stopwatch()..start();
  Uint8List? lastPbEncoded;
  for (var i = 0; i < iterations; i++) {
    lastPbEncoded = userPb.writeToBuffer();
  }
  pbEncodeWatch.stop();

  // Decode
  final pbDecodeWatch = Stopwatch()..start();
  pb.UserPB? decodedPb;
  for (var i = 0; i < iterations; i++) {
    decodedPb = pb.UserPB.fromBuffer(lastPbEncoded!);
  }
  pbDecodeWatch.stop();

  final pbEncodeAvg = pbEncodeWatch.elapsedMicroseconds / iterations;
  final pbDecodeAvg = pbDecodeWatch.elapsedMicroseconds / iterations;
  final pbRoundTrip = pbEncodeAvg + pbDecodeAvg;

  print('   Encode:      ${pbEncodeAvg.toStringAsFixed(2)} μs  (${(1000000 / pbEncodeAvg).round()} ops/sec)');
  print('   Decode:      ${pbDecodeAvg.toStringAsFixed(2)} μs  (${(1000000 / pbDecodeAvg).round()} ops/sec)');
  print('   Round-trip:  ${pbRoundTrip.toStringAsFixed(2)} μs  (${(1000000 / pbRoundTrip).round()} ops/sec)\n');

  // ═══ FFI BENCHMARK ═══
  print('⚡ PROTO2FFI (Direct FFI - Zero Copy):');
  print('   ─────────────────────────────────────');

  final userFfi = createUserFFI(1);
  final ffiPtr = userAPI.send(userFfi);
  print('   FFI struct size: ${ffi_types.USER_SIZE} bytes');

  // Send to Rust and receive back
  final ffiWatch = Stopwatch()..start();
  ffi.Pointer<ffi.Void>? lastPtr;
  for (var i = 0; i < iterations; i++) {
    final ptr = userAPI.send(userFfi);
    lastPtr = echoUser(ptr.cast());
    userAPI.free(ptr);
    if (lastPtr != ffi.nullptr) {
      userAPI.free(lastPtr.cast());
    }
  }
  ffiWatch.stop();

  final ffiAvg = ffiWatch.elapsedMicroseconds / iterations;

  print('   Send + FFI call + Receive: ${ffiAvg.toStringAsFixed(2)} μs  (${(1000000 / ffiAvg).round()} ops/sec)\n');

  // Clean up
  userAPI.free(ffiPtr);

  // ═══ COMPARISON ═══
  print('📊 PERFORMANCE COMPARISON:');
  print('   ─────────────────────────────────────');
  final speedup = pbRoundTrip / ffiAvg;
  print('   Protobuf round-trip: ${pbRoundTrip.toStringAsFixed(2)} μs');
  print('   FFI round-trip:      ${ffiAvg.toStringAsFixed(2)} μs');
  print('   Speedup:             ${speedup.toStringAsFixed(2)}x FASTER\n');

  if (speedup > 1) {
    print('   🏆 Proto2FFI is ${speedup.toStringAsFixed(1)}x faster than Protobuf!');
  } else {
    print('   ⚠️  Protobuf is ${(1 / speedup).toStringAsFixed(1)}x faster than FFI');
  }
  print('');
}

void benchmarkPostComparison(ffi_wrapper.PostAPI postAPI, EchoPostDart echoPost) {
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  TEST 2: Post Message (~12 fields, ~1KB with content)');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final iterations = 10000;

  // ═══ PROTOBUF BENCHMARK ═══
  print('📦 PROTOBUF (Standard Serialization):');
  print('   ─────────────────────────────────────');

  final postPb = createPostPB(1, 1);
  final pbSize = postPb.writeToBuffer().length;
  print('   Serialized size: $pbSize bytes');

  // Encode
  final pbEncodeWatch = Stopwatch()..start();
  Uint8List? lastPbEncoded;
  for (var i = 0; i < iterations; i++) {
    lastPbEncoded = postPb.writeToBuffer();
  }
  pbEncodeWatch.stop();

  // Decode
  final pbDecodeWatch = Stopwatch()..start();
  pb.PostPB? decodedPb;
  for (var i = 0; i < iterations; i++) {
    decodedPb = pb.PostPB.fromBuffer(lastPbEncoded!);
  }
  pbDecodeWatch.stop();

  final pbEncodeAvg = pbEncodeWatch.elapsedMicroseconds / iterations;
  final pbDecodeAvg = pbDecodeWatch.elapsedMicroseconds / iterations;
  final pbRoundTrip = pbEncodeAvg + pbDecodeAvg;

  print('   Encode:      ${pbEncodeAvg.toStringAsFixed(2)} μs  (${(1000000 / pbEncodeAvg).round()} ops/sec)');
  print('   Decode:      ${pbDecodeAvg.toStringAsFixed(2)} μs  (${(1000000 / pbDecodeAvg).round()} ops/sec)');
  print('   Round-trip:  ${pbRoundTrip.toStringAsFixed(2)} μs  (${(1000000 / pbRoundTrip).round()} ops/sec)\n');

  // ═══ FFI BENCHMARK ═══
  print('⚡ PROTO2FFI (Direct FFI - Zero Copy):');
  print('   ─────────────────────────────────────');

  final postFfi = createPostFFI(1, 1);
  final ffiPtr = postAPI.send(postFfi);
  print('   FFI struct size: ${ffi_types.POST_SIZE} bytes');

  // Send to Rust and receive back
  final ffiWatch = Stopwatch()..start();
  ffi.Pointer<ffi.Void>? lastPtr;
  for (var i = 0; i < iterations; i++) {
    final ptr = postAPI.send(postFfi);
    lastPtr = echoPost(ptr.cast());
    postAPI.free(ptr);
    if (lastPtr != ffi.nullptr) {
      postAPI.free(lastPtr.cast());
    }
  }
  ffiWatch.stop();

  final ffiAvg = ffiWatch.elapsedMicroseconds / iterations;

  print('   Send + FFI call + Receive: ${ffiAvg.toStringAsFixed(2)} μs  (${(1000000 / ffiAvg).round()} ops/sec)\n');

  // Clean up
  postAPI.free(ffiPtr);

  // ═══ COMPARISON ═══
  print('📊 PERFORMANCE COMPARISON:');
  print('   ─────────────────────────────────────');
  final speedup = pbRoundTrip / ffiAvg;
  print('   Protobuf round-trip: ${pbRoundTrip.toStringAsFixed(2)} μs');
  print('   FFI round-trip:      ${ffiAvg.toStringAsFixed(2)} μs');
  print('   Speedup:             ${speedup.toStringAsFixed(2)}x FASTER\n');

  if (speedup > 1) {
    print('   🏆 Proto2FFI is ${speedup.toStringAsFixed(1)}x faster than Protobuf!');
  } else {
    print('   ⚠️  Protobuf is ${(1 / speedup).toStringAsFixed(1)}x faster than FFI');
  }
  print('');
}

// Helper functions to create test data

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
