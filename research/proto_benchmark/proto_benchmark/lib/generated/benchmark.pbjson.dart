// This is a generated file - do not edit.
//
// Generated from benchmark.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use genderDescriptor instead')
const Gender$json = {
  '1': 'Gender',
  '2': [
    {'1': 'GENDER_UNSPECIFIED', '2': 0},
    {'1': 'MALE', '2': 1},
    {'1': 'FEMALE', '2': 2},
    {'1': 'OTHER', '2': 3},
    {'1': 'PREFER_NOT_TO_SAY', '2': 4},
  ],
};

/// Descriptor for `Gender`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List genderDescriptor = $convert.base64Decode(
    'CgZHZW5kZXISFgoSR0VOREVSX1VOU1BFQ0lGSUVEEAASCAoETUFMRRABEgoKBkZFTUFMRRACEg'
    'kKBU9USEVSEAMSFQoRUFJFRkVSX05PVF9UT19TQVkQBA==');

@$core.Deprecated('Use accountStatusDescriptor instead')
const AccountStatus$json = {
  '1': 'AccountStatus',
  '2': [
    {'1': 'ACCOUNT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ACTIVE', '2': 1},
    {'1': 'SUSPENDED', '2': 2},
    {'1': 'BANNED', '2': 3},
    {'1': 'DELETED', '2': 4},
    {'1': 'PENDING_VERIFICATION', '2': 5},
  ],
};

/// Descriptor for `AccountStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List accountStatusDescriptor = $convert.base64Decode(
    'Cg1BY2NvdW50U3RhdHVzEh4KGkFDQ09VTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASCgoGQUNUSV'
    'ZFEAESDQoJU1VTUEVOREVEEAISCgoGQkFOTkVEEAMSCwoHREVMRVRFRBAEEhgKFFBFTkRJTkdf'
    'VkVSSUZJQ0FUSU9OEAU=');

@$core.Deprecated('Use addressTypeDescriptor instead')
const AddressType$json = {
  '1': 'AddressType',
  '2': [
    {'1': 'ADDRESS_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'HOME', '2': 1},
    {'1': 'WORK', '2': 2},
    {'1': 'BILLING', '2': 3},
    {'1': 'SHIPPING', '2': 4},
  ],
};

/// Descriptor for `AddressType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List addressTypeDescriptor = $convert.base64Decode(
    'CgtBZGRyZXNzVHlwZRIcChhBRERSRVNTX1RZUEVfVU5TUEVDSUZJRUQQABIICgRIT01FEAESCA'
    'oEV09SSxACEgsKB0JJTExJTkcQAxIMCghTSElQUElORxAE');

@$core.Deprecated('Use profileVisibilityDescriptor instead')
const ProfileVisibility$json = {
  '1': 'ProfileVisibility',
  '2': [
    {'1': 'PROFILE_VISIBILITY_UNSPECIFIED', '2': 0},
    {'1': 'PUBLIC', '2': 1},
    {'1': 'FRIENDS', '2': 2},
    {'1': 'PRIVATE', '2': 3},
  ],
};

/// Descriptor for `ProfileVisibility`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List profileVisibilityDescriptor = $convert.base64Decode(
    'ChFQcm9maWxlVmlzaWJpbGl0eRIiCh5QUk9GSUxFX1ZJU0lCSUxJVFlfVU5TUEVDSUZJRUQQAB'
    'IKCgZQVUJMSUMQARILCgdGUklFTkRTEAISCwoHUFJJVkFURRAD');

@$core.Deprecated('Use paymentTypeDescriptor instead')
const PaymentType$json = {
  '1': 'PaymentType',
  '2': [
    {'1': 'PAYMENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CREDIT_CARD', '2': 1},
    {'1': 'DEBIT_CARD', '2': 2},
    {'1': 'PAYPAL', '2': 3},
    {'1': 'BANK_TRANSFER', '2': 4},
    {'1': 'CRYPTOCURRENCY', '2': 5},
    {'1': 'CASH_ON_DELIVERY', '2': 6},
  ],
};

/// Descriptor for `PaymentType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List paymentTypeDescriptor = $convert.base64Decode(
    'CgtQYXltZW50VHlwZRIcChhQQVlNRU5UX1RZUEVfVU5TUEVDSUZJRUQQABIPCgtDUkVESVRfQ0'
    'FSRBABEg4KCkRFQklUX0NBUkQQAhIKCgZQQVlQQUwQAxIRCg1CQU5LX1RSQU5TRkVSEAQSEgoO'
    'Q1JZUFRPQ1VSUkVOQ1kQBRIUChBDQVNIX09OX0RFTElWRVJZEAY=');

@$core.Deprecated('Use subscriptionStatusDescriptor instead')
const SubscriptionStatus$json = {
  '1': 'SubscriptionStatus',
  '2': [
    {'1': 'SUBSCRIPTION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TRIAL', '2': 1},
    {'1': 'SUBSCRIPTION_ACTIVE', '2': 2},
    {'1': 'SUBSCRIPTION_CANCELLED', '2': 3},
    {'1': 'SUBSCRIPTION_EXPIRED', '2': 4},
    {'1': 'SUBSCRIPTION_PAYMENT_FAILED', '2': 5},
  ],
};

/// Descriptor for `SubscriptionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List subscriptionStatusDescriptor = $convert.base64Decode(
    'ChJTdWJzY3JpcHRpb25TdGF0dXMSIwofU1VCU0NSSVBUSU9OX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEgkKBVRSSUFMEAESFwoTU1VCU0NSSVBUSU9OX0FDVElWRRACEhoKFlNVQlNDUklQVElPTl9D'
    'QU5DRUxMRUQQAxIYChRTVUJTQ1JJUFRJT05fRVhQSVJFRBAEEh8KG1NVQlNDUklQVElPTl9QQV'
    'lNRU5UX0ZBSUxFRBAF');

@$core.Deprecated('Use postTypeDescriptor instead')
const PostType$json = {
  '1': 'PostType',
  '2': [
    {'1': 'POST_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'TEXT', '2': 1},
    {'1': 'IMAGE', '2': 2},
    {'1': 'VIDEO', '2': 3},
    {'1': 'LINK', '2': 4},
    {'1': 'POLL_POST', '2': 5},
    {'1': 'LIVE', '2': 6},
    {'1': 'STORY', '2': 7},
  ],
};

/// Descriptor for `PostType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List postTypeDescriptor = $convert.base64Decode(
    'CghQb3N0VHlwZRIZChVQT1NUX1RZUEVfVU5TUEVDSUZJRUQQABIICgRURVhUEAESCQoFSU1BR0'
    'UQAhIJCgVWSURFTxADEggKBExJTksQBBINCglQT0xMX1BPU1QQBRIICgRMSVZFEAYSCQoFU1RP'
    'UlkQBw==');

@$core.Deprecated('Use mediaTypeDescriptor instead')
const MediaType$json = {
  '1': 'MediaType',
  '2': [
    {'1': 'MEDIA_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'IMAGE_MEDIA', '2': 1},
    {'1': 'VIDEO_MEDIA', '2': 2},
    {'1': 'AUDIO', '2': 3},
    {'1': 'DOCUMENT', '2': 4},
    {'1': 'GIF', '2': 5},
  ],
};

/// Descriptor for `MediaType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaTypeDescriptor = $convert.base64Decode(
    'CglNZWRpYVR5cGUSGgoWTUVESUFfVFlQRV9VTlNQRUNJRklFRBAAEg8KC0lNQUdFX01FRElBEA'
    'ESDwoLVklERU9fTUVESUEQAhIJCgVBVURJTxADEgwKCERPQ1VNRU5UEAQSBwoDR0lGEAU=');

@$core.Deprecated('Use postVisibilityDescriptor instead')
const PostVisibility$json = {
  '1': 'PostVisibility',
  '2': [
    {'1': 'POST_VISIBILITY_UNSPECIFIED', '2': 0},
    {'1': 'POST_PUBLIC', '2': 1},
    {'1': 'POST_FRIENDS', '2': 2},
    {'1': 'POST_PRIVATE', '2': 3},
    {'1': 'CUSTOM', '2': 4},
  ],
};

/// Descriptor for `PostVisibility`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List postVisibilityDescriptor = $convert.base64Decode(
    'Cg5Qb3N0VmlzaWJpbGl0eRIfChtQT1NUX1ZJU0lCSUxJVFlfVU5TUEVDSUZJRUQQABIPCgtQT1'
    'NUX1BVQkxJQxABEhAKDFBPU1RfRlJJRU5EUxACEhAKDFBPU1RfUFJJVkFURRADEgoKBkNVU1RP'
    'TRAE');

@$core.Deprecated('Use reactionTypeDescriptor instead')
const ReactionType$json = {
  '1': 'ReactionType',
  '2': [
    {'1': 'REACTION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'LIKE', '2': 1},
    {'1': 'LOVE', '2': 2},
    {'1': 'HAHA', '2': 3},
    {'1': 'WOW', '2': 4},
    {'1': 'SAD', '2': 5},
    {'1': 'ANGRY', '2': 6},
  ],
};

/// Descriptor for `ReactionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reactionTypeDescriptor = $convert.base64Decode(
    'CgxSZWFjdGlvblR5cGUSHQoZUkVBQ1RJT05fVFlQRV9VTlNQRUNJRklFRBAAEggKBExJS0UQAR'
    'IICgRMT1ZFEAISCAoESEFIQRADEgcKA1dPVxAEEgcKA1NBRBAFEgkKBUFOR1JZEAY=');

@$core.Deprecated('Use productStatusDescriptor instead')
const ProductStatus$json = {
  '1': 'ProductStatus',
  '2': [
    {'1': 'PRODUCT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DRAFT', '2': 1},
    {'1': 'PRODUCT_ACTIVE', '2': 2},
    {'1': 'ARCHIVED', '2': 3},
    {'1': 'OUT_OF_STOCK', '2': 4},
  ],
};

/// Descriptor for `ProductStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List productStatusDescriptor = $convert.base64Decode(
    'Cg1Qcm9kdWN0U3RhdHVzEh4KGlBST0RVQ1RfU1RBVFVTX1VOU1BFQ0lGSUVEEAASCQoFRFJBRl'
    'QQARISCg5QUk9EVUNUX0FDVElWRRACEgwKCEFSQ0hJVkVEEAMSEAoMT1VUX09GX1NUT0NLEAQ=');

@$core.Deprecated('Use orderStatusDescriptor instead')
const OrderStatus$json = {
  '1': 'OrderStatus',
  '2': [
    {'1': 'ORDER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ORDER_PENDING', '2': 1},
    {'1': 'ORDER_PROCESSING', '2': 2},
    {'1': 'ORDER_SHIPPED', '2': 3},
    {'1': 'ORDER_DELIVERED', '2': 4},
    {'1': 'ORDER_CANCELLED', '2': 5},
    {'1': 'ORDER_REFUNDED', '2': 6},
    {'1': 'ORDER_FAILED', '2': 7},
  ],
};

/// Descriptor for `OrderStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderStatusDescriptor = $convert.base64Decode(
    'CgtPcmRlclN0YXR1cxIcChhPUkRFUl9TVEFUVVNfVU5TUEVDSUZJRUQQABIRCg1PUkRFUl9QRU'
    '5ESU5HEAESFAoQT1JERVJfUFJPQ0VTU0lORxACEhEKDU9SREVSX1NISVBQRUQQAxITCg9PUkRF'
    'Ul9ERUxJVkVSRUQQBBITCg9PUkRFUl9DQU5DRUxMRUQQBRISCg5PUkRFUl9SRUZVTkRFRBAGEh'
    'AKDE9SREVSX0ZBSUxFRBAH');

@$core.Deprecated('Use paymentStatusDescriptor instead')
const PaymentStatus$json = {
  '1': 'PaymentStatus',
  '2': [
    {'1': 'PAYMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PAYMENT_PENDING', '2': 1},
    {'1': 'COMPLETED', '2': 2},
    {'1': 'PAYMENT_FAILED', '2': 3},
    {'1': 'PAYMENT_REFUNDED', '2': 4},
  ],
};

/// Descriptor for `PaymentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List paymentStatusDescriptor = $convert.base64Decode(
    'Cg1QYXltZW50U3RhdHVzEh4KGlBBWU1FTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASEwoPUEFZTU'
    'VOVF9QRU5ESU5HEAESDQoJQ09NUExFVEVEEAISEgoOUEFZTUVOVF9GQUlMRUQQAxIUChBQQVlN'
    'RU5UX1JFRlVOREVEEAQ=');

@$core.Deprecated('Use couponTypeDescriptor instead')
const CouponType$json = {
  '1': 'CouponType',
  '2': [
    {'1': 'COUPON_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PERCENTAGE', '2': 1},
    {'1': 'FIXED_AMOUNT', '2': 2},
    {'1': 'FREE_SHIPPING', '2': 3},
  ],
};

/// Descriptor for `CouponType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List couponTypeDescriptor = $convert.base64Decode(
    'CgpDb3Vwb25UeXBlEhsKF0NPVVBPTl9UWVBFX1VOU1BFQ0lGSUVEEAASDgoKUEVSQ0VOVEFHRR'
    'ABEhAKDEZJWEVEX0FNT1VOVBACEhEKDUZSRUVfU0hJUFBJTkcQAw==');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'first_name', '3': 4, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'last_name', '3': 5, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'display_name', '3': 6, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'bio', '3': 7, '4': 1, '5': 9, '10': 'bio'},
    {'1': 'avatar_url', '3': 8, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'cover_photo_url', '3': 9, '4': 1, '5': 9, '10': 'coverPhotoUrl'},
    {'1': 'phone_number', '3': 10, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'date_of_birth', '3': 11, '4': 1, '5': 4, '10': 'dateOfBirth'},
    {
      '1': 'gender',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.benchmark.Gender',
      '10': 'gender'
    },
    {
      '1': 'primary_address',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.benchmark.Address',
      '10': 'primaryAddress'
    },
    {
      '1': 'additional_addresses',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Address',
      '10': 'additionalAddresses'
    },
    {
      '1': 'settings',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.benchmark.UserSettings',
      '10': 'settings'
    },
    {
      '1': 'stats',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.benchmark.UserStats',
      '10': 'stats'
    },
    {
      '1': 'social_links',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.benchmark.SocialLink',
      '10': 'socialLinks'
    },
    {'1': 'is_verified', '3': 18, '4': 1, '5': 8, '10': 'isVerified'},
    {'1': 'is_premium', '3': 19, '4': 1, '5': 8, '10': 'isPremium'},
    {
      '1': 'status',
      '3': 20,
      '4': 1,
      '5': 14,
      '6': '.benchmark.AccountStatus',
      '10': 'status'
    },
    {'1': 'created_at', '3': 21, '4': 1, '5': 4, '10': 'createdAt'},
    {'1': 'updated_at', '3': 22, '4': 1, '5': 4, '10': 'updatedAt'},
    {'1': 'last_login', '3': 23, '4': 1, '5': 4, '10': 'lastLogin'},
    {'1': 'device_id', '3': 24, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'ip_address', '3': 25, '4': 1, '5': 9, '10': 'ipAddress'},
    {'1': 'user_agent', '3': 26, '4': 1, '5': 9, '10': 'userAgent'},
    {'1': 'timezone', '3': 27, '4': 1, '5': 9, '10': 'timezone'},
    {'1': 'language', '3': 28, '4': 1, '5': 9, '10': 'language'},
    {'1': 'country_code', '3': 29, '4': 1, '5': 9, '10': 'countryCode'},
    {'1': 'account_balance', '3': 30, '4': 1, '5': 1, '10': 'accountBalance'},
    {
      '1': 'payment_methods',
      '3': 31,
      '4': 3,
      '5': 11,
      '6': '.benchmark.PaymentMethod',
      '10': 'paymentMethods'
    },
    {
      '1': 'subscriptions',
      '3': 32,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Subscription',
      '10': 'subscriptions'
    },
    {'1': 'profile_data', '3': 33, '4': 1, '5': 12, '10': 'profileData'},
    {
      '1': 'metadata',
      '3': 34,
      '4': 3,
      '5': 11,
      '6': '.benchmark.User.MetadataEntry',
      '10': 'metadata'
    },
    {'1': 'tags', '3': 35, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'follower_ids', '3': 36, '4': 3, '5': 4, '10': 'followerIds'},
    {'1': 'following_ids', '3': 37, '4': 3, '5': 4, '10': 'followingIds'},
    {'1': 'blocked_user_ids', '3': 38, '4': 3, '5': 4, '10': 'blockedUserIds'},
    {'1': 'reputation_score', '3': 39, '4': 1, '5': 5, '10': 'reputationScore'},
    {'1': 'referral_code', '3': 40, '4': 1, '5': 9, '10': 'referralCode'},
  ],
  '3': [User_MetadataEntry$json],
};

@$core.Deprecated('Use userDescriptor instead')
const User_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhcKB3VzZXJfaWQYASABKARSBnVzZXJJZBIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm'
    '5hbWUSFAoFZW1haWwYAyABKAlSBWVtYWlsEh0KCmZpcnN0X25hbWUYBCABKAlSCWZpcnN0TmFt'
    'ZRIbCglsYXN0X25hbWUYBSABKAlSCGxhc3ROYW1lEiEKDGRpc3BsYXlfbmFtZRgGIAEoCVILZG'
    'lzcGxheU5hbWUSEAoDYmlvGAcgASgJUgNiaW8SHQoKYXZhdGFyX3VybBgIIAEoCVIJYXZhdGFy'
    'VXJsEiYKD2NvdmVyX3Bob3RvX3VybBgJIAEoCVINY292ZXJQaG90b1VybBIhCgxwaG9uZV9udW'
    '1iZXIYCiABKAlSC3Bob25lTnVtYmVyEiIKDWRhdGVfb2ZfYmlydGgYCyABKARSC2RhdGVPZkJp'
    'cnRoEikKBmdlbmRlchgMIAEoDjIRLmJlbmNobWFyay5HZW5kZXJSBmdlbmRlchI7Cg9wcmltYX'
    'J5X2FkZHJlc3MYDSABKAsyEi5iZW5jaG1hcmsuQWRkcmVzc1IOcHJpbWFyeUFkZHJlc3MSRQoU'
    'YWRkaXRpb25hbF9hZGRyZXNzZXMYDiADKAsyEi5iZW5jaG1hcmsuQWRkcmVzc1ITYWRkaXRpb2'
    '5hbEFkZHJlc3NlcxIzCghzZXR0aW5ncxgPIAEoCzIXLmJlbmNobWFyay5Vc2VyU2V0dGluZ3NS'
    'CHNldHRpbmdzEioKBXN0YXRzGBAgASgLMhQuYmVuY2htYXJrLlVzZXJTdGF0c1IFc3RhdHMSOA'
    'oMc29jaWFsX2xpbmtzGBEgAygLMhUuYmVuY2htYXJrLlNvY2lhbExpbmtSC3NvY2lhbExpbmtz'
    'Eh8KC2lzX3ZlcmlmaWVkGBIgASgIUgppc1ZlcmlmaWVkEh0KCmlzX3ByZW1pdW0YEyABKAhSCW'
    'lzUHJlbWl1bRIwCgZzdGF0dXMYFCABKA4yGC5iZW5jaG1hcmsuQWNjb3VudFN0YXR1c1IGc3Rh'
    'dHVzEh0KCmNyZWF0ZWRfYXQYFSABKARSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GBYgASgEUg'
    'l1cGRhdGVkQXQSHQoKbGFzdF9sb2dpbhgXIAEoBFIJbGFzdExvZ2luEhsKCWRldmljZV9pZBgY'
    'IAEoCVIIZGV2aWNlSWQSHQoKaXBfYWRkcmVzcxgZIAEoCVIJaXBBZGRyZXNzEh0KCnVzZXJfYW'
    'dlbnQYGiABKAlSCXVzZXJBZ2VudBIaCgh0aW1lem9uZRgbIAEoCVIIdGltZXpvbmUSGgoIbGFu'
    'Z3VhZ2UYHCABKAlSCGxhbmd1YWdlEiEKDGNvdW50cnlfY29kZRgdIAEoCVILY291bnRyeUNvZG'
    'USJwoPYWNjb3VudF9iYWxhbmNlGB4gASgBUg5hY2NvdW50QmFsYW5jZRJBCg9wYXltZW50X21l'
    'dGhvZHMYHyADKAsyGC5iZW5jaG1hcmsuUGF5bWVudE1ldGhvZFIOcGF5bWVudE1ldGhvZHMSPQ'
    'oNc3Vic2NyaXB0aW9ucxggIAMoCzIXLmJlbmNobWFyay5TdWJzY3JpcHRpb25SDXN1YnNjcmlw'
    'dGlvbnMSIQoMcHJvZmlsZV9kYXRhGCEgASgMUgtwcm9maWxlRGF0YRI5CghtZXRhZGF0YRgiIA'
    'MoCzIdLmJlbmNobWFyay5Vc2VyLk1ldGFkYXRhRW50cnlSCG1ldGFkYXRhEhIKBHRhZ3MYIyAD'
    'KAlSBHRhZ3MSIQoMZm9sbG93ZXJfaWRzGCQgAygEUgtmb2xsb3dlcklkcxIjCg1mb2xsb3dpbm'
    'dfaWRzGCUgAygEUgxmb2xsb3dpbmdJZHMSKAoQYmxvY2tlZF91c2VyX2lkcxgmIAMoBFIOYmxv'
    'Y2tlZFVzZXJJZHMSKQoQcmVwdXRhdGlvbl9zY29yZRgnIAEoBVIPcmVwdXRhdGlvblNjb3JlEi'
    'MKDXJlZmVycmFsX2NvZGUYKCABKAlSDHJlZmVycmFsQ29kZRo7Cg1NZXRhZGF0YUVudHJ5EhAK'
    'A2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use addressDescriptor instead')
const Address$json = {
  '1': 'Address',
  '2': [
    {'1': 'street_line1', '3': 1, '4': 1, '5': 9, '10': 'streetLine1'},
    {'1': 'street_line2', '3': 2, '4': 1, '5': 9, '10': 'streetLine2'},
    {'1': 'city', '3': 3, '4': 1, '5': 9, '10': 'city'},
    {'1': 'state', '3': 4, '4': 1, '5': 9, '10': 'state'},
    {'1': 'postal_code', '3': 5, '4': 1, '5': 9, '10': 'postalCode'},
    {'1': 'country', '3': 6, '4': 1, '5': 9, '10': 'country'},
    {
      '1': 'type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.benchmark.AddressType',
      '10': 'type'
    },
    {'1': 'is_default', '3': 8, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'latitude', '3': 9, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 10, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'instructions', '3': 11, '4': 1, '5': 9, '10': 'instructions'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode(
    'CgdBZGRyZXNzEiEKDHN0cmVldF9saW5lMRgBIAEoCVILc3RyZWV0TGluZTESIQoMc3RyZWV0X2'
    'xpbmUyGAIgASgJUgtzdHJlZXRMaW5lMhISCgRjaXR5GAMgASgJUgRjaXR5EhQKBXN0YXRlGAQg'
    'ASgJUgVzdGF0ZRIfCgtwb3N0YWxfY29kZRgFIAEoCVIKcG9zdGFsQ29kZRIYCgdjb3VudHJ5GA'
    'YgASgJUgdjb3VudHJ5EioKBHR5cGUYByABKA4yFi5iZW5jaG1hcmsuQWRkcmVzc1R5cGVSBHR5'
    'cGUSHQoKaXNfZGVmYXVsdBgIIAEoCFIJaXNEZWZhdWx0EhoKCGxhdGl0dWRlGAkgASgBUghsYX'
    'RpdHVkZRIcCglsb25naXR1ZGUYCiABKAFSCWxvbmdpdHVkZRIiCgxpbnN0cnVjdGlvbnMYCyAB'
    'KAlSDGluc3RydWN0aW9ucw==');

@$core.Deprecated('Use userSettingsDescriptor instead')
const UserSettings$json = {
  '1': 'UserSettings',
  '2': [
    {
      '1': 'notifications',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.benchmark.NotificationSettings',
      '10': 'notifications'
    },
    {
      '1': 'privacy',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.benchmark.PrivacySettings',
      '10': 'privacy'
    },
    {
      '1': 'display',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.benchmark.DisplaySettings',
      '10': 'display'
    },
    {'1': 'email_verified', '3': 4, '4': 1, '5': 8, '10': 'emailVerified'},
    {'1': 'phone_verified', '3': 5, '4': 1, '5': 8, '10': 'phoneVerified'},
    {
      '1': 'two_factor_enabled',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'twoFactorEnabled'
    },
    {'1': 'blocked_keywords', '3': 7, '4': 3, '5': 9, '10': 'blockedKeywords'},
    {'1': 'auto_play_videos', '3': 8, '4': 1, '5': 8, '10': 'autoPlayVideos'},
    {
      '1': 'show_adult_content',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'showAdultContent'
    },
    {
      '1': 'feed_refresh_interval',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'feedRefreshInterval'
    },
  ],
};

/// Descriptor for `UserSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userSettingsDescriptor = $convert.base64Decode(
    'CgxVc2VyU2V0dGluZ3MSRQoNbm90aWZpY2F0aW9ucxgBIAEoCzIfLmJlbmNobWFyay5Ob3RpZm'
    'ljYXRpb25TZXR0aW5nc1INbm90aWZpY2F0aW9ucxI0Cgdwcml2YWN5GAIgASgLMhouYmVuY2ht'
    'YXJrLlByaXZhY3lTZXR0aW5nc1IHcHJpdmFjeRI0CgdkaXNwbGF5GAMgASgLMhouYmVuY2htYX'
    'JrLkRpc3BsYXlTZXR0aW5nc1IHZGlzcGxheRIlCg5lbWFpbF92ZXJpZmllZBgEIAEoCFINZW1h'
    'aWxWZXJpZmllZBIlCg5waG9uZV92ZXJpZmllZBgFIAEoCFINcGhvbmVWZXJpZmllZBIsChJ0d2'
    '9fZmFjdG9yX2VuYWJsZWQYBiABKAhSEHR3b0ZhY3RvckVuYWJsZWQSKQoQYmxvY2tlZF9rZXl3'
    'b3JkcxgHIAMoCVIPYmxvY2tlZEtleXdvcmRzEigKEGF1dG9fcGxheV92aWRlb3MYCCABKAhSDm'
    'F1dG9QbGF5VmlkZW9zEiwKEnNob3dfYWR1bHRfY29udGVudBgJIAEoCFIQc2hvd0FkdWx0Q29u'
    'dGVudBIyChVmZWVkX3JlZnJlc2hfaW50ZXJ2YWwYCiABKAVSE2ZlZWRSZWZyZXNoSW50ZXJ2YW'
    'w=');

@$core.Deprecated('Use notificationSettingsDescriptor instead')
const NotificationSettings$json = {
  '1': 'NotificationSettings',
  '2': [
    {'1': 'push_enabled', '3': 1, '4': 1, '5': 8, '10': 'pushEnabled'},
    {'1': 'email_enabled', '3': 2, '4': 1, '5': 8, '10': 'emailEnabled'},
    {'1': 'sms_enabled', '3': 3, '4': 1, '5': 8, '10': 'smsEnabled'},
    {
      '1': 'likes_notifications',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'likesNotifications'
    },
    {
      '1': 'comments_notifications',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'commentsNotifications'
    },
    {
      '1': 'mentions_notifications',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'mentionsNotifications'
    },
    {
      '1': 'follow_notifications',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'followNotifications'
    },
    {
      '1': 'message_notifications',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'messageNotifications'
    },
    {'1': 'marketing_emails', '3': 9, '4': 1, '5': 8, '10': 'marketingEmails'},
    {
      '1': 'quiet_hours_start',
      '3': 10,
      '4': 3,
      '5': 13,
      '10': 'quietHoursStart'
    },
    {'1': 'quiet_hours_end', '3': 11, '4': 3, '5': 13, '10': 'quietHoursEnd'},
  ],
};

/// Descriptor for `NotificationSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationSettingsDescriptor = $convert.base64Decode(
    'ChROb3RpZmljYXRpb25TZXR0aW5ncxIhCgxwdXNoX2VuYWJsZWQYASABKAhSC3B1c2hFbmFibG'
    'VkEiMKDWVtYWlsX2VuYWJsZWQYAiABKAhSDGVtYWlsRW5hYmxlZBIfCgtzbXNfZW5hYmxlZBgD'
    'IAEoCFIKc21zRW5hYmxlZBIvChNsaWtlc19ub3RpZmljYXRpb25zGAQgASgIUhJsaWtlc05vdG'
    'lmaWNhdGlvbnMSNQoWY29tbWVudHNfbm90aWZpY2F0aW9ucxgFIAEoCFIVY29tbWVudHNOb3Rp'
    'ZmljYXRpb25zEjUKFm1lbnRpb25zX25vdGlmaWNhdGlvbnMYBiABKAhSFW1lbnRpb25zTm90aW'
    'ZpY2F0aW9ucxIxChRmb2xsb3dfbm90aWZpY2F0aW9ucxgHIAEoCFITZm9sbG93Tm90aWZpY2F0'
    'aW9ucxIzChVtZXNzYWdlX25vdGlmaWNhdGlvbnMYCCABKAhSFG1lc3NhZ2VOb3RpZmljYXRpb2'
    '5zEikKEG1hcmtldGluZ19lbWFpbHMYCSABKAhSD21hcmtldGluZ0VtYWlscxIqChFxdWlldF9o'
    'b3Vyc19zdGFydBgKIAMoDVIPcXVpZXRIb3Vyc1N0YXJ0EiYKD3F1aWV0X2hvdXJzX2VuZBgLIA'
    'MoDVINcXVpZXRIb3Vyc0VuZA==');

@$core.Deprecated('Use privacySettingsDescriptor instead')
const PrivacySettings$json = {
  '1': 'PrivacySettings',
  '2': [
    {
      '1': 'profile_visibility',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.benchmark.ProfileVisibility',
      '10': 'profileVisibility'
    },
    {'1': 'show_email', '3': 2, '4': 1, '5': 8, '10': 'showEmail'},
    {'1': 'show_phone', '3': 3, '4': 1, '5': 8, '10': 'showPhone'},
    {'1': 'show_location', '3': 4, '4': 1, '5': 8, '10': 'showLocation'},
    {'1': 'allow_tags', '3': 5, '4': 1, '5': 8, '10': 'allowTags'},
    {'1': 'allow_mentions', '3': 6, '4': 1, '5': 8, '10': 'allowMentions'},
    {'1': 'searchable', '3': 7, '4': 1, '5': 8, '10': 'searchable'},
    {
      '1': 'show_online_status',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'showOnlineStatus'
    },
    {'1': 'show_last_seen', '3': 9, '4': 1, '5': 8, '10': 'showLastSeen'},
    {
      '1': 'allow_direct_messages',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'allowDirectMessages'
    },
  ],
};

/// Descriptor for `PrivacySettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List privacySettingsDescriptor = $convert.base64Decode(
    'Cg9Qcml2YWN5U2V0dGluZ3MSSwoScHJvZmlsZV92aXNpYmlsaXR5GAEgASgOMhwuYmVuY2htYX'
    'JrLlByb2ZpbGVWaXNpYmlsaXR5UhFwcm9maWxlVmlzaWJpbGl0eRIdCgpzaG93X2VtYWlsGAIg'
    'ASgIUglzaG93RW1haWwSHQoKc2hvd19waG9uZRgDIAEoCFIJc2hvd1Bob25lEiMKDXNob3dfbG'
    '9jYXRpb24YBCABKAhSDHNob3dMb2NhdGlvbhIdCgphbGxvd190YWdzGAUgASgIUglhbGxvd1Rh'
    'Z3MSJQoOYWxsb3dfbWVudGlvbnMYBiABKAhSDWFsbG93TWVudGlvbnMSHgoKc2VhcmNoYWJsZR'
    'gHIAEoCFIKc2VhcmNoYWJsZRIsChJzaG93X29ubGluZV9zdGF0dXMYCCABKAhSEHNob3dPbmxp'
    'bmVTdGF0dXMSJAoOc2hvd19sYXN0X3NlZW4YCSABKAhSDHNob3dMYXN0U2VlbhIyChVhbGxvd1'
    '9kaXJlY3RfbWVzc2FnZXMYCiABKAhSE2FsbG93RGlyZWN0TWVzc2FnZXM=');

@$core.Deprecated('Use displaySettingsDescriptor instead')
const DisplaySettings$json = {
  '1': 'DisplaySettings',
  '2': [
    {'1': 'theme', '3': 1, '4': 1, '5': 9, '10': 'theme'},
    {'1': 'font_size', '3': 2, '4': 1, '5': 9, '10': 'fontSize'},
    {'1': 'compact_mode', '3': 3, '4': 1, '5': 8, '10': 'compactMode'},
    {'1': 'show_thumbnails', '3': 4, '4': 1, '5': 8, '10': 'showThumbnails'},
    {'1': 'high_contrast', '3': 5, '4': 1, '5': 8, '10': 'highContrast'},
    {'1': 'date_format', '3': 6, '4': 1, '5': 9, '10': 'dateFormat'},
    {'1': 'time_format', '3': 7, '4': 1, '5': 9, '10': 'timeFormat'},
  ],
};

/// Descriptor for `DisplaySettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List displaySettingsDescriptor = $convert.base64Decode(
    'Cg9EaXNwbGF5U2V0dGluZ3MSFAoFdGhlbWUYASABKAlSBXRoZW1lEhsKCWZvbnRfc2l6ZRgCIA'
    'EoCVIIZm9udFNpemUSIQoMY29tcGFjdF9tb2RlGAMgASgIUgtjb21wYWN0TW9kZRInCg9zaG93'
    'X3RodW1ibmFpbHMYBCABKAhSDnNob3dUaHVtYm5haWxzEiMKDWhpZ2hfY29udHJhc3QYBSABKA'
    'hSDGhpZ2hDb250cmFzdBIfCgtkYXRlX2Zvcm1hdBgGIAEoCVIKZGF0ZUZvcm1hdBIfCgt0aW1l'
    'X2Zvcm1hdBgHIAEoCVIKdGltZUZvcm1hdA==');

@$core.Deprecated('Use userStatsDescriptor instead')
const UserStats$json = {
  '1': 'UserStats',
  '2': [
    {'1': 'total_posts', '3': 1, '4': 1, '5': 4, '10': 'totalPosts'},
    {'1': 'total_comments', '3': 2, '4': 1, '5': 4, '10': 'totalComments'},
    {'1': 'total_likes', '3': 3, '4': 1, '5': 4, '10': 'totalLikes'},
    {'1': 'total_shares', '3': 4, '4': 1, '5': 4, '10': 'totalShares'},
    {'1': 'total_views', '3': 5, '4': 1, '5': 4, '10': 'totalViews'},
    {'1': 'follower_count', '3': 6, '4': 1, '5': 4, '10': 'followerCount'},
    {'1': 'following_count', '3': 7, '4': 1, '5': 4, '10': 'followingCount'},
    {'1': 'total_purchases', '3': 8, '4': 1, '5': 4, '10': 'totalPurchases'},
    {'1': 'total_spent', '3': 9, '4': 1, '5': 1, '10': 'totalSpent'},
    {
      '1': 'engagement_score',
      '3': 10,
      '4': 1,
      '5': 13,
      '10': 'engagementScore'
    },
    {'1': 'influence_score', '3': 11, '4': 1, '5': 13, '10': 'influenceScore'},
    {
      '1': 'achievements',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Achievement',
      '10': 'achievements'
    },
  ],
};

/// Descriptor for `UserStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userStatsDescriptor = $convert.base64Decode(
    'CglVc2VyU3RhdHMSHwoLdG90YWxfcG9zdHMYASABKARSCnRvdGFsUG9zdHMSJQoOdG90YWxfY2'
    '9tbWVudHMYAiABKARSDXRvdGFsQ29tbWVudHMSHwoLdG90YWxfbGlrZXMYAyABKARSCnRvdGFs'
    'TGlrZXMSIQoMdG90YWxfc2hhcmVzGAQgASgEUgt0b3RhbFNoYXJlcxIfCgt0b3RhbF92aWV3cx'
    'gFIAEoBFIKdG90YWxWaWV3cxIlCg5mb2xsb3dlcl9jb3VudBgGIAEoBFINZm9sbG93ZXJDb3Vu'
    'dBInCg9mb2xsb3dpbmdfY291bnQYByABKARSDmZvbGxvd2luZ0NvdW50EicKD3RvdGFsX3B1cm'
    'NoYXNlcxgIIAEoBFIOdG90YWxQdXJjaGFzZXMSHwoLdG90YWxfc3BlbnQYCSABKAFSCnRvdGFs'
    'U3BlbnQSKQoQZW5nYWdlbWVudF9zY29yZRgKIAEoDVIPZW5nYWdlbWVudFNjb3JlEicKD2luZm'
    'x1ZW5jZV9zY29yZRgLIAEoDVIOaW5mbHVlbmNlU2NvcmUSOgoMYWNoaWV2ZW1lbnRzGAwgAygL'
    'MhYuYmVuY2htYXJrLkFjaGlldmVtZW50UgxhY2hpZXZlbWVudHM=');

@$core.Deprecated('Use achievementDescriptor instead')
const Achievement$json = {
  '1': 'Achievement',
  '2': [
    {'1': 'achievement_id', '3': 1, '4': 1, '5': 9, '10': 'achievementId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'icon_url', '3': 4, '4': 1, '5': 9, '10': 'iconUrl'},
    {'1': 'unlocked_at', '3': 5, '4': 1, '5': 4, '10': 'unlockedAt'},
    {'1': 'points', '3': 6, '4': 1, '5': 5, '10': 'points'},
  ],
};

/// Descriptor for `Achievement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List achievementDescriptor = $convert.base64Decode(
    'CgtBY2hpZXZlbWVudBIlCg5hY2hpZXZlbWVudF9pZBgBIAEoCVINYWNoaWV2ZW1lbnRJZBISCg'
    'RuYW1lGAIgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhIZCghp'
    'Y29uX3VybBgEIAEoCVIHaWNvblVybBIfCgt1bmxvY2tlZF9hdBgFIAEoBFIKdW5sb2NrZWRBdB'
    'IWCgZwb2ludHMYBiABKAVSBnBvaW50cw==');

@$core.Deprecated('Use socialLinkDescriptor instead')
const SocialLink$json = {
  '1': 'SocialLink',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'verified', '3': 4, '4': 1, '5': 8, '10': 'verified'},
  ],
};

/// Descriptor for `SocialLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List socialLinkDescriptor = $convert.base64Decode(
    'CgpTb2NpYWxMaW5rEhoKCHBsYXRmb3JtGAEgASgJUghwbGF0Zm9ybRIQCgN1cmwYAiABKAlSA3'
    'VybBIaCgh1c2VybmFtZRgDIAEoCVIIdXNlcm5hbWUSGgoIdmVyaWZpZWQYBCABKAhSCHZlcmlm'
    'aWVk');

@$core.Deprecated('Use paymentMethodDescriptor instead')
const PaymentMethod$json = {
  '1': 'PaymentMethod',
  '2': [
    {'1': 'payment_method_id', '3': 1, '4': 1, '5': 9, '10': 'paymentMethodId'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.benchmark.PaymentType',
      '10': 'type'
    },
    {'1': 'last_four_digits', '3': 3, '4': 1, '5': 9, '10': 'lastFourDigits'},
    {'1': 'card_brand', '3': 4, '4': 1, '5': 9, '10': 'cardBrand'},
    {'1': 'expiry_month', '3': 5, '4': 1, '5': 13, '10': 'expiryMonth'},
    {'1': 'expiry_year', '3': 6, '4': 1, '5': 13, '10': 'expiryYear'},
    {
      '1': 'billing_address_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'billingAddressId'
    },
    {'1': 'is_default', '3': 8, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'provider', '3': 9, '4': 1, '5': 9, '10': 'provider'},
  ],
};

/// Descriptor for `PaymentMethod`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentMethodDescriptor = $convert.base64Decode(
    'Cg1QYXltZW50TWV0aG9kEioKEXBheW1lbnRfbWV0aG9kX2lkGAEgASgJUg9wYXltZW50TWV0aG'
    '9kSWQSKgoEdHlwZRgCIAEoDjIWLmJlbmNobWFyay5QYXltZW50VHlwZVIEdHlwZRIoChBsYXN0'
    'X2ZvdXJfZGlnaXRzGAMgASgJUg5sYXN0Rm91ckRpZ2l0cxIdCgpjYXJkX2JyYW5kGAQgASgJUg'
    'ljYXJkQnJhbmQSIQoMZXhwaXJ5X21vbnRoGAUgASgNUgtleHBpcnlNb250aBIfCgtleHBpcnlf'
    'eWVhchgGIAEoDVIKZXhwaXJ5WWVhchIsChJiaWxsaW5nX2FkZHJlc3NfaWQYByABKAlSEGJpbG'
    'xpbmdBZGRyZXNzSWQSHQoKaXNfZGVmYXVsdBgIIAEoCFIJaXNEZWZhdWx0EhoKCHByb3ZpZGVy'
    'GAkgASgJUghwcm92aWRlcg==');

@$core.Deprecated('Use subscriptionDescriptor instead')
const Subscription$json = {
  '1': 'Subscription',
  '2': [
    {'1': 'subscription_id', '3': 1, '4': 1, '5': 9, '10': 'subscriptionId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'plan_name', '3': 3, '4': 1, '5': 9, '10': 'planName'},
    {'1': 'price', '3': 4, '4': 1, '5': 1, '10': 'price'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.benchmark.SubscriptionStatus',
      '10': 'status'
    },
    {'1': 'start_date', '3': 7, '4': 1, '5': 4, '10': 'startDate'},
    {'1': 'end_date', '3': 8, '4': 1, '5': 4, '10': 'endDate'},
    {'1': 'next_billing_date', '3': 9, '4': 1, '5': 4, '10': 'nextBillingDate'},
    {'1': 'auto_renew', '3': 10, '4': 1, '5': 8, '10': 'autoRenew'},
  ],
};

/// Descriptor for `Subscription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionDescriptor = $convert.base64Decode(
    'CgxTdWJzY3JpcHRpb24SJwoPc3Vic2NyaXB0aW9uX2lkGAEgASgJUg5zdWJzY3JpcHRpb25JZB'
    'IXCgdwbGFuX2lkGAIgASgJUgZwbGFuSWQSGwoJcGxhbl9uYW1lGAMgASgJUghwbGFuTmFtZRIU'
    'CgVwcmljZRgEIAEoAVIFcHJpY2USGgoIY3VycmVuY3kYBSABKAlSCGN1cnJlbmN5EjUKBnN0YX'
    'R1cxgGIAEoDjIdLmJlbmNobWFyay5TdWJzY3JpcHRpb25TdGF0dXNSBnN0YXR1cxIdCgpzdGFy'
    'dF9kYXRlGAcgASgEUglzdGFydERhdGUSGQoIZW5kX2RhdGUYCCABKARSB2VuZERhdGUSKgoRbm'
    'V4dF9iaWxsaW5nX2RhdGUYCSABKARSD25leHRCaWxsaW5nRGF0ZRIdCgphdXRvX3JlbmV3GAog'
    'ASgIUglhdXRvUmVuZXc=');

@$core.Deprecated('Use postDescriptor instead')
const Post$json = {
  '1': 'Post',
  '2': [
    {'1': 'post_id', '3': 1, '4': 1, '5': 4, '10': 'postId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'user_avatar_url', '3': 4, '4': 1, '5': 9, '10': 'userAvatarUrl'},
    {
      '1': 'type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.benchmark.PostType',
      '10': 'type'
    },
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'content', '3': 7, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'media',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.benchmark.MediaAttachment',
      '10': 'media'
    },
    {'1': 'hashtags', '3': 9, '4': 3, '5': 9, '10': 'hashtags'},
    {
      '1': 'mentions',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.benchmark.UserMention',
      '10': 'mentions'
    },
    {
      '1': 'location',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.benchmark.Location',
      '10': 'location'
    },
    {'1': 'created_at', '3': 12, '4': 1, '5': 4, '10': 'createdAt'},
    {'1': 'updated_at', '3': 13, '4': 1, '5': 4, '10': 'updatedAt'},
    {
      '1': 'stats',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.benchmark.PostStats',
      '10': 'stats'
    },
    {
      '1': 'settings',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.benchmark.PostSettings',
      '10': 'settings'
    },
    {
      '1': 'comments',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Comment',
      '10': 'comments'
    },
    {
      '1': 'reactions',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Reaction',
      '10': 'reactions'
    },
    {'1': 'category_ids', '3': 18, '4': 3, '5': 9, '10': 'categoryIds'},
    {'1': 'language', '3': 19, '4': 1, '5': 9, '10': 'language'},
    {
      '1': 'translations',
      '3': 20,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Translation',
      '10': 'translations'
    },
    {'1': 'is_edited', '3': 21, '4': 1, '5': 8, '10': 'isEdited'},
    {'1': 'is_pinned', '3': 22, '4': 1, '5': 8, '10': 'isPinned'},
    {'1': 'is_sponsored', '3': 23, '4': 1, '5': 8, '10': 'isSponsored'},
    {'1': 'sponsor_name', '3': 24, '4': 1, '5': 9, '10': 'sponsorName'},
    {
      '1': 'links',
      '3': 25,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Link',
      '10': 'links'
    },
    {
      '1': 'polls',
      '3': 26,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Poll',
      '10': 'polls'
    },
    {
      '1': 'tags',
      '3': 27,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Tag',
      '10': 'tags'
    },
    {'1': 'custom_data', '3': 28, '4': 1, '5': 12, '10': 'customData'},
    {'1': 'shared_post_id', '3': 29, '4': 1, '5': 4, '10': 'sharedPostId'},
    {'1': 'share_comment', '3': 30, '4': 1, '5': 9, '10': 'shareComment'},
  ],
};

/// Descriptor for `Post`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postDescriptor = $convert.base64Decode(
    'CgRQb3N0EhcKB3Bvc3RfaWQYASABKARSBnBvc3RJZBIXCgd1c2VyX2lkGAIgASgEUgZ1c2VySW'
    'QSGgoIdXNlcm5hbWUYAyABKAlSCHVzZXJuYW1lEiYKD3VzZXJfYXZhdGFyX3VybBgEIAEoCVIN'
    'dXNlckF2YXRhclVybBInCgR0eXBlGAUgASgOMhMuYmVuY2htYXJrLlBvc3RUeXBlUgR0eXBlEh'
    'QKBXRpdGxlGAYgASgJUgV0aXRsZRIYCgdjb250ZW50GAcgASgJUgdjb250ZW50EjAKBW1lZGlh'
    'GAggAygLMhouYmVuY2htYXJrLk1lZGlhQXR0YWNobWVudFIFbWVkaWESGgoIaGFzaHRhZ3MYCS'
    'ADKAlSCGhhc2h0YWdzEjIKCG1lbnRpb25zGAogAygLMhYuYmVuY2htYXJrLlVzZXJNZW50aW9u'
    'UghtZW50aW9ucxIvCghsb2NhdGlvbhgLIAEoCzITLmJlbmNobWFyay5Mb2NhdGlvblIIbG9jYX'
    'Rpb24SHQoKY3JlYXRlZF9hdBgMIAEoBFIJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYDSABKARS'
    'CXVwZGF0ZWRBdBIqCgVzdGF0cxgOIAEoCzIULmJlbmNobWFyay5Qb3N0U3RhdHNSBXN0YXRzEj'
    'MKCHNldHRpbmdzGA8gASgLMhcuYmVuY2htYXJrLlBvc3RTZXR0aW5nc1IIc2V0dGluZ3MSLgoI'
    'Y29tbWVudHMYECADKAsyEi5iZW5jaG1hcmsuQ29tbWVudFIIY29tbWVudHMSMQoJcmVhY3Rpb2'
    '5zGBEgAygLMhMuYmVuY2htYXJrLlJlYWN0aW9uUglyZWFjdGlvbnMSIQoMY2F0ZWdvcnlfaWRz'
    'GBIgAygJUgtjYXRlZ29yeUlkcxIaCghsYW5ndWFnZRgTIAEoCVIIbGFuZ3VhZ2USOgoMdHJhbn'
    'NsYXRpb25zGBQgAygLMhYuYmVuY2htYXJrLlRyYW5zbGF0aW9uUgx0cmFuc2xhdGlvbnMSGwoJ'
    'aXNfZWRpdGVkGBUgASgIUghpc0VkaXRlZBIbCglpc19waW5uZWQYFiABKAhSCGlzUGlubmVkEi'
    'EKDGlzX3Nwb25zb3JlZBgXIAEoCFILaXNTcG9uc29yZWQSIQoMc3BvbnNvcl9uYW1lGBggASgJ'
    'UgtzcG9uc29yTmFtZRIlCgVsaW5rcxgZIAMoCzIPLmJlbmNobWFyay5MaW5rUgVsaW5rcxIlCg'
    'Vwb2xscxgaIAMoCzIPLmJlbmNobWFyay5Qb2xsUgVwb2xscxIiCgR0YWdzGBsgAygLMg4uYmVu'
    'Y2htYXJrLlRhZ1IEdGFncxIfCgtjdXN0b21fZGF0YRgcIAEoDFIKY3VzdG9tRGF0YRIkCg5zaG'
    'FyZWRfcG9zdF9pZBgdIAEoBFIMc2hhcmVkUG9zdElkEiMKDXNoYXJlX2NvbW1lbnQYHiABKAlS'
    'DHNoYXJlQ29tbWVudA==');

@$core.Deprecated('Use mediaAttachmentDescriptor instead')
const MediaAttachment$json = {
  '1': 'MediaAttachment',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.benchmark.MediaType',
      '10': 'type'
    },
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {'1': 'thumbnail_url', '3': 4, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {'1': 'preview_url', '3': 5, '4': 1, '5': 9, '10': 'previewUrl'},
    {'1': 'size_bytes', '3': 6, '4': 1, '5': 4, '10': 'sizeBytes'},
    {'1': 'width', '3': 7, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 8, '4': 1, '5': 13, '10': 'height'},
    {'1': 'duration_seconds', '3': 9, '4': 1, '5': 13, '10': 'durationSeconds'},
    {'1': 'mime_type', '3': 10, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'alt_text', '3': 11, '4': 1, '5': 9, '10': 'altText'},
    {'1': 'filters', '3': 12, '4': 3, '5': 9, '10': 'filters'},
    {
      '1': 'metadata',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.benchmark.MediaAttachment.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [MediaAttachment_MetadataEntry$json],
};

@$core.Deprecated('Use mediaAttachmentDescriptor instead')
const MediaAttachment_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `MediaAttachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaAttachmentDescriptor = $convert.base64Decode(
    'Cg9NZWRpYUF0dGFjaG1lbnQSGQoIbWVkaWFfaWQYASABKAlSB21lZGlhSWQSKAoEdHlwZRgCIA'
    'EoDjIULmJlbmNobWFyay5NZWRpYVR5cGVSBHR5cGUSEAoDdXJsGAMgASgJUgN1cmwSIwoNdGh1'
    'bWJuYWlsX3VybBgEIAEoCVIMdGh1bWJuYWlsVXJsEh8KC3ByZXZpZXdfdXJsGAUgASgJUgpwcm'
    'V2aWV3VXJsEh0KCnNpemVfYnl0ZXMYBiABKARSCXNpemVCeXRlcxIUCgV3aWR0aBgHIAEoDVIF'
    'd2lkdGgSFgoGaGVpZ2h0GAggASgNUgZoZWlnaHQSKQoQZHVyYXRpb25fc2Vjb25kcxgJIAEoDV'
    'IPZHVyYXRpb25TZWNvbmRzEhsKCW1pbWVfdHlwZRgKIAEoCVIIbWltZVR5cGUSGQoIYWx0X3Rl'
    'eHQYCyABKAlSB2FsdFRleHQSGAoHZmlsdGVycxgMIAMoCVIHZmlsdGVycxJECghtZXRhZGF0YR'
    'gNIAMoCzIoLmJlbmNobWFyay5NZWRpYUF0dGFjaG1lbnQuTWV0YWRhdGFFbnRyeVIIbWV0YWRh'
    'dGEaOwoNTWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdm'
    'FsdWU6AjgB');

@$core.Deprecated('Use userMentionDescriptor instead')
const UserMention$json = {
  '1': 'UserMention',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'start_index', '3': 3, '4': 1, '5': 13, '10': 'startIndex'},
    {'1': 'end_index', '3': 4, '4': 1, '5': 13, '10': 'endIndex'},
  ],
};

/// Descriptor for `UserMention`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userMentionDescriptor = $convert.base64Decode(
    'CgtVc2VyTWVudGlvbhIXCgd1c2VyX2lkGAEgASgEUgZ1c2VySWQSGgoIdXNlcm5hbWUYAiABKA'
    'lSCHVzZXJuYW1lEh8KC3N0YXJ0X2luZGV4GAMgASgNUgpzdGFydEluZGV4EhsKCWVuZF9pbmRl'
    'eBgEIAEoDVIIZW5kSW5kZXg=');

@$core.Deprecated('Use locationDescriptor instead')
const Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'address', '3': 4, '4': 1, '5': 9, '10': 'address'},
    {'1': 'city', '3': 5, '4': 1, '5': 9, '10': 'city'},
    {'1': 'country', '3': 6, '4': 1, '5': 9, '10': 'country'},
    {'1': 'place_id', '3': 7, '4': 1, '5': 9, '10': 'placeId'},
  ],
};

/// Descriptor for `Location`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationDescriptor = $convert.base64Decode(
    'CghMb2NhdGlvbhIaCghsYXRpdHVkZRgBIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgAS'
    'gBUglsb25naXR1ZGUSEgoEbmFtZRgDIAEoCVIEbmFtZRIYCgdhZGRyZXNzGAQgASgJUgdhZGRy'
    'ZXNzEhIKBGNpdHkYBSABKAlSBGNpdHkSGAoHY291bnRyeRgGIAEoCVIHY291bnRyeRIZCghwbG'
    'FjZV9pZBgHIAEoCVIHcGxhY2VJZA==');

@$core.Deprecated('Use postStatsDescriptor instead')
const PostStats$json = {
  '1': 'PostStats',
  '2': [
    {'1': 'view_count', '3': 1, '4': 1, '5': 4, '10': 'viewCount'},
    {'1': 'like_count', '3': 2, '4': 1, '5': 4, '10': 'likeCount'},
    {'1': 'comment_count', '3': 3, '4': 1, '5': 4, '10': 'commentCount'},
    {'1': 'share_count', '3': 4, '4': 1, '5': 4, '10': 'shareCount'},
    {'1': 'save_count', '3': 5, '4': 1, '5': 4, '10': 'saveCount'},
    {'1': 'click_count', '3': 6, '4': 1, '5': 4, '10': 'clickCount'},
    {'1': 'engagement_rate', '3': 7, '4': 1, '5': 1, '10': 'engagementRate'},
    {'1': 'virality_score', '3': 8, '4': 1, '5': 1, '10': 'viralityScore'},
  ],
};

/// Descriptor for `PostStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postStatsDescriptor = $convert.base64Decode(
    'CglQb3N0U3RhdHMSHQoKdmlld19jb3VudBgBIAEoBFIJdmlld0NvdW50Eh0KCmxpa2VfY291bn'
    'QYAiABKARSCWxpa2VDb3VudBIjCg1jb21tZW50X2NvdW50GAMgASgEUgxjb21tZW50Q291bnQS'
    'HwoLc2hhcmVfY291bnQYBCABKARSCnNoYXJlQ291bnQSHQoKc2F2ZV9jb3VudBgFIAEoBFIJc2'
    'F2ZUNvdW50Eh8KC2NsaWNrX2NvdW50GAYgASgEUgpjbGlja0NvdW50EicKD2VuZ2FnZW1lbnRf'
    'cmF0ZRgHIAEoAVIOZW5nYWdlbWVudFJhdGUSJQoOdmlyYWxpdHlfc2NvcmUYCCABKAFSDXZpcm'
    'FsaXR5U2NvcmU=');

@$core.Deprecated('Use postSettingsDescriptor instead')
const PostSettings$json = {
  '1': 'PostSettings',
  '2': [
    {
      '1': 'visibility',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.benchmark.PostVisibility',
      '10': 'visibility'
    },
    {'1': 'allow_comments', '3': 2, '4': 1, '5': 8, '10': 'allowComments'},
    {'1': 'allow_shares', '3': 3, '4': 1, '5': 8, '10': 'allowShares'},
    {'1': 'allow_downloads', '3': 4, '4': 1, '5': 8, '10': 'allowDownloads'},
    {'1': 'show_stats', '3': 5, '4': 1, '5': 8, '10': 'showStats'},
    {
      '1': 'allowed_countries',
      '3': 6,
      '4': 3,
      '5': 9,
      '10': 'allowedCountries'
    },
    {'1': 'expiry_date', '3': 7, '4': 1, '5': 4, '10': 'expiryDate'},
  ],
};

/// Descriptor for `PostSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postSettingsDescriptor = $convert.base64Decode(
    'CgxQb3N0U2V0dGluZ3MSOQoKdmlzaWJpbGl0eRgBIAEoDjIZLmJlbmNobWFyay5Qb3N0VmlzaW'
    'JpbGl0eVIKdmlzaWJpbGl0eRIlCg5hbGxvd19jb21tZW50cxgCIAEoCFINYWxsb3dDb21tZW50'
    'cxIhCgxhbGxvd19zaGFyZXMYAyABKAhSC2FsbG93U2hhcmVzEicKD2FsbG93X2Rvd25sb2Fkcx'
    'gEIAEoCFIOYWxsb3dEb3dubG9hZHMSHQoKc2hvd19zdGF0cxgFIAEoCFIJc2hvd1N0YXRzEisK'
    'EWFsbG93ZWRfY291bnRyaWVzGAYgAygJUhBhbGxvd2VkQ291bnRyaWVzEh8KC2V4cGlyeV9kYX'
    'RlGAcgASgEUgpleHBpcnlEYXRl');

@$core.Deprecated('Use commentDescriptor instead')
const Comment$json = {
  '1': 'Comment',
  '2': [
    {'1': 'comment_id', '3': 1, '4': 1, '5': 4, '10': 'commentId'},
    {'1': 'post_id', '3': 2, '4': 1, '5': 4, '10': 'postId'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    {'1': 'user_avatar_url', '3': 5, '4': 1, '5': 9, '10': 'userAvatarUrl'},
    {'1': 'parent_comment_id', '3': 6, '4': 1, '5': 4, '10': 'parentCommentId'},
    {'1': 'content', '3': 7, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'media',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.benchmark.MediaAttachment',
      '10': 'media'
    },
    {'1': 'created_at', '3': 9, '4': 1, '5': 4, '10': 'createdAt'},
    {'1': 'updated_at', '3': 10, '4': 1, '5': 4, '10': 'updatedAt'},
    {
      '1': 'stats',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.benchmark.CommentStats',
      '10': 'stats'
    },
    {
      '1': 'reactions',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Reaction',
      '10': 'reactions'
    },
    {'1': 'is_edited', '3': 13, '4': 1, '5': 8, '10': 'isEdited'},
    {'1': 'is_pinned', '3': 14, '4': 1, '5': 8, '10': 'isPinned'},
    {
      '1': 'replies',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Comment',
      '10': 'replies'
    },
  ],
};

/// Descriptor for `Comment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentDescriptor = $convert.base64Decode(
    'CgdDb21tZW50Eh0KCmNvbW1lbnRfaWQYASABKARSCWNvbW1lbnRJZBIXCgdwb3N0X2lkGAIgAS'
    'gEUgZwb3N0SWQSFwoHdXNlcl9pZBgDIAEoBFIGdXNlcklkEhoKCHVzZXJuYW1lGAQgASgJUgh1'
    'c2VybmFtZRImCg91c2VyX2F2YXRhcl91cmwYBSABKAlSDXVzZXJBdmF0YXJVcmwSKgoRcGFyZW'
    '50X2NvbW1lbnRfaWQYBiABKARSD3BhcmVudENvbW1lbnRJZBIYCgdjb250ZW50GAcgASgJUgdj'
    'b250ZW50EjAKBW1lZGlhGAggAygLMhouYmVuY2htYXJrLk1lZGlhQXR0YWNobWVudFIFbWVkaW'
    'ESHQoKY3JlYXRlZF9hdBgJIAEoBFIJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYCiABKARSCXVw'
    'ZGF0ZWRBdBItCgVzdGF0cxgLIAEoCzIXLmJlbmNobWFyay5Db21tZW50U3RhdHNSBXN0YXRzEj'
    'EKCXJlYWN0aW9ucxgMIAMoCzITLmJlbmNobWFyay5SZWFjdGlvblIJcmVhY3Rpb25zEhsKCWlz'
    'X2VkaXRlZBgNIAEoCFIIaXNFZGl0ZWQSGwoJaXNfcGlubmVkGA4gASgIUghpc1Bpbm5lZBIsCg'
    'dyZXBsaWVzGA8gAygLMhIuYmVuY2htYXJrLkNvbW1lbnRSB3JlcGxpZXM=');

@$core.Deprecated('Use commentStatsDescriptor instead')
const CommentStats$json = {
  '1': 'CommentStats',
  '2': [
    {'1': 'like_count', '3': 1, '4': 1, '5': 4, '10': 'likeCount'},
    {'1': 'reply_count', '3': 2, '4': 1, '5': 4, '10': 'replyCount'},
  ],
};

/// Descriptor for `CommentStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentStatsDescriptor = $convert.base64Decode(
    'CgxDb21tZW50U3RhdHMSHQoKbGlrZV9jb3VudBgBIAEoBFIJbGlrZUNvdW50Eh8KC3JlcGx5X2'
    'NvdW50GAIgASgEUgpyZXBseUNvdW50');

@$core.Deprecated('Use reactionDescriptor instead')
const Reaction$json = {
  '1': 'Reaction',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.benchmark.ReactionType',
      '10': 'type'
    },
    {'1': 'created_at', '3': 3, '4': 1, '5': 4, '10': 'createdAt'},
  ],
};

/// Descriptor for `Reaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactionDescriptor = $convert.base64Decode(
    'CghSZWFjdGlvbhIXCgd1c2VyX2lkGAEgASgEUgZ1c2VySWQSKwoEdHlwZRgCIAEoDjIXLmJlbm'
    'NobWFyay5SZWFjdGlvblR5cGVSBHR5cGUSHQoKY3JlYXRlZF9hdBgDIAEoBFIJY3JlYXRlZEF0');

@$core.Deprecated('Use translationDescriptor instead')
const Translation$json = {
  '1': 'Translation',
  '2': [
    {'1': 'language_code', '3': 1, '4': 1, '5': 9, '10': 'languageCode'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'is_auto_translated',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'isAutoTranslated'
    },
  ],
};

/// Descriptor for `Translation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translationDescriptor = $convert.base64Decode(
    'CgtUcmFuc2xhdGlvbhIjCg1sYW5ndWFnZV9jb2RlGAEgASgJUgxsYW5ndWFnZUNvZGUSFAoFdG'
    'l0bGUYAiABKAlSBXRpdGxlEhgKB2NvbnRlbnQYAyABKAlSB2NvbnRlbnQSLAoSaXNfYXV0b190'
    'cmFuc2xhdGVkGAQgASgIUhBpc0F1dG9UcmFuc2xhdGVk');

@$core.Deprecated('Use linkDescriptor instead')
const Link$json = {
  '1': 'Link',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'image_url', '3': 4, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'domain', '3': 5, '4': 1, '5': 9, '10': 'domain'},
  ],
};

/// Descriptor for `Link`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkDescriptor = $convert.base64Decode(
    'CgRMaW5rEhAKA3VybBgBIAEoCVIDdXJsEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIgCgtkZXNjcm'
    'lwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SGwoJaW1hZ2VfdXJsGAQgASgJUghpbWFnZVVybBIW'
    'CgZkb21haW4YBSABKAlSBmRvbWFpbg==');

@$core.Deprecated('Use pollDescriptor instead')
const Poll$json = {
  '1': 'Poll',
  '2': [
    {'1': 'poll_id', '3': 1, '4': 1, '5': 9, '10': 'pollId'},
    {'1': 'question', '3': 2, '4': 1, '5': 9, '10': 'question'},
    {
      '1': 'options',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.benchmark.PollOption',
      '10': 'options'
    },
    {'1': 'total_votes', '3': 4, '4': 1, '5': 4, '10': 'totalVotes'},
    {'1': 'end_date', '3': 5, '4': 1, '5': 4, '10': 'endDate'},
    {'1': 'multiple_choice', '3': 6, '4': 1, '5': 8, '10': 'multipleChoice'},
  ],
};

/// Descriptor for `Poll`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pollDescriptor = $convert.base64Decode(
    'CgRQb2xsEhcKB3BvbGxfaWQYASABKAlSBnBvbGxJZBIaCghxdWVzdGlvbhgCIAEoCVIIcXVlc3'
    'Rpb24SLwoHb3B0aW9ucxgDIAMoCzIVLmJlbmNobWFyay5Qb2xsT3B0aW9uUgdvcHRpb25zEh8K'
    'C3RvdGFsX3ZvdGVzGAQgASgEUgp0b3RhbFZvdGVzEhkKCGVuZF9kYXRlGAUgASgEUgdlbmREYX'
    'RlEicKD211bHRpcGxlX2Nob2ljZRgGIAEoCFIObXVsdGlwbGVDaG9pY2U=');

@$core.Deprecated('Use pollOptionDescriptor instead')
const PollOption$json = {
  '1': 'PollOption',
  '2': [
    {'1': 'option_id', '3': 1, '4': 1, '5': 9, '10': 'optionId'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'vote_count', '3': 3, '4': 1, '5': 4, '10': 'voteCount'},
    {'1': 'percentage', '3': 4, '4': 1, '5': 1, '10': 'percentage'},
  ],
};

/// Descriptor for `PollOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pollOptionDescriptor = $convert.base64Decode(
    'CgpQb2xsT3B0aW9uEhsKCW9wdGlvbl9pZBgBIAEoCVIIb3B0aW9uSWQSEgoEdGV4dBgCIAEoCV'
    'IEdGV4dBIdCgp2b3RlX2NvdW50GAMgASgEUgl2b3RlQ291bnQSHgoKcGVyY2VudGFnZRgEIAEo'
    'AVIKcGVyY2VudGFnZQ==');

@$core.Deprecated('Use tagDescriptor instead')
const Tag$json = {
  '1': 'Tag',
  '2': [
    {'1': 'tag_id', '3': 1, '4': 1, '5': 9, '10': 'tagId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'color', '3': 3, '4': 1, '5': 9, '10': 'color'},
  ],
};

/// Descriptor for `Tag`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tagDescriptor = $convert.base64Decode(
    'CgNUYWcSFQoGdGFnX2lkGAEgASgJUgV0YWdJZBISCgRuYW1lGAIgASgJUgRuYW1lEhQKBWNvbG'
    '9yGAMgASgJUgVjb2xvcg==');

@$core.Deprecated('Use productDescriptor instead')
const Product$json = {
  '1': 'Product',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 4, '10': 'productId'},
    {'1': 'sku', '3': 2, '4': 1, '5': 9, '10': 'sku'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'short_description',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'shortDescription'
    },
    {'1': 'category_ids', '3': 6, '4': 3, '5': 9, '10': 'categoryIds'},
    {'1': 'brand', '3': 7, '4': 1, '5': 9, '10': 'brand'},
    {'1': 'price', '3': 8, '4': 1, '5': 1, '10': 'price'},
    {'1': 'compare_at_price', '3': 9, '4': 1, '5': 1, '10': 'compareAtPrice'},
    {'1': 'cost', '3': 10, '4': 1, '5': 1, '10': 'cost'},
    {'1': 'currency', '3': 11, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'variants',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.benchmark.ProductVariant',
      '10': 'variants'
    },
    {
      '1': 'images',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.benchmark.MediaAttachment',
      '10': 'images'
    },
    {
      '1': 'videos',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.benchmark.MediaAttachment',
      '10': 'videos'
    },
    {
      '1': 'inventory',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.benchmark.ProductInventory',
      '10': 'inventory'
    },
    {
      '1': 'attributes',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.benchmark.ProductAttribute',
      '10': 'attributes'
    },
    {
      '1': 'reviews',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.benchmark.ProductReview',
      '10': 'reviews'
    },
    {
      '1': 'stats',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.benchmark.ProductStats',
      '10': 'stats'
    },
    {'1': 'tags', '3': 19, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'created_at', '3': 20, '4': 1, '5': 4, '10': 'createdAt'},
    {'1': 'updated_at', '3': 21, '4': 1, '5': 4, '10': 'updatedAt'},
    {
      '1': 'status',
      '3': 22,
      '4': 1,
      '5': 14,
      '6': '.benchmark.ProductStatus',
      '10': 'status'
    },
    {'1': 'is_featured', '3': 23, '4': 1, '5': 8, '10': 'isFeatured'},
    {'1': 'is_new', '3': 24, '4': 1, '5': 8, '10': 'isNew'},
    {'1': 'is_on_sale', '3': 25, '4': 1, '5': 8, '10': 'isOnSale'},
    {
      '1': 'related_products',
      '3': 26,
      '4': 3,
      '5': 11,
      '6': '.benchmark.RelatedProduct',
      '10': 'relatedProducts'
    },
    {
      '1': 'shipping',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.benchmark.ShippingInfo',
      '10': 'shipping'
    },
    {
      '1': 'compatible_products',
      '3': 28,
      '4': 3,
      '5': 9,
      '10': 'compatibleProducts'
    },
    {
      '1': 'metadata',
      '3': 29,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Product.MetadataEntry',
      '10': 'metadata'
    },
    {
      '1': 'seo',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.benchmark.SEOInfo',
      '10': 'seo'
    },
  ],
  '3': [Product_MetadataEntry$json],
};

@$core.Deprecated('Use productDescriptor instead')
const Product_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Product`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productDescriptor = $convert.base64Decode(
    'CgdQcm9kdWN0Eh0KCnByb2R1Y3RfaWQYASABKARSCXByb2R1Y3RJZBIQCgNza3UYAiABKAlSA3'
    'NrdRISCgRuYW1lGAMgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlv'
    'bhIrChFzaG9ydF9kZXNjcmlwdGlvbhgFIAEoCVIQc2hvcnREZXNjcmlwdGlvbhIhCgxjYXRlZ2'
    '9yeV9pZHMYBiADKAlSC2NhdGVnb3J5SWRzEhQKBWJyYW5kGAcgASgJUgVicmFuZBIUCgVwcmlj'
    'ZRgIIAEoAVIFcHJpY2USKAoQY29tcGFyZV9hdF9wcmljZRgJIAEoAVIOY29tcGFyZUF0UHJpY2'
    'USEgoEY29zdBgKIAEoAVIEY29zdBIaCghjdXJyZW5jeRgLIAEoCVIIY3VycmVuY3kSNQoIdmFy'
    'aWFudHMYDCADKAsyGS5iZW5jaG1hcmsuUHJvZHVjdFZhcmlhbnRSCHZhcmlhbnRzEjIKBmltYW'
    'dlcxgNIAMoCzIaLmJlbmNobWFyay5NZWRpYUF0dGFjaG1lbnRSBmltYWdlcxIyCgZ2aWRlb3MY'
    'DiADKAsyGi5iZW5jaG1hcmsuTWVkaWFBdHRhY2htZW50UgZ2aWRlb3MSOQoJaW52ZW50b3J5GA'
    '8gASgLMhsuYmVuY2htYXJrLlByb2R1Y3RJbnZlbnRvcnlSCWludmVudG9yeRI7CgphdHRyaWJ1'
    'dGVzGBAgAygLMhsuYmVuY2htYXJrLlByb2R1Y3RBdHRyaWJ1dGVSCmF0dHJpYnV0ZXMSMgoHcm'
    'V2aWV3cxgRIAMoCzIYLmJlbmNobWFyay5Qcm9kdWN0UmV2aWV3UgdyZXZpZXdzEi0KBXN0YXRz'
    'GBIgASgLMhcuYmVuY2htYXJrLlByb2R1Y3RTdGF0c1IFc3RhdHMSEgoEdGFncxgTIAMoCVIEdG'
    'FncxIdCgpjcmVhdGVkX2F0GBQgASgEUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgVIAEoBFIJ'
    'dXBkYXRlZEF0EjAKBnN0YXR1cxgWIAEoDjIYLmJlbmNobWFyay5Qcm9kdWN0U3RhdHVzUgZzdG'
    'F0dXMSHwoLaXNfZmVhdHVyZWQYFyABKAhSCmlzRmVhdHVyZWQSFQoGaXNfbmV3GBggASgIUgVp'
    'c05ldxIcCgppc19vbl9zYWxlGBkgASgIUghpc09uU2FsZRJEChByZWxhdGVkX3Byb2R1Y3RzGB'
    'ogAygLMhkuYmVuY2htYXJrLlJlbGF0ZWRQcm9kdWN0Ug9yZWxhdGVkUHJvZHVjdHMSMwoIc2hp'
    'cHBpbmcYGyABKAsyFy5iZW5jaG1hcmsuU2hpcHBpbmdJbmZvUghzaGlwcGluZxIvChNjb21wYX'
    'RpYmxlX3Byb2R1Y3RzGBwgAygJUhJjb21wYXRpYmxlUHJvZHVjdHMSPAoIbWV0YWRhdGEYHSAD'
    'KAsyIC5iZW5jaG1hcmsuUHJvZHVjdC5NZXRhZGF0YUVudHJ5UghtZXRhZGF0YRIkCgNzZW8YHi'
    'ABKAsyEi5iZW5jaG1hcmsuU0VPSW5mb1IDc2VvGjsKDU1ldGFkYXRhRW50cnkSEAoDa2V5GAEg'
    'ASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use productVariantDescriptor instead')
const ProductVariant$json = {
  '1': 'ProductVariant',
  '2': [
    {'1': 'variant_id', '3': 1, '4': 1, '5': 9, '10': 'variantId'},
    {'1': 'sku', '3': 2, '4': 1, '5': 9, '10': 'sku'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 4, '4': 1, '5': 1, '10': 'price'},
    {
      '1': 'options',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.benchmark.VariantOption',
      '10': 'options'
    },
    {'1': 'image_url', '3': 6, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'stock_quantity', '3': 7, '4': 1, '5': 5, '10': 'stockQuantity'},
    {'1': 'weight', '3': 8, '4': 1, '5': 1, '10': 'weight'},
    {
      '1': 'dimensions',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.benchmark.Dimensions',
      '10': 'dimensions'
    },
    {'1': 'barcode', '3': 10, '4': 1, '5': 9, '10': 'barcode'},
  ],
};

/// Descriptor for `ProductVariant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productVariantDescriptor = $convert.base64Decode(
    'Cg5Qcm9kdWN0VmFyaWFudBIdCgp2YXJpYW50X2lkGAEgASgJUgl2YXJpYW50SWQSEAoDc2t1GA'
    'IgASgJUgNza3USEgoEbmFtZRgDIAEoCVIEbmFtZRIUCgVwcmljZRgEIAEoAVIFcHJpY2USMgoH'
    'b3B0aW9ucxgFIAMoCzIYLmJlbmNobWFyay5WYXJpYW50T3B0aW9uUgdvcHRpb25zEhsKCWltYW'
    'dlX3VybBgGIAEoCVIIaW1hZ2VVcmwSJQoOc3RvY2tfcXVhbnRpdHkYByABKAVSDXN0b2NrUXVh'
    'bnRpdHkSFgoGd2VpZ2h0GAggASgBUgZ3ZWlnaHQSNQoKZGltZW5zaW9ucxgJIAEoCzIVLmJlbm'
    'NobWFyay5EaW1lbnNpb25zUgpkaW1lbnNpb25zEhgKB2JhcmNvZGUYCiABKAlSB2JhcmNvZGU=');

@$core.Deprecated('Use variantOptionDescriptor instead')
const VariantOption$json = {
  '1': 'VariantOption',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `VariantOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List variantOptionDescriptor = $convert.base64Decode(
    'Cg1WYXJpYW50T3B0aW9uEhIKBG5hbWUYASABKAlSBG5hbWUSFAoFdmFsdWUYAiABKAlSBXZhbH'
    'Vl');

@$core.Deprecated('Use productInventoryDescriptor instead')
const ProductInventory$json = {
  '1': 'ProductInventory',
  '2': [
    {'1': 'stock_quantity', '3': 1, '4': 1, '5': 5, '10': 'stockQuantity'},
    {
      '1': 'reserved_quantity',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'reservedQuantity'
    },
    {
      '1': 'available_quantity',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'availableQuantity'
    },
    {'1': 'track_inventory', '3': 4, '4': 1, '5': 8, '10': 'trackInventory'},
    {'1': 'allow_backorder', '3': 5, '4': 1, '5': 8, '10': 'allowBackorder'},
    {
      '1': 'low_stock_threshold',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'lowStockThreshold'
    },
    {
      '1': 'warehouse_stocks',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.benchmark.WarehouseStock',
      '10': 'warehouseStocks'
    },
  ],
};

/// Descriptor for `ProductInventory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productInventoryDescriptor = $convert.base64Decode(
    'ChBQcm9kdWN0SW52ZW50b3J5EiUKDnN0b2NrX3F1YW50aXR5GAEgASgFUg1zdG9ja1F1YW50aX'
    'R5EisKEXJlc2VydmVkX3F1YW50aXR5GAIgASgFUhByZXNlcnZlZFF1YW50aXR5Ei0KEmF2YWls'
    'YWJsZV9xdWFudGl0eRgDIAEoBVIRYXZhaWxhYmxlUXVhbnRpdHkSJwoPdHJhY2tfaW52ZW50b3'
    'J5GAQgASgIUg50cmFja0ludmVudG9yeRInCg9hbGxvd19iYWNrb3JkZXIYBSABKAhSDmFsbG93'
    'QmFja29yZGVyEi4KE2xvd19zdG9ja190aHJlc2hvbGQYBiABKAVSEWxvd1N0b2NrVGhyZXNob2'
    'xkEkQKEHdhcmVob3VzZV9zdG9ja3MYByADKAsyGS5iZW5jaG1hcmsuV2FyZWhvdXNlU3RvY2tS'
    'D3dhcmVob3VzZVN0b2Nrcw==');

@$core.Deprecated('Use warehouseStockDescriptor instead')
const WarehouseStock$json = {
  '1': 'WarehouseStock',
  '2': [
    {'1': 'warehouse_id', '3': 1, '4': 1, '5': 9, '10': 'warehouseId'},
    {'1': 'warehouse_name', '3': 2, '4': 1, '5': 9, '10': 'warehouseName'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'location', '3': 4, '4': 1, '5': 9, '10': 'location'},
  ],
};

/// Descriptor for `WarehouseStock`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List warehouseStockDescriptor = $convert.base64Decode(
    'Cg5XYXJlaG91c2VTdG9jaxIhCgx3YXJlaG91c2VfaWQYASABKAlSC3dhcmVob3VzZUlkEiUKDn'
    'dhcmVob3VzZV9uYW1lGAIgASgJUg13YXJlaG91c2VOYW1lEhoKCHF1YW50aXR5GAMgASgFUghx'
    'dWFudGl0eRIaCghsb2NhdGlvbhgEIAEoCVIIbG9jYXRpb24=');

@$core.Deprecated('Use productAttributeDescriptor instead')
const ProductAttribute$json = {
  '1': 'ProductAttribute',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'values', '3': 2, '4': 3, '5': 9, '10': 'values'},
    {
      '1': 'is_variant_attribute',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'isVariantAttribute'
    },
  ],
};

/// Descriptor for `ProductAttribute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productAttributeDescriptor = $convert.base64Decode(
    'ChBQcm9kdWN0QXR0cmlidXRlEhIKBG5hbWUYASABKAlSBG5hbWUSFgoGdmFsdWVzGAIgAygJUg'
    'Z2YWx1ZXMSMAoUaXNfdmFyaWFudF9hdHRyaWJ1dGUYAyABKAhSEmlzVmFyaWFudEF0dHJpYnV0'
    'ZQ==');

@$core.Deprecated('Use productReviewDescriptor instead')
const ProductReview$json = {
  '1': 'ProductReview',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 4, '10': 'reviewId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'user_avatar_url', '3': 4, '4': 1, '5': 9, '10': 'userAvatarUrl'},
    {'1': 'rating', '3': 5, '4': 1, '5': 13, '10': 'rating'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'content', '3': 7, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'images',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.benchmark.MediaAttachment',
      '10': 'images'
    },
    {'1': 'created_at', '3': 9, '4': 1, '5': 4, '10': 'createdAt'},
    {
      '1': 'stats',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.benchmark.ReviewStats',
      '10': 'stats'
    },
    {
      '1': 'verified_purchase',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'verifiedPurchase'
    },
    {'1': 'variant_id', '3': 12, '4': 1, '5': 9, '10': 'variantId'},
  ],
};

/// Descriptor for `ProductReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productReviewDescriptor = $convert.base64Decode(
    'Cg1Qcm9kdWN0UmV2aWV3EhsKCXJldmlld19pZBgBIAEoBFIIcmV2aWV3SWQSFwoHdXNlcl9pZB'
    'gCIAEoBFIGdXNlcklkEhoKCHVzZXJuYW1lGAMgASgJUgh1c2VybmFtZRImCg91c2VyX2F2YXRh'
    'cl91cmwYBCABKAlSDXVzZXJBdmF0YXJVcmwSFgoGcmF0aW5nGAUgASgNUgZyYXRpbmcSFAoFdG'
    'l0bGUYBiABKAlSBXRpdGxlEhgKB2NvbnRlbnQYByABKAlSB2NvbnRlbnQSMgoGaW1hZ2VzGAgg'
    'AygLMhouYmVuY2htYXJrLk1lZGlhQXR0YWNobWVudFIGaW1hZ2VzEh0KCmNyZWF0ZWRfYXQYCS'
    'ABKARSCWNyZWF0ZWRBdBIsCgVzdGF0cxgKIAEoCzIWLmJlbmNobWFyay5SZXZpZXdTdGF0c1IF'
    'c3RhdHMSKwoRdmVyaWZpZWRfcHVyY2hhc2UYCyABKAhSEHZlcmlmaWVkUHVyY2hhc2USHQoKdm'
    'FyaWFudF9pZBgMIAEoCVIJdmFyaWFudElk');

@$core.Deprecated('Use reviewStatsDescriptor instead')
const ReviewStats$json = {
  '1': 'ReviewStats',
  '2': [
    {'1': 'helpful_count', '3': 1, '4': 1, '5': 4, '10': 'helpfulCount'},
    {'1': 'not_helpful_count', '3': 2, '4': 1, '5': 4, '10': 'notHelpfulCount'},
  ],
};

/// Descriptor for `ReviewStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewStatsDescriptor = $convert.base64Decode(
    'CgtSZXZpZXdTdGF0cxIjCg1oZWxwZnVsX2NvdW50GAEgASgEUgxoZWxwZnVsQ291bnQSKgoRbm'
    '90X2hlbHBmdWxfY291bnQYAiABKARSD25vdEhlbHBmdWxDb3VudA==');

@$core.Deprecated('Use productStatsDescriptor instead')
const ProductStats$json = {
  '1': 'ProductStats',
  '2': [
    {'1': 'view_count', '3': 1, '4': 1, '5': 4, '10': 'viewCount'},
    {'1': 'cart_add_count', '3': 2, '4': 1, '5': 4, '10': 'cartAddCount'},
    {'1': 'purchase_count', '3': 3, '4': 1, '5': 4, '10': 'purchaseCount'},
    {'1': 'wishlist_count', '3': 4, '4': 1, '5': 4, '10': 'wishlistCount'},
    {'1': 'average_rating', '3': 5, '4': 1, '5': 1, '10': 'averageRating'},
    {'1': 'review_count', '3': 6, '4': 1, '5': 4, '10': 'reviewCount'},
    {'1': 'share_count', '3': 7, '4': 1, '5': 4, '10': 'shareCount'},
  ],
};

/// Descriptor for `ProductStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productStatsDescriptor = $convert.base64Decode(
    'CgxQcm9kdWN0U3RhdHMSHQoKdmlld19jb3VudBgBIAEoBFIJdmlld0NvdW50EiQKDmNhcnRfYW'
    'RkX2NvdW50GAIgASgEUgxjYXJ0QWRkQ291bnQSJQoOcHVyY2hhc2VfY291bnQYAyABKARSDXB1'
    'cmNoYXNlQ291bnQSJQoOd2lzaGxpc3RfY291bnQYBCABKARSDXdpc2hsaXN0Q291bnQSJQoOYX'
    'ZlcmFnZV9yYXRpbmcYBSABKAFSDWF2ZXJhZ2VSYXRpbmcSIQoMcmV2aWV3X2NvdW50GAYgASgE'
    'UgtyZXZpZXdDb3VudBIfCgtzaGFyZV9jb3VudBgHIAEoBFIKc2hhcmVDb3VudA==');

@$core.Deprecated('Use relatedProductDescriptor instead')
const RelatedProduct$json = {
  '1': 'RelatedProduct',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 4, '10': 'productId'},
    {'1': 'relation_type', '3': 2, '4': 1, '5': 9, '10': 'relationType'},
  ],
};

/// Descriptor for `RelatedProduct`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relatedProductDescriptor = $convert.base64Decode(
    'Cg5SZWxhdGVkUHJvZHVjdBIdCgpwcm9kdWN0X2lkGAEgASgEUglwcm9kdWN0SWQSIwoNcmVsYX'
    'Rpb25fdHlwZRgCIAEoCVIMcmVsYXRpb25UeXBl');

@$core.Deprecated('Use shippingInfoDescriptor instead')
const ShippingInfo$json = {
  '1': 'ShippingInfo',
  '2': [
    {'1': 'free_shipping', '3': 1, '4': 1, '5': 8, '10': 'freeShipping'},
    {'1': 'weight', '3': 2, '4': 1, '5': 1, '10': 'weight'},
    {
      '1': 'dimensions',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.benchmark.Dimensions',
      '10': 'dimensions'
    },
    {
      '1': 'available_methods',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.benchmark.ShippingMethod',
      '10': 'availableMethods'
    },
    {'1': 'shipping_class', '3': 5, '4': 1, '5': 9, '10': 'shippingClass'},
  ],
};

/// Descriptor for `ShippingInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shippingInfoDescriptor = $convert.base64Decode(
    'CgxTaGlwcGluZ0luZm8SIwoNZnJlZV9zaGlwcGluZxgBIAEoCFIMZnJlZVNoaXBwaW5nEhYKBn'
    'dlaWdodBgCIAEoAVIGd2VpZ2h0EjUKCmRpbWVuc2lvbnMYAyABKAsyFS5iZW5jaG1hcmsuRGlt'
    'ZW5zaW9uc1IKZGltZW5zaW9ucxJGChFhdmFpbGFibGVfbWV0aG9kcxgEIAMoCzIZLmJlbmNobW'
    'Fyay5TaGlwcGluZ01ldGhvZFIQYXZhaWxhYmxlTWV0aG9kcxIlCg5zaGlwcGluZ19jbGFzcxgF'
    'IAEoCVINc2hpcHBpbmdDbGFzcw==');

@$core.Deprecated('Use shippingMethodDescriptor instead')
const ShippingMethod$json = {
  '1': 'ShippingMethod',
  '2': [
    {'1': 'method_id', '3': 1, '4': 1, '5': 9, '10': 'methodId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'cost', '3': 3, '4': 1, '5': 1, '10': 'cost'},
    {'1': 'estimated_days', '3': 4, '4': 1, '5': 13, '10': 'estimatedDays'},
  ],
};

/// Descriptor for `ShippingMethod`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shippingMethodDescriptor = $convert.base64Decode(
    'Cg5TaGlwcGluZ01ldGhvZBIbCgltZXRob2RfaWQYASABKAlSCG1ldGhvZElkEhIKBG5hbWUYAi'
    'ABKAlSBG5hbWUSEgoEY29zdBgDIAEoAVIEY29zdBIlCg5lc3RpbWF0ZWRfZGF5cxgEIAEoDVIN'
    'ZXN0aW1hdGVkRGF5cw==');

@$core.Deprecated('Use dimensionsDescriptor instead')
const Dimensions$json = {
  '1': 'Dimensions',
  '2': [
    {'1': 'length', '3': 1, '4': 1, '5': 1, '10': 'length'},
    {'1': 'width', '3': 2, '4': 1, '5': 1, '10': 'width'},
    {'1': 'height', '3': 3, '4': 1, '5': 1, '10': 'height'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
  ],
};

/// Descriptor for `Dimensions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dimensionsDescriptor = $convert.base64Decode(
    'CgpEaW1lbnNpb25zEhYKBmxlbmd0aBgBIAEoAVIGbGVuZ3RoEhQKBXdpZHRoGAIgASgBUgV3aW'
    'R0aBIWCgZoZWlnaHQYAyABKAFSBmhlaWdodBISCgR1bml0GAQgASgJUgR1bml0');

@$core.Deprecated('Use sEOInfoDescriptor instead')
const SEOInfo$json = {
  '1': 'SEOInfo',
  '2': [
    {'1': 'meta_title', '3': 1, '4': 1, '5': 9, '10': 'metaTitle'},
    {'1': 'meta_description', '3': 2, '4': 1, '5': 9, '10': 'metaDescription'},
    {'1': 'meta_keywords', '3': 3, '4': 3, '5': 9, '10': 'metaKeywords'},
    {'1': 'canonical_url', '3': 4, '4': 1, '5': 9, '10': 'canonicalUrl'},
    {
      '1': 'og_tags',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.benchmark.SEOInfo.OgTagsEntry',
      '10': 'ogTags'
    },
  ],
  '3': [SEOInfo_OgTagsEntry$json],
};

@$core.Deprecated('Use sEOInfoDescriptor instead')
const SEOInfo_OgTagsEntry$json = {
  '1': 'OgTagsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SEOInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sEOInfoDescriptor = $convert.base64Decode(
    'CgdTRU9JbmZvEh0KCm1ldGFfdGl0bGUYASABKAlSCW1ldGFUaXRsZRIpChBtZXRhX2Rlc2NyaX'
    'B0aW9uGAIgASgJUg9tZXRhRGVzY3JpcHRpb24SIwoNbWV0YV9rZXl3b3JkcxgDIAMoCVIMbWV0'
    'YUtleXdvcmRzEiMKDWNhbm9uaWNhbF91cmwYBCABKAlSDGNhbm9uaWNhbFVybBI3CgdvZ190YW'
    'dzGAUgAygLMh4uYmVuY2htYXJrLlNFT0luZm8uT2dUYWdzRW50cnlSBm9nVGFncxo5CgtPZ1Rh'
    'Z3NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use orderDescriptor instead')
const Order$json = {
  '1': 'Order',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 4, '10': 'orderId'},
    {'1': 'order_number', '3': 2, '4': 1, '5': 9, '10': 'orderNumber'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 4, '10': 'userId'},
    {
      '1': 'items',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.benchmark.OrderItem',
      '10': 'items'
    },
    {'1': 'subtotal', '3': 5, '4': 1, '5': 1, '10': 'subtotal'},
    {'1': 'tax', '3': 6, '4': 1, '5': 1, '10': 'tax'},
    {'1': 'shipping_cost', '3': 7, '4': 1, '5': 1, '10': 'shippingCost'},
    {'1': 'discount', '3': 8, '4': 1, '5': 1, '10': 'discount'},
    {'1': 'total', '3': 9, '4': 1, '5': 1, '10': 'total'},
    {'1': 'currency', '3': 10, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'status',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.benchmark.OrderStatus',
      '10': 'status'
    },
    {
      '1': 'payment',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.benchmark.PaymentInfo',
      '10': 'payment'
    },
    {
      '1': 'shipping_address',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.benchmark.Address',
      '10': 'shippingAddress'
    },
    {
      '1': 'billing_address',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.benchmark.Address',
      '10': 'billingAddress'
    },
    {
      '1': 'status_history',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.benchmark.OrderStatusHistory',
      '10': 'statusHistory'
    },
    {'1': 'tracking_number', '3': 16, '4': 1, '5': 9, '10': 'trackingNumber'},
    {'1': 'carrier', '3': 17, '4': 1, '5': 9, '10': 'carrier'},
    {'1': 'created_at', '3': 18, '4': 1, '5': 4, '10': 'createdAt'},
    {'1': 'updated_at', '3': 19, '4': 1, '5': 4, '10': 'updatedAt'},
    {'1': 'shipped_at', '3': 20, '4': 1, '5': 4, '10': 'shippedAt'},
    {'1': 'delivered_at', '3': 21, '4': 1, '5': 4, '10': 'deliveredAt'},
    {'1': 'customer_notes', '3': 22, '4': 1, '5': 9, '10': 'customerNotes'},
    {'1': 'internal_notes', '3': 23, '4': 1, '5': 9, '10': 'internalNotes'},
    {
      '1': 'applied_coupons',
      '3': 24,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Coupon',
      '10': 'appliedCoupons'
    },
    {
      '1': 'shipping_method',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.benchmark.ShippingMethod',
      '10': 'shippingMethod'
    },
    {
      '1': 'metadata',
      '3': 26,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Order.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [Order_MetadataEntry$json],
};

@$core.Deprecated('Use orderDescriptor instead')
const Order_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode(
    'CgVPcmRlchIZCghvcmRlcl9pZBgBIAEoBFIHb3JkZXJJZBIhCgxvcmRlcl9udW1iZXIYAiABKA'
    'lSC29yZGVyTnVtYmVyEhcKB3VzZXJfaWQYAyABKARSBnVzZXJJZBIqCgVpdGVtcxgEIAMoCzIU'
    'LmJlbmNobWFyay5PcmRlckl0ZW1SBWl0ZW1zEhoKCHN1YnRvdGFsGAUgASgBUghzdWJ0b3RhbB'
    'IQCgN0YXgYBiABKAFSA3RheBIjCg1zaGlwcGluZ19jb3N0GAcgASgBUgxzaGlwcGluZ0Nvc3QS'
    'GgoIZGlzY291bnQYCCABKAFSCGRpc2NvdW50EhQKBXRvdGFsGAkgASgBUgV0b3RhbBIaCghjdX'
    'JyZW5jeRgKIAEoCVIIY3VycmVuY3kSLgoGc3RhdHVzGAsgASgOMhYuYmVuY2htYXJrLk9yZGVy'
    'U3RhdHVzUgZzdGF0dXMSMAoHcGF5bWVudBgMIAEoCzIWLmJlbmNobWFyay5QYXltZW50SW5mb1'
    'IHcGF5bWVudBI9ChBzaGlwcGluZ19hZGRyZXNzGA0gASgLMhIuYmVuY2htYXJrLkFkZHJlc3NS'
    'D3NoaXBwaW5nQWRkcmVzcxI7Cg9iaWxsaW5nX2FkZHJlc3MYDiABKAsyEi5iZW5jaG1hcmsuQW'
    'RkcmVzc1IOYmlsbGluZ0FkZHJlc3MSRAoOc3RhdHVzX2hpc3RvcnkYDyADKAsyHS5iZW5jaG1h'
    'cmsuT3JkZXJTdGF0dXNIaXN0b3J5Ug1zdGF0dXNIaXN0b3J5EicKD3RyYWNraW5nX251bWJlch'
    'gQIAEoCVIOdHJhY2tpbmdOdW1iZXISGAoHY2FycmllchgRIAEoCVIHY2FycmllchIdCgpjcmVh'
    'dGVkX2F0GBIgASgEUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgTIAEoBFIJdXBkYXRlZEF0Eh'
    '0KCnNoaXBwZWRfYXQYFCABKARSCXNoaXBwZWRBdBIhCgxkZWxpdmVyZWRfYXQYFSABKARSC2Rl'
    'bGl2ZXJlZEF0EiUKDmN1c3RvbWVyX25vdGVzGBYgASgJUg1jdXN0b21lck5vdGVzEiUKDmludG'
    'VybmFsX25vdGVzGBcgASgJUg1pbnRlcm5hbE5vdGVzEjoKD2FwcGxpZWRfY291cG9ucxgYIAMo'
    'CzIRLmJlbmNobWFyay5Db3Vwb25SDmFwcGxpZWRDb3Vwb25zEkIKD3NoaXBwaW5nX21ldGhvZB'
    'gZIAEoCzIZLmJlbmNobWFyay5TaGlwcGluZ01ldGhvZFIOc2hpcHBpbmdNZXRob2QSOgoIbWV0'
    'YWRhdGEYGiADKAsyHi5iZW5jaG1hcmsuT3JkZXIuTWV0YWRhdGFFbnRyeVIIbWV0YWRhdGEaOw'
    'oNTWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6'
    'AjgB');

@$core.Deprecated('Use orderItemDescriptor instead')
const OrderItem$json = {
  '1': 'OrderItem',
  '2': [
    {'1': 'order_item_id', '3': 1, '4': 1, '5': 9, '10': 'orderItemId'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 4, '10': 'productId'},
    {'1': 'variant_id', '3': 3, '4': 1, '5': 9, '10': 'variantId'},
    {'1': 'product_name', '3': 4, '4': 1, '5': 9, '10': 'productName'},
    {'1': 'variant_name', '3': 5, '4': 1, '5': 9, '10': 'variantName'},
    {'1': 'sku', '3': 6, '4': 1, '5': 9, '10': 'sku'},
    {'1': 'quantity', '3': 7, '4': 1, '5': 13, '10': 'quantity'},
    {'1': 'unit_price', '3': 8, '4': 1, '5': 1, '10': 'unitPrice'},
    {'1': 'total_price', '3': 9, '4': 1, '5': 1, '10': 'totalPrice'},
    {'1': 'tax_amount', '3': 10, '4': 1, '5': 1, '10': 'taxAmount'},
    {'1': 'discount_amount', '3': 11, '4': 1, '5': 1, '10': 'discountAmount'},
    {'1': 'image_url', '3': 12, '4': 1, '5': 9, '10': 'imageUrl'},
    {
      '1': 'attributes',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.benchmark.OrderItem.AttributesEntry',
      '10': 'attributes'
    },
  ],
  '3': [OrderItem_AttributesEntry$json],
};

@$core.Deprecated('Use orderItemDescriptor instead')
const OrderItem_AttributesEntry$json = {
  '1': 'AttributesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `OrderItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderItemDescriptor = $convert.base64Decode(
    'CglPcmRlckl0ZW0SIgoNb3JkZXJfaXRlbV9pZBgBIAEoCVILb3JkZXJJdGVtSWQSHQoKcHJvZH'
    'VjdF9pZBgCIAEoBFIJcHJvZHVjdElkEh0KCnZhcmlhbnRfaWQYAyABKAlSCXZhcmlhbnRJZBIh'
    'Cgxwcm9kdWN0X25hbWUYBCABKAlSC3Byb2R1Y3ROYW1lEiEKDHZhcmlhbnRfbmFtZRgFIAEoCV'
    'ILdmFyaWFudE5hbWUSEAoDc2t1GAYgASgJUgNza3USGgoIcXVhbnRpdHkYByABKA1SCHF1YW50'
    'aXR5Eh0KCnVuaXRfcHJpY2UYCCABKAFSCXVuaXRQcmljZRIfCgt0b3RhbF9wcmljZRgJIAEoAV'
    'IKdG90YWxQcmljZRIdCgp0YXhfYW1vdW50GAogASgBUgl0YXhBbW91bnQSJwoPZGlzY291bnRf'
    'YW1vdW50GAsgASgBUg5kaXNjb3VudEFtb3VudBIbCglpbWFnZV91cmwYDCABKAlSCGltYWdlVX'
    'JsEkQKCmF0dHJpYnV0ZXMYDSADKAsyJC5iZW5jaG1hcmsuT3JkZXJJdGVtLkF0dHJpYnV0ZXNF'
    'bnRyeVIKYXR0cmlidXRlcxo9Cg9BdHRyaWJ1dGVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFA'
    'oFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use orderStatusHistoryDescriptor instead')
const OrderStatusHistory$json = {
  '1': 'OrderStatusHistory',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.benchmark.OrderStatus',
      '10': 'status'
    },
    {'1': 'timestamp', '3': 2, '4': 1, '5': 4, '10': 'timestamp'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'updated_by', '3': 4, '4': 1, '5': 9, '10': 'updatedBy'},
  ],
};

/// Descriptor for `OrderStatusHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderStatusHistoryDescriptor = $convert.base64Decode(
    'ChJPcmRlclN0YXR1c0hpc3RvcnkSLgoGc3RhdHVzGAEgASgOMhYuYmVuY2htYXJrLk9yZGVyU3'
    'RhdHVzUgZzdGF0dXMSHAoJdGltZXN0YW1wGAIgASgEUgl0aW1lc3RhbXASEgoEbm90ZRgDIAEo'
    'CVIEbm90ZRIdCgp1cGRhdGVkX2J5GAQgASgJUgl1cGRhdGVkQnk=');

@$core.Deprecated('Use paymentInfoDescriptor instead')
const PaymentInfo$json = {
  '1': 'PaymentInfo',
  '2': [
    {'1': 'payment_id', '3': 1, '4': 1, '5': 9, '10': 'paymentId'},
    {'1': 'payment_method_id', '3': 2, '4': 1, '5': 9, '10': 'paymentMethodId'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.benchmark.PaymentType',
      '10': 'type'
    },
    {'1': 'amount', '3': 4, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.benchmark.PaymentStatus',
      '10': 'status'
    },
    {'1': 'transaction_id', '3': 7, '4': 1, '5': 9, '10': 'transactionId'},
    {'1': 'provider', '3': 8, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 4, '10': 'createdAt'},
    {
      '1': 'metadata',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.benchmark.PaymentInfo.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [PaymentInfo_MetadataEntry$json],
};

@$core.Deprecated('Use paymentInfoDescriptor instead')
const PaymentInfo_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `PaymentInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentInfoDescriptor = $convert.base64Decode(
    'CgtQYXltZW50SW5mbxIdCgpwYXltZW50X2lkGAEgASgJUglwYXltZW50SWQSKgoRcGF5bWVudF'
    '9tZXRob2RfaWQYAiABKAlSD3BheW1lbnRNZXRob2RJZBIqCgR0eXBlGAMgASgOMhYuYmVuY2ht'
    'YXJrLlBheW1lbnRUeXBlUgR0eXBlEhYKBmFtb3VudBgEIAEoAVIGYW1vdW50EhoKCGN1cnJlbm'
    'N5GAUgASgJUghjdXJyZW5jeRIwCgZzdGF0dXMYBiABKA4yGC5iZW5jaG1hcmsuUGF5bWVudFN0'
    'YXR1c1IGc3RhdHVzEiUKDnRyYW5zYWN0aW9uX2lkGAcgASgJUg10cmFuc2FjdGlvbklkEhoKCH'
    'Byb3ZpZGVyGAggASgJUghwcm92aWRlchIdCgpjcmVhdGVkX2F0GAkgASgEUgljcmVhdGVkQXQS'
    'QAoIbWV0YWRhdGEYCiADKAsyJC5iZW5jaG1hcmsuUGF5bWVudEluZm8uTWV0YWRhdGFFbnRyeV'
    'IIbWV0YWRhdGEaOwoNTWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgC'
    'IAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use couponDescriptor instead')
const Coupon$json = {
  '1': 'Coupon',
  '2': [
    {'1': 'coupon_id', '3': 1, '4': 1, '5': 9, '10': 'couponId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.benchmark.CouponType',
      '10': 'type'
    },
    {'1': 'value', '3': 4, '4': 1, '5': 1, '10': 'value'},
    {'1': 'minimum_purchase', '3': 5, '4': 1, '5': 1, '10': 'minimumPurchase'},
    {'1': 'expiry_date', '3': 6, '4': 1, '5': 4, '10': 'expiryDate'},
  ],
};

/// Descriptor for `Coupon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponDescriptor = $convert.base64Decode(
    'CgZDb3Vwb24SGwoJY291cG9uX2lkGAEgASgJUghjb3Vwb25JZBISCgRjb2RlGAIgASgJUgRjb2'
    'RlEikKBHR5cGUYAyABKA4yFS5iZW5jaG1hcmsuQ291cG9uVHlwZVIEdHlwZRIUCgV2YWx1ZRgE'
    'IAEoAVIFdmFsdWUSKQoQbWluaW11bV9wdXJjaGFzZRgFIAEoAVIPbWluaW11bVB1cmNoYXNlEh'
    '8KC2V4cGlyeV9kYXRlGAYgASgEUgpleHBpcnlEYXRl');

@$core.Deprecated('Use benchmarkDataDescriptor instead')
const BenchmarkData$json = {
  '1': 'BenchmarkData',
  '2': [
    {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.benchmark.User',
      '10': 'users'
    },
    {
      '1': 'posts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Post',
      '10': 'posts'
    },
    {
      '1': 'products',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Product',
      '10': 'products'
    },
    {
      '1': 'orders',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.benchmark.Order',
      '10': 'orders'
    },
    {
      '1': 'user_index',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.benchmark.BenchmarkData.UserIndexEntry',
      '10': 'userIndex'
    },
    {
      '1': 'product_index',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.benchmark.BenchmarkData.ProductIndexEntry',
      '10': 'productIndex'
    },
    {
      '1': 'config',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.benchmark.BenchmarkData.ConfigEntry',
      '10': 'config'
    },
    {'1': 'timestamp', '3': 8, '4': 1, '5': 4, '10': 'timestamp'},
    {'1': 'version', '3': 9, '4': 1, '5': 9, '10': 'version'},
    {'1': 'raw_data', '3': 10, '4': 1, '5': 12, '10': 'rawData'},
  ],
  '3': [
    BenchmarkData_UserIndexEntry$json,
    BenchmarkData_ProductIndexEntry$json,
    BenchmarkData_ConfigEntry$json
  ],
};

@$core.Deprecated('Use benchmarkDataDescriptor instead')
const BenchmarkData_UserIndexEntry$json = {
  '1': 'UserIndexEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 4, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.benchmark.User',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use benchmarkDataDescriptor instead')
const BenchmarkData_ProductIndexEntry$json = {
  '1': 'ProductIndexEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 4, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.benchmark.Product',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use benchmarkDataDescriptor instead')
const BenchmarkData_ConfigEntry$json = {
  '1': 'ConfigEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `BenchmarkData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List benchmarkDataDescriptor = $convert.base64Decode(
    'Cg1CZW5jaG1hcmtEYXRhEiUKBXVzZXJzGAEgAygLMg8uYmVuY2htYXJrLlVzZXJSBXVzZXJzEi'
    'UKBXBvc3RzGAIgAygLMg8uYmVuY2htYXJrLlBvc3RSBXBvc3RzEi4KCHByb2R1Y3RzGAMgAygL'
    'MhIuYmVuY2htYXJrLlByb2R1Y3RSCHByb2R1Y3RzEigKBm9yZGVycxgEIAMoCzIQLmJlbmNobW'
    'Fyay5PcmRlclIGb3JkZXJzEkYKCnVzZXJfaW5kZXgYBSADKAsyJy5iZW5jaG1hcmsuQmVuY2ht'
    'YXJrRGF0YS5Vc2VySW5kZXhFbnRyeVIJdXNlckluZGV4Ek8KDXByb2R1Y3RfaW5kZXgYBiADKA'
    'syKi5iZW5jaG1hcmsuQmVuY2htYXJrRGF0YS5Qcm9kdWN0SW5kZXhFbnRyeVIMcHJvZHVjdElu'
    'ZGV4EjwKBmNvbmZpZxgHIAMoCzIkLmJlbmNobWFyay5CZW5jaG1hcmtEYXRhLkNvbmZpZ0VudH'
    'J5UgZjb25maWcSHAoJdGltZXN0YW1wGAggASgEUgl0aW1lc3RhbXASGAoHdmVyc2lvbhgJIAEo'
    'CVIHdmVyc2lvbhIZCghyYXdfZGF0YRgKIAEoDFIHcmF3RGF0YRpNCg5Vc2VySW5kZXhFbnRyeR'
    'IQCgNrZXkYASABKARSA2tleRIlCgV2YWx1ZRgCIAEoCzIPLmJlbmNobWFyay5Vc2VyUgV2YWx1'
    'ZToCOAEaUwoRUHJvZHVjdEluZGV4RW50cnkSEAoDa2V5GAEgASgEUgNrZXkSKAoFdmFsdWUYAi'
    'ABKAsyEi5iZW5jaG1hcmsuUHJvZHVjdFIFdmFsdWU6AjgBGjkKC0NvbmZpZ0VudHJ5EhAKA2tl'
    'eRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');
