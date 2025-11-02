// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum PostType {
  TEXT(0), // Value: 0
  IMAGE(1), // Value: 1
  VIDEO(2), // Value: 2
  LINK(3), // Value: 3
  POLL(4); // Value: 4

  const PostType(this.value);
  final int value;
}

enum PostVisibility {
  PUBLIC(0), // Value: 0
  FRIENDS(1), // Value: 1
  PRIVATE(2), // Value: 2
  CUSTOM(3); // Value: 3

  const PostVisibility(this.value);
  final int value;
}

enum ReactionType {
  LIKE(0), // Value: 0
  LOVE(1), // Value: 1
  HAHA(2), // Value: 2
  WOW(3), // Value: 3
  SAD(4), // Value: 4
  ANGRY(5); // Value: 5

  const ReactionType(this.value);
  final int value;
}

enum NotificationType {
  POST_LIKE(0), // Value: 0
  POST_COMMENT(1), // Value: 1
  FRIEND_REQUEST(2), // Value: 2
  MENTION(3), // Value: 3
  MESSAGE(4); // Value: 4

  const NotificationType(this.value);
  final int value;
}

const int USERID_SIZE = 8;
const int USERID_ALIGNMENT = 8;

final class UserId extends ffi.Struct {
  @ffi.Uint64()
  external int id;

  static ffi.Pointer<UserId> allocate() {
    return calloc<UserId>();
  }
}

const int USERPROFILE_SIZE = 656;
const int USERPROFILE_ALIGNMENT = 8;

final class UserProfile extends ffi.Struct {
  @ffi.Uint64()
  external int user_id;

  @ffi.Uint64()
  external int follower_count;

  @ffi.Uint64()
  external int following_count;

  @ffi.Uint64()
  external int post_count;

  @ffi.Uint64()
  external int created_at;

  @ffi.Array<ffi.Uint8>(32)
  external ffi.Array<ffi.Uint8> username;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> display_name;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> bio;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> avatar_url;

  @ffi.Uint8()
  external int is_verified;

  String get username_str {
    final bytes = <int>[];
    for (int i = 0; i < 32; i++) {
      if (username[i] == 0) break;
      bytes.add(username[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set username_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 31 ? bytes.length : 31;
    for (int i = 0; i < len; i++) {
      username[i] = bytes[i];
    }
    if (len < 32) {
      username[len] = 0;
    }
  }

  String get display_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (display_name[i] == 0) break;
      bytes.add(display_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set display_name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      display_name[i] = bytes[i];
    }
    if (len < 64) {
      display_name[len] = 0;
    }
  }

  String get bio_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (bio[i] == 0) break;
      bytes.add(bio[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set bio_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      bio[i] = bytes[i];
    }
    if (len < 256) {
      bio[len] = 0;
    }
  }

  String get avatar_url_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (avatar_url[i] == 0) break;
      bytes.add(avatar_url[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set avatar_url_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      avatar_url[i] = bytes[i];
    }
    if (len < 256) {
      avatar_url[len] = 0;
    }
  }

  static ffi.Pointer<UserProfile> allocate() {
    return calloc<UserProfile>();
  }
}

const int POST_SIZE = 5584;
const int POST_ALIGNMENT = 8;

final class Post extends ffi.Struct {
  @ffi.Uint64()
  external int post_id;

  @ffi.Uint64()
  external int author_id;

  @ffi.Uint64()
  external int like_count;

  @ffi.Uint64()
  external int comment_count;

  @ffi.Uint64()
  external int share_count;

  @ffi.Uint64()
  external int view_count;

  @ffi.Uint64()
  external int created_at;

  @ffi.Uint64()
  external int updated_at;

  @ffi.Uint32()
  external int post_type;

  @ffi.Uint32()
  external int visibility;

  @ffi.Array<ffi.Uint8>(5000)
  external ffi.Array<ffi.Uint8> content;

  @ffi.Array<ffi.Uint8>(512)
  external ffi.Array<ffi.Uint8> media_url;

  String get content_str {
    final bytes = <int>[];
    for (int i = 0; i < 5000; i++) {
      if (content[i] == 0) break;
      bytes.add(content[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set content_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 4999 ? bytes.length : 4999;
    for (int i = 0; i < len; i++) {
      content[i] = bytes[i];
    }
    if (len < 5000) {
      content[len] = 0;
    }
  }

  String get media_url_str {
    final bytes = <int>[];
    for (int i = 0; i < 512; i++) {
      if (media_url[i] == 0) break;
      bytes.add(media_url[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set media_url_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 511 ? bytes.length : 511;
    for (int i = 0; i < len; i++) {
      media_url[i] = bytes[i];
    }
    if (len < 512) {
      media_url[len] = 0;
    }
  }

  static ffi.Pointer<Post> allocate() {
    return calloc<Post>();
  }
}

const int COMMENT_SIZE = 2056;
const int COMMENT_ALIGNMENT = 8;

final class Comment extends ffi.Struct {
  @ffi.Uint64()
  external int comment_id;

  @ffi.Uint64()
  external int post_id;

  @ffi.Uint64()
  external int author_id;

  @ffi.Uint64()
  external int parent_comment_id;

  @ffi.Uint64()
  external int like_count;

  @ffi.Uint64()
  external int reply_count;

  @ffi.Uint64()
  external int created_at;

  @ffi.Array<ffi.Uint8>(2000)
  external ffi.Array<ffi.Uint8> text;

  String get text_str {
    final bytes = <int>[];
    for (int i = 0; i < 2000; i++) {
      if (text[i] == 0) break;
      bytes.add(text[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set text_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 1999 ? bytes.length : 1999;
    for (int i = 0; i < len; i++) {
      text[i] = bytes[i];
    }
    if (len < 2000) {
      text[len] = 0;
    }
  }

  static ffi.Pointer<Comment> allocate() {
    return calloc<Comment>();
  }
}

const int REACTION_SIZE = 40;
const int REACTION_ALIGNMENT = 8;

final class Reaction extends ffi.Struct {
  @ffi.Uint64()
  external int reaction_id;

  @ffi.Uint64()
  external int user_id;

  @ffi.Uint64()
  external int target_id;

  @ffi.Uint64()
  external int created_at;

  @ffi.Uint32()
  external int reaction_type;

  static ffi.Pointer<Reaction> allocate() {
    return calloc<Reaction>();
  }
}

const int FRIENDCONNECTION_SIZE = 24;
const int FRIENDCONNECTION_ALIGNMENT = 8;

final class FriendConnection extends ffi.Struct {
  @ffi.Uint64()
  external int user_id_1;

  @ffi.Uint64()
  external int user_id_2;

  @ffi.Uint64()
  external int connected_at;

  static ffi.Pointer<FriendConnection> allocate() {
    return calloc<FriendConnection>();
  }
}

const int MESSAGE_SIZE = 4040;
const int MESSAGE_ALIGNMENT = 8;

final class Message extends ffi.Struct {
  @ffi.Uint64()
  external int message_id;

  @ffi.Uint64()
  external int sender_id;

  @ffi.Uint64()
  external int receiver_id;

  @ffi.Uint64()
  external int created_at;

  @ffi.Array<ffi.Uint8>(4000)
  external ffi.Array<ffi.Uint8> text;

  @ffi.Uint8()
  external int is_read;

  String get text_str {
    final bytes = <int>[];
    for (int i = 0; i < 4000; i++) {
      if (text[i] == 0) break;
      bytes.add(text[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set text_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 3999 ? bytes.length : 3999;
    for (int i = 0; i < len; i++) {
      text[i] = bytes[i];
    }
    if (len < 4000) {
      text[len] = 0;
    }
  }

  static ffi.Pointer<Message> allocate() {
    return calloc<Message>();
  }
}

const int NOTIFICATION_SIZE = 304;
const int NOTIFICATION_ALIGNMENT = 8;

final class Notification extends ffi.Struct {
  @ffi.Uint64()
  external int notification_id;

  @ffi.Uint64()
  external int user_id;

  @ffi.Uint64()
  external int actor_id;

  @ffi.Uint64()
  external int target_id;

  @ffi.Uint64()
  external int created_at;

  @ffi.Uint32()
  external int notification_type;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> text;

  @ffi.Uint8()
  external int is_read;

  String get text_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (text[i] == 0) break;
      bytes.add(text[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set text_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      text[i] = bytes[i];
    }
    if (len < 256) {
      text[len] = 0;
    }
  }

  static ffi.Pointer<Notification> allocate() {
    return calloc<Notification>();
  }
}

const int NEWSFEEDITEM_SIZE = 56;
const int NEWSFEEDITEM_ALIGNMENT = 8;

final class NewsFeedItem extends ffi.Struct {
  @ffi.Uint64()
  external int post_id;

  @ffi.Uint64()
  external int author_id;

  @ffi.Double()
  external double relevance_score;

  @ffi.Double()
  external double engagement_score;

  @ffi.Double()
  external double recency_score;

  @ffi.Double()
  external double final_score;

  @ffi.Uint64()
  external int shown_at;

  static ffi.Pointer<NewsFeedItem> allocate() {
    return calloc<NewsFeedItem>();
  }
}

const int FOLLOWERLIST_SIZE = 80016;
const int FOLLOWERLIST_ALIGNMENT = 8;

final class FollowerList extends ffi.Struct {
  @ffi.Uint64()
  external int user_id;

  @ffi.Uint32()
  external int follower_ids_count;

  @ffi.Array<ffi.Uint64>(10000)
  external ffi.Array<ffi.Uint64> follower_ids;

  List<int> get follower_ids_list {
    return List.generate(
      follower_ids_count,
      (i) => follower_ids[i],
      growable: false,
    );
  }

  void add_follower_id(int item) {
    if (follower_ids_count >= 10000) {
      throw Exception('follower_ids array full');
    }
    follower_ids[follower_ids_count] = item;
    follower_ids_count++;
  }

  static ffi.Pointer<FollowerList> allocate() {
    return calloc<FollowerList>();
  }
}

const int TIMELINECACHE_SIZE = 56024;
const int TIMELINECACHE_ALIGNMENT = 8;

final class TimelineCache extends ffi.Struct {
  @ffi.Uint64()
  external int user_id;

  @ffi.Uint32()
  external int items_count;

  @ffi.Array<NewsFeedItem>(1000)
  external ffi.Array<NewsFeedItem> items;

  @ffi.Uint64()
  external int last_updated;

  List<NewsFeedItem> get items_list {
    return List.generate(
      items_count,
      (i) => items[i],
      growable: false,
    );
  }

  NewsFeedItem get_next_item() {
    if (items_count >= 1000) {
      throw Exception('items array full');
    }
    final idx = items_count;
    items_count++;
    return items[idx];
  }

  static ffi.Pointer<TimelineCache> allocate() {
    return calloc<TimelineCache>();
  }
}

const int ENGAGEMENTSTATS_SIZE = 48;
const int ENGAGEMENTSTATS_ALIGNMENT = 8;

final class EngagementStats extends ffi.Struct {
  @ffi.Uint64()
  external int total_views;

  @ffi.Uint64()
  external int total_likes;

  @ffi.Uint64()
  external int total_comments;

  @ffi.Uint64()
  external int total_shares;

  @ffi.Double()
  external double avg_engagement_rate;

  @ffi.Double()
  external double viral_coefficient;

  static ffi.Pointer<EngagementStats> allocate() {
    return calloc<EngagementStats>();
  }
}

const int HASHTAGDATA_SIZE = 80;
const int HASHTAGDATA_ALIGNMENT = 8;

final class HashtagData extends ffi.Struct {
  @ffi.Uint64()
  external int post_count;

  @ffi.Uint64()
  external int trend_score;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> tag;

  String get tag_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (tag[i] == 0) break;
      bytes.add(tag[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set tag_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      tag[i] = bytes[i];
    }
    if (len < 64) {
      tag[len] = 0;
    }
  }

  static ffi.Pointer<HashtagData> allocate() {
    return calloc<HashtagData>();
  }
}

const int SEARCHINDEX_SIZE = 152;
const int SEARCHINDEX_ALIGNMENT = 8;

final class SearchIndex extends ffi.Struct {
  @ffi.Uint64()
  external int doc_id;

  @ffi.Double()
  external double relevance_score;

  @ffi.Uint32()
  external int term_frequency;

  @ffi.Array<ffi.Uint8>(128)
  external ffi.Array<ffi.Uint8> term;

  String get term_str {
    final bytes = <int>[];
    for (int i = 0; i < 128; i++) {
      if (term[i] == 0) break;
      bytes.add(term[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set term_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 127 ? bytes.length : 127;
    for (int i = 0; i < len; i++) {
      term[i] = bytes[i];
    }
    if (len < 128) {
      term[len] = 0;
    }
  }

  static ffi.Pointer<SearchIndex> allocate() {
    return calloc<SearchIndex>();
  }
}

class FFIBindings {
  static final _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libbenchmarks_lib.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('/Volumes/Projects/DevCaches/project-targets/release/libbenchmarks_lib.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('benchmarks_lib.dll');
    } else {
      return ffi.DynamicLibrary.open('libbenchmarks_lib.so');
    }
  }

  late final userid_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('userid_size');

  late final userid_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('userid_alignment');

  late final userprofile_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('userprofile_size');

  late final userprofile_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('userprofile_alignment');

  late final post_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('post_size');

  late final post_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('post_alignment');

  late final comment_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('comment_size');

  late final comment_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('comment_alignment');

  late final reaction_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('reaction_size');

  late final reaction_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('reaction_alignment');

  late final friendconnection_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('friendconnection_size');

  late final friendconnection_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('friendconnection_alignment');

  late final message_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('message_size');

  late final message_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('message_alignment');

  late final notification_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('notification_size');

  late final notification_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('notification_alignment');

  late final newsfeeditem_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('newsfeeditem_size');

  late final newsfeeditem_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('newsfeeditem_alignment');

  late final followerlist_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('followerlist_size');

  late final followerlist_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('followerlist_alignment');

  late final timelinecache_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timelinecache_size');

  late final timelinecache_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('timelinecache_alignment');

  late final engagementstats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('engagementstats_size');

  late final engagementstats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('engagementstats_alignment');

  late final hashtagdata_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hashtagdata_size');

  late final hashtagdata_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hashtagdata_alignment');

  late final searchindex_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('searchindex_size');

  late final searchindex_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('searchindex_alignment');
}
