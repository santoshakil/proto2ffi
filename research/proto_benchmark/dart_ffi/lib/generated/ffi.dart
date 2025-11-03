// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

/// Size of User in bytes
const int USER_SIZE = 1200;
/// Alignment requirement of User in bytes
const int USER_ALIGNMENT = 8;

/// Proto message: User
///
/// Size: 1200 bytes
/// Alignment: 8 bytes
/// Fields: 15
///
/// Zero-copy FFI compatible struct with C representation.
/// Use [allocate] to create new instances.
///
/// Internal FFI type - users interact with proto models instead.
final class UserFFI extends ffi.Struct {
  @ffi.Uint64()
  external int user_id;

  @ffi.Uint64()
  external int date_of_birth;

  @ffi.Uint64()
  external int created_at;

  @ffi.Uint64()
  external int updated_at;

  @ffi.Double()
  external double account_balance;

  @ffi.Uint32()
  external int reputation_score;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> username;

  @ffi.Uint32()
  external int username_len;

  @ffi.Array<ffi.Uint8>(128)
  external ffi.Array<ffi.Uint8> email;

  @ffi.Uint32()
  external int email_len;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> first_name;

  @ffi.Uint32()
  external int first_name_len;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> last_name;

  @ffi.Uint32()
  external int last_name_len;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> display_name;

  @ffi.Uint32()
  external int display_name_len;

  @ffi.Array<ffi.Uint8>(512)
  external ffi.Array<ffi.Uint8> bio;

  @ffi.Uint32()
  external int bio_len;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> avatar_url;

  @ffi.Uint32()
  external int avatar_url_len;

  @ffi.Uint8()
  external int is_verified;

  @ffi.Uint8()
  external int is_premium;

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

  /// Returns the UTF-8 string value of first_name
  ///
  /// Reads bytes until the first null terminator (max 64 bytes).
  String get first_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (first_name[i] == 0) break;
      bytes.add(first_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of first_name
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 64 bytes. Adds null terminator.
  set first_name_str(String value) {
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
      first_name[i] = bytes[i];
    }
    first_name[bytes.length] = 0;
  }

  /// Returns the UTF-8 string value of last_name
  ///
  /// Reads bytes until the first null terminator (max 64 bytes).
  String get last_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (last_name[i] == 0) break;
      bytes.add(last_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of last_name
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 64 bytes. Adds null terminator.
  set last_name_str(String value) {
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
      last_name[i] = bytes[i];
    }
    last_name[bytes.length] = 0;
  }

  /// Returns the UTF-8 string value of display_name
  ///
  /// Reads bytes until the first null terminator (max 64 bytes).
  String get display_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (display_name[i] == 0) break;
      bytes.add(display_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of display_name
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 64 bytes. Adds null terminator.
  set display_name_str(String value) {
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
      display_name[i] = bytes[i];
    }
    display_name[bytes.length] = 0;
  }

  /// Returns the UTF-8 string value of bio
  ///
  /// Reads bytes until the first null terminator (max 512 bytes).
  String get bio_str {
    final bytes = <int>[];
    for (int i = 0; i < 512; i++) {
      if (bio[i] == 0) break;
      bytes.add(bio[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of bio
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 512 bytes. Adds null terminator.
  set bio_str(String value) {
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
      bio[i] = bytes[i];
    }
    bio[bytes.length] = 0;
  }

  /// Returns the UTF-8 string value of avatar_url
  ///
  /// Reads bytes until the first null terminator (max 256 bytes).
  String get avatar_url_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (avatar_url[i] == 0) break;
      bytes.add(avatar_url[i]);
    }
    return String.fromCharCodes(bytes);
  }

  /// Sets the UTF-8 string value of avatar_url
  ///
  /// Automatically truncates at UTF-8 character boundaries if value exceeds
  /// 256 bytes. Adds null terminator.
  set avatar_url_str(String value) {
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
      avatar_url[i] = bytes[i];
    }
    avatar_url[bytes.length] = 0;
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
const int POST_SIZE = 4480;
/// Alignment requirement of Post in bytes
const int POST_ALIGNMENT = 8;

/// Proto message: Post
///
/// Size: 4480 bytes
/// Alignment: 8 bytes
/// Fields: 9
///
/// Zero-copy FFI compatible struct with C representation.
/// Use [allocate] to create new instances.
///
/// Internal FFI type - users interact with proto models instead.
final class PostFFI extends ffi.Struct {
  @ffi.Uint64()
  external int post_id;

  @ffi.Uint64()
  external int user_id;

  @ffi.Uint64()
  external int created_at;

  @ffi.Uint64()
  external int updated_at;

  @ffi.Uint64()
  external int view_count;

  @ffi.Uint64()
  external int like_count;

  @ffi.Uint64()
  external int comment_count;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> username;

  @ffi.Uint32()
  external int username_len;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> title;

  @ffi.Uint32()
  external int title_len;

  @ffi.Array<ffi.Uint8>(4096)
  external ffi.Array<ffi.Uint8> content;

  @ffi.Uint32()
  external int content_len;

  @ffi.Uint8()
  external int is_edited;

  @ffi.Uint8()
  external int is_pinned;

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
}
