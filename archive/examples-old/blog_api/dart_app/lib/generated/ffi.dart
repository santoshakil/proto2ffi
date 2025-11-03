// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

/// Size of User in bytes
const int USER_SIZE = 208;
/// Alignment requirement of User in bytes
const int USER_ALIGNMENT = 8;

/// Proto message: User
///
/// Size: 208 bytes
/// Alignment: 8 bytes
/// Fields: 4
///
/// Zero-copy FFI compatible struct with C representation.
/// Use [allocate] to create new instances.
///
/// Internal FFI type - users interact with proto models instead.
final class UserFFI extends ffi.Struct {
  @ffi.Uint64()
  external int created_at;

  @ffi.Uint32()
  external int id;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> username;

  @ffi.Uint32()
  external int username_len;

  @ffi.Array<ffi.Uint8>(128)
  external ffi.Array<ffi.Uint8> email;

  @ffi.Uint32()
  external int email_len;

  /// Returns the UTF-8 string value of username
  ///
  /// Reads bytes until the first null terminator (max 64 bytes).
  String get username_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (username[i] == 0) break;
      bytes.add(username[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of username
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 64 bytes. Adds null terminator.
  set username_str(String value) {
    var bytes = utf8.encode(value);
    final maxBytes = 64 - 1;

    if (bytes.length > maxBytes) {
      var truncated = maxBytes;
      while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
        truncated--;
      }

      if (truncated > 0 && (bytes[truncated] & 0x80) != 0) {
        final firstByte = bytes[truncated];
        int charLen;
        if ((firstByte & 0xE0) == 0xC0) {
          charLen = 2;
        } else if ((firstByte & 0xF0) == 0xE0) {
          charLen = 3;
        } else if ((firstByte & 0xF8) == 0xF0) {
          charLen = 4;
        } else {
          charLen = 1;
        }

        if (truncated + charLen > maxBytes) {
          truncated--;
          while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
            truncated--;
          }
        }
      }
      bytes = bytes.sublist(0, truncated);
    }

    for (var i = 0; i < bytes.length; i++) {
      username[i] = bytes[i];
    }
    username[bytes.length] = 0;
  }

  /// Returns the UTF-8 string value of email
  ///
  /// Reads bytes until the first null terminator (max 128 bytes).
  String get email_str {
    final bytes = <int>[];
    for (int i = 0; i < 128; i++) {
      if (email[i] == 0) break;
      bytes.add(email[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of email
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 128 bytes. Adds null terminator.
  set email_str(String value) {
    var bytes = utf8.encode(value);
    final maxBytes = 128 - 1;

    if (bytes.length > maxBytes) {
      var truncated = maxBytes;
      while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
        truncated--;
      }

      if (truncated > 0 && (bytes[truncated] & 0x80) != 0) {
        final firstByte = bytes[truncated];
        int charLen;
        if ((firstByte & 0xE0) == 0xC0) {
          charLen = 2;
        } else if ((firstByte & 0xF0) == 0xE0) {
          charLen = 3;
        } else if ((firstByte & 0xF8) == 0xF0) {
          charLen = 4;
        } else {
          charLen = 1;
        }

        if (truncated + charLen > maxBytes) {
          truncated--;
          while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
            truncated--;
          }
        }
      }
      bytes = bytes.sublist(0, truncated);
    }

    for (var i = 0; i < bytes.length; i++) {
      email[i] = bytes[i];
    }
    email[bytes.length] = 0;
  }

  /// Allocates a new instance on the heap using calloc
  ///
  /// Returns a pointer to the allocated memory.
  /// Must be freed using `calloc.free()` when done.
  static ffi.Pointer<UserFFI> allocate() {
    return calloc<UserFFI>();
  }
}

/// Size of Post in bytes
const int POST_SIZE = 4376;
/// Alignment requirement of Post in bytes
const int POST_ALIGNMENT = 8;

/// Proto message: Post
///
/// Size: 4376 bytes
/// Alignment: 8 bytes
/// Fields: 6
///
/// Zero-copy FFI compatible struct with C representation.
/// Use [allocate] to create new instances.
///
/// Internal FFI type - users interact with proto models instead.
final class PostFFI extends ffi.Struct {
  @ffi.Uint64()
  external int created_at;

  @ffi.Uint32()
  external int id;

  @ffi.Uint32()
  external int author_id;

  @ffi.Uint32()
  external int likes;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> title;

  @ffi.Uint32()
  external int title_len;

  @ffi.Array<ffi.Uint8>(4096)
  external ffi.Array<ffi.Uint8> content;

  @ffi.Uint32()
  external int content_len;

  /// Returns the UTF-8 string value of title
  ///
  /// Reads bytes until the first null terminator (max 256 bytes).
  String get title_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (title[i] == 0) break;
      bytes.add(title[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of title
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 256 bytes. Adds null terminator.
  set title_str(String value) {
    var bytes = utf8.encode(value);
    final maxBytes = 256 - 1;

    if (bytes.length > maxBytes) {
      var truncated = maxBytes;
      while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
        truncated--;
      }

      if (truncated > 0 && (bytes[truncated] & 0x80) != 0) {
        final firstByte = bytes[truncated];
        int charLen;
        if ((firstByte & 0xE0) == 0xC0) {
          charLen = 2;
        } else if ((firstByte & 0xF0) == 0xE0) {
          charLen = 3;
        } else if ((firstByte & 0xF8) == 0xF0) {
          charLen = 4;
        } else {
          charLen = 1;
        }

        if (truncated + charLen > maxBytes) {
          truncated--;
          while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
            truncated--;
          }
        }
      }
      bytes = bytes.sublist(0, truncated);
    }

    for (var i = 0; i < bytes.length; i++) {
      title[i] = bytes[i];
    }
    title[bytes.length] = 0;
  }

  /// Returns the UTF-8 string value of content
  ///
  /// Reads bytes until the first null terminator (max 4096 bytes).
  String get content_str {
    final bytes = <int>[];
    for (int i = 0; i < 4096; i++) {
      if (content[i] == 0) break;
      bytes.add(content[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of content
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 4096 bytes. Adds null terminator.
  set content_str(String value) {
    var bytes = utf8.encode(value);
    final maxBytes = 4096 - 1;

    if (bytes.length > maxBytes) {
      var truncated = maxBytes;
      while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
        truncated--;
      }

      if (truncated > 0 && (bytes[truncated] & 0x80) != 0) {
        final firstByte = bytes[truncated];
        int charLen;
        if ((firstByte & 0xE0) == 0xC0) {
          charLen = 2;
        } else if ((firstByte & 0xF0) == 0xE0) {
          charLen = 3;
        } else if ((firstByte & 0xF8) == 0xF0) {
          charLen = 4;
        } else {
          charLen = 1;
        }

        if (truncated + charLen > maxBytes) {
          truncated--;
          while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
            truncated--;
          }
        }
      }
      bytes = bytes.sublist(0, truncated);
    }

    for (var i = 0; i < bytes.length; i++) {
      content[i] = bytes[i];
    }
    content[bytes.length] = 0;
  }

  /// Allocates a new instance on the heap using calloc
  ///
  /// Returns a pointer to the allocated memory.
  /// Must be freed using `calloc.free()` when done.
  static ffi.Pointer<PostFFI> allocate() {
    return calloc<PostFFI>();
  }
}

/// Size of Response in bytes
const int RESPONSE_SIZE = 520;
/// Alignment requirement of Response in bytes
const int RESPONSE_ALIGNMENT = 8;

/// Proto message: Response
///
/// Size: 520 bytes
/// Alignment: 8 bytes
/// Fields: 3
///
/// Zero-copy FFI compatible struct with C representation.
/// Use [allocate] to create new instances.
///
/// Internal FFI type - users interact with proto models instead.
final class ResponseFFI extends ffi.Struct {
  @ffi.Uint32()
  external int affected_id;

  @ffi.Uint8()
  external int success;

  @ffi.Array<ffi.Uint8>(512)
  external ffi.Array<ffi.Uint8> message;

  @ffi.Uint32()
  external int message_len;

  /// Returns the UTF-8 string value of message
  ///
  /// Reads bytes until the first null terminator (max 512 bytes).
  String get message_str {
    final bytes = <int>[];
    for (int i = 0; i < 512; i++) {
      if (message[i] == 0) break;
      bytes.add(message[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of message
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 512 bytes. Adds null terminator.
  set message_str(String value) {
    var bytes = utf8.encode(value);
    final maxBytes = 512 - 1;

    if (bytes.length > maxBytes) {
      var truncated = maxBytes;
      while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
        truncated--;
      }

      if (truncated > 0 && (bytes[truncated] & 0x80) != 0) {
        final firstByte = bytes[truncated];
        int charLen;
        if ((firstByte & 0xE0) == 0xC0) {
          charLen = 2;
        } else if ((firstByte & 0xF0) == 0xE0) {
          charLen = 3;
        } else if ((firstByte & 0xF8) == 0xF0) {
          charLen = 4;
        } else {
          charLen = 1;
        }

        if (truncated + charLen > maxBytes) {
          truncated--;
          while (truncated > 0 && (bytes[truncated] & 0xC0) == 0x80) {
            truncated--;
          }
        }
      }
      bytes = bytes.sublist(0, truncated);
    }

    for (var i = 0; i < bytes.length; i++) {
      message[i] = bytes[i];
    }
    message[bytes.length] = 0;
  }

  /// Allocates a new instance on the heap using calloc
  ///
  /// Returns a pointer to the allocated memory.
  /// Must be freed using `calloc.free()` when done.
  static ffi.Pointer<ResponseFFI> allocate() {
    return calloc<ResponseFFI>();
  }
}

/// FFI bindings for generated message types
///
/// Provides size and alignment introspection functions.
/// The dynamic library is loaded automatically based on platform.
class FFIBindings {
  static final _dylib = _loadLibrary();

  /// Loads the appropriate native library for the current platform
  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libgenerated.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libgenerated.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('generated.dll');
    } else {
      return ffi.DynamicLibrary.open('libgenerated.so');
    }
  }

  late final user_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('user_size');

  late final user_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('user_alignment');

  late final post_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('post_size');

  late final post_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('post_alignment');

  late final response_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('response_size');

  late final response_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('response_alignment');
}
