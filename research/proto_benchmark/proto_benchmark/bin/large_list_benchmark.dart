import 'dart:io';
import 'dart:ffi' as ffi;
import 'package:fixnum/fixnum.dart';
import 'package:proto_benchmark/generated_pb/benchmark_simple_pb.pb.dart' as pb;
import 'package:path/path.dart' as path;

import 'package:proto_benchmark/generated_ffi/proto.dart' as ffi_proto;
import 'package:proto_benchmark/generated_ffi/wrapper.dart' as ffi_wrapper;
import 'package:proto_benchmark/generated_ffi/ffi.dart' as ffi_types;

typedef EchoUserNative = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);
typedef EchoUserDart = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);

typedef EchoPostNative = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);
typedef EchoPostDart = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>);

void main() {
  print('═══════════════════════════════════════════════════════════');
  print('   LARGE LIST BENCHMARK: FFI vs Protobuf');
  print('═══════════════════════════════════════════════════════════\n');

  final libraryPath = path.join(
    Directory.current.parent.path,
    'dart_ffi/lib',
    'libbenchmark_ffi.dylib',
  );

  print('Loading FFI library from: $libraryPath');
  final dylib = ffi.DynamicLibrary.open(libraryPath);
  print('✅ FFI Library loaded\n');

  final userAPI = ffi_wrapper.UserAPI(dylib);
  final postAPI = ffi_wrapper.PostAPI(dylib);

  final echoUser = dylib.lookupFunction<EchoUserNative, EchoUserDart>('echo_user');
  final echoPost = dylib.lookupFunction<EchoPostNative, EchoPostDart>('echo_post');

  print('Warming up JIT compiler...');
  for (var i = 0; i < 100; i++) {
    final userPb = createUserPB(1);
    userPb.writeToBuffer();
    pb.UserPB.fromBuffer(userPb.writeToBuffer());

    final userFfi = createUserFFI(1);
    final ptr = userAPI.send(userFfi);
    userAPI.free(ptr);
  }
  print('✅ Warmup complete\n');

  benchmarkUserList(userAPI, echoUser, 100);
  benchmarkUserList(userAPI, echoUser, 1000);
  benchmarkPostList(postAPI, echoPost, 100);
  benchmarkPostList(postAPI, echoPost, 1000);

  print('\n═══════════════════════════════════════════════════════════');
  print('                    BENCHMARK COMPLETE');
  print('═══════════════════════════════════════════════════════════');
}

void benchmarkUserList(ffi_wrapper.UserAPI userAPI, EchoUserDart echoUser, int listSize) {
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  TEST: List of $listSize User Messages');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final samples = 100;

  // ═══ PROTOBUF ═══
  print('📦 PROTOBUF:');
  print('   ─────────────────────────────────────');

  final usersPb = List.generate(listSize, (i) => createUserPB(i));
  final pbSize = usersPb.fold(0, (sum, u) => sum + u.writeToBuffer().length);
  print('   Total size: ${(pbSize / 1024).toStringAsFixed(2)} KB');

  final pbTimes = <double>[];
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
    pbTimes.add(sw.elapsedMicroseconds.toDouble());
  }

  pbTimes.sort();
  final pbMin = pbTimes.first;
  final pbMax = pbTimes.last;
  final pbMedian = pbTimes[samples ~/ 2];
  final pbAvg = pbTimes.reduce((a, b) => a + b) / pbTimes.length;
  final pbP95 = pbTimes[(samples * 0.95).floor()];
  final pbP99 = pbTimes[(samples * 0.99).floor()];

  print('   Running $samples samples...');
  print('   Min:     ${pbMin.toStringAsFixed(2)} μs');
  print('   Median:  ${pbMedian.toStringAsFixed(2)} μs');
  print('   Average: ${pbAvg.toStringAsFixed(2)} μs');
  print('   P95:     ${pbP95.toStringAsFixed(2)} μs');
  print('   P99:     ${pbP99.toStringAsFixed(2)} μs');
  print('   Max:     ${pbMax.toStringAsFixed(2)} μs');
  print('   Per message: ${(pbAvg / listSize).toStringAsFixed(2)} μs\n');

  // ═══ FFI ═══
  print('⚡ PROTO2FFI:');
  print('   ─────────────────────────────────────');

  final usersFFI = List.generate(listSize, (i) => createUserFFI(i));
  final ffiSize = listSize * ffi_types.USER_SIZE;
  print('   Total size: ${(ffiSize / 1024).toStringAsFixed(2)} KB');

  final ffiTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final allPtrs = <ffi.Pointer<ffi_types.UserFFI>>[];
    for (final user in usersFFI) {
      allPtrs.add(userAPI.send(user));
    }

    for (final ptr in allPtrs) {
      final resultPtr = echoUser(ptr.cast());
      userAPI.free(ptr);
      if (resultPtr != ffi.nullptr) {
        userAPI.free(resultPtr.cast());
      }
    }

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

  print('   Running $samples samples...');
  print('   Min:     ${ffiMin.toStringAsFixed(2)} μs');
  print('   Median:  ${ffiMedian.toStringAsFixed(2)} μs');
  print('   Average: ${ffiAvg.toStringAsFixed(2)} μs');
  print('   P95:     ${ffiP95.toStringAsFixed(2)} μs');
  print('   P99:     ${ffiP99.toStringAsFixed(2)} μs');
  print('   Max:     ${ffiMax.toStringAsFixed(2)} μs');
  print('   Per message: ${(ffiAvg / listSize).toStringAsFixed(2)} μs\n');

  // ═══ COMPARISON ═══
  print('📊 COMPARISON:');
  print('   ─────────────────────────────────────');
  final speedup = pbAvg / ffiAvg;
  print('   Protobuf average: ${pbAvg.toStringAsFixed(2)} μs (${(pbAvg / listSize).toStringAsFixed(2)} μs/msg)');
  print('   FFI average:      ${ffiAvg.toStringAsFixed(2)} μs (${(ffiAvg / listSize).toStringAsFixed(2)} μs/msg)');
  print('   Size ratio:       ${(ffiSize / pbSize).toStringAsFixed(2)}x (FFI larger)');

  if (speedup > 1) {
    print('   🏆 Proto2FFI is ${speedup.toStringAsFixed(2)}x faster');
  } else {
    print('   ⚠️  Protobuf is ${(1 / speedup).toStringAsFixed(2)}x faster');
  }
  print('');
}

void benchmarkPostList(ffi_wrapper.PostAPI postAPI, EchoPostDart echoPost, int listSize) {
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('  TEST: List of $listSize Post Messages');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  final samples = 100;

  // ═══ PROTOBUF ═══
  print('📦 PROTOBUF:');
  print('   ─────────────────────────────────────');

  final postsPb = List.generate(listSize, (i) => createPostPB(i, 1));
  final pbSize = postsPb.fold(0, (sum, p) => sum + p.writeToBuffer().length);
  print('   Total size: ${(pbSize / 1024).toStringAsFixed(2)} KB');

  final pbTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final allBytes = <List<int>>[];
    for (final post in postsPb) {
      allBytes.add(post.writeToBuffer());
    }

    for (final bytes in allBytes) {
      pb.PostPB.fromBuffer(bytes);
    }

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

  print('   Running $samples samples...');
  print('   Min:     ${pbMin.toStringAsFixed(2)} μs');
  print('   Median:  ${pbMedian.toStringAsFixed(2)} μs');
  print('   Average: ${pbAvg.toStringAsFixed(2)} μs');
  print('   P95:     ${pbP95.toStringAsFixed(2)} μs');
  print('   P99:     ${pbP99.toStringAsFixed(2)} μs');
  print('   Max:     ${pbMax.toStringAsFixed(2)} μs');
  print('   Per message: ${(pbAvg / listSize).toStringAsFixed(2)} μs\n');

  // ═══ FFI ═══
  print('⚡ PROTO2FFI:');
  print('   ─────────────────────────────────────');

  final postsFFI = List.generate(listSize, (i) => createPostFFI(i, 1));
  final ffiSize = listSize * ffi_types.POST_SIZE;
  print('   Total size: ${(ffiSize / 1024).toStringAsFixed(2)} KB');

  final ffiTimes = <double>[];
  for (var i = 0; i < samples; i++) {
    final sw = Stopwatch()..start();

    final allPtrs = <ffi.Pointer<ffi_types.PostFFI>>[];
    for (final post in postsFFI) {
      allPtrs.add(postAPI.send(post));
    }

    for (final ptr in allPtrs) {
      final resultPtr = echoPost(ptr.cast());
      postAPI.free(ptr);
      if (resultPtr != ffi.nullptr) {
        postAPI.free(resultPtr.cast());
      }
    }

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

  print('   Running $samples samples...');
  print('   Min:     ${ffiMin.toStringAsFixed(2)} μs');
  print('   Median:  ${ffiMedian.toStringAsFixed(2)} μs');
  print('   Average: ${ffiAvg.toStringAsFixed(2)} μs');
  print('   P95:     ${ffiP95.toStringAsFixed(2)} μs');
  print('   P99:     ${ffiP99.toStringAsFixed(2)} μs');
  print('   Max:     ${ffiMax.toStringAsFixed(2)} μs');
  print('   Per message: ${(ffiAvg / listSize).toStringAsFixed(2)} μs\n');

  // ═══ COMPARISON ═══
  print('📊 COMPARISON:');
  print('   ─────────────────────────────────────');
  final speedup = pbAvg / ffiAvg;
  print('   Protobuf average: ${pbAvg.toStringAsFixed(2)} μs (${(pbAvg / listSize).toStringAsFixed(2)} μs/msg)');
  print('   FFI average:      ${ffiAvg.toStringAsFixed(2)} μs (${(ffiAvg / listSize).toStringAsFixed(2)} μs/msg)');
  print('   Size ratio:       ${(ffiSize / pbSize).toStringAsFixed(2)}x (FFI larger)');

  if (speedup > 1) {
    print('   🏆 Proto2FFI is ${speedup.toStringAsFixed(2)}x faster');
  } else {
    print('   ⚠️  Protobuf is ${(1 / speedup).toStringAsFixed(2)}x faster');
  }
  print('');
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
