// Generated FFI wrapper functions
// These call the Rust FFI exports

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'ffi.dart';
import 'proto.dart';
import 'conversion.dart';

/// FFI wrapper functions for User
class UserAPI {
  late final ffi.DynamicLibrary _lib;

  UserAPI(this._lib);

  /// Creates a new User FFI struct on the heap
  ffi.Pointer<UserFFI> create() {
    final createFn = _lib.lookupFunction<
        ffi.Pointer<UserFFI> Function(),
        ffi.Pointer<UserFFI> Function()>('user_create');
    return createFn();
  }

  /// Frees a User FFI struct
  void free(ffi.Pointer<UserFFI> ptr) {
    final freeFn = _lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<UserFFI>),
        void Function(ffi.Pointer<UserFFI>)>('user_free');
    freeFn(ptr);
  }

  /// Clones a User FFI struct
  ffi.Pointer<UserFFI> clone(ffi.Pointer<UserFFI> ptr) {
    final cloneFn = _lib.lookupFunction<
        ffi.Pointer<UserFFI> Function(ffi.Pointer<UserFFI>),
        ffi.Pointer<UserFFI> Function(ffi.Pointer<UserFFI>)>('user_clone');
    return cloneFn(ptr);
  }

  /// Sends a User proto model to Rust (returns FFI pointer)
  ffi.Pointer<UserFFI> send(User msg) {
    final ptr = create();
    // Convert proto to FFI
    final ffiMsg = msg.toFFI();
    ptr.ref = ffiMsg.ref;
    calloc.free(ffiMsg);
    return ptr;
  }

  /// Receives a User proto model from Rust (does not free pointer)
  User receive(ffi.Pointer<UserFFI> ptr) {
    return UserFromFFI.fromFFI(ptr);
  }

  /// Receives and frees a User proto model from Rust
  User receiveAndFree(ffi.Pointer<UserFFI> ptr) {
    final msg = receive(ptr);
    free(ptr);
    return msg;
  }
}

/// FFI wrapper functions for Post
class PostAPI {
  late final ffi.DynamicLibrary _lib;

  PostAPI(this._lib);

  /// Creates a new Post FFI struct on the heap
  ffi.Pointer<PostFFI> create() {
    final createFn = _lib.lookupFunction<
        ffi.Pointer<PostFFI> Function(),
        ffi.Pointer<PostFFI> Function()>('post_create');
    return createFn();
  }

  /// Frees a Post FFI struct
  void free(ffi.Pointer<PostFFI> ptr) {
    final freeFn = _lib.lookupFunction<
        ffi.Void Function(ffi.Pointer<PostFFI>),
        void Function(ffi.Pointer<PostFFI>)>('post_free');
    freeFn(ptr);
  }

  /// Clones a Post FFI struct
  ffi.Pointer<PostFFI> clone(ffi.Pointer<PostFFI> ptr) {
    final cloneFn = _lib.lookupFunction<
        ffi.Pointer<PostFFI> Function(ffi.Pointer<PostFFI>),
        ffi.Pointer<PostFFI> Function(ffi.Pointer<PostFFI>)>('post_clone');
    return cloneFn(ptr);
  }

  /// Sends a Post proto model to Rust (returns FFI pointer)
  ffi.Pointer<PostFFI> send(Post msg) {
    final ptr = create();
    // Convert proto to FFI
    final ffiMsg = msg.toFFI();
    ptr.ref = ffiMsg.ref;
    calloc.free(ffiMsg);
    return ptr;
  }

  /// Receives a Post proto model from Rust (does not free pointer)
  Post receive(ffi.Pointer<PostFFI> ptr) {
    return PostFromFFI.fromFFI(ptr);
  }

  /// Receives and frees a Post proto model from Rust
  Post receiveAndFree(ffi.Pointer<PostFFI> ptr) {
    final msg = receive(ptr);
    free(ptr);
    return msg;
  }
}

