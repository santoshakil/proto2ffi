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

    ref.user_id = this.user_id;
    ref.date_of_birth = this.date_of_birth;
    ref.created_at = this.created_at;
    ref.updated_at = this.updated_at;
    ref.account_balance = this.account_balance;
    ref.reputation_score = this.reputation_score;
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
    {
      final bytes = utf8.encode(this.first_name);
      final maxLen = 64;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.first_name[i] = bytes[i];
      }
      ref.first_name_len = copyLen;
    }
    {
      final bytes = utf8.encode(this.last_name);
      final maxLen = 64;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.last_name[i] = bytes[i];
      }
      ref.last_name_len = copyLen;
    }
    {
      final bytes = utf8.encode(this.display_name);
      final maxLen = 64;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.display_name[i] = bytes[i];
      }
      ref.display_name_len = copyLen;
    }
    {
      final bytes = utf8.encode(this.bio);
      final maxLen = 512;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.bio[i] = bytes[i];
      }
      ref.bio_len = copyLen;
    }
    {
      final bytes = utf8.encode(this.avatar_url);
      final maxLen = 256;
      final copyLen = bytes.length < maxLen ? bytes.length : maxLen;
      for (var i = 0; i < copyLen; i++) {
        ref.avatar_url[i] = bytes[i];
      }
      ref.avatar_url_len = copyLen;
    }
    ref.is_verified = this.is_verified;
    ref.is_premium = this.is_premium;

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
      user_id: ref.user_id,
      date_of_birth: ref.date_of_birth,
      created_at: ref.created_at,
      updated_at: ref.updated_at,
      account_balance: ref.account_balance,
      reputation_score: ref.reputation_score,
      username: () { final bytes = <int>[]; for (var i = 0; i < ref.username_len; i++) { bytes.add(ref.username[i]); } return utf8.decode(bytes); }(),
      email: () { final bytes = <int>[]; for (var i = 0; i < ref.email_len; i++) { bytes.add(ref.email[i]); } return utf8.decode(bytes); }(),
      first_name: () { final bytes = <int>[]; for (var i = 0; i < ref.first_name_len; i++) { bytes.add(ref.first_name[i]); } return utf8.decode(bytes); }(),
      last_name: () { final bytes = <int>[]; for (var i = 0; i < ref.last_name_len; i++) { bytes.add(ref.last_name[i]); } return utf8.decode(bytes); }(),
      display_name: () { final bytes = <int>[]; for (var i = 0; i < ref.display_name_len; i++) { bytes.add(ref.display_name[i]); } return utf8.decode(bytes); }(),
      bio: () { final bytes = <int>[]; for (var i = 0; i < ref.bio_len; i++) { bytes.add(ref.bio[i]); } return utf8.decode(bytes); }(),
      avatar_url: () { final bytes = <int>[]; for (var i = 0; i < ref.avatar_url_len; i++) { bytes.add(ref.avatar_url[i]); } return utf8.decode(bytes); }(),
      is_verified: ref.is_verified,
      is_premium: ref.is_premium,
    );
  }
}

extension PostConversions on Post {
  /// Convert to FFI representation
  Pointer<PostFFI> toFFI() {
    final ptr = calloc<PostFFI>();
    final ref = ptr.ref;

    ref.post_id = this.post_id;
    ref.user_id = this.user_id;
    ref.created_at = this.created_at;
    ref.updated_at = this.updated_at;
    ref.view_count = this.view_count;
    ref.like_count = this.like_count;
    ref.comment_count = this.comment_count;
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
    ref.is_edited = this.is_edited;
    ref.is_pinned = this.is_pinned;

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
      post_id: ref.post_id,
      user_id: ref.user_id,
      created_at: ref.created_at,
      updated_at: ref.updated_at,
      view_count: ref.view_count,
      like_count: ref.like_count,
      comment_count: ref.comment_count,
      username: () { final bytes = <int>[]; for (var i = 0; i < ref.username_len; i++) { bytes.add(ref.username[i]); } return utf8.decode(bytes); }(),
      title: () { final bytes = <int>[]; for (var i = 0; i < ref.title_len; i++) { bytes.add(ref.title[i]); } return utf8.decode(bytes); }(),
      content: () { final bytes = <int>[]; for (var i = 0; i < ref.content_len; i++) { bytes.add(ref.content[i]); } return utf8.decode(bytes); }(),
      is_edited: ref.is_edited,
      is_pinned: ref.is_pinned,
    );
  }
}

