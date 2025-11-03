// Generated conversions between proto models and FFI
// This layer is transparent to users

import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert';
import 'package:ffi/ffi.dart';

import 'proto.dart';
import 'ffi.dart';

extension UserConversions on User {
  /// Convert to FFI representation
  Pointer<UserFFI> toFFI() {
    final ptr = calloc<UserFFI>();
    final ref = ptr.ref;

    ref.created_at = this.created_at;
    ref.id = this.id;
    {
      final bytes = utf8.encode(this.username);
      final maxLen = 64;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.username[i] = bytes[i];
      }
      ref.username_len = copyLen;
    }
    {
      final bytes = utf8.encode(this.email);
      final maxLen = 128;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.email[i] = bytes[i];
      }
      ref.email_len = copyLen;
    }

    return ptr;
  }

  /// Free FFI pointer (call this when done)
  static void freeFFI(Pointer<UserFFI> ptr) {
    calloc.free(ptr);
  }
}

extension UserFromFFI on UserFFI {
  /// Convert from FFI representation
  static User fromFFI(Pointer<UserFFI> ptr) {
    final ref = ptr.ref;
    return User(
      created_at: ref.created_at,
      id: ref.id,
      username: () { final bytes = <int>[]; for (var i = 0; i < ref.username_len; i++) { bytes.add(ref.username[i]); } return utf8.decode(bytes); }(),
      email: () { final bytes = <int>[]; for (var i = 0; i < ref.email_len; i++) { bytes.add(ref.email[i]); } return utf8.decode(bytes); }(),
    );
  }
}

extension PostConversions on Post {
  /// Convert to FFI representation
  Pointer<PostFFI> toFFI() {
    final ptr = calloc<PostFFI>();
    final ref = ptr.ref;

    ref.created_at = this.created_at;
    ref.id = this.id;
    ref.author_id = this.author_id;
    ref.likes = this.likes;
    {
      final bytes = utf8.encode(this.title);
      final maxLen = 256;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.title[i] = bytes[i];
      }
      ref.title_len = copyLen;
    }
    {
      final bytes = utf8.encode(this.content);
      final maxLen = 4096;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.content[i] = bytes[i];
      }
      ref.content_len = copyLen;
    }

    return ptr;
  }

  /// Free FFI pointer (call this when done)
  static void freeFFI(Pointer<PostFFI> ptr) {
    calloc.free(ptr);
  }
}

extension PostFromFFI on PostFFI {
  /// Convert from FFI representation
  static Post fromFFI(Pointer<PostFFI> ptr) {
    final ref = ptr.ref;
    return Post(
      created_at: ref.created_at,
      id: ref.id,
      author_id: ref.author_id,
      likes: ref.likes,
      title: () { final bytes = <int>[]; for (var i = 0; i < ref.title_len; i++) { bytes.add(ref.title[i]); } return utf8.decode(bytes); }(),
      content: () { final bytes = <int>[]; for (var i = 0; i < ref.content_len; i++) { bytes.add(ref.content[i]); } return utf8.decode(bytes); }(),
    );
  }
}

extension ResponseConversions on Response {
  /// Convert to FFI representation
  Pointer<ResponseFFI> toFFI() {
    final ptr = calloc<ResponseFFI>();
    final ref = ptr.ref;

    ref.affected_id = this.affected_id;
    ref.success = this.success;
    {
      final bytes = utf8.encode(this.message);
      final maxLen = 512;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.message[i] = bytes[i];
      }
      ref.message_len = copyLen;
    }

    return ptr;
  }

  /// Free FFI pointer (call this when done)
  static void freeFFI(Pointer<ResponseFFI> ptr) {
    calloc.free(ptr);
  }
}

extension ResponseFromFFI on ResponseFFI {
  /// Convert from FFI representation
  static Response fromFFI(Pointer<ResponseFFI> ptr) {
    final ref = ptr.ref;
    return Response(
      affected_id: ref.affected_id,
      success: ref.success,
      message: () { final bytes = <int>[]; for (var i = 0; i < ref.message_len; i++) { bytes.add(ref.message[i]); } return utf8.decode(bytes); }(),
    );
  }
}

