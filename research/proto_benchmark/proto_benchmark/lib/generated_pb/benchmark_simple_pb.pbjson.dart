// This is a generated file - do not edit.
//
// Generated from benchmark_simple_pb.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userPBDescriptor instead')
const UserPB$json = {
  '1': 'UserPB',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'first_name', '3': 4, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'last_name', '3': 5, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'display_name', '3': 6, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'bio', '3': 7, '4': 1, '5': 9, '10': 'bio'},
    {'1': 'avatar_url', '3': 8, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'date_of_birth', '3': 9, '4': 1, '5': 4, '10': 'dateOfBirth'},
    {'1': 'is_verified', '3': 10, '4': 1, '5': 8, '10': 'isVerified'},
    {'1': 'is_premium', '3': 11, '4': 1, '5': 8, '10': 'isPremium'},
    {'1': 'created_at', '3': 12, '4': 1, '5': 4, '10': 'createdAt'},
    {'1': 'updated_at', '3': 13, '4': 1, '5': 4, '10': 'updatedAt'},
    {'1': 'account_balance', '3': 14, '4': 1, '5': 1, '10': 'accountBalance'},
    {
      '1': 'reputation_score',
      '3': 15,
      '4': 1,
      '5': 13,
      '10': 'reputationScore'
    },
  ],
};

/// Descriptor for `UserPB`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userPBDescriptor = $convert.base64Decode(
    'CgZVc2VyUEISFwoHdXNlcl9pZBgBIAEoBFIGdXNlcklkEhoKCHVzZXJuYW1lGAIgASgJUgh1c2'
    'VybmFtZRIUCgVlbWFpbBgDIAEoCVIFZW1haWwSHQoKZmlyc3RfbmFtZRgEIAEoCVIJZmlyc3RO'
    'YW1lEhsKCWxhc3RfbmFtZRgFIAEoCVIIbGFzdE5hbWUSIQoMZGlzcGxheV9uYW1lGAYgASgJUg'
    'tkaXNwbGF5TmFtZRIQCgNiaW8YByABKAlSA2JpbxIdCgphdmF0YXJfdXJsGAggASgJUglhdmF0'
    'YXJVcmwSIgoNZGF0ZV9vZl9iaXJ0aBgJIAEoBFILZGF0ZU9mQmlydGgSHwoLaXNfdmVyaWZpZW'
    'QYCiABKAhSCmlzVmVyaWZpZWQSHQoKaXNfcHJlbWl1bRgLIAEoCFIJaXNQcmVtaXVtEh0KCmNy'
    'ZWF0ZWRfYXQYDCABKARSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GA0gASgEUgl1cGRhdGVkQX'
    'QSJwoPYWNjb3VudF9iYWxhbmNlGA4gASgBUg5hY2NvdW50QmFsYW5jZRIpChByZXB1dGF0aW9u'
    'X3Njb3JlGA8gASgNUg9yZXB1dGF0aW9uU2NvcmU=');

@$core.Deprecated('Use postPBDescriptor instead')
const PostPB$json = {
  '1': 'PostPB',
  '2': [
    {'1': 'post_id', '3': 1, '4': 1, '5': 4, '10': 'postId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {'1': 'created_at', '3': 6, '4': 1, '5': 4, '10': 'createdAt'},
    {'1': 'updated_at', '3': 7, '4': 1, '5': 4, '10': 'updatedAt'},
    {'1': 'view_count', '3': 8, '4': 1, '5': 4, '10': 'viewCount'},
    {'1': 'like_count', '3': 9, '4': 1, '5': 4, '10': 'likeCount'},
    {'1': 'comment_count', '3': 10, '4': 1, '5': 4, '10': 'commentCount'},
    {'1': 'is_edited', '3': 11, '4': 1, '5': 8, '10': 'isEdited'},
    {'1': 'is_pinned', '3': 12, '4': 1, '5': 8, '10': 'isPinned'},
  ],
};

/// Descriptor for `PostPB`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postPBDescriptor = $convert.base64Decode(
    'CgZQb3N0UEISFwoHcG9zdF9pZBgBIAEoBFIGcG9zdElkEhcKB3VzZXJfaWQYAiABKARSBnVzZX'
    'JJZBIaCgh1c2VybmFtZRgDIAEoCVIIdXNlcm5hbWUSFAoFdGl0bGUYBCABKAlSBXRpdGxlEhgK'
    'B2NvbnRlbnQYBSABKAlSB2NvbnRlbnQSHQoKY3JlYXRlZF9hdBgGIAEoBFIJY3JlYXRlZEF0Eh'
    '0KCnVwZGF0ZWRfYXQYByABKARSCXVwZGF0ZWRBdBIdCgp2aWV3X2NvdW50GAggASgEUgl2aWV3'
    'Q291bnQSHQoKbGlrZV9jb3VudBgJIAEoBFIJbGlrZUNvdW50EiMKDWNvbW1lbnRfY291bnQYCi'
    'ABKARSDGNvbW1lbnRDb3VudBIbCglpc19lZGl0ZWQYCyABKAhSCGlzRWRpdGVkEhsKCWlzX3Bp'
    'bm5lZBgMIAEoCFIIaXNQaW5uZWQ=');
