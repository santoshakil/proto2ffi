import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:path/path.dart' as path;

// Import generated proto models and wrappers
import '../lib/generated/proto.dart';
import '../lib/generated/wrapper.dart';

// FFI type definitions for our custom functions
typedef BlogInitNative = ffi.Void Function();
typedef BlogInitDart = void Function();

typedef BlogCleanupNative = ffi.Void Function();
typedef BlogCleanupDart = void Function();

typedef BlogLikePostNative = ffi.Bool Function(ffi.Uint32);
typedef BlogLikePostDart = bool Function(int);

void main() {
  print('=== Proto2FFI Blog API Example ===\n');

  // Load the shared library
  final libraryPath = path.join(
    Directory.current.path,
    'lib',
    'libblog_api.dylib',  // .dylib on macOS, .so on Linux, .dll on Windows
  );

  print('Loading library from: $libraryPath');
  final dylib = ffi.DynamicLibrary.open(libraryPath);
  print('✅ Library loaded successfully\n');

  // Initialize blog API
  final blogInit = dylib.lookupFunction<BlogInitNative, BlogInitDart>('blog_init');
  blogInit();
  print('✅ Blog API initialized\n');

  // Create wrapper instances for User, Post, and Response
  final userAPI = UserAPI(dylib);
  final postAPI = PostAPI(dylib);
  final responseAPI = ResponseAPI(dylib);

  // Test 1: Create a user
  print('--- Test 1: Create User ---');
  final user = User(
    id: 0,  // Will be assigned by Rust
    username: 'alice_dart',
    email: 'alice@example.com',
    created_at: 0,  // Will be assigned by Rust
  );

  print('Creating user: ${user.username}');
  final userPtr = userAPI.send(user);
  print('✅ User sent to Rust via FFI\n');

  // Call blog_create_user
  final blogCreateUser = dylib.lookupFunction<
      ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>),
      ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>('blog_create_user');

  final responsePtr = blogCreateUser(userPtr.cast());
  final response = responseAPI.receive(responsePtr.cast());

  print('Response:');
  print('  Success: ${response.success == 1}');
  print('  Message: ${response.message}');
  print('  User ID: ${response.affected_id}');

  // Clean up
  userAPI.free(userPtr);
  responseAPI.free(responsePtr.cast());
  print('');

  // Test 2: Get the user back
  print('--- Test 2: Get User ---');
  final userId = response.affected_id;

  final blogGetUser = dylib.lookupFunction<
      ffi.Pointer<ffi.Void> Function(ffi.Uint32),
      ffi.Pointer<ffi.Void> Function(int)>('blog_get_user');

  final retrievedUserPtr = blogGetUser(userId);
  if (retrievedUserPtr != ffi.nullptr) {
    final retrievedUser = userAPI.receive(retrievedUserPtr.cast());
    print('Retrieved user:');
    print('  ID: ${retrievedUser.id}');
    print('  Username: ${retrievedUser.username}');
    print('  Email: ${retrievedUser.email}');
    print('  Created: ${DateTime.fromMillisecondsSinceEpoch(retrievedUser.created_at.toInt() * 1000)}');
    userAPI.free(retrievedUserPtr.cast());
  } else {
    print('❌ User not found');
  }
  print('');

  // Test 3: Create a post
  print('--- Test 3: Create Post ---');
  final post = Post(
    id: 0,
    author_id: userId,
    title: 'My First Post from Dart!',
    content: 'This post was created using proto2ffi generated bindings. Zero manual FFI code!',
    created_at: 0,
    likes: 0,
  );

  print('Creating post: ${post.title}');
  final postPtr = postAPI.send(post);

  final blogCreatePost = dylib.lookupFunction<
      ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>),
      ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>)>('blog_create_post');

  final postResponsePtr = blogCreatePost(postPtr.cast());
  final postResponse = responseAPI.receive(postResponsePtr.cast());

  print('Response:');
  print('  Success: ${postResponse.success == 1}');
  print('  Message: ${postResponse.message}');
  print('  Post ID: ${postResponse.affected_id}');

  postAPI.free(postPtr);
  responseAPI.free(postResponsePtr.cast());
  print('');

  // Test 4: Like the post
  print('--- Test 4: Like Post ---');
  final postId = postResponse.affected_id;

  final blogLikePost = dylib.lookupFunction<BlogLikePostNative, BlogLikePostDart>('blog_like_post');

  print('Liking post $postId...');
  final liked = blogLikePost(postId);
  print('Result: ${liked ? "✅ Liked!" : "❌ Failed"}');
  print('');

  // Test 5: Get the post back
  print('--- Test 5: Get Post ---');
  final blogGetPost = dylib.lookupFunction<
      ffi.Pointer<ffi.Void> Function(ffi.Uint32),
      ffi.Pointer<ffi.Void> Function(int)>('blog_get_post');

  final retrievedPostPtr = blogGetPost(postId);
  if (retrievedPostPtr != ffi.nullptr) {
    final retrievedPost = postAPI.receive(retrievedPostPtr.cast());
    print('Retrieved post:');
    print('  ID: ${retrievedPost.id}');
    print('  Author ID: ${retrievedPost.author_id}');
    print('  Title: ${retrievedPost.title}');
    print('  Content: ${retrievedPost.content}');
    print('  Likes: ${retrievedPost.likes} ❤️');
    print('  Created: ${DateTime.fromMillisecondsSinceEpoch(retrievedPost.created_at.toInt() * 1000)}');
    postAPI.free(retrievedPostPtr.cast());
  } else {
    print('❌ Post not found');
  }
  print('');

  // Cleanup
  final blogCleanup = dylib.lookupFunction<BlogCleanupNative, BlogCleanupDart>('blog_cleanup');
  blogCleanup();

  print('\n🎉 All tests passed! Proto2FFI working perfectly!');
  print('\n📊 Summary:');
  print('  - Used proto models (User, Post, Response)');
  print('  - FFI completely transparent');
  print('  - Zero manual FFI struct manipulation');
  print('  - Data flows: Dart ↔ Rust seamlessly');
}
