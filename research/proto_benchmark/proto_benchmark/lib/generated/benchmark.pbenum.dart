// This is a generated file - do not edit.
//
// Generated from benchmark.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Enums
class Gender extends $pb.ProtobufEnum {
  static const Gender GENDER_UNSPECIFIED =
      Gender._(0, _omitEnumNames ? '' : 'GENDER_UNSPECIFIED');
  static const Gender MALE = Gender._(1, _omitEnumNames ? '' : 'MALE');
  static const Gender FEMALE = Gender._(2, _omitEnumNames ? '' : 'FEMALE');
  static const Gender OTHER = Gender._(3, _omitEnumNames ? '' : 'OTHER');
  static const Gender PREFER_NOT_TO_SAY =
      Gender._(4, _omitEnumNames ? '' : 'PREFER_NOT_TO_SAY');

  static const $core.List<Gender> values = <Gender>[
    GENDER_UNSPECIFIED,
    MALE,
    FEMALE,
    OTHER,
    PREFER_NOT_TO_SAY,
  ];

  static final $core.List<Gender?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Gender? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Gender._(super.value, super.name);
}

class AccountStatus extends $pb.ProtobufEnum {
  static const AccountStatus ACCOUNT_STATUS_UNSPECIFIED =
      AccountStatus._(0, _omitEnumNames ? '' : 'ACCOUNT_STATUS_UNSPECIFIED');
  static const AccountStatus ACTIVE =
      AccountStatus._(1, _omitEnumNames ? '' : 'ACTIVE');
  static const AccountStatus SUSPENDED =
      AccountStatus._(2, _omitEnumNames ? '' : 'SUSPENDED');
  static const AccountStatus BANNED =
      AccountStatus._(3, _omitEnumNames ? '' : 'BANNED');
  static const AccountStatus DELETED =
      AccountStatus._(4, _omitEnumNames ? '' : 'DELETED');
  static const AccountStatus PENDING_VERIFICATION =
      AccountStatus._(5, _omitEnumNames ? '' : 'PENDING_VERIFICATION');

  static const $core.List<AccountStatus> values = <AccountStatus>[
    ACCOUNT_STATUS_UNSPECIFIED,
    ACTIVE,
    SUSPENDED,
    BANNED,
    DELETED,
    PENDING_VERIFICATION,
  ];

  static final $core.List<AccountStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AccountStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AccountStatus._(super.value, super.name);
}

class AddressType extends $pb.ProtobufEnum {
  static const AddressType ADDRESS_TYPE_UNSPECIFIED =
      AddressType._(0, _omitEnumNames ? '' : 'ADDRESS_TYPE_UNSPECIFIED');
  static const AddressType HOME =
      AddressType._(1, _omitEnumNames ? '' : 'HOME');
  static const AddressType WORK =
      AddressType._(2, _omitEnumNames ? '' : 'WORK');
  static const AddressType BILLING =
      AddressType._(3, _omitEnumNames ? '' : 'BILLING');
  static const AddressType SHIPPING =
      AddressType._(4, _omitEnumNames ? '' : 'SHIPPING');

  static const $core.List<AddressType> values = <AddressType>[
    ADDRESS_TYPE_UNSPECIFIED,
    HOME,
    WORK,
    BILLING,
    SHIPPING,
  ];

  static final $core.List<AddressType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AddressType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AddressType._(super.value, super.name);
}

class ProfileVisibility extends $pb.ProtobufEnum {
  static const ProfileVisibility PROFILE_VISIBILITY_UNSPECIFIED =
      ProfileVisibility._(
          0, _omitEnumNames ? '' : 'PROFILE_VISIBILITY_UNSPECIFIED');
  static const ProfileVisibility PUBLIC =
      ProfileVisibility._(1, _omitEnumNames ? '' : 'PUBLIC');
  static const ProfileVisibility FRIENDS =
      ProfileVisibility._(2, _omitEnumNames ? '' : 'FRIENDS');
  static const ProfileVisibility PRIVATE =
      ProfileVisibility._(3, _omitEnumNames ? '' : 'PRIVATE');

  static const $core.List<ProfileVisibility> values = <ProfileVisibility>[
    PROFILE_VISIBILITY_UNSPECIFIED,
    PUBLIC,
    FRIENDS,
    PRIVATE,
  ];

  static final $core.List<ProfileVisibility?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ProfileVisibility? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProfileVisibility._(super.value, super.name);
}

class PaymentType extends $pb.ProtobufEnum {
  static const PaymentType PAYMENT_TYPE_UNSPECIFIED =
      PaymentType._(0, _omitEnumNames ? '' : 'PAYMENT_TYPE_UNSPECIFIED');
  static const PaymentType CREDIT_CARD =
      PaymentType._(1, _omitEnumNames ? '' : 'CREDIT_CARD');
  static const PaymentType DEBIT_CARD =
      PaymentType._(2, _omitEnumNames ? '' : 'DEBIT_CARD');
  static const PaymentType PAYPAL =
      PaymentType._(3, _omitEnumNames ? '' : 'PAYPAL');
  static const PaymentType BANK_TRANSFER =
      PaymentType._(4, _omitEnumNames ? '' : 'BANK_TRANSFER');
  static const PaymentType CRYPTOCURRENCY =
      PaymentType._(5, _omitEnumNames ? '' : 'CRYPTOCURRENCY');
  static const PaymentType CASH_ON_DELIVERY =
      PaymentType._(6, _omitEnumNames ? '' : 'CASH_ON_DELIVERY');

  static const $core.List<PaymentType> values = <PaymentType>[
    PAYMENT_TYPE_UNSPECIFIED,
    CREDIT_CARD,
    DEBIT_CARD,
    PAYPAL,
    BANK_TRANSFER,
    CRYPTOCURRENCY,
    CASH_ON_DELIVERY,
  ];

  static final $core.List<PaymentType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static PaymentType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PaymentType._(super.value, super.name);
}

class SubscriptionStatus extends $pb.ProtobufEnum {
  static const SubscriptionStatus SUBSCRIPTION_STATUS_UNSPECIFIED =
      SubscriptionStatus._(
          0, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_UNSPECIFIED');
  static const SubscriptionStatus TRIAL =
      SubscriptionStatus._(1, _omitEnumNames ? '' : 'TRIAL');
  static const SubscriptionStatus SUBSCRIPTION_ACTIVE =
      SubscriptionStatus._(2, _omitEnumNames ? '' : 'SUBSCRIPTION_ACTIVE');
  static const SubscriptionStatus SUBSCRIPTION_CANCELLED =
      SubscriptionStatus._(3, _omitEnumNames ? '' : 'SUBSCRIPTION_CANCELLED');
  static const SubscriptionStatus SUBSCRIPTION_EXPIRED =
      SubscriptionStatus._(4, _omitEnumNames ? '' : 'SUBSCRIPTION_EXPIRED');
  static const SubscriptionStatus SUBSCRIPTION_PAYMENT_FAILED =
      SubscriptionStatus._(
          5, _omitEnumNames ? '' : 'SUBSCRIPTION_PAYMENT_FAILED');

  static const $core.List<SubscriptionStatus> values = <SubscriptionStatus>[
    SUBSCRIPTION_STATUS_UNSPECIFIED,
    TRIAL,
    SUBSCRIPTION_ACTIVE,
    SUBSCRIPTION_CANCELLED,
    SUBSCRIPTION_EXPIRED,
    SUBSCRIPTION_PAYMENT_FAILED,
  ];

  static final $core.List<SubscriptionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SubscriptionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubscriptionStatus._(super.value, super.name);
}

class PostType extends $pb.ProtobufEnum {
  static const PostType POST_TYPE_UNSPECIFIED =
      PostType._(0, _omitEnumNames ? '' : 'POST_TYPE_UNSPECIFIED');
  static const PostType TEXT = PostType._(1, _omitEnumNames ? '' : 'TEXT');
  static const PostType IMAGE = PostType._(2, _omitEnumNames ? '' : 'IMAGE');
  static const PostType VIDEO = PostType._(3, _omitEnumNames ? '' : 'VIDEO');
  static const PostType LINK = PostType._(4, _omitEnumNames ? '' : 'LINK');
  static const PostType POLL_POST =
      PostType._(5, _omitEnumNames ? '' : 'POLL_POST');
  static const PostType LIVE = PostType._(6, _omitEnumNames ? '' : 'LIVE');
  static const PostType STORY = PostType._(7, _omitEnumNames ? '' : 'STORY');

  static const $core.List<PostType> values = <PostType>[
    POST_TYPE_UNSPECIFIED,
    TEXT,
    IMAGE,
    VIDEO,
    LINK,
    POLL_POST,
    LIVE,
    STORY,
  ];

  static final $core.List<PostType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static PostType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PostType._(super.value, super.name);
}

class MediaType extends $pb.ProtobufEnum {
  static const MediaType MEDIA_TYPE_UNSPECIFIED =
      MediaType._(0, _omitEnumNames ? '' : 'MEDIA_TYPE_UNSPECIFIED');
  static const MediaType IMAGE_MEDIA =
      MediaType._(1, _omitEnumNames ? '' : 'IMAGE_MEDIA');
  static const MediaType VIDEO_MEDIA =
      MediaType._(2, _omitEnumNames ? '' : 'VIDEO_MEDIA');
  static const MediaType AUDIO = MediaType._(3, _omitEnumNames ? '' : 'AUDIO');
  static const MediaType DOCUMENT =
      MediaType._(4, _omitEnumNames ? '' : 'DOCUMENT');
  static const MediaType GIF = MediaType._(5, _omitEnumNames ? '' : 'GIF');

  static const $core.List<MediaType> values = <MediaType>[
    MEDIA_TYPE_UNSPECIFIED,
    IMAGE_MEDIA,
    VIDEO_MEDIA,
    AUDIO,
    DOCUMENT,
    GIF,
  ];

  static final $core.List<MediaType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static MediaType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MediaType._(super.value, super.name);
}

class PostVisibility extends $pb.ProtobufEnum {
  static const PostVisibility POST_VISIBILITY_UNSPECIFIED =
      PostVisibility._(0, _omitEnumNames ? '' : 'POST_VISIBILITY_UNSPECIFIED');
  static const PostVisibility POST_PUBLIC =
      PostVisibility._(1, _omitEnumNames ? '' : 'POST_PUBLIC');
  static const PostVisibility POST_FRIENDS =
      PostVisibility._(2, _omitEnumNames ? '' : 'POST_FRIENDS');
  static const PostVisibility POST_PRIVATE =
      PostVisibility._(3, _omitEnumNames ? '' : 'POST_PRIVATE');
  static const PostVisibility CUSTOM =
      PostVisibility._(4, _omitEnumNames ? '' : 'CUSTOM');

  static const $core.List<PostVisibility> values = <PostVisibility>[
    POST_VISIBILITY_UNSPECIFIED,
    POST_PUBLIC,
    POST_FRIENDS,
    POST_PRIVATE,
    CUSTOM,
  ];

  static final $core.List<PostVisibility?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PostVisibility? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PostVisibility._(super.value, super.name);
}

class ReactionType extends $pb.ProtobufEnum {
  static const ReactionType REACTION_TYPE_UNSPECIFIED =
      ReactionType._(0, _omitEnumNames ? '' : 'REACTION_TYPE_UNSPECIFIED');
  static const ReactionType LIKE =
      ReactionType._(1, _omitEnumNames ? '' : 'LIKE');
  static const ReactionType LOVE =
      ReactionType._(2, _omitEnumNames ? '' : 'LOVE');
  static const ReactionType HAHA =
      ReactionType._(3, _omitEnumNames ? '' : 'HAHA');
  static const ReactionType WOW =
      ReactionType._(4, _omitEnumNames ? '' : 'WOW');
  static const ReactionType SAD =
      ReactionType._(5, _omitEnumNames ? '' : 'SAD');
  static const ReactionType ANGRY =
      ReactionType._(6, _omitEnumNames ? '' : 'ANGRY');

  static const $core.List<ReactionType> values = <ReactionType>[
    REACTION_TYPE_UNSPECIFIED,
    LIKE,
    LOVE,
    HAHA,
    WOW,
    SAD,
    ANGRY,
  ];

  static final $core.List<ReactionType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ReactionType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReactionType._(super.value, super.name);
}

class ProductStatus extends $pb.ProtobufEnum {
  static const ProductStatus PRODUCT_STATUS_UNSPECIFIED =
      ProductStatus._(0, _omitEnumNames ? '' : 'PRODUCT_STATUS_UNSPECIFIED');
  static const ProductStatus DRAFT =
      ProductStatus._(1, _omitEnumNames ? '' : 'DRAFT');
  static const ProductStatus PRODUCT_ACTIVE =
      ProductStatus._(2, _omitEnumNames ? '' : 'PRODUCT_ACTIVE');
  static const ProductStatus ARCHIVED =
      ProductStatus._(3, _omitEnumNames ? '' : 'ARCHIVED');
  static const ProductStatus OUT_OF_STOCK =
      ProductStatus._(4, _omitEnumNames ? '' : 'OUT_OF_STOCK');

  static const $core.List<ProductStatus> values = <ProductStatus>[
    PRODUCT_STATUS_UNSPECIFIED,
    DRAFT,
    PRODUCT_ACTIVE,
    ARCHIVED,
    OUT_OF_STOCK,
  ];

  static final $core.List<ProductStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ProductStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProductStatus._(super.value, super.name);
}

class OrderStatus extends $pb.ProtobufEnum {
  static const OrderStatus ORDER_STATUS_UNSPECIFIED =
      OrderStatus._(0, _omitEnumNames ? '' : 'ORDER_STATUS_UNSPECIFIED');
  static const OrderStatus ORDER_PENDING =
      OrderStatus._(1, _omitEnumNames ? '' : 'ORDER_PENDING');
  static const OrderStatus ORDER_PROCESSING =
      OrderStatus._(2, _omitEnumNames ? '' : 'ORDER_PROCESSING');
  static const OrderStatus ORDER_SHIPPED =
      OrderStatus._(3, _omitEnumNames ? '' : 'ORDER_SHIPPED');
  static const OrderStatus ORDER_DELIVERED =
      OrderStatus._(4, _omitEnumNames ? '' : 'ORDER_DELIVERED');
  static const OrderStatus ORDER_CANCELLED =
      OrderStatus._(5, _omitEnumNames ? '' : 'ORDER_CANCELLED');
  static const OrderStatus ORDER_REFUNDED =
      OrderStatus._(6, _omitEnumNames ? '' : 'ORDER_REFUNDED');
  static const OrderStatus ORDER_FAILED =
      OrderStatus._(7, _omitEnumNames ? '' : 'ORDER_FAILED');

  static const $core.List<OrderStatus> values = <OrderStatus>[
    ORDER_STATUS_UNSPECIFIED,
    ORDER_PENDING,
    ORDER_PROCESSING,
    ORDER_SHIPPED,
    ORDER_DELIVERED,
    ORDER_CANCELLED,
    ORDER_REFUNDED,
    ORDER_FAILED,
  ];

  static final $core.List<OrderStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static OrderStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrderStatus._(super.value, super.name);
}

class PaymentStatus extends $pb.ProtobufEnum {
  static const PaymentStatus PAYMENT_STATUS_UNSPECIFIED =
      PaymentStatus._(0, _omitEnumNames ? '' : 'PAYMENT_STATUS_UNSPECIFIED');
  static const PaymentStatus PAYMENT_PENDING =
      PaymentStatus._(1, _omitEnumNames ? '' : 'PAYMENT_PENDING');
  static const PaymentStatus COMPLETED =
      PaymentStatus._(2, _omitEnumNames ? '' : 'COMPLETED');
  static const PaymentStatus PAYMENT_FAILED =
      PaymentStatus._(3, _omitEnumNames ? '' : 'PAYMENT_FAILED');
  static const PaymentStatus PAYMENT_REFUNDED =
      PaymentStatus._(4, _omitEnumNames ? '' : 'PAYMENT_REFUNDED');

  static const $core.List<PaymentStatus> values = <PaymentStatus>[
    PAYMENT_STATUS_UNSPECIFIED,
    PAYMENT_PENDING,
    COMPLETED,
    PAYMENT_FAILED,
    PAYMENT_REFUNDED,
  ];

  static final $core.List<PaymentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PaymentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PaymentStatus._(super.value, super.name);
}

class CouponType extends $pb.ProtobufEnum {
  static const CouponType COUPON_TYPE_UNSPECIFIED =
      CouponType._(0, _omitEnumNames ? '' : 'COUPON_TYPE_UNSPECIFIED');
  static const CouponType PERCENTAGE =
      CouponType._(1, _omitEnumNames ? '' : 'PERCENTAGE');
  static const CouponType FIXED_AMOUNT =
      CouponType._(2, _omitEnumNames ? '' : 'FIXED_AMOUNT');
  static const CouponType FREE_SHIPPING =
      CouponType._(3, _omitEnumNames ? '' : 'FREE_SHIPPING');

  static const $core.List<CouponType> values = <CouponType>[
    COUPON_TYPE_UNSPECIFIED,
    PERCENTAGE,
    FIXED_AMOUNT,
    FREE_SHIPPING,
  ];

  static final $core.List<CouponType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CouponType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CouponType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
