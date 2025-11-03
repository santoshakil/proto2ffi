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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'benchmark.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'benchmark.pbenum.dart';

/// User profile with extensive information
class User extends $pb.GeneratedMessage {
  factory User({
    $fixnum.Int64? userId,
    $core.String? username,
    $core.String? email,
    $core.String? firstName,
    $core.String? lastName,
    $core.String? displayName,
    $core.String? bio,
    $core.String? avatarUrl,
    $core.String? coverPhotoUrl,
    $core.String? phoneNumber,
    $fixnum.Int64? dateOfBirth,
    Gender? gender,
    Address? primaryAddress,
    $core.Iterable<Address>? additionalAddresses,
    UserSettings? settings,
    UserStats? stats,
    $core.Iterable<SocialLink>? socialLinks,
    $core.bool? isVerified,
    $core.bool? isPremium,
    AccountStatus? status,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    $fixnum.Int64? lastLogin,
    $core.String? deviceId,
    $core.String? ipAddress,
    $core.String? userAgent,
    $core.String? timezone,
    $core.String? language,
    $core.String? countryCode,
    $core.double? accountBalance,
    $core.Iterable<PaymentMethod>? paymentMethods,
    $core.Iterable<Subscription>? subscriptions,
    $core.List<$core.int>? profileData,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
    $core.Iterable<$core.String>? tags,
    $core.Iterable<$fixnum.Int64>? followerIds,
    $core.Iterable<$fixnum.Int64>? followingIds,
    $core.Iterable<$fixnum.Int64>? blockedUserIds,
    $core.int? reputationScore,
    $core.String? referralCode,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (displayName != null) result.displayName = displayName;
    if (bio != null) result.bio = bio;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (coverPhotoUrl != null) result.coverPhotoUrl = coverPhotoUrl;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (dateOfBirth != null) result.dateOfBirth = dateOfBirth;
    if (gender != null) result.gender = gender;
    if (primaryAddress != null) result.primaryAddress = primaryAddress;
    if (additionalAddresses != null)
      result.additionalAddresses.addAll(additionalAddresses);
    if (settings != null) result.settings = settings;
    if (stats != null) result.stats = stats;
    if (socialLinks != null) result.socialLinks.addAll(socialLinks);
    if (isVerified != null) result.isVerified = isVerified;
    if (isPremium != null) result.isPremium = isPremium;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (lastLogin != null) result.lastLogin = lastLogin;
    if (deviceId != null) result.deviceId = deviceId;
    if (ipAddress != null) result.ipAddress = ipAddress;
    if (userAgent != null) result.userAgent = userAgent;
    if (timezone != null) result.timezone = timezone;
    if (language != null) result.language = language;
    if (countryCode != null) result.countryCode = countryCode;
    if (accountBalance != null) result.accountBalance = accountBalance;
    if (paymentMethods != null) result.paymentMethods.addAll(paymentMethods);
    if (subscriptions != null) result.subscriptions.addAll(subscriptions);
    if (profileData != null) result.profileData = profileData;
    if (metadata != null) result.metadata.addEntries(metadata);
    if (tags != null) result.tags.addAll(tags);
    if (followerIds != null) result.followerIds.addAll(followerIds);
    if (followingIds != null) result.followingIds.addAll(followingIds);
    if (blockedUserIds != null) result.blockedUserIds.addAll(blockedUserIds);
    if (reputationScore != null) result.reputationScore = reputationScore;
    if (referralCode != null) result.referralCode = referralCode;
    return result;
  }

  User._();

  factory User.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory User.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'User',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aOS(4, _omitFieldNames ? '' : 'firstName')
    ..aOS(5, _omitFieldNames ? '' : 'lastName')
    ..aOS(6, _omitFieldNames ? '' : 'displayName')
    ..aOS(7, _omitFieldNames ? '' : 'bio')
    ..aOS(8, _omitFieldNames ? '' : 'avatarUrl')
    ..aOS(9, _omitFieldNames ? '' : 'coverPhotoUrl')
    ..aOS(10, _omitFieldNames ? '' : 'phoneNumber')
    ..a<$fixnum.Int64>(
        11, _omitFieldNames ? '' : 'dateOfBirth', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<Gender>(12, _omitFieldNames ? '' : 'gender', enumValues: Gender.values)
    ..aOM<Address>(13, _omitFieldNames ? '' : 'primaryAddress',
        subBuilder: Address.create)
    ..pPM<Address>(14, _omitFieldNames ? '' : 'additionalAddresses',
        subBuilder: Address.create)
    ..aOM<UserSettings>(15, _omitFieldNames ? '' : 'settings',
        subBuilder: UserSettings.create)
    ..aOM<UserStats>(16, _omitFieldNames ? '' : 'stats',
        subBuilder: UserStats.create)
    ..pPM<SocialLink>(17, _omitFieldNames ? '' : 'socialLinks',
        subBuilder: SocialLink.create)
    ..aOB(18, _omitFieldNames ? '' : 'isVerified')
    ..aOB(19, _omitFieldNames ? '' : 'isPremium')
    ..aE<AccountStatus>(20, _omitFieldNames ? '' : 'status',
        enumValues: AccountStatus.values)
    ..a<$fixnum.Int64>(
        21, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        22, _omitFieldNames ? '' : 'updatedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        23, _omitFieldNames ? '' : 'lastLogin', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(24, _omitFieldNames ? '' : 'deviceId')
    ..aOS(25, _omitFieldNames ? '' : 'ipAddress')
    ..aOS(26, _omitFieldNames ? '' : 'userAgent')
    ..aOS(27, _omitFieldNames ? '' : 'timezone')
    ..aOS(28, _omitFieldNames ? '' : 'language')
    ..aOS(29, _omitFieldNames ? '' : 'countryCode')
    ..aD(30, _omitFieldNames ? '' : 'accountBalance')
    ..pPM<PaymentMethod>(31, _omitFieldNames ? '' : 'paymentMethods',
        subBuilder: PaymentMethod.create)
    ..pPM<Subscription>(32, _omitFieldNames ? '' : 'subscriptions',
        subBuilder: Subscription.create)
    ..a<$core.List<$core.int>>(
        33, _omitFieldNames ? '' : 'profileData', $pb.PbFieldType.OY)
    ..m<$core.String, $core.String>(34, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'User.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('benchmark'))
    ..pPS(35, _omitFieldNames ? '' : 'tags')
    ..p<$fixnum.Int64>(
        36, _omitFieldNames ? '' : 'followerIds', $pb.PbFieldType.KU6)
    ..p<$fixnum.Int64>(
        37, _omitFieldNames ? '' : 'followingIds', $pb.PbFieldType.KU6)
    ..p<$fixnum.Int64>(
        38, _omitFieldNames ? '' : 'blockedUserIds', $pb.PbFieldType.KU6)
    ..aI(39, _omitFieldNames ? '' : 'reputationScore')
    ..aOS(40, _omitFieldNames ? '' : 'referralCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User copyWith(void Function(User) updates) =>
      super.copyWith((message) => updates(message as User)) as User;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  @$core.override
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get firstName => $_getSZ(3);
  @$pb.TagNumber(4)
  set firstName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFirstName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFirstName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get lastName => $_getSZ(4);
  @$pb.TagNumber(5)
  set lastName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLastName() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get displayName => $_getSZ(5);
  @$pb.TagNumber(6)
  set displayName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDisplayName() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get bio => $_getSZ(6);
  @$pb.TagNumber(7)
  set bio($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBio() => $_has(6);
  @$pb.TagNumber(7)
  void clearBio() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get avatarUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set avatarUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAvatarUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearAvatarUrl() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get coverPhotoUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set coverPhotoUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCoverPhotoUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearCoverPhotoUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get phoneNumber => $_getSZ(9);
  @$pb.TagNumber(10)
  set phoneNumber($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPhoneNumber() => $_has(9);
  @$pb.TagNumber(10)
  void clearPhoneNumber() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get dateOfBirth => $_getI64(10);
  @$pb.TagNumber(11)
  set dateOfBirth($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDateOfBirth() => $_has(10);
  @$pb.TagNumber(11)
  void clearDateOfBirth() => $_clearField(11);

  @$pb.TagNumber(12)
  Gender get gender => $_getN(11);
  @$pb.TagNumber(12)
  set gender(Gender value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasGender() => $_has(11);
  @$pb.TagNumber(12)
  void clearGender() => $_clearField(12);

  @$pb.TagNumber(13)
  Address get primaryAddress => $_getN(12);
  @$pb.TagNumber(13)
  set primaryAddress(Address value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPrimaryAddress() => $_has(12);
  @$pb.TagNumber(13)
  void clearPrimaryAddress() => $_clearField(13);
  @$pb.TagNumber(13)
  Address ensurePrimaryAddress() => $_ensure(12);

  @$pb.TagNumber(14)
  $pb.PbList<Address> get additionalAddresses => $_getList(13);

  @$pb.TagNumber(15)
  UserSettings get settings => $_getN(14);
  @$pb.TagNumber(15)
  set settings(UserSettings value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSettings() => $_has(14);
  @$pb.TagNumber(15)
  void clearSettings() => $_clearField(15);
  @$pb.TagNumber(15)
  UserSettings ensureSettings() => $_ensure(14);

  @$pb.TagNumber(16)
  UserStats get stats => $_getN(15);
  @$pb.TagNumber(16)
  set stats(UserStats value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasStats() => $_has(15);
  @$pb.TagNumber(16)
  void clearStats() => $_clearField(16);
  @$pb.TagNumber(16)
  UserStats ensureStats() => $_ensure(15);

  @$pb.TagNumber(17)
  $pb.PbList<SocialLink> get socialLinks => $_getList(16);

  @$pb.TagNumber(18)
  $core.bool get isVerified => $_getBF(17);
  @$pb.TagNumber(18)
  set isVerified($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasIsVerified() => $_has(17);
  @$pb.TagNumber(18)
  void clearIsVerified() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get isPremium => $_getBF(18);
  @$pb.TagNumber(19)
  set isPremium($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasIsPremium() => $_has(18);
  @$pb.TagNumber(19)
  void clearIsPremium() => $_clearField(19);

  @$pb.TagNumber(20)
  AccountStatus get status => $_getN(19);
  @$pb.TagNumber(20)
  set status(AccountStatus value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasStatus() => $_has(19);
  @$pb.TagNumber(20)
  void clearStatus() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get createdAt => $_getI64(20);
  @$pb.TagNumber(21)
  set createdAt($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasCreatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearCreatedAt() => $_clearField(21);

  @$pb.TagNumber(22)
  $fixnum.Int64 get updatedAt => $_getI64(21);
  @$pb.TagNumber(22)
  set updatedAt($fixnum.Int64 value) => $_setInt64(21, value);
  @$pb.TagNumber(22)
  $core.bool hasUpdatedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearUpdatedAt() => $_clearField(22);

  @$pb.TagNumber(23)
  $fixnum.Int64 get lastLogin => $_getI64(22);
  @$pb.TagNumber(23)
  set lastLogin($fixnum.Int64 value) => $_setInt64(22, value);
  @$pb.TagNumber(23)
  $core.bool hasLastLogin() => $_has(22);
  @$pb.TagNumber(23)
  void clearLastLogin() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get deviceId => $_getSZ(23);
  @$pb.TagNumber(24)
  set deviceId($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasDeviceId() => $_has(23);
  @$pb.TagNumber(24)
  void clearDeviceId() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get ipAddress => $_getSZ(24);
  @$pb.TagNumber(25)
  set ipAddress($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasIpAddress() => $_has(24);
  @$pb.TagNumber(25)
  void clearIpAddress() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get userAgent => $_getSZ(25);
  @$pb.TagNumber(26)
  set userAgent($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasUserAgent() => $_has(25);
  @$pb.TagNumber(26)
  void clearUserAgent() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.String get timezone => $_getSZ(26);
  @$pb.TagNumber(27)
  set timezone($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasTimezone() => $_has(26);
  @$pb.TagNumber(27)
  void clearTimezone() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.String get language => $_getSZ(27);
  @$pb.TagNumber(28)
  set language($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasLanguage() => $_has(27);
  @$pb.TagNumber(28)
  void clearLanguage() => $_clearField(28);

  @$pb.TagNumber(29)
  $core.String get countryCode => $_getSZ(28);
  @$pb.TagNumber(29)
  set countryCode($core.String value) => $_setString(28, value);
  @$pb.TagNumber(29)
  $core.bool hasCountryCode() => $_has(28);
  @$pb.TagNumber(29)
  void clearCountryCode() => $_clearField(29);

  @$pb.TagNumber(30)
  $core.double get accountBalance => $_getN(29);
  @$pb.TagNumber(30)
  set accountBalance($core.double value) => $_setDouble(29, value);
  @$pb.TagNumber(30)
  $core.bool hasAccountBalance() => $_has(29);
  @$pb.TagNumber(30)
  void clearAccountBalance() => $_clearField(30);

  @$pb.TagNumber(31)
  $pb.PbList<PaymentMethod> get paymentMethods => $_getList(30);

  @$pb.TagNumber(32)
  $pb.PbList<Subscription> get subscriptions => $_getList(31);

  @$pb.TagNumber(33)
  $core.List<$core.int> get profileData => $_getN(32);
  @$pb.TagNumber(33)
  set profileData($core.List<$core.int> value) => $_setBytes(32, value);
  @$pb.TagNumber(33)
  $core.bool hasProfileData() => $_has(32);
  @$pb.TagNumber(33)
  void clearProfileData() => $_clearField(33);

  @$pb.TagNumber(34)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(33);

  @$pb.TagNumber(35)
  $pb.PbList<$core.String> get tags => $_getList(34);

  @$pb.TagNumber(36)
  $pb.PbList<$fixnum.Int64> get followerIds => $_getList(35);

  @$pb.TagNumber(37)
  $pb.PbList<$fixnum.Int64> get followingIds => $_getList(36);

  @$pb.TagNumber(38)
  $pb.PbList<$fixnum.Int64> get blockedUserIds => $_getList(37);

  @$pb.TagNumber(39)
  $core.int get reputationScore => $_getIZ(38);
  @$pb.TagNumber(39)
  set reputationScore($core.int value) => $_setSignedInt32(38, value);
  @$pb.TagNumber(39)
  $core.bool hasReputationScore() => $_has(38);
  @$pb.TagNumber(39)
  void clearReputationScore() => $_clearField(39);

  @$pb.TagNumber(40)
  $core.String get referralCode => $_getSZ(39);
  @$pb.TagNumber(40)
  set referralCode($core.String value) => $_setString(39, value);
  @$pb.TagNumber(40)
  $core.bool hasReferralCode() => $_has(39);
  @$pb.TagNumber(40)
  void clearReferralCode() => $_clearField(40);
}

class Address extends $pb.GeneratedMessage {
  factory Address({
    $core.String? streetLine1,
    $core.String? streetLine2,
    $core.String? city,
    $core.String? state,
    $core.String? postalCode,
    $core.String? country,
    AddressType? type,
    $core.bool? isDefault,
    $core.double? latitude,
    $core.double? longitude,
    $core.String? instructions,
  }) {
    final result = create();
    if (streetLine1 != null) result.streetLine1 = streetLine1;
    if (streetLine2 != null) result.streetLine2 = streetLine2;
    if (city != null) result.city = city;
    if (state != null) result.state = state;
    if (postalCode != null) result.postalCode = postalCode;
    if (country != null) result.country = country;
    if (type != null) result.type = type;
    if (isDefault != null) result.isDefault = isDefault;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (instructions != null) result.instructions = instructions;
    return result;
  }

  Address._();

  factory Address.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Address.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Address',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'streetLine1')
    ..aOS(2, _omitFieldNames ? '' : 'streetLine2')
    ..aOS(3, _omitFieldNames ? '' : 'city')
    ..aOS(4, _omitFieldNames ? '' : 'state')
    ..aOS(5, _omitFieldNames ? '' : 'postalCode')
    ..aOS(6, _omitFieldNames ? '' : 'country')
    ..aE<AddressType>(7, _omitFieldNames ? '' : 'type',
        enumValues: AddressType.values)
    ..aOB(8, _omitFieldNames ? '' : 'isDefault')
    ..aD(9, _omitFieldNames ? '' : 'latitude')
    ..aD(10, _omitFieldNames ? '' : 'longitude')
    ..aOS(11, _omitFieldNames ? '' : 'instructions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Address clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Address copyWith(void Function(Address) updates) =>
      super.copyWith((message) => updates(message as Address)) as Address;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Address create() => Address._();
  @$core.override
  Address createEmptyInstance() => create();
  static $pb.PbList<Address> createRepeated() => $pb.PbList<Address>();
  @$core.pragma('dart2js:noInline')
  static Address getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Address>(create);
  static Address? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get streetLine1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set streetLine1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStreetLine1() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreetLine1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get streetLine2 => $_getSZ(1);
  @$pb.TagNumber(2)
  set streetLine2($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStreetLine2() => $_has(1);
  @$pb.TagNumber(2)
  void clearStreetLine2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get city => $_getSZ(2);
  @$pb.TagNumber(3)
  set city($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get state => $_getSZ(3);
  @$pb.TagNumber(4)
  set state($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get postalCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set postalCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPostalCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearPostalCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get country => $_getSZ(5);
  @$pb.TagNumber(6)
  set country($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCountry() => $_has(5);
  @$pb.TagNumber(6)
  void clearCountry() => $_clearField(6);

  @$pb.TagNumber(7)
  AddressType get type => $_getN(6);
  @$pb.TagNumber(7)
  set type(AddressType value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasType() => $_has(6);
  @$pb.TagNumber(7)
  void clearType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDefault => $_getBF(7);
  @$pb.TagNumber(8)
  set isDefault($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDefault() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDefault() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get latitude => $_getN(8);
  @$pb.TagNumber(9)
  set latitude($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLatitude() => $_has(8);
  @$pb.TagNumber(9)
  void clearLatitude() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get longitude => $_getN(9);
  @$pb.TagNumber(10)
  set longitude($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLongitude() => $_has(9);
  @$pb.TagNumber(10)
  void clearLongitude() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get instructions => $_getSZ(10);
  @$pb.TagNumber(11)
  set instructions($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInstructions() => $_has(10);
  @$pb.TagNumber(11)
  void clearInstructions() => $_clearField(11);
}

class UserSettings extends $pb.GeneratedMessage {
  factory UserSettings({
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    DisplaySettings? display,
    $core.bool? emailVerified,
    $core.bool? phoneVerified,
    $core.bool? twoFactorEnabled,
    $core.Iterable<$core.String>? blockedKeywords,
    $core.bool? autoPlayVideos,
    $core.bool? showAdultContent,
    $core.int? feedRefreshInterval,
  }) {
    final result = create();
    if (notifications != null) result.notifications = notifications;
    if (privacy != null) result.privacy = privacy;
    if (display != null) result.display = display;
    if (emailVerified != null) result.emailVerified = emailVerified;
    if (phoneVerified != null) result.phoneVerified = phoneVerified;
    if (twoFactorEnabled != null) result.twoFactorEnabled = twoFactorEnabled;
    if (blockedKeywords != null) result.blockedKeywords.addAll(blockedKeywords);
    if (autoPlayVideos != null) result.autoPlayVideos = autoPlayVideos;
    if (showAdultContent != null) result.showAdultContent = showAdultContent;
    if (feedRefreshInterval != null)
      result.feedRefreshInterval = feedRefreshInterval;
    return result;
  }

  UserSettings._();

  factory UserSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOM<NotificationSettings>(1, _omitFieldNames ? '' : 'notifications',
        subBuilder: NotificationSettings.create)
    ..aOM<PrivacySettings>(2, _omitFieldNames ? '' : 'privacy',
        subBuilder: PrivacySettings.create)
    ..aOM<DisplaySettings>(3, _omitFieldNames ? '' : 'display',
        subBuilder: DisplaySettings.create)
    ..aOB(4, _omitFieldNames ? '' : 'emailVerified')
    ..aOB(5, _omitFieldNames ? '' : 'phoneVerified')
    ..aOB(6, _omitFieldNames ? '' : 'twoFactorEnabled')
    ..pPS(7, _omitFieldNames ? '' : 'blockedKeywords')
    ..aOB(8, _omitFieldNames ? '' : 'autoPlayVideos')
    ..aOB(9, _omitFieldNames ? '' : 'showAdultContent')
    ..aI(10, _omitFieldNames ? '' : 'feedRefreshInterval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSettings copyWith(void Function(UserSettings) updates) =>
      super.copyWith((message) => updates(message as UserSettings))
          as UserSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserSettings create() => UserSettings._();
  @$core.override
  UserSettings createEmptyInstance() => create();
  static $pb.PbList<UserSettings> createRepeated() =>
      $pb.PbList<UserSettings>();
  @$core.pragma('dart2js:noInline')
  static UserSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserSettings>(create);
  static UserSettings? _defaultInstance;

  @$pb.TagNumber(1)
  NotificationSettings get notifications => $_getN(0);
  @$pb.TagNumber(1)
  set notifications(NotificationSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotifications() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotifications() => $_clearField(1);
  @$pb.TagNumber(1)
  NotificationSettings ensureNotifications() => $_ensure(0);

  @$pb.TagNumber(2)
  PrivacySettings get privacy => $_getN(1);
  @$pb.TagNumber(2)
  set privacy(PrivacySettings value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPrivacy() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrivacy() => $_clearField(2);
  @$pb.TagNumber(2)
  PrivacySettings ensurePrivacy() => $_ensure(1);

  @$pb.TagNumber(3)
  DisplaySettings get display => $_getN(2);
  @$pb.TagNumber(3)
  set display(DisplaySettings value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplay() => $_clearField(3);
  @$pb.TagNumber(3)
  DisplaySettings ensureDisplay() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get emailVerified => $_getBF(3);
  @$pb.TagNumber(4)
  set emailVerified($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEmailVerified() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmailVerified() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get phoneVerified => $_getBF(4);
  @$pb.TagNumber(5)
  set phoneVerified($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPhoneVerified() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhoneVerified() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get twoFactorEnabled => $_getBF(5);
  @$pb.TagNumber(6)
  set twoFactorEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTwoFactorEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearTwoFactorEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get blockedKeywords => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get autoPlayVideos => $_getBF(7);
  @$pb.TagNumber(8)
  set autoPlayVideos($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAutoPlayVideos() => $_has(7);
  @$pb.TagNumber(8)
  void clearAutoPlayVideos() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get showAdultContent => $_getBF(8);
  @$pb.TagNumber(9)
  set showAdultContent($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasShowAdultContent() => $_has(8);
  @$pb.TagNumber(9)
  void clearShowAdultContent() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get feedRefreshInterval => $_getIZ(9);
  @$pb.TagNumber(10)
  set feedRefreshInterval($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFeedRefreshInterval() => $_has(9);
  @$pb.TagNumber(10)
  void clearFeedRefreshInterval() => $_clearField(10);
}

class NotificationSettings extends $pb.GeneratedMessage {
  factory NotificationSettings({
    $core.bool? pushEnabled,
    $core.bool? emailEnabled,
    $core.bool? smsEnabled,
    $core.bool? likesNotifications,
    $core.bool? commentsNotifications,
    $core.bool? mentionsNotifications,
    $core.bool? followNotifications,
    $core.bool? messageNotifications,
    $core.bool? marketingEmails,
    $core.Iterable<$core.int>? quietHoursStart,
    $core.Iterable<$core.int>? quietHoursEnd,
  }) {
    final result = create();
    if (pushEnabled != null) result.pushEnabled = pushEnabled;
    if (emailEnabled != null) result.emailEnabled = emailEnabled;
    if (smsEnabled != null) result.smsEnabled = smsEnabled;
    if (likesNotifications != null)
      result.likesNotifications = likesNotifications;
    if (commentsNotifications != null)
      result.commentsNotifications = commentsNotifications;
    if (mentionsNotifications != null)
      result.mentionsNotifications = mentionsNotifications;
    if (followNotifications != null)
      result.followNotifications = followNotifications;
    if (messageNotifications != null)
      result.messageNotifications = messageNotifications;
    if (marketingEmails != null) result.marketingEmails = marketingEmails;
    if (quietHoursStart != null) result.quietHoursStart.addAll(quietHoursStart);
    if (quietHoursEnd != null) result.quietHoursEnd.addAll(quietHoursEnd);
    return result;
  }

  NotificationSettings._();

  factory NotificationSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'pushEnabled')
    ..aOB(2, _omitFieldNames ? '' : 'emailEnabled')
    ..aOB(3, _omitFieldNames ? '' : 'smsEnabled')
    ..aOB(4, _omitFieldNames ? '' : 'likesNotifications')
    ..aOB(5, _omitFieldNames ? '' : 'commentsNotifications')
    ..aOB(6, _omitFieldNames ? '' : 'mentionsNotifications')
    ..aOB(7, _omitFieldNames ? '' : 'followNotifications')
    ..aOB(8, _omitFieldNames ? '' : 'messageNotifications')
    ..aOB(9, _omitFieldNames ? '' : 'marketingEmails')
    ..p<$core.int>(
        10, _omitFieldNames ? '' : 'quietHoursStart', $pb.PbFieldType.KU3)
    ..p<$core.int>(
        11, _omitFieldNames ? '' : 'quietHoursEnd', $pb.PbFieldType.KU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationSettings copyWith(void Function(NotificationSettings) updates) =>
      super.copyWith((message) => updates(message as NotificationSettings))
          as NotificationSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationSettings create() => NotificationSettings._();
  @$core.override
  NotificationSettings createEmptyInstance() => create();
  static $pb.PbList<NotificationSettings> createRepeated() =>
      $pb.PbList<NotificationSettings>();
  @$core.pragma('dart2js:noInline')
  static NotificationSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationSettings>(create);
  static NotificationSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get pushEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set pushEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPushEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearPushEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get emailEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set emailEnabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmailEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmailEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get smsEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set smsEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSmsEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearSmsEnabled() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get likesNotifications => $_getBF(3);
  @$pb.TagNumber(4)
  set likesNotifications($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLikesNotifications() => $_has(3);
  @$pb.TagNumber(4)
  void clearLikesNotifications() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get commentsNotifications => $_getBF(4);
  @$pb.TagNumber(5)
  set commentsNotifications($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCommentsNotifications() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommentsNotifications() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get mentionsNotifications => $_getBF(5);
  @$pb.TagNumber(6)
  set mentionsNotifications($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMentionsNotifications() => $_has(5);
  @$pb.TagNumber(6)
  void clearMentionsNotifications() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get followNotifications => $_getBF(6);
  @$pb.TagNumber(7)
  set followNotifications($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowNotifications() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowNotifications() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get messageNotifications => $_getBF(7);
  @$pb.TagNumber(8)
  set messageNotifications($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMessageNotifications() => $_has(7);
  @$pb.TagNumber(8)
  void clearMessageNotifications() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get marketingEmails => $_getBF(8);
  @$pb.TagNumber(9)
  set marketingEmails($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMarketingEmails() => $_has(8);
  @$pb.TagNumber(9)
  void clearMarketingEmails() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.int> get quietHoursStart => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.int> get quietHoursEnd => $_getList(10);
}

class PrivacySettings extends $pb.GeneratedMessage {
  factory PrivacySettings({
    ProfileVisibility? profileVisibility,
    $core.bool? showEmail,
    $core.bool? showPhone,
    $core.bool? showLocation,
    $core.bool? allowTags,
    $core.bool? allowMentions,
    $core.bool? searchable,
    $core.bool? showOnlineStatus,
    $core.bool? showLastSeen,
    $core.bool? allowDirectMessages,
  }) {
    final result = create();
    if (profileVisibility != null) result.profileVisibility = profileVisibility;
    if (showEmail != null) result.showEmail = showEmail;
    if (showPhone != null) result.showPhone = showPhone;
    if (showLocation != null) result.showLocation = showLocation;
    if (allowTags != null) result.allowTags = allowTags;
    if (allowMentions != null) result.allowMentions = allowMentions;
    if (searchable != null) result.searchable = searchable;
    if (showOnlineStatus != null) result.showOnlineStatus = showOnlineStatus;
    if (showLastSeen != null) result.showLastSeen = showLastSeen;
    if (allowDirectMessages != null)
      result.allowDirectMessages = allowDirectMessages;
    return result;
  }

  PrivacySettings._();

  factory PrivacySettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacySettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrivacySettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aE<ProfileVisibility>(1, _omitFieldNames ? '' : 'profileVisibility',
        enumValues: ProfileVisibility.values)
    ..aOB(2, _omitFieldNames ? '' : 'showEmail')
    ..aOB(3, _omitFieldNames ? '' : 'showPhone')
    ..aOB(4, _omitFieldNames ? '' : 'showLocation')
    ..aOB(5, _omitFieldNames ? '' : 'allowTags')
    ..aOB(6, _omitFieldNames ? '' : 'allowMentions')
    ..aOB(7, _omitFieldNames ? '' : 'searchable')
    ..aOB(8, _omitFieldNames ? '' : 'showOnlineStatus')
    ..aOB(9, _omitFieldNames ? '' : 'showLastSeen')
    ..aOB(10, _omitFieldNames ? '' : 'allowDirectMessages')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettings copyWith(void Function(PrivacySettings) updates) =>
      super.copyWith((message) => updates(message as PrivacySettings))
          as PrivacySettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacySettings create() => PrivacySettings._();
  @$core.override
  PrivacySettings createEmptyInstance() => create();
  static $pb.PbList<PrivacySettings> createRepeated() =>
      $pb.PbList<PrivacySettings>();
  @$core.pragma('dart2js:noInline')
  static PrivacySettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrivacySettings>(create);
  static PrivacySettings? _defaultInstance;

  @$pb.TagNumber(1)
  ProfileVisibility get profileVisibility => $_getN(0);
  @$pb.TagNumber(1)
  set profileVisibility(ProfileVisibility value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProfileVisibility() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfileVisibility() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get showEmail => $_getBF(1);
  @$pb.TagNumber(2)
  set showEmail($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShowEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearShowEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get showPhone => $_getBF(2);
  @$pb.TagNumber(3)
  set showPhone($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShowPhone() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowPhone() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get showLocation => $_getBF(3);
  @$pb.TagNumber(4)
  set showLocation($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowLocation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get allowTags => $_getBF(4);
  @$pb.TagNumber(5)
  set allowTags($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAllowTags() => $_has(4);
  @$pb.TagNumber(5)
  void clearAllowTags() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get allowMentions => $_getBF(5);
  @$pb.TagNumber(6)
  set allowMentions($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAllowMentions() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllowMentions() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get searchable => $_getBF(6);
  @$pb.TagNumber(7)
  set searchable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSearchable() => $_has(6);
  @$pb.TagNumber(7)
  void clearSearchable() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get showOnlineStatus => $_getBF(7);
  @$pb.TagNumber(8)
  set showOnlineStatus($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasShowOnlineStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearShowOnlineStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get showLastSeen => $_getBF(8);
  @$pb.TagNumber(9)
  set showLastSeen($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasShowLastSeen() => $_has(8);
  @$pb.TagNumber(9)
  void clearShowLastSeen() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get allowDirectMessages => $_getBF(9);
  @$pb.TagNumber(10)
  set allowDirectMessages($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAllowDirectMessages() => $_has(9);
  @$pb.TagNumber(10)
  void clearAllowDirectMessages() => $_clearField(10);
}

class DisplaySettings extends $pb.GeneratedMessage {
  factory DisplaySettings({
    $core.String? theme,
    $core.String? fontSize,
    $core.bool? compactMode,
    $core.bool? showThumbnails,
    $core.bool? highContrast,
    $core.String? dateFormat,
    $core.String? timeFormat,
  }) {
    final result = create();
    if (theme != null) result.theme = theme;
    if (fontSize != null) result.fontSize = fontSize;
    if (compactMode != null) result.compactMode = compactMode;
    if (showThumbnails != null) result.showThumbnails = showThumbnails;
    if (highContrast != null) result.highContrast = highContrast;
    if (dateFormat != null) result.dateFormat = dateFormat;
    if (timeFormat != null) result.timeFormat = timeFormat;
    return result;
  }

  DisplaySettings._();

  factory DisplaySettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisplaySettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisplaySettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'theme')
    ..aOS(2, _omitFieldNames ? '' : 'fontSize')
    ..aOB(3, _omitFieldNames ? '' : 'compactMode')
    ..aOB(4, _omitFieldNames ? '' : 'showThumbnails')
    ..aOB(5, _omitFieldNames ? '' : 'highContrast')
    ..aOS(6, _omitFieldNames ? '' : 'dateFormat')
    ..aOS(7, _omitFieldNames ? '' : 'timeFormat')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisplaySettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisplaySettings copyWith(void Function(DisplaySettings) updates) =>
      super.copyWith((message) => updates(message as DisplaySettings))
          as DisplaySettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisplaySettings create() => DisplaySettings._();
  @$core.override
  DisplaySettings createEmptyInstance() => create();
  static $pb.PbList<DisplaySettings> createRepeated() =>
      $pb.PbList<DisplaySettings>();
  @$core.pragma('dart2js:noInline')
  static DisplaySettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisplaySettings>(create);
  static DisplaySettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get theme => $_getSZ(0);
  @$pb.TagNumber(1)
  set theme($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTheme() => $_has(0);
  @$pb.TagNumber(1)
  void clearTheme() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fontSize => $_getSZ(1);
  @$pb.TagNumber(2)
  set fontSize($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFontSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearFontSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get compactMode => $_getBF(2);
  @$pb.TagNumber(3)
  set compactMode($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCompactMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompactMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get showThumbnails => $_getBF(3);
  @$pb.TagNumber(4)
  set showThumbnails($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowThumbnails() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowThumbnails() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get highContrast => $_getBF(4);
  @$pb.TagNumber(5)
  set highContrast($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHighContrast() => $_has(4);
  @$pb.TagNumber(5)
  void clearHighContrast() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dateFormat => $_getSZ(5);
  @$pb.TagNumber(6)
  set dateFormat($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDateFormat() => $_has(5);
  @$pb.TagNumber(6)
  void clearDateFormat() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get timeFormat => $_getSZ(6);
  @$pb.TagNumber(7)
  set timeFormat($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTimeFormat() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeFormat() => $_clearField(7);
}

class UserStats extends $pb.GeneratedMessage {
  factory UserStats({
    $fixnum.Int64? totalPosts,
    $fixnum.Int64? totalComments,
    $fixnum.Int64? totalLikes,
    $fixnum.Int64? totalShares,
    $fixnum.Int64? totalViews,
    $fixnum.Int64? followerCount,
    $fixnum.Int64? followingCount,
    $fixnum.Int64? totalPurchases,
    $core.double? totalSpent,
    $core.int? engagementScore,
    $core.int? influenceScore,
    $core.Iterable<Achievement>? achievements,
  }) {
    final result = create();
    if (totalPosts != null) result.totalPosts = totalPosts;
    if (totalComments != null) result.totalComments = totalComments;
    if (totalLikes != null) result.totalLikes = totalLikes;
    if (totalShares != null) result.totalShares = totalShares;
    if (totalViews != null) result.totalViews = totalViews;
    if (followerCount != null) result.followerCount = followerCount;
    if (followingCount != null) result.followingCount = followingCount;
    if (totalPurchases != null) result.totalPurchases = totalPurchases;
    if (totalSpent != null) result.totalSpent = totalSpent;
    if (engagementScore != null) result.engagementScore = engagementScore;
    if (influenceScore != null) result.influenceScore = influenceScore;
    if (achievements != null) result.achievements.addAll(achievements);
    return result;
  }

  UserStats._();

  factory UserStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'totalPosts', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'totalComments', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'totalLikes', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'totalShares', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'totalViews', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'followerCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'followingCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'totalPurchases', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(9, _omitFieldNames ? '' : 'totalSpent')
    ..aI(10, _omitFieldNames ? '' : 'engagementScore',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'influenceScore',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<Achievement>(12, _omitFieldNames ? '' : 'achievements',
        subBuilder: Achievement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserStats copyWith(void Function(UserStats) updates) =>
      super.copyWith((message) => updates(message as UserStats)) as UserStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserStats create() => UserStats._();
  @$core.override
  UserStats createEmptyInstance() => create();
  static $pb.PbList<UserStats> createRepeated() => $pb.PbList<UserStats>();
  @$core.pragma('dart2js:noInline')
  static UserStats getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserStats>(create);
  static UserStats? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalPosts => $_getI64(0);
  @$pb.TagNumber(1)
  set totalPosts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalPosts() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalPosts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalComments => $_getI64(1);
  @$pb.TagNumber(2)
  set totalComments($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalComments() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalComments() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalLikes => $_getI64(2);
  @$pb.TagNumber(3)
  set totalLikes($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalLikes() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalLikes() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalShares => $_getI64(3);
  @$pb.TagNumber(4)
  set totalShares($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalShares() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalShares() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get totalViews => $_getI64(4);
  @$pb.TagNumber(5)
  set totalViews($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalViews() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalViews() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get followerCount => $_getI64(5);
  @$pb.TagNumber(6)
  set followerCount($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFollowerCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearFollowerCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get followingCount => $_getI64(6);
  @$pb.TagNumber(7)
  set followingCount($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowingCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowingCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get totalPurchases => $_getI64(7);
  @$pb.TagNumber(8)
  set totalPurchases($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalPurchases() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalPurchases() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get totalSpent => $_getN(8);
  @$pb.TagNumber(9)
  set totalSpent($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotalSpent() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalSpent() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get engagementScore => $_getIZ(9);
  @$pb.TagNumber(10)
  set engagementScore($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEngagementScore() => $_has(9);
  @$pb.TagNumber(10)
  void clearEngagementScore() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get influenceScore => $_getIZ(10);
  @$pb.TagNumber(11)
  set influenceScore($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInfluenceScore() => $_has(10);
  @$pb.TagNumber(11)
  void clearInfluenceScore() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<Achievement> get achievements => $_getList(11);
}

class Achievement extends $pb.GeneratedMessage {
  factory Achievement({
    $core.String? achievementId,
    $core.String? name,
    $core.String? description,
    $core.String? iconUrl,
    $fixnum.Int64? unlockedAt,
    $core.int? points,
  }) {
    final result = create();
    if (achievementId != null) result.achievementId = achievementId;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (iconUrl != null) result.iconUrl = iconUrl;
    if (unlockedAt != null) result.unlockedAt = unlockedAt;
    if (points != null) result.points = points;
    return result;
  }

  Achievement._();

  factory Achievement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Achievement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Achievement',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'achievementId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'iconUrl')
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'unlockedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(6, _omitFieldNames ? '' : 'points')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Achievement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Achievement copyWith(void Function(Achievement) updates) =>
      super.copyWith((message) => updates(message as Achievement))
          as Achievement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Achievement create() => Achievement._();
  @$core.override
  Achievement createEmptyInstance() => create();
  static $pb.PbList<Achievement> createRepeated() => $pb.PbList<Achievement>();
  @$core.pragma('dart2js:noInline')
  static Achievement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Achievement>(create);
  static Achievement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get achievementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set achievementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAchievementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAchievementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get iconUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set iconUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIconUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearIconUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get unlockedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set unlockedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnlockedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnlockedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get points => $_getIZ(5);
  @$pb.TagNumber(6)
  set points($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPoints() => $_has(5);
  @$pb.TagNumber(6)
  void clearPoints() => $_clearField(6);
}

class SocialLink extends $pb.GeneratedMessage {
  factory SocialLink({
    $core.String? platform,
    $core.String? url,
    $core.String? username,
    $core.bool? verified,
  }) {
    final result = create();
    if (platform != null) result.platform = platform;
    if (url != null) result.url = url;
    if (username != null) result.username = username;
    if (verified != null) result.verified = verified;
    return result;
  }

  SocialLink._();

  factory SocialLink.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SocialLink.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SocialLink',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aOS(3, _omitFieldNames ? '' : 'username')
    ..aOB(4, _omitFieldNames ? '' : 'verified')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SocialLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SocialLink copyWith(void Function(SocialLink) updates) =>
      super.copyWith((message) => updates(message as SocialLink)) as SocialLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SocialLink create() => SocialLink._();
  @$core.override
  SocialLink createEmptyInstance() => create();
  static $pb.PbList<SocialLink> createRepeated() => $pb.PbList<SocialLink>();
  @$core.pragma('dart2js:noInline')
  static SocialLink getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SocialLink>(create);
  static SocialLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get username => $_getSZ(2);
  @$pb.TagNumber(3)
  set username($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsername() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get verified => $_getBF(3);
  @$pb.TagNumber(4)
  set verified($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVerified() => $_has(3);
  @$pb.TagNumber(4)
  void clearVerified() => $_clearField(4);
}

class PaymentMethod extends $pb.GeneratedMessage {
  factory PaymentMethod({
    $core.String? paymentMethodId,
    PaymentType? type,
    $core.String? lastFourDigits,
    $core.String? cardBrand,
    $core.int? expiryMonth,
    $core.int? expiryYear,
    $core.String? billingAddressId,
    $core.bool? isDefault,
    $core.String? provider,
  }) {
    final result = create();
    if (paymentMethodId != null) result.paymentMethodId = paymentMethodId;
    if (type != null) result.type = type;
    if (lastFourDigits != null) result.lastFourDigits = lastFourDigits;
    if (cardBrand != null) result.cardBrand = cardBrand;
    if (expiryMonth != null) result.expiryMonth = expiryMonth;
    if (expiryYear != null) result.expiryYear = expiryYear;
    if (billingAddressId != null) result.billingAddressId = billingAddressId;
    if (isDefault != null) result.isDefault = isDefault;
    if (provider != null) result.provider = provider;
    return result;
  }

  PaymentMethod._();

  factory PaymentMethod.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PaymentMethod.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaymentMethod',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymentMethodId')
    ..aE<PaymentType>(2, _omitFieldNames ? '' : 'type',
        enumValues: PaymentType.values)
    ..aOS(3, _omitFieldNames ? '' : 'lastFourDigits')
    ..aOS(4, _omitFieldNames ? '' : 'cardBrand')
    ..aI(5, _omitFieldNames ? '' : 'expiryMonth',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'expiryYear', fieldType: $pb.PbFieldType.OU3)
    ..aOS(7, _omitFieldNames ? '' : 'billingAddressId')
    ..aOB(8, _omitFieldNames ? '' : 'isDefault')
    ..aOS(9, _omitFieldNames ? '' : 'provider')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentMethod clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentMethod copyWith(void Function(PaymentMethod) updates) =>
      super.copyWith((message) => updates(message as PaymentMethod))
          as PaymentMethod;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PaymentMethod create() => PaymentMethod._();
  @$core.override
  PaymentMethod createEmptyInstance() => create();
  static $pb.PbList<PaymentMethod> createRepeated() =>
      $pb.PbList<PaymentMethod>();
  @$core.pragma('dart2js:noInline')
  static PaymentMethod getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaymentMethod>(create);
  static PaymentMethod? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentMethodId => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentMethodId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPaymentMethodId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentMethodId() => $_clearField(1);

  @$pb.TagNumber(2)
  PaymentType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(PaymentType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lastFourDigits => $_getSZ(2);
  @$pb.TagNumber(3)
  set lastFourDigits($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastFourDigits() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastFourDigits() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cardBrand => $_getSZ(3);
  @$pb.TagNumber(4)
  set cardBrand($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCardBrand() => $_has(3);
  @$pb.TagNumber(4)
  void clearCardBrand() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get expiryMonth => $_getIZ(4);
  @$pb.TagNumber(5)
  set expiryMonth($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiryMonth() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiryMonth() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get expiryYear => $_getIZ(5);
  @$pb.TagNumber(6)
  set expiryYear($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiryYear() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiryYear() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get billingAddressId => $_getSZ(6);
  @$pb.TagNumber(7)
  set billingAddressId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBillingAddressId() => $_has(6);
  @$pb.TagNumber(7)
  void clearBillingAddressId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDefault => $_getBF(7);
  @$pb.TagNumber(8)
  set isDefault($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDefault() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDefault() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get provider => $_getSZ(8);
  @$pb.TagNumber(9)
  set provider($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasProvider() => $_has(8);
  @$pb.TagNumber(9)
  void clearProvider() => $_clearField(9);
}

class Subscription extends $pb.GeneratedMessage {
  factory Subscription({
    $core.String? subscriptionId,
    $core.String? planId,
    $core.String? planName,
    $core.double? price,
    $core.String? currency,
    SubscriptionStatus? status,
    $fixnum.Int64? startDate,
    $fixnum.Int64? endDate,
    $fixnum.Int64? nextBillingDate,
    $core.bool? autoRenew,
  }) {
    final result = create();
    if (subscriptionId != null) result.subscriptionId = subscriptionId;
    if (planId != null) result.planId = planId;
    if (planName != null) result.planName = planName;
    if (price != null) result.price = price;
    if (currency != null) result.currency = currency;
    if (status != null) result.status = status;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (nextBillingDate != null) result.nextBillingDate = nextBillingDate;
    if (autoRenew != null) result.autoRenew = autoRenew;
    return result;
  }

  Subscription._();

  factory Subscription.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Subscription.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Subscription',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subscriptionId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOS(3, _omitFieldNames ? '' : 'planName')
    ..aD(4, _omitFieldNames ? '' : 'price')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..aE<SubscriptionStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: SubscriptionStatus.values)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'startDate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'endDate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'nextBillingDate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(10, _omitFieldNames ? '' : 'autoRenew')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subscription clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subscription copyWith(void Function(Subscription) updates) =>
      super.copyWith((message) => updates(message as Subscription))
          as Subscription;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Subscription create() => Subscription._();
  @$core.override
  Subscription createEmptyInstance() => create();
  static $pb.PbList<Subscription> createRepeated() =>
      $pb.PbList<Subscription>();
  @$core.pragma('dart2js:noInline')
  static Subscription getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Subscription>(create);
  static Subscription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subscriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subscriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscriptionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get planName => $_getSZ(2);
  @$pb.TagNumber(3)
  set planName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlanName() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlanName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);

  @$pb.TagNumber(6)
  SubscriptionStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(SubscriptionStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get startDate => $_getI64(6);
  @$pb.TagNumber(7)
  set startDate($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStartDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartDate() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get endDate => $_getI64(7);
  @$pb.TagNumber(8)
  set endDate($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEndDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearEndDate() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get nextBillingDate => $_getI64(8);
  @$pb.TagNumber(9)
  set nextBillingDate($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNextBillingDate() => $_has(8);
  @$pb.TagNumber(9)
  void clearNextBillingDate() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get autoRenew => $_getBF(9);
  @$pb.TagNumber(10)
  set autoRenew($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAutoRenew() => $_has(9);
  @$pb.TagNumber(10)
  void clearAutoRenew() => $_clearField(10);
}

/// Post/Content with rich media
class Post extends $pb.GeneratedMessage {
  factory Post({
    $fixnum.Int64? postId,
    $fixnum.Int64? userId,
    $core.String? username,
    $core.String? userAvatarUrl,
    PostType? type,
    $core.String? title,
    $core.String? content,
    $core.Iterable<MediaAttachment>? media,
    $core.Iterable<$core.String>? hashtags,
    $core.Iterable<UserMention>? mentions,
    Location? location,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    PostStats? stats,
    PostSettings? settings,
    $core.Iterable<Comment>? comments,
    $core.Iterable<Reaction>? reactions,
    $core.Iterable<$core.String>? categoryIds,
    $core.String? language,
    $core.Iterable<Translation>? translations,
    $core.bool? isEdited,
    $core.bool? isPinned,
    $core.bool? isSponsored,
    $core.String? sponsorName,
    $core.Iterable<Link>? links,
    $core.Iterable<Poll>? polls,
    $core.Iterable<Tag>? tags,
    $core.List<$core.int>? customData,
    $fixnum.Int64? sharedPostId,
    $core.String? shareComment,
  }) {
    final result = create();
    if (postId != null) result.postId = postId;
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (userAvatarUrl != null) result.userAvatarUrl = userAvatarUrl;
    if (type != null) result.type = type;
    if (title != null) result.title = title;
    if (content != null) result.content = content;
    if (media != null) result.media.addAll(media);
    if (hashtags != null) result.hashtags.addAll(hashtags);
    if (mentions != null) result.mentions.addAll(mentions);
    if (location != null) result.location = location;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (stats != null) result.stats = stats;
    if (settings != null) result.settings = settings;
    if (comments != null) result.comments.addAll(comments);
    if (reactions != null) result.reactions.addAll(reactions);
    if (categoryIds != null) result.categoryIds.addAll(categoryIds);
    if (language != null) result.language = language;
    if (translations != null) result.translations.addAll(translations);
    if (isEdited != null) result.isEdited = isEdited;
    if (isPinned != null) result.isPinned = isPinned;
    if (isSponsored != null) result.isSponsored = isSponsored;
    if (sponsorName != null) result.sponsorName = sponsorName;
    if (links != null) result.links.addAll(links);
    if (polls != null) result.polls.addAll(polls);
    if (tags != null) result.tags.addAll(tags);
    if (customData != null) result.customData = customData;
    if (sharedPostId != null) result.sharedPostId = sharedPostId;
    if (shareComment != null) result.shareComment = shareComment;
    return result;
  }

  Post._();

  factory Post.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Post.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Post',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'postId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'username')
    ..aOS(4, _omitFieldNames ? '' : 'userAvatarUrl')
    ..aE<PostType>(5, _omitFieldNames ? '' : 'type',
        enumValues: PostType.values)
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'content')
    ..pPM<MediaAttachment>(8, _omitFieldNames ? '' : 'media',
        subBuilder: MediaAttachment.create)
    ..pPS(9, _omitFieldNames ? '' : 'hashtags')
    ..pPM<UserMention>(10, _omitFieldNames ? '' : 'mentions',
        subBuilder: UserMention.create)
    ..aOM<Location>(11, _omitFieldNames ? '' : 'location',
        subBuilder: Location.create)
    ..a<$fixnum.Int64>(
        12, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        13, _omitFieldNames ? '' : 'updatedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<PostStats>(14, _omitFieldNames ? '' : 'stats',
        subBuilder: PostStats.create)
    ..aOM<PostSettings>(15, _omitFieldNames ? '' : 'settings',
        subBuilder: PostSettings.create)
    ..pPM<Comment>(16, _omitFieldNames ? '' : 'comments',
        subBuilder: Comment.create)
    ..pPM<Reaction>(17, _omitFieldNames ? '' : 'reactions',
        subBuilder: Reaction.create)
    ..pPS(18, _omitFieldNames ? '' : 'categoryIds')
    ..aOS(19, _omitFieldNames ? '' : 'language')
    ..pPM<Translation>(20, _omitFieldNames ? '' : 'translations',
        subBuilder: Translation.create)
    ..aOB(21, _omitFieldNames ? '' : 'isEdited')
    ..aOB(22, _omitFieldNames ? '' : 'isPinned')
    ..aOB(23, _omitFieldNames ? '' : 'isSponsored')
    ..aOS(24, _omitFieldNames ? '' : 'sponsorName')
    ..pPM<Link>(25, _omitFieldNames ? '' : 'links', subBuilder: Link.create)
    ..pPM<Poll>(26, _omitFieldNames ? '' : 'polls', subBuilder: Poll.create)
    ..pPM<Tag>(27, _omitFieldNames ? '' : 'tags', subBuilder: Tag.create)
    ..a<$core.List<$core.int>>(
        28, _omitFieldNames ? '' : 'customData', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(
        29, _omitFieldNames ? '' : 'sharedPostId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(30, _omitFieldNames ? '' : 'shareComment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Post clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Post copyWith(void Function(Post) updates) =>
      super.copyWith((message) => updates(message as Post)) as Post;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Post create() => Post._();
  @$core.override
  Post createEmptyInstance() => create();
  static $pb.PbList<Post> createRepeated() => $pb.PbList<Post>();
  @$core.pragma('dart2js:noInline')
  static Post getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Post>(create);
  static Post? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get postId => $_getI64(0);
  @$pb.TagNumber(1)
  set postId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPostId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get userId => $_getI64(1);
  @$pb.TagNumber(2)
  set userId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get username => $_getSZ(2);
  @$pb.TagNumber(3)
  set username($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsername() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userAvatarUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set userAvatarUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserAvatarUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserAvatarUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  PostType get type => $_getN(4);
  @$pb.TagNumber(5)
  set type(PostType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get content => $_getSZ(6);
  @$pb.TagNumber(7)
  set content($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearContent() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<MediaAttachment> get media => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get hashtags => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<UserMention> get mentions => $_getList(9);

  @$pb.TagNumber(11)
  Location get location => $_getN(10);
  @$pb.TagNumber(11)
  set location(Location value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLocation() => $_has(10);
  @$pb.TagNumber(11)
  void clearLocation() => $_clearField(11);
  @$pb.TagNumber(11)
  Location ensureLocation() => $_ensure(10);

  @$pb.TagNumber(12)
  $fixnum.Int64 get createdAt => $_getI64(11);
  @$pb.TagNumber(12)
  set createdAt($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get updatedAt => $_getI64(12);
  @$pb.TagNumber(13)
  set updatedAt($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasUpdatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearUpdatedAt() => $_clearField(13);

  @$pb.TagNumber(14)
  PostStats get stats => $_getN(13);
  @$pb.TagNumber(14)
  set stats(PostStats value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasStats() => $_has(13);
  @$pb.TagNumber(14)
  void clearStats() => $_clearField(14);
  @$pb.TagNumber(14)
  PostStats ensureStats() => $_ensure(13);

  @$pb.TagNumber(15)
  PostSettings get settings => $_getN(14);
  @$pb.TagNumber(15)
  set settings(PostSettings value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSettings() => $_has(14);
  @$pb.TagNumber(15)
  void clearSettings() => $_clearField(15);
  @$pb.TagNumber(15)
  PostSettings ensureSettings() => $_ensure(14);

  @$pb.TagNumber(16)
  $pb.PbList<Comment> get comments => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<Reaction> get reactions => $_getList(16);

  @$pb.TagNumber(18)
  $pb.PbList<$core.String> get categoryIds => $_getList(17);

  @$pb.TagNumber(19)
  $core.String get language => $_getSZ(18);
  @$pb.TagNumber(19)
  set language($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasLanguage() => $_has(18);
  @$pb.TagNumber(19)
  void clearLanguage() => $_clearField(19);

  @$pb.TagNumber(20)
  $pb.PbList<Translation> get translations => $_getList(19);

  @$pb.TagNumber(21)
  $core.bool get isEdited => $_getBF(20);
  @$pb.TagNumber(21)
  set isEdited($core.bool value) => $_setBool(20, value);
  @$pb.TagNumber(21)
  $core.bool hasIsEdited() => $_has(20);
  @$pb.TagNumber(21)
  void clearIsEdited() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.bool get isPinned => $_getBF(21);
  @$pb.TagNumber(22)
  set isPinned($core.bool value) => $_setBool(21, value);
  @$pb.TagNumber(22)
  $core.bool hasIsPinned() => $_has(21);
  @$pb.TagNumber(22)
  void clearIsPinned() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.bool get isSponsored => $_getBF(22);
  @$pb.TagNumber(23)
  set isSponsored($core.bool value) => $_setBool(22, value);
  @$pb.TagNumber(23)
  $core.bool hasIsSponsored() => $_has(22);
  @$pb.TagNumber(23)
  void clearIsSponsored() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get sponsorName => $_getSZ(23);
  @$pb.TagNumber(24)
  set sponsorName($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasSponsorName() => $_has(23);
  @$pb.TagNumber(24)
  void clearSponsorName() => $_clearField(24);

  @$pb.TagNumber(25)
  $pb.PbList<Link> get links => $_getList(24);

  @$pb.TagNumber(26)
  $pb.PbList<Poll> get polls => $_getList(25);

  @$pb.TagNumber(27)
  $pb.PbList<Tag> get tags => $_getList(26);

  @$pb.TagNumber(28)
  $core.List<$core.int> get customData => $_getN(27);
  @$pb.TagNumber(28)
  set customData($core.List<$core.int> value) => $_setBytes(27, value);
  @$pb.TagNumber(28)
  $core.bool hasCustomData() => $_has(27);
  @$pb.TagNumber(28)
  void clearCustomData() => $_clearField(28);

  @$pb.TagNumber(29)
  $fixnum.Int64 get sharedPostId => $_getI64(28);
  @$pb.TagNumber(29)
  set sharedPostId($fixnum.Int64 value) => $_setInt64(28, value);
  @$pb.TagNumber(29)
  $core.bool hasSharedPostId() => $_has(28);
  @$pb.TagNumber(29)
  void clearSharedPostId() => $_clearField(29);

  @$pb.TagNumber(30)
  $core.String get shareComment => $_getSZ(29);
  @$pb.TagNumber(30)
  set shareComment($core.String value) => $_setString(29, value);
  @$pb.TagNumber(30)
  $core.bool hasShareComment() => $_has(29);
  @$pb.TagNumber(30)
  void clearShareComment() => $_clearField(30);
}

class MediaAttachment extends $pb.GeneratedMessage {
  factory MediaAttachment({
    $core.String? mediaId,
    MediaType? type,
    $core.String? url,
    $core.String? thumbnailUrl,
    $core.String? previewUrl,
    $fixnum.Int64? sizeBytes,
    $core.int? width,
    $core.int? height,
    $core.int? durationSeconds,
    $core.String? mimeType,
    $core.String? altText,
    $core.Iterable<$core.String>? filters,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (type != null) result.type = type;
    if (url != null) result.url = url;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (previewUrl != null) result.previewUrl = previewUrl;
    if (sizeBytes != null) result.sizeBytes = sizeBytes;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (mimeType != null) result.mimeType = mimeType;
    if (altText != null) result.altText = altText;
    if (filters != null) result.filters.addAll(filters);
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  MediaAttachment._();

  factory MediaAttachment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaAttachment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaAttachment',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aE<MediaType>(2, _omitFieldNames ? '' : 'type',
        enumValues: MediaType.values)
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aOS(4, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aOS(5, _omitFieldNames ? '' : 'previewUrl')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'sizeBytes', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(7, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(8, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..aI(9, _omitFieldNames ? '' : 'durationSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(10, _omitFieldNames ? '' : 'mimeType')
    ..aOS(11, _omitFieldNames ? '' : 'altText')
    ..pPS(12, _omitFieldNames ? '' : 'filters')
    ..m<$core.String, $core.String>(13, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'MediaAttachment.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('benchmark'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaAttachment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaAttachment copyWith(void Function(MediaAttachment) updates) =>
      super.copyWith((message) => updates(message as MediaAttachment))
          as MediaAttachment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaAttachment create() => MediaAttachment._();
  @$core.override
  MediaAttachment createEmptyInstance() => create();
  static $pb.PbList<MediaAttachment> createRepeated() =>
      $pb.PbList<MediaAttachment>();
  @$core.pragma('dart2js:noInline')
  static MediaAttachment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaAttachment>(create);
  static MediaAttachment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  MediaType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(MediaType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get thumbnailUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set thumbnailUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasThumbnailUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearThumbnailUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get previewUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set previewUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPreviewUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearPreviewUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get sizeBytes => $_getI64(5);
  @$pb.TagNumber(6)
  set sizeBytes($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSizeBytes() => $_has(5);
  @$pb.TagNumber(6)
  void clearSizeBytes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get width => $_getIZ(6);
  @$pb.TagNumber(7)
  set width($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWidth() => $_has(6);
  @$pb.TagNumber(7)
  void clearWidth() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get height => $_getIZ(7);
  @$pb.TagNumber(8)
  set height($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHeight() => $_has(7);
  @$pb.TagNumber(8)
  void clearHeight() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get durationSeconds => $_getIZ(8);
  @$pb.TagNumber(9)
  set durationSeconds($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDurationSeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearDurationSeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get mimeType => $_getSZ(9);
  @$pb.TagNumber(10)
  set mimeType($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMimeType() => $_has(9);
  @$pb.TagNumber(10)
  void clearMimeType() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get altText => $_getSZ(10);
  @$pb.TagNumber(11)
  set altText($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAltText() => $_has(10);
  @$pb.TagNumber(11)
  void clearAltText() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get filters => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(12);
}

class UserMention extends $pb.GeneratedMessage {
  factory UserMention({
    $fixnum.Int64? userId,
    $core.String? username,
    $core.int? startIndex,
    $core.int? endIndex,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (startIndex != null) result.startIndex = startIndex;
    if (endIndex != null) result.endIndex = endIndex;
    return result;
  }

  UserMention._();

  factory UserMention.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserMention.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserMention',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aI(3, _omitFieldNames ? '' : 'startIndex', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'endIndex', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserMention clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserMention copyWith(void Function(UserMention) updates) =>
      super.copyWith((message) => updates(message as UserMention))
          as UserMention;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserMention create() => UserMention._();
  @$core.override
  UserMention createEmptyInstance() => create();
  static $pb.PbList<UserMention> createRepeated() => $pb.PbList<UserMention>();
  @$core.pragma('dart2js:noInline')
  static UserMention getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserMention>(create);
  static UserMention? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get startIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set startIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get endIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set endIndex($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEndIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndIndex() => $_clearField(4);
}

class Location extends $pb.GeneratedMessage {
  factory Location({
    $core.double? latitude,
    $core.double? longitude,
    $core.String? name,
    $core.String? address,
    $core.String? city,
    $core.String? country,
    $core.String? placeId,
  }) {
    final result = create();
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (name != null) result.name = name;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (country != null) result.country = country;
    if (placeId != null) result.placeId = placeId;
    return result;
  }

  Location._();

  factory Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Location',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'latitude')
    ..aD(2, _omitFieldNames ? '' : 'longitude')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'address')
    ..aOS(5, _omitFieldNames ? '' : 'city')
    ..aOS(6, _omitFieldNames ? '' : 'country')
    ..aOS(7, _omitFieldNames ? '' : 'placeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Location copyWith(void Function(Location) updates) =>
      super.copyWith((message) => updates(message as Location)) as Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Location create() => Location._();
  @$core.override
  Location createEmptyInstance() => create();
  static $pb.PbList<Location> createRepeated() => $pb.PbList<Location>();
  @$core.pragma('dart2js:noInline')
  static Location getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location>(create);
  static Location? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get address => $_getSZ(3);
  @$pb.TagNumber(4)
  set address($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get city => $_getSZ(4);
  @$pb.TagNumber(5)
  set city($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCity() => $_has(4);
  @$pb.TagNumber(5)
  void clearCity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get country => $_getSZ(5);
  @$pb.TagNumber(6)
  set country($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCountry() => $_has(5);
  @$pb.TagNumber(6)
  void clearCountry() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get placeId => $_getSZ(6);
  @$pb.TagNumber(7)
  set placeId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPlaceId() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlaceId() => $_clearField(7);
}

class PostStats extends $pb.GeneratedMessage {
  factory PostStats({
    $fixnum.Int64? viewCount,
    $fixnum.Int64? likeCount,
    $fixnum.Int64? commentCount,
    $fixnum.Int64? shareCount,
    $fixnum.Int64? saveCount,
    $fixnum.Int64? clickCount,
    $core.double? engagementRate,
    $core.double? viralityScore,
  }) {
    final result = create();
    if (viewCount != null) result.viewCount = viewCount;
    if (likeCount != null) result.likeCount = likeCount;
    if (commentCount != null) result.commentCount = commentCount;
    if (shareCount != null) result.shareCount = shareCount;
    if (saveCount != null) result.saveCount = saveCount;
    if (clickCount != null) result.clickCount = clickCount;
    if (engagementRate != null) result.engagementRate = engagementRate;
    if (viralityScore != null) result.viralityScore = viralityScore;
    return result;
  }

  PostStats._();

  factory PostStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PostStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'viewCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'likeCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'commentCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'shareCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'saveCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'clickCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(7, _omitFieldNames ? '' : 'engagementRate')
    ..aD(8, _omitFieldNames ? '' : 'viralityScore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostStats copyWith(void Function(PostStats) updates) =>
      super.copyWith((message) => updates(message as PostStats)) as PostStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PostStats create() => PostStats._();
  @$core.override
  PostStats createEmptyInstance() => create();
  static $pb.PbList<PostStats> createRepeated() => $pb.PbList<PostStats>();
  @$core.pragma('dart2js:noInline')
  static PostStats getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PostStats>(create);
  static PostStats? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get viewCount => $_getI64(0);
  @$pb.TagNumber(1)
  set viewCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasViewCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearViewCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get likeCount => $_getI64(1);
  @$pb.TagNumber(2)
  set likeCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLikeCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearLikeCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get commentCount => $_getI64(2);
  @$pb.TagNumber(3)
  set commentCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCommentCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommentCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get shareCount => $_getI64(3);
  @$pb.TagNumber(4)
  set shareCount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShareCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearShareCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get saveCount => $_getI64(4);
  @$pb.TagNumber(5)
  set saveCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSaveCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearSaveCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get clickCount => $_getI64(5);
  @$pb.TagNumber(6)
  set clickCount($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasClickCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearClickCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get engagementRate => $_getN(6);
  @$pb.TagNumber(7)
  set engagementRate($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEngagementRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearEngagementRate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get viralityScore => $_getN(7);
  @$pb.TagNumber(8)
  set viralityScore($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasViralityScore() => $_has(7);
  @$pb.TagNumber(8)
  void clearViralityScore() => $_clearField(8);
}

class PostSettings extends $pb.GeneratedMessage {
  factory PostSettings({
    PostVisibility? visibility,
    $core.bool? allowComments,
    $core.bool? allowShares,
    $core.bool? allowDownloads,
    $core.bool? showStats,
    $core.Iterable<$core.String>? allowedCountries,
    $fixnum.Int64? expiryDate,
  }) {
    final result = create();
    if (visibility != null) result.visibility = visibility;
    if (allowComments != null) result.allowComments = allowComments;
    if (allowShares != null) result.allowShares = allowShares;
    if (allowDownloads != null) result.allowDownloads = allowDownloads;
    if (showStats != null) result.showStats = showStats;
    if (allowedCountries != null)
      result.allowedCountries.addAll(allowedCountries);
    if (expiryDate != null) result.expiryDate = expiryDate;
    return result;
  }

  PostSettings._();

  factory PostSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PostSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aE<PostVisibility>(1, _omitFieldNames ? '' : 'visibility',
        enumValues: PostVisibility.values)
    ..aOB(2, _omitFieldNames ? '' : 'allowComments')
    ..aOB(3, _omitFieldNames ? '' : 'allowShares')
    ..aOB(4, _omitFieldNames ? '' : 'allowDownloads')
    ..aOB(5, _omitFieldNames ? '' : 'showStats')
    ..pPS(6, _omitFieldNames ? '' : 'allowedCountries')
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'expiryDate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostSettings copyWith(void Function(PostSettings) updates) =>
      super.copyWith((message) => updates(message as PostSettings))
          as PostSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PostSettings create() => PostSettings._();
  @$core.override
  PostSettings createEmptyInstance() => create();
  static $pb.PbList<PostSettings> createRepeated() =>
      $pb.PbList<PostSettings>();
  @$core.pragma('dart2js:noInline')
  static PostSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostSettings>(create);
  static PostSettings? _defaultInstance;

  @$pb.TagNumber(1)
  PostVisibility get visibility => $_getN(0);
  @$pb.TagNumber(1)
  set visibility(PostVisibility value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVisibility() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisibility() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get allowComments => $_getBF(1);
  @$pb.TagNumber(2)
  set allowComments($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAllowComments() => $_has(1);
  @$pb.TagNumber(2)
  void clearAllowComments() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get allowShares => $_getBF(2);
  @$pb.TagNumber(3)
  set allowShares($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAllowShares() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllowShares() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get allowDownloads => $_getBF(3);
  @$pb.TagNumber(4)
  set allowDownloads($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAllowDownloads() => $_has(3);
  @$pb.TagNumber(4)
  void clearAllowDownloads() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get showStats => $_getBF(4);
  @$pb.TagNumber(5)
  set showStats($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShowStats() => $_has(4);
  @$pb.TagNumber(5)
  void clearShowStats() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get allowedCountries => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get expiryDate => $_getI64(6);
  @$pb.TagNumber(7)
  set expiryDate($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExpiryDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpiryDate() => $_clearField(7);
}

class Comment extends $pb.GeneratedMessage {
  factory Comment({
    $fixnum.Int64? commentId,
    $fixnum.Int64? postId,
    $fixnum.Int64? userId,
    $core.String? username,
    $core.String? userAvatarUrl,
    $fixnum.Int64? parentCommentId,
    $core.String? content,
    $core.Iterable<MediaAttachment>? media,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    CommentStats? stats,
    $core.Iterable<Reaction>? reactions,
    $core.bool? isEdited,
    $core.bool? isPinned,
    $core.Iterable<Comment>? replies,
  }) {
    final result = create();
    if (commentId != null) result.commentId = commentId;
    if (postId != null) result.postId = postId;
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (userAvatarUrl != null) result.userAvatarUrl = userAvatarUrl;
    if (parentCommentId != null) result.parentCommentId = parentCommentId;
    if (content != null) result.content = content;
    if (media != null) result.media.addAll(media);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (stats != null) result.stats = stats;
    if (reactions != null) result.reactions.addAll(reactions);
    if (isEdited != null) result.isEdited = isEdited;
    if (isPinned != null) result.isPinned = isPinned;
    if (replies != null) result.replies.addAll(replies);
    return result;
  }

  Comment._();

  factory Comment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Comment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Comment',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'commentId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'postId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aOS(5, _omitFieldNames ? '' : 'userAvatarUrl')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'parentCommentId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(7, _omitFieldNames ? '' : 'content')
    ..pPM<MediaAttachment>(8, _omitFieldNames ? '' : 'media',
        subBuilder: MediaAttachment.create)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        10, _omitFieldNames ? '' : 'updatedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<CommentStats>(11, _omitFieldNames ? '' : 'stats',
        subBuilder: CommentStats.create)
    ..pPM<Reaction>(12, _omitFieldNames ? '' : 'reactions',
        subBuilder: Reaction.create)
    ..aOB(13, _omitFieldNames ? '' : 'isEdited')
    ..aOB(14, _omitFieldNames ? '' : 'isPinned')
    ..pPM<Comment>(15, _omitFieldNames ? '' : 'replies',
        subBuilder: Comment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Comment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Comment copyWith(void Function(Comment) updates) =>
      super.copyWith((message) => updates(message as Comment)) as Comment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Comment create() => Comment._();
  @$core.override
  Comment createEmptyInstance() => create();
  static $pb.PbList<Comment> createRepeated() => $pb.PbList<Comment>();
  @$core.pragma('dart2js:noInline')
  static Comment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Comment>(create);
  static Comment? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get commentId => $_getI64(0);
  @$pb.TagNumber(1)
  set commentId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get postId => $_getI64(1);
  @$pb.TagNumber(2)
  set postId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get userId => $_getI64(2);
  @$pb.TagNumber(3)
  set userId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get username => $_getSZ(3);
  @$pb.TagNumber(4)
  set username($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get userAvatarUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set userAvatarUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserAvatarUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserAvatarUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get parentCommentId => $_getI64(5);
  @$pb.TagNumber(6)
  set parentCommentId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParentCommentId() => $_has(5);
  @$pb.TagNumber(6)
  void clearParentCommentId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get content => $_getSZ(6);
  @$pb.TagNumber(7)
  set content($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearContent() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<MediaAttachment> get media => $_getList(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createdAt => $_getI64(8);
  @$pb.TagNumber(9)
  set createdAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get updatedAt => $_getI64(9);
  @$pb.TagNumber(10)
  set updatedAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);

  @$pb.TagNumber(11)
  CommentStats get stats => $_getN(10);
  @$pb.TagNumber(11)
  set stats(CommentStats value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStats() => $_has(10);
  @$pb.TagNumber(11)
  void clearStats() => $_clearField(11);
  @$pb.TagNumber(11)
  CommentStats ensureStats() => $_ensure(10);

  @$pb.TagNumber(12)
  $pb.PbList<Reaction> get reactions => $_getList(11);

  @$pb.TagNumber(13)
  $core.bool get isEdited => $_getBF(12);
  @$pb.TagNumber(13)
  set isEdited($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIsEdited() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsEdited() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get isPinned => $_getBF(13);
  @$pb.TagNumber(14)
  set isPinned($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasIsPinned() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsPinned() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbList<Comment> get replies => $_getList(14);
}

class CommentStats extends $pb.GeneratedMessage {
  factory CommentStats({
    $fixnum.Int64? likeCount,
    $fixnum.Int64? replyCount,
  }) {
    final result = create();
    if (likeCount != null) result.likeCount = likeCount;
    if (replyCount != null) result.replyCount = replyCount;
    return result;
  }

  CommentStats._();

  factory CommentStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommentStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommentStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'likeCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'replyCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentStats copyWith(void Function(CommentStats) updates) =>
      super.copyWith((message) => updates(message as CommentStats))
          as CommentStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommentStats create() => CommentStats._();
  @$core.override
  CommentStats createEmptyInstance() => create();
  static $pb.PbList<CommentStats> createRepeated() =>
      $pb.PbList<CommentStats>();
  @$core.pragma('dart2js:noInline')
  static CommentStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommentStats>(create);
  static CommentStats? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get likeCount => $_getI64(0);
  @$pb.TagNumber(1)
  set likeCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLikeCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearLikeCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get replyCount => $_getI64(1);
  @$pb.TagNumber(2)
  set replyCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReplyCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplyCount() => $_clearField(2);
}

class Reaction extends $pb.GeneratedMessage {
  factory Reaction({
    $fixnum.Int64? userId,
    ReactionType? type,
    $fixnum.Int64? createdAt,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (type != null) result.type = type;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Reaction._();

  factory Reaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<ReactionType>(2, _omitFieldNames ? '' : 'type',
        enumValues: ReactionType.values)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reaction copyWith(void Function(Reaction) updates) =>
      super.copyWith((message) => updates(message as Reaction)) as Reaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reaction create() => Reaction._();
  @$core.override
  Reaction createEmptyInstance() => create();
  static $pb.PbList<Reaction> createRepeated() => $pb.PbList<Reaction>();
  @$core.pragma('dart2js:noInline')
  static Reaction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reaction>(create);
  static Reaction? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  ReactionType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(ReactionType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createdAt => $_getI64(2);
  @$pb.TagNumber(3)
  set createdAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
}

class Translation extends $pb.GeneratedMessage {
  factory Translation({
    $core.String? languageCode,
    $core.String? title,
    $core.String? content,
    $core.bool? isAutoTranslated,
  }) {
    final result = create();
    if (languageCode != null) result.languageCode = languageCode;
    if (title != null) result.title = title;
    if (content != null) result.content = content;
    if (isAutoTranslated != null) result.isAutoTranslated = isAutoTranslated;
    return result;
  }

  Translation._();

  factory Translation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Translation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Translation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'languageCode')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..aOB(4, _omitFieldNames ? '' : 'isAutoTranslated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Translation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Translation copyWith(void Function(Translation) updates) =>
      super.copyWith((message) => updates(message as Translation))
          as Translation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Translation create() => Translation._();
  @$core.override
  Translation createEmptyInstance() => create();
  static $pb.PbList<Translation> createRepeated() => $pb.PbList<Translation>();
  @$core.pragma('dart2js:noInline')
  static Translation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Translation>(create);
  static Translation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get languageCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set languageCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLanguageCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanguageCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isAutoTranslated => $_getBF(3);
  @$pb.TagNumber(4)
  set isAutoTranslated($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsAutoTranslated() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsAutoTranslated() => $_clearField(4);
}

class Link extends $pb.GeneratedMessage {
  factory Link({
    $core.String? url,
    $core.String? title,
    $core.String? description,
    $core.String? imageUrl,
    $core.String? domain,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (domain != null) result.domain = domain;
    return result;
  }

  Link._();

  factory Link.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Link.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Link',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'imageUrl')
    ..aOS(5, _omitFieldNames ? '' : 'domain')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Link clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Link copyWith(void Function(Link) updates) =>
      super.copyWith((message) => updates(message as Link)) as Link;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Link create() => Link._();
  @$core.override
  Link createEmptyInstance() => create();
  static $pb.PbList<Link> createRepeated() => $pb.PbList<Link>();
  @$core.pragma('dart2js:noInline')
  static Link getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Link>(create);
  static Link? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get imageUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set imageUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImageUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearImageUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get domain => $_getSZ(4);
  @$pb.TagNumber(5)
  set domain($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDomain() => $_has(4);
  @$pb.TagNumber(5)
  void clearDomain() => $_clearField(5);
}

class Poll extends $pb.GeneratedMessage {
  factory Poll({
    $core.String? pollId,
    $core.String? question,
    $core.Iterable<PollOption>? options,
    $fixnum.Int64? totalVotes,
    $fixnum.Int64? endDate,
    $core.bool? multipleChoice,
  }) {
    final result = create();
    if (pollId != null) result.pollId = pollId;
    if (question != null) result.question = question;
    if (options != null) result.options.addAll(options);
    if (totalVotes != null) result.totalVotes = totalVotes;
    if (endDate != null) result.endDate = endDate;
    if (multipleChoice != null) result.multipleChoice = multipleChoice;
    return result;
  }

  Poll._();

  factory Poll.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Poll.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Poll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pollId')
    ..aOS(2, _omitFieldNames ? '' : 'question')
    ..pPM<PollOption>(3, _omitFieldNames ? '' : 'options',
        subBuilder: PollOption.create)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'totalVotes', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'endDate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(6, _omitFieldNames ? '' : 'multipleChoice')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Poll clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Poll copyWith(void Function(Poll) updates) =>
      super.copyWith((message) => updates(message as Poll)) as Poll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Poll create() => Poll._();
  @$core.override
  Poll createEmptyInstance() => create();
  static $pb.PbList<Poll> createRepeated() => $pb.PbList<Poll>();
  @$core.pragma('dart2js:noInline')
  static Poll getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Poll>(create);
  static Poll? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pollId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pollId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPollId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPollId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get question => $_getSZ(1);
  @$pb.TagNumber(2)
  set question($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuestion() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuestion() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<PollOption> get options => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalVotes => $_getI64(3);
  @$pb.TagNumber(4)
  set totalVotes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalVotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalVotes() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get endDate => $_getI64(4);
  @$pb.TagNumber(5)
  set endDate($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEndDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndDate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get multipleChoice => $_getBF(5);
  @$pb.TagNumber(6)
  set multipleChoice($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMultipleChoice() => $_has(5);
  @$pb.TagNumber(6)
  void clearMultipleChoice() => $_clearField(6);
}

class PollOption extends $pb.GeneratedMessage {
  factory PollOption({
    $core.String? optionId,
    $core.String? text,
    $fixnum.Int64? voteCount,
    $core.double? percentage,
  }) {
    final result = create();
    if (optionId != null) result.optionId = optionId;
    if (text != null) result.text = text;
    if (voteCount != null) result.voteCount = voteCount;
    if (percentage != null) result.percentage = percentage;
    return result;
  }

  PollOption._();

  factory PollOption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PollOption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PollOption',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'optionId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'voteCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(4, _omitFieldNames ? '' : 'percentage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollOption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollOption copyWith(void Function(PollOption) updates) =>
      super.copyWith((message) => updates(message as PollOption)) as PollOption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PollOption create() => PollOption._();
  @$core.override
  PollOption createEmptyInstance() => create();
  static $pb.PbList<PollOption> createRepeated() => $pb.PbList<PollOption>();
  @$core.pragma('dart2js:noInline')
  static PollOption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PollOption>(create);
  static PollOption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get optionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set optionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOptionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get voteCount => $_getI64(2);
  @$pb.TagNumber(3)
  set voteCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVoteCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoteCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get percentage => $_getN(3);
  @$pb.TagNumber(4)
  set percentage($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPercentage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPercentage() => $_clearField(4);
}

class Tag extends $pb.GeneratedMessage {
  factory Tag({
    $core.String? tagId,
    $core.String? name,
    $core.String? color,
  }) {
    final result = create();
    if (tagId != null) result.tagId = tagId;
    if (name != null) result.name = name;
    if (color != null) result.color = color;
    return result;
  }

  Tag._();

  factory Tag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tag',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tagId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'color')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tag copyWith(void Function(Tag) updates) =>
      super.copyWith((message) => updates(message as Tag)) as Tag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tag create() => Tag._();
  @$core.override
  Tag createEmptyInstance() => create();
  static $pb.PbList<Tag> createRepeated() => $pb.PbList<Tag>();
  @$core.pragma('dart2js:noInline')
  static Tag getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tag>(create);
  static Tag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tagId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tagId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTagId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTagId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get color => $_getSZ(2);
  @$pb.TagNumber(3)
  set color($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);
}

/// Product for e-commerce
class Product extends $pb.GeneratedMessage {
  factory Product({
    $fixnum.Int64? productId,
    $core.String? sku,
    $core.String? name,
    $core.String? description,
    $core.String? shortDescription,
    $core.Iterable<$core.String>? categoryIds,
    $core.String? brand,
    $core.double? price,
    $core.double? compareAtPrice,
    $core.double? cost,
    $core.String? currency,
    $core.Iterable<ProductVariant>? variants,
    $core.Iterable<MediaAttachment>? images,
    $core.Iterable<MediaAttachment>? videos,
    ProductInventory? inventory,
    $core.Iterable<ProductAttribute>? attributes,
    $core.Iterable<ProductReview>? reviews,
    ProductStats? stats,
    $core.Iterable<$core.String>? tags,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    ProductStatus? status,
    $core.bool? isFeatured,
    $core.bool? isNew,
    $core.bool? isOnSale,
    $core.Iterable<RelatedProduct>? relatedProducts,
    ShippingInfo? shipping,
    $core.Iterable<$core.String>? compatibleProducts,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
    SEOInfo? seo,
  }) {
    final result = create();
    if (productId != null) result.productId = productId;
    if (sku != null) result.sku = sku;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (shortDescription != null) result.shortDescription = shortDescription;
    if (categoryIds != null) result.categoryIds.addAll(categoryIds);
    if (brand != null) result.brand = brand;
    if (price != null) result.price = price;
    if (compareAtPrice != null) result.compareAtPrice = compareAtPrice;
    if (cost != null) result.cost = cost;
    if (currency != null) result.currency = currency;
    if (variants != null) result.variants.addAll(variants);
    if (images != null) result.images.addAll(images);
    if (videos != null) result.videos.addAll(videos);
    if (inventory != null) result.inventory = inventory;
    if (attributes != null) result.attributes.addAll(attributes);
    if (reviews != null) result.reviews.addAll(reviews);
    if (stats != null) result.stats = stats;
    if (tags != null) result.tags.addAll(tags);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (status != null) result.status = status;
    if (isFeatured != null) result.isFeatured = isFeatured;
    if (isNew != null) result.isNew = isNew;
    if (isOnSale != null) result.isOnSale = isOnSale;
    if (relatedProducts != null) result.relatedProducts.addAll(relatedProducts);
    if (shipping != null) result.shipping = shipping;
    if (compatibleProducts != null)
      result.compatibleProducts.addAll(compatibleProducts);
    if (metadata != null) result.metadata.addEntries(metadata);
    if (seo != null) result.seo = seo;
    return result;
  }

  Product._();

  factory Product.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Product.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Product',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'productId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'sku')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'shortDescription')
    ..pPS(6, _omitFieldNames ? '' : 'categoryIds')
    ..aOS(7, _omitFieldNames ? '' : 'brand')
    ..aD(8, _omitFieldNames ? '' : 'price')
    ..aD(9, _omitFieldNames ? '' : 'compareAtPrice')
    ..aD(10, _omitFieldNames ? '' : 'cost')
    ..aOS(11, _omitFieldNames ? '' : 'currency')
    ..pPM<ProductVariant>(12, _omitFieldNames ? '' : 'variants',
        subBuilder: ProductVariant.create)
    ..pPM<MediaAttachment>(13, _omitFieldNames ? '' : 'images',
        subBuilder: MediaAttachment.create)
    ..pPM<MediaAttachment>(14, _omitFieldNames ? '' : 'videos',
        subBuilder: MediaAttachment.create)
    ..aOM<ProductInventory>(15, _omitFieldNames ? '' : 'inventory',
        subBuilder: ProductInventory.create)
    ..pPM<ProductAttribute>(16, _omitFieldNames ? '' : 'attributes',
        subBuilder: ProductAttribute.create)
    ..pPM<ProductReview>(17, _omitFieldNames ? '' : 'reviews',
        subBuilder: ProductReview.create)
    ..aOM<ProductStats>(18, _omitFieldNames ? '' : 'stats',
        subBuilder: ProductStats.create)
    ..pPS(19, _omitFieldNames ? '' : 'tags')
    ..a<$fixnum.Int64>(
        20, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        21, _omitFieldNames ? '' : 'updatedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<ProductStatus>(22, _omitFieldNames ? '' : 'status',
        enumValues: ProductStatus.values)
    ..aOB(23, _omitFieldNames ? '' : 'isFeatured')
    ..aOB(24, _omitFieldNames ? '' : 'isNew')
    ..aOB(25, _omitFieldNames ? '' : 'isOnSale')
    ..pPM<RelatedProduct>(26, _omitFieldNames ? '' : 'relatedProducts',
        subBuilder: RelatedProduct.create)
    ..aOM<ShippingInfo>(27, _omitFieldNames ? '' : 'shipping',
        subBuilder: ShippingInfo.create)
    ..pPS(28, _omitFieldNames ? '' : 'compatibleProducts')
    ..m<$core.String, $core.String>(29, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'Product.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('benchmark'))
    ..aOM<SEOInfo>(30, _omitFieldNames ? '' : 'seo', subBuilder: SEOInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Product clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Product copyWith(void Function(Product) updates) =>
      super.copyWith((message) => updates(message as Product)) as Product;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Product create() => Product._();
  @$core.override
  Product createEmptyInstance() => create();
  static $pb.PbList<Product> createRepeated() => $pb.PbList<Product>();
  @$core.pragma('dart2js:noInline')
  static Product getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Product>(create);
  static Product? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get productId => $_getI64(0);
  @$pb.TagNumber(1)
  set productId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sku => $_getSZ(1);
  @$pb.TagNumber(2)
  set sku($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSku() => $_has(1);
  @$pb.TagNumber(2)
  void clearSku() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get shortDescription => $_getSZ(4);
  @$pb.TagNumber(5)
  set shortDescription($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShortDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearShortDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get categoryIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get brand => $_getSZ(6);
  @$pb.TagNumber(7)
  set brand($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBrand() => $_has(6);
  @$pb.TagNumber(7)
  void clearBrand() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get price => $_getN(7);
  @$pb.TagNumber(8)
  set price($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPrice() => $_has(7);
  @$pb.TagNumber(8)
  void clearPrice() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get compareAtPrice => $_getN(8);
  @$pb.TagNumber(9)
  set compareAtPrice($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCompareAtPrice() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompareAtPrice() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get cost => $_getN(9);
  @$pb.TagNumber(10)
  set cost($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCost() => $_has(9);
  @$pb.TagNumber(10)
  void clearCost() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get currency => $_getSZ(10);
  @$pb.TagNumber(11)
  set currency($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCurrency() => $_has(10);
  @$pb.TagNumber(11)
  void clearCurrency() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<ProductVariant> get variants => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbList<MediaAttachment> get images => $_getList(12);

  @$pb.TagNumber(14)
  $pb.PbList<MediaAttachment> get videos => $_getList(13);

  @$pb.TagNumber(15)
  ProductInventory get inventory => $_getN(14);
  @$pb.TagNumber(15)
  set inventory(ProductInventory value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasInventory() => $_has(14);
  @$pb.TagNumber(15)
  void clearInventory() => $_clearField(15);
  @$pb.TagNumber(15)
  ProductInventory ensureInventory() => $_ensure(14);

  @$pb.TagNumber(16)
  $pb.PbList<ProductAttribute> get attributes => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<ProductReview> get reviews => $_getList(16);

  @$pb.TagNumber(18)
  ProductStats get stats => $_getN(17);
  @$pb.TagNumber(18)
  set stats(ProductStats value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasStats() => $_has(17);
  @$pb.TagNumber(18)
  void clearStats() => $_clearField(18);
  @$pb.TagNumber(18)
  ProductStats ensureStats() => $_ensure(17);

  @$pb.TagNumber(19)
  $pb.PbList<$core.String> get tags => $_getList(18);

  @$pb.TagNumber(20)
  $fixnum.Int64 get createdAt => $_getI64(19);
  @$pb.TagNumber(20)
  set createdAt($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedAt() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get updatedAt => $_getI64(20);
  @$pb.TagNumber(21)
  set updatedAt($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasUpdatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearUpdatedAt() => $_clearField(21);

  @$pb.TagNumber(22)
  ProductStatus get status => $_getN(21);
  @$pb.TagNumber(22)
  set status(ProductStatus value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasStatus() => $_has(21);
  @$pb.TagNumber(22)
  void clearStatus() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.bool get isFeatured => $_getBF(22);
  @$pb.TagNumber(23)
  set isFeatured($core.bool value) => $_setBool(22, value);
  @$pb.TagNumber(23)
  $core.bool hasIsFeatured() => $_has(22);
  @$pb.TagNumber(23)
  void clearIsFeatured() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.bool get isNew => $_getBF(23);
  @$pb.TagNumber(24)
  set isNew($core.bool value) => $_setBool(23, value);
  @$pb.TagNumber(24)
  $core.bool hasIsNew() => $_has(23);
  @$pb.TagNumber(24)
  void clearIsNew() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.bool get isOnSale => $_getBF(24);
  @$pb.TagNumber(25)
  set isOnSale($core.bool value) => $_setBool(24, value);
  @$pb.TagNumber(25)
  $core.bool hasIsOnSale() => $_has(24);
  @$pb.TagNumber(25)
  void clearIsOnSale() => $_clearField(25);

  @$pb.TagNumber(26)
  $pb.PbList<RelatedProduct> get relatedProducts => $_getList(25);

  @$pb.TagNumber(27)
  ShippingInfo get shipping => $_getN(26);
  @$pb.TagNumber(27)
  set shipping(ShippingInfo value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasShipping() => $_has(26);
  @$pb.TagNumber(27)
  void clearShipping() => $_clearField(27);
  @$pb.TagNumber(27)
  ShippingInfo ensureShipping() => $_ensure(26);

  @$pb.TagNumber(28)
  $pb.PbList<$core.String> get compatibleProducts => $_getList(27);

  @$pb.TagNumber(29)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(28);

  @$pb.TagNumber(30)
  SEOInfo get seo => $_getN(29);
  @$pb.TagNumber(30)
  set seo(SEOInfo value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasSeo() => $_has(29);
  @$pb.TagNumber(30)
  void clearSeo() => $_clearField(30);
  @$pb.TagNumber(30)
  SEOInfo ensureSeo() => $_ensure(29);
}

class ProductVariant extends $pb.GeneratedMessage {
  factory ProductVariant({
    $core.String? variantId,
    $core.String? sku,
    $core.String? name,
    $core.double? price,
    $core.Iterable<VariantOption>? options,
    $core.String? imageUrl,
    $core.int? stockQuantity,
    $core.double? weight,
    Dimensions? dimensions,
    $core.String? barcode,
  }) {
    final result = create();
    if (variantId != null) result.variantId = variantId;
    if (sku != null) result.sku = sku;
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (options != null) result.options.addAll(options);
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (stockQuantity != null) result.stockQuantity = stockQuantity;
    if (weight != null) result.weight = weight;
    if (dimensions != null) result.dimensions = dimensions;
    if (barcode != null) result.barcode = barcode;
    return result;
  }

  ProductVariant._();

  factory ProductVariant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProductVariant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProductVariant',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'variantId')
    ..aOS(2, _omitFieldNames ? '' : 'sku')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aD(4, _omitFieldNames ? '' : 'price')
    ..pPM<VariantOption>(5, _omitFieldNames ? '' : 'options',
        subBuilder: VariantOption.create)
    ..aOS(6, _omitFieldNames ? '' : 'imageUrl')
    ..aI(7, _omitFieldNames ? '' : 'stockQuantity')
    ..aD(8, _omitFieldNames ? '' : 'weight')
    ..aOM<Dimensions>(9, _omitFieldNames ? '' : 'dimensions',
        subBuilder: Dimensions.create)
    ..aOS(10, _omitFieldNames ? '' : 'barcode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductVariant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductVariant copyWith(void Function(ProductVariant) updates) =>
      super.copyWith((message) => updates(message as ProductVariant))
          as ProductVariant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProductVariant create() => ProductVariant._();
  @$core.override
  ProductVariant createEmptyInstance() => create();
  static $pb.PbList<ProductVariant> createRepeated() =>
      $pb.PbList<ProductVariant>();
  @$core.pragma('dart2js:noInline')
  static ProductVariant getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProductVariant>(create);
  static ProductVariant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get variantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set variantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVariantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVariantId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sku => $_getSZ(1);
  @$pb.TagNumber(2)
  set sku($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSku() => $_has(1);
  @$pb.TagNumber(2)
  void clearSku() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<VariantOption> get options => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get imageUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set imageUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImageUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearImageUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get stockQuantity => $_getIZ(6);
  @$pb.TagNumber(7)
  set stockQuantity($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStockQuantity() => $_has(6);
  @$pb.TagNumber(7)
  void clearStockQuantity() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get weight => $_getN(7);
  @$pb.TagNumber(8)
  set weight($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWeight() => $_has(7);
  @$pb.TagNumber(8)
  void clearWeight() => $_clearField(8);

  @$pb.TagNumber(9)
  Dimensions get dimensions => $_getN(8);
  @$pb.TagNumber(9)
  set dimensions(Dimensions value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDimensions() => $_has(8);
  @$pb.TagNumber(9)
  void clearDimensions() => $_clearField(9);
  @$pb.TagNumber(9)
  Dimensions ensureDimensions() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get barcode => $_getSZ(9);
  @$pb.TagNumber(10)
  set barcode($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBarcode() => $_has(9);
  @$pb.TagNumber(10)
  void clearBarcode() => $_clearField(10);
}

class VariantOption extends $pb.GeneratedMessage {
  factory VariantOption({
    $core.String? name,
    $core.String? value,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (value != null) result.value = value;
    return result;
  }

  VariantOption._();

  factory VariantOption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VariantOption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VariantOption',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VariantOption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VariantOption copyWith(void Function(VariantOption) updates) =>
      super.copyWith((message) => updates(message as VariantOption))
          as VariantOption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VariantOption create() => VariantOption._();
  @$core.override
  VariantOption createEmptyInstance() => create();
  static $pb.PbList<VariantOption> createRepeated() =>
      $pb.PbList<VariantOption>();
  @$core.pragma('dart2js:noInline')
  static VariantOption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VariantOption>(create);
  static VariantOption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class ProductInventory extends $pb.GeneratedMessage {
  factory ProductInventory({
    $core.int? stockQuantity,
    $core.int? reservedQuantity,
    $core.int? availableQuantity,
    $core.bool? trackInventory,
    $core.bool? allowBackorder,
    $core.int? lowStockThreshold,
    $core.Iterable<WarehouseStock>? warehouseStocks,
  }) {
    final result = create();
    if (stockQuantity != null) result.stockQuantity = stockQuantity;
    if (reservedQuantity != null) result.reservedQuantity = reservedQuantity;
    if (availableQuantity != null) result.availableQuantity = availableQuantity;
    if (trackInventory != null) result.trackInventory = trackInventory;
    if (allowBackorder != null) result.allowBackorder = allowBackorder;
    if (lowStockThreshold != null) result.lowStockThreshold = lowStockThreshold;
    if (warehouseStocks != null) result.warehouseStocks.addAll(warehouseStocks);
    return result;
  }

  ProductInventory._();

  factory ProductInventory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProductInventory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProductInventory',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'stockQuantity')
    ..aI(2, _omitFieldNames ? '' : 'reservedQuantity')
    ..aI(3, _omitFieldNames ? '' : 'availableQuantity')
    ..aOB(4, _omitFieldNames ? '' : 'trackInventory')
    ..aOB(5, _omitFieldNames ? '' : 'allowBackorder')
    ..aI(6, _omitFieldNames ? '' : 'lowStockThreshold')
    ..pPM<WarehouseStock>(7, _omitFieldNames ? '' : 'warehouseStocks',
        subBuilder: WarehouseStock.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductInventory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductInventory copyWith(void Function(ProductInventory) updates) =>
      super.copyWith((message) => updates(message as ProductInventory))
          as ProductInventory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProductInventory create() => ProductInventory._();
  @$core.override
  ProductInventory createEmptyInstance() => create();
  static $pb.PbList<ProductInventory> createRepeated() =>
      $pb.PbList<ProductInventory>();
  @$core.pragma('dart2js:noInline')
  static ProductInventory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProductInventory>(create);
  static ProductInventory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get stockQuantity => $_getIZ(0);
  @$pb.TagNumber(1)
  set stockQuantity($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStockQuantity() => $_has(0);
  @$pb.TagNumber(1)
  void clearStockQuantity() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get reservedQuantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set reservedQuantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReservedQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearReservedQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get availableQuantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set availableQuantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvailableQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvailableQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get trackInventory => $_getBF(3);
  @$pb.TagNumber(4)
  set trackInventory($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrackInventory() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrackInventory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get allowBackorder => $_getBF(4);
  @$pb.TagNumber(5)
  set allowBackorder($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAllowBackorder() => $_has(4);
  @$pb.TagNumber(5)
  void clearAllowBackorder() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get lowStockThreshold => $_getIZ(5);
  @$pb.TagNumber(6)
  set lowStockThreshold($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLowStockThreshold() => $_has(5);
  @$pb.TagNumber(6)
  void clearLowStockThreshold() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<WarehouseStock> get warehouseStocks => $_getList(6);
}

class WarehouseStock extends $pb.GeneratedMessage {
  factory WarehouseStock({
    $core.String? warehouseId,
    $core.String? warehouseName,
    $core.int? quantity,
    $core.String? location,
  }) {
    final result = create();
    if (warehouseId != null) result.warehouseId = warehouseId;
    if (warehouseName != null) result.warehouseName = warehouseName;
    if (quantity != null) result.quantity = quantity;
    if (location != null) result.location = location;
    return result;
  }

  WarehouseStock._();

  factory WarehouseStock.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WarehouseStock.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WarehouseStock',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'warehouseId')
    ..aOS(2, _omitFieldNames ? '' : 'warehouseName')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aOS(4, _omitFieldNames ? '' : 'location')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WarehouseStock clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WarehouseStock copyWith(void Function(WarehouseStock) updates) =>
      super.copyWith((message) => updates(message as WarehouseStock))
          as WarehouseStock;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WarehouseStock create() => WarehouseStock._();
  @$core.override
  WarehouseStock createEmptyInstance() => create();
  static $pb.PbList<WarehouseStock> createRepeated() =>
      $pb.PbList<WarehouseStock>();
  @$core.pragma('dart2js:noInline')
  static WarehouseStock getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WarehouseStock>(create);
  static WarehouseStock? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get warehouseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set warehouseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWarehouseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWarehouseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get warehouseName => $_getSZ(1);
  @$pb.TagNumber(2)
  set warehouseName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWarehouseName() => $_has(1);
  @$pb.TagNumber(2)
  void clearWarehouseName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get location => $_getSZ(3);
  @$pb.TagNumber(4)
  set location($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocation() => $_clearField(4);
}

class ProductAttribute extends $pb.GeneratedMessage {
  factory ProductAttribute({
    $core.String? name,
    $core.Iterable<$core.String>? values,
    $core.bool? isVariantAttribute,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (values != null) result.values.addAll(values);
    if (isVariantAttribute != null)
      result.isVariantAttribute = isVariantAttribute;
    return result;
  }

  ProductAttribute._();

  factory ProductAttribute.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProductAttribute.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProductAttribute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..pPS(2, _omitFieldNames ? '' : 'values')
    ..aOB(3, _omitFieldNames ? '' : 'isVariantAttribute')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductAttribute clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductAttribute copyWith(void Function(ProductAttribute) updates) =>
      super.copyWith((message) => updates(message as ProductAttribute))
          as ProductAttribute;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProductAttribute create() => ProductAttribute._();
  @$core.override
  ProductAttribute createEmptyInstance() => create();
  static $pb.PbList<ProductAttribute> createRepeated() =>
      $pb.PbList<ProductAttribute>();
  @$core.pragma('dart2js:noInline')
  static ProductAttribute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProductAttribute>(create);
  static ProductAttribute? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get values => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get isVariantAttribute => $_getBF(2);
  @$pb.TagNumber(3)
  set isVariantAttribute($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsVariantAttribute() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsVariantAttribute() => $_clearField(3);
}

class ProductReview extends $pb.GeneratedMessage {
  factory ProductReview({
    $fixnum.Int64? reviewId,
    $fixnum.Int64? userId,
    $core.String? username,
    $core.String? userAvatarUrl,
    $core.int? rating,
    $core.String? title,
    $core.String? content,
    $core.Iterable<MediaAttachment>? images,
    $fixnum.Int64? createdAt,
    ReviewStats? stats,
    $core.bool? verifiedPurchase,
    $core.String? variantId,
  }) {
    final result = create();
    if (reviewId != null) result.reviewId = reviewId;
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (userAvatarUrl != null) result.userAvatarUrl = userAvatarUrl;
    if (rating != null) result.rating = rating;
    if (title != null) result.title = title;
    if (content != null) result.content = content;
    if (images != null) result.images.addAll(images);
    if (createdAt != null) result.createdAt = createdAt;
    if (stats != null) result.stats = stats;
    if (verifiedPurchase != null) result.verifiedPurchase = verifiedPurchase;
    if (variantId != null) result.variantId = variantId;
    return result;
  }

  ProductReview._();

  factory ProductReview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProductReview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProductReview',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'reviewId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'username')
    ..aOS(4, _omitFieldNames ? '' : 'userAvatarUrl')
    ..aI(5, _omitFieldNames ? '' : 'rating', fieldType: $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'content')
    ..pPM<MediaAttachment>(8, _omitFieldNames ? '' : 'images',
        subBuilder: MediaAttachment.create)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<ReviewStats>(10, _omitFieldNames ? '' : 'stats',
        subBuilder: ReviewStats.create)
    ..aOB(11, _omitFieldNames ? '' : 'verifiedPurchase')
    ..aOS(12, _omitFieldNames ? '' : 'variantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductReview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductReview copyWith(void Function(ProductReview) updates) =>
      super.copyWith((message) => updates(message as ProductReview))
          as ProductReview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProductReview create() => ProductReview._();
  @$core.override
  ProductReview createEmptyInstance() => create();
  static $pb.PbList<ProductReview> createRepeated() =>
      $pb.PbList<ProductReview>();
  @$core.pragma('dart2js:noInline')
  static ProductReview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProductReview>(create);
  static ProductReview? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get reviewId => $_getI64(0);
  @$pb.TagNumber(1)
  set reviewId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get userId => $_getI64(1);
  @$pb.TagNumber(2)
  set userId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get username => $_getSZ(2);
  @$pb.TagNumber(3)
  set username($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsername() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userAvatarUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set userAvatarUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserAvatarUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserAvatarUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get rating => $_getIZ(4);
  @$pb.TagNumber(5)
  set rating($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRating() => $_has(4);
  @$pb.TagNumber(5)
  void clearRating() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get content => $_getSZ(6);
  @$pb.TagNumber(7)
  set content($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearContent() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<MediaAttachment> get images => $_getList(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createdAt => $_getI64(8);
  @$pb.TagNumber(9)
  set createdAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  ReviewStats get stats => $_getN(9);
  @$pb.TagNumber(10)
  set stats(ReviewStats value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStats() => $_has(9);
  @$pb.TagNumber(10)
  void clearStats() => $_clearField(10);
  @$pb.TagNumber(10)
  ReviewStats ensureStats() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get verifiedPurchase => $_getBF(10);
  @$pb.TagNumber(11)
  set verifiedPurchase($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVerifiedPurchase() => $_has(10);
  @$pb.TagNumber(11)
  void clearVerifiedPurchase() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get variantId => $_getSZ(11);
  @$pb.TagNumber(12)
  set variantId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVariantId() => $_has(11);
  @$pb.TagNumber(12)
  void clearVariantId() => $_clearField(12);
}

class ReviewStats extends $pb.GeneratedMessage {
  factory ReviewStats({
    $fixnum.Int64? helpfulCount,
    $fixnum.Int64? notHelpfulCount,
  }) {
    final result = create();
    if (helpfulCount != null) result.helpfulCount = helpfulCount;
    if (notHelpfulCount != null) result.notHelpfulCount = notHelpfulCount;
    return result;
  }

  ReviewStats._();

  factory ReviewStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'helpfulCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'notHelpfulCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewStats copyWith(void Function(ReviewStats) updates) =>
      super.copyWith((message) => updates(message as ReviewStats))
          as ReviewStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewStats create() => ReviewStats._();
  @$core.override
  ReviewStats createEmptyInstance() => create();
  static $pb.PbList<ReviewStats> createRepeated() => $pb.PbList<ReviewStats>();
  @$core.pragma('dart2js:noInline')
  static ReviewStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewStats>(create);
  static ReviewStats? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get helpfulCount => $_getI64(0);
  @$pb.TagNumber(1)
  set helpfulCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHelpfulCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearHelpfulCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get notHelpfulCount => $_getI64(1);
  @$pb.TagNumber(2)
  set notHelpfulCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotHelpfulCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotHelpfulCount() => $_clearField(2);
}

class ProductStats extends $pb.GeneratedMessage {
  factory ProductStats({
    $fixnum.Int64? viewCount,
    $fixnum.Int64? cartAddCount,
    $fixnum.Int64? purchaseCount,
    $fixnum.Int64? wishlistCount,
    $core.double? averageRating,
    $fixnum.Int64? reviewCount,
    $fixnum.Int64? shareCount,
  }) {
    final result = create();
    if (viewCount != null) result.viewCount = viewCount;
    if (cartAddCount != null) result.cartAddCount = cartAddCount;
    if (purchaseCount != null) result.purchaseCount = purchaseCount;
    if (wishlistCount != null) result.wishlistCount = wishlistCount;
    if (averageRating != null) result.averageRating = averageRating;
    if (reviewCount != null) result.reviewCount = reviewCount;
    if (shareCount != null) result.shareCount = shareCount;
    return result;
  }

  ProductStats._();

  factory ProductStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProductStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProductStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'viewCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'cartAddCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'purchaseCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'wishlistCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(5, _omitFieldNames ? '' : 'averageRating')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'reviewCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'shareCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProductStats copyWith(void Function(ProductStats) updates) =>
      super.copyWith((message) => updates(message as ProductStats))
          as ProductStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProductStats create() => ProductStats._();
  @$core.override
  ProductStats createEmptyInstance() => create();
  static $pb.PbList<ProductStats> createRepeated() =>
      $pb.PbList<ProductStats>();
  @$core.pragma('dart2js:noInline')
  static ProductStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProductStats>(create);
  static ProductStats? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get viewCount => $_getI64(0);
  @$pb.TagNumber(1)
  set viewCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasViewCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearViewCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cartAddCount => $_getI64(1);
  @$pb.TagNumber(2)
  set cartAddCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCartAddCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCartAddCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get purchaseCount => $_getI64(2);
  @$pb.TagNumber(3)
  set purchaseCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPurchaseCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurchaseCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get wishlistCount => $_getI64(3);
  @$pb.TagNumber(4)
  set wishlistCount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWishlistCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearWishlistCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get averageRating => $_getN(4);
  @$pb.TagNumber(5)
  set averageRating($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAverageRating() => $_has(4);
  @$pb.TagNumber(5)
  void clearAverageRating() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get reviewCount => $_getI64(5);
  @$pb.TagNumber(6)
  set reviewCount($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReviewCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearReviewCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get shareCount => $_getI64(6);
  @$pb.TagNumber(7)
  set shareCount($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasShareCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearShareCount() => $_clearField(7);
}

class RelatedProduct extends $pb.GeneratedMessage {
  factory RelatedProduct({
    $fixnum.Int64? productId,
    $core.String? relationType,
  }) {
    final result = create();
    if (productId != null) result.productId = productId;
    if (relationType != null) result.relationType = relationType;
    return result;
  }

  RelatedProduct._();

  factory RelatedProduct.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RelatedProduct.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelatedProduct',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'productId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'relationType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedProduct clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedProduct copyWith(void Function(RelatedProduct) updates) =>
      super.copyWith((message) => updates(message as RelatedProduct))
          as RelatedProduct;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RelatedProduct create() => RelatedProduct._();
  @$core.override
  RelatedProduct createEmptyInstance() => create();
  static $pb.PbList<RelatedProduct> createRepeated() =>
      $pb.PbList<RelatedProduct>();
  @$core.pragma('dart2js:noInline')
  static RelatedProduct getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelatedProduct>(create);
  static RelatedProduct? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get productId => $_getI64(0);
  @$pb.TagNumber(1)
  set productId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get relationType => $_getSZ(1);
  @$pb.TagNumber(2)
  set relationType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRelationType() => $_has(1);
  @$pb.TagNumber(2)
  void clearRelationType() => $_clearField(2);
}

class ShippingInfo extends $pb.GeneratedMessage {
  factory ShippingInfo({
    $core.bool? freeShipping,
    $core.double? weight,
    Dimensions? dimensions,
    $core.Iterable<ShippingMethod>? availableMethods,
    $core.String? shippingClass,
  }) {
    final result = create();
    if (freeShipping != null) result.freeShipping = freeShipping;
    if (weight != null) result.weight = weight;
    if (dimensions != null) result.dimensions = dimensions;
    if (availableMethods != null)
      result.availableMethods.addAll(availableMethods);
    if (shippingClass != null) result.shippingClass = shippingClass;
    return result;
  }

  ShippingInfo._();

  factory ShippingInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShippingInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShippingInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'freeShipping')
    ..aD(2, _omitFieldNames ? '' : 'weight')
    ..aOM<Dimensions>(3, _omitFieldNames ? '' : 'dimensions',
        subBuilder: Dimensions.create)
    ..pPM<ShippingMethod>(4, _omitFieldNames ? '' : 'availableMethods',
        subBuilder: ShippingMethod.create)
    ..aOS(5, _omitFieldNames ? '' : 'shippingClass')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShippingInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShippingInfo copyWith(void Function(ShippingInfo) updates) =>
      super.copyWith((message) => updates(message as ShippingInfo))
          as ShippingInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShippingInfo create() => ShippingInfo._();
  @$core.override
  ShippingInfo createEmptyInstance() => create();
  static $pb.PbList<ShippingInfo> createRepeated() =>
      $pb.PbList<ShippingInfo>();
  @$core.pragma('dart2js:noInline')
  static ShippingInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShippingInfo>(create);
  static ShippingInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get freeShipping => $_getBF(0);
  @$pb.TagNumber(1)
  set freeShipping($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFreeShipping() => $_has(0);
  @$pb.TagNumber(1)
  void clearFreeShipping() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get weight => $_getN(1);
  @$pb.TagNumber(2)
  set weight($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeight() => $_clearField(2);

  @$pb.TagNumber(3)
  Dimensions get dimensions => $_getN(2);
  @$pb.TagNumber(3)
  set dimensions(Dimensions value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDimensions() => $_has(2);
  @$pb.TagNumber(3)
  void clearDimensions() => $_clearField(3);
  @$pb.TagNumber(3)
  Dimensions ensureDimensions() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<ShippingMethod> get availableMethods => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get shippingClass => $_getSZ(4);
  @$pb.TagNumber(5)
  set shippingClass($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShippingClass() => $_has(4);
  @$pb.TagNumber(5)
  void clearShippingClass() => $_clearField(5);
}

class ShippingMethod extends $pb.GeneratedMessage {
  factory ShippingMethod({
    $core.String? methodId,
    $core.String? name,
    $core.double? cost,
    $core.int? estimatedDays,
  }) {
    final result = create();
    if (methodId != null) result.methodId = methodId;
    if (name != null) result.name = name;
    if (cost != null) result.cost = cost;
    if (estimatedDays != null) result.estimatedDays = estimatedDays;
    return result;
  }

  ShippingMethod._();

  factory ShippingMethod.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShippingMethod.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShippingMethod',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'methodId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aD(3, _omitFieldNames ? '' : 'cost')
    ..aI(4, _omitFieldNames ? '' : 'estimatedDays',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShippingMethod clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShippingMethod copyWith(void Function(ShippingMethod) updates) =>
      super.copyWith((message) => updates(message as ShippingMethod))
          as ShippingMethod;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShippingMethod create() => ShippingMethod._();
  @$core.override
  ShippingMethod createEmptyInstance() => create();
  static $pb.PbList<ShippingMethod> createRepeated() =>
      $pb.PbList<ShippingMethod>();
  @$core.pragma('dart2js:noInline')
  static ShippingMethod getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShippingMethod>(create);
  static ShippingMethod? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get methodId => $_getSZ(0);
  @$pb.TagNumber(1)
  set methodId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMethodId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMethodId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get cost => $_getN(2);
  @$pb.TagNumber(3)
  set cost($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCost() => $_has(2);
  @$pb.TagNumber(3)
  void clearCost() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get estimatedDays => $_getIZ(3);
  @$pb.TagNumber(4)
  set estimatedDays($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEstimatedDays() => $_has(3);
  @$pb.TagNumber(4)
  void clearEstimatedDays() => $_clearField(4);
}

class Dimensions extends $pb.GeneratedMessage {
  factory Dimensions({
    $core.double? length,
    $core.double? width,
    $core.double? height,
    $core.String? unit,
  }) {
    final result = create();
    if (length != null) result.length = length;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (unit != null) result.unit = unit;
    return result;
  }

  Dimensions._();

  factory Dimensions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Dimensions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Dimensions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'length')
    ..aD(2, _omitFieldNames ? '' : 'width')
    ..aD(3, _omitFieldNames ? '' : 'height')
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dimensions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dimensions copyWith(void Function(Dimensions) updates) =>
      super.copyWith((message) => updates(message as Dimensions)) as Dimensions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Dimensions create() => Dimensions._();
  @$core.override
  Dimensions createEmptyInstance() => create();
  static $pb.PbList<Dimensions> createRepeated() => $pb.PbList<Dimensions>();
  @$core.pragma('dart2js:noInline')
  static Dimensions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Dimensions>(create);
  static Dimensions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get length => $_getN(0);
  @$pb.TagNumber(1)
  set length($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLength() => $_has(0);
  @$pb.TagNumber(1)
  void clearLength() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get width => $_getN(1);
  @$pb.TagNumber(2)
  set width($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get height => $_getN(2);
  @$pb.TagNumber(3)
  set height($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);
}

class SEOInfo extends $pb.GeneratedMessage {
  factory SEOInfo({
    $core.String? metaTitle,
    $core.String? metaDescription,
    $core.Iterable<$core.String>? metaKeywords,
    $core.String? canonicalUrl,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? ogTags,
  }) {
    final result = create();
    if (metaTitle != null) result.metaTitle = metaTitle;
    if (metaDescription != null) result.metaDescription = metaDescription;
    if (metaKeywords != null) result.metaKeywords.addAll(metaKeywords);
    if (canonicalUrl != null) result.canonicalUrl = canonicalUrl;
    if (ogTags != null) result.ogTags.addEntries(ogTags);
    return result;
  }

  SEOInfo._();

  factory SEOInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SEOInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SEOInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'metaTitle')
    ..aOS(2, _omitFieldNames ? '' : 'metaDescription')
    ..pPS(3, _omitFieldNames ? '' : 'metaKeywords')
    ..aOS(4, _omitFieldNames ? '' : 'canonicalUrl')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'ogTags',
        entryClassName: 'SEOInfo.OgTagsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('benchmark'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SEOInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SEOInfo copyWith(void Function(SEOInfo) updates) =>
      super.copyWith((message) => updates(message as SEOInfo)) as SEOInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SEOInfo create() => SEOInfo._();
  @$core.override
  SEOInfo createEmptyInstance() => create();
  static $pb.PbList<SEOInfo> createRepeated() => $pb.PbList<SEOInfo>();
  @$core.pragma('dart2js:noInline')
  static SEOInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SEOInfo>(create);
  static SEOInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get metaTitle => $_getSZ(0);
  @$pb.TagNumber(1)
  set metaTitle($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMetaTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetaTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get metaDescription => $_getSZ(1);
  @$pb.TagNumber(2)
  set metaDescription($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMetaDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetaDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get metaKeywords => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get canonicalUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set canonicalUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanonicalUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanonicalUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get ogTags => $_getMap(4);
}

/// Order/Transaction
class Order extends $pb.GeneratedMessage {
  factory Order({
    $fixnum.Int64? orderId,
    $core.String? orderNumber,
    $fixnum.Int64? userId,
    $core.Iterable<OrderItem>? items,
    $core.double? subtotal,
    $core.double? tax,
    $core.double? shippingCost,
    $core.double? discount,
    $core.double? total,
    $core.String? currency,
    OrderStatus? status,
    PaymentInfo? payment,
    Address? shippingAddress,
    Address? billingAddress,
    $core.Iterable<OrderStatusHistory>? statusHistory,
    $core.String? trackingNumber,
    $core.String? carrier,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    $fixnum.Int64? shippedAt,
    $fixnum.Int64? deliveredAt,
    $core.String? customerNotes,
    $core.String? internalNotes,
    $core.Iterable<Coupon>? appliedCoupons,
    ShippingMethod? shippingMethod,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (orderNumber != null) result.orderNumber = orderNumber;
    if (userId != null) result.userId = userId;
    if (items != null) result.items.addAll(items);
    if (subtotal != null) result.subtotal = subtotal;
    if (tax != null) result.tax = tax;
    if (shippingCost != null) result.shippingCost = shippingCost;
    if (discount != null) result.discount = discount;
    if (total != null) result.total = total;
    if (currency != null) result.currency = currency;
    if (status != null) result.status = status;
    if (payment != null) result.payment = payment;
    if (shippingAddress != null) result.shippingAddress = shippingAddress;
    if (billingAddress != null) result.billingAddress = billingAddress;
    if (statusHistory != null) result.statusHistory.addAll(statusHistory);
    if (trackingNumber != null) result.trackingNumber = trackingNumber;
    if (carrier != null) result.carrier = carrier;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (shippedAt != null) result.shippedAt = shippedAt;
    if (deliveredAt != null) result.deliveredAt = deliveredAt;
    if (customerNotes != null) result.customerNotes = customerNotes;
    if (internalNotes != null) result.internalNotes = internalNotes;
    if (appliedCoupons != null) result.appliedCoupons.addAll(appliedCoupons);
    if (shippingMethod != null) result.shippingMethod = shippingMethod;
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  Order._();

  factory Order.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Order.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Order',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'orderId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'orderNumber')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPM<OrderItem>(4, _omitFieldNames ? '' : 'items',
        subBuilder: OrderItem.create)
    ..aD(5, _omitFieldNames ? '' : 'subtotal')
    ..aD(6, _omitFieldNames ? '' : 'tax')
    ..aD(7, _omitFieldNames ? '' : 'shippingCost')
    ..aD(8, _omitFieldNames ? '' : 'discount')
    ..aD(9, _omitFieldNames ? '' : 'total')
    ..aOS(10, _omitFieldNames ? '' : 'currency')
    ..aE<OrderStatus>(11, _omitFieldNames ? '' : 'status',
        enumValues: OrderStatus.values)
    ..aOM<PaymentInfo>(12, _omitFieldNames ? '' : 'payment',
        subBuilder: PaymentInfo.create)
    ..aOM<Address>(13, _omitFieldNames ? '' : 'shippingAddress',
        subBuilder: Address.create)
    ..aOM<Address>(14, _omitFieldNames ? '' : 'billingAddress',
        subBuilder: Address.create)
    ..pPM<OrderStatusHistory>(15, _omitFieldNames ? '' : 'statusHistory',
        subBuilder: OrderStatusHistory.create)
    ..aOS(16, _omitFieldNames ? '' : 'trackingNumber')
    ..aOS(17, _omitFieldNames ? '' : 'carrier')
    ..a<$fixnum.Int64>(
        18, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        19, _omitFieldNames ? '' : 'updatedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        20, _omitFieldNames ? '' : 'shippedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        21, _omitFieldNames ? '' : 'deliveredAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(22, _omitFieldNames ? '' : 'customerNotes')
    ..aOS(23, _omitFieldNames ? '' : 'internalNotes')
    ..pPM<Coupon>(24, _omitFieldNames ? '' : 'appliedCoupons',
        subBuilder: Coupon.create)
    ..aOM<ShippingMethod>(25, _omitFieldNames ? '' : 'shippingMethod',
        subBuilder: ShippingMethod.create)
    ..m<$core.String, $core.String>(26, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'Order.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('benchmark'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order copyWith(void Function(Order) updates) =>
      super.copyWith((message) => updates(message as Order)) as Order;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Order create() => Order._();
  @$core.override
  Order createEmptyInstance() => create();
  static $pb.PbList<Order> createRepeated() => $pb.PbList<Order>();
  @$core.pragma('dart2js:noInline')
  static Order getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Order>(create);
  static Order? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get orderId => $_getI64(0);
  @$pb.TagNumber(1)
  set orderId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get userId => $_getI64(2);
  @$pb.TagNumber(3)
  set userId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<OrderItem> get items => $_getList(3);

  @$pb.TagNumber(5)
  $core.double get subtotal => $_getN(4);
  @$pb.TagNumber(5)
  set subtotal($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubtotal() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubtotal() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get tax => $_getN(5);
  @$pb.TagNumber(6)
  set tax($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTax() => $_has(5);
  @$pb.TagNumber(6)
  void clearTax() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get shippingCost => $_getN(6);
  @$pb.TagNumber(7)
  set shippingCost($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasShippingCost() => $_has(6);
  @$pb.TagNumber(7)
  void clearShippingCost() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get discount => $_getN(7);
  @$pb.TagNumber(8)
  set discount($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDiscount() => $_has(7);
  @$pb.TagNumber(8)
  void clearDiscount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get total => $_getN(8);
  @$pb.TagNumber(9)
  set total($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotal() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotal() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get currency => $_getSZ(9);
  @$pb.TagNumber(10)
  set currency($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCurrency() => $_has(9);
  @$pb.TagNumber(10)
  void clearCurrency() => $_clearField(10);

  @$pb.TagNumber(11)
  OrderStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(OrderStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => $_clearField(11);

  @$pb.TagNumber(12)
  PaymentInfo get payment => $_getN(11);
  @$pb.TagNumber(12)
  set payment(PaymentInfo value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPayment() => $_has(11);
  @$pb.TagNumber(12)
  void clearPayment() => $_clearField(12);
  @$pb.TagNumber(12)
  PaymentInfo ensurePayment() => $_ensure(11);

  @$pb.TagNumber(13)
  Address get shippingAddress => $_getN(12);
  @$pb.TagNumber(13)
  set shippingAddress(Address value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasShippingAddress() => $_has(12);
  @$pb.TagNumber(13)
  void clearShippingAddress() => $_clearField(13);
  @$pb.TagNumber(13)
  Address ensureShippingAddress() => $_ensure(12);

  @$pb.TagNumber(14)
  Address get billingAddress => $_getN(13);
  @$pb.TagNumber(14)
  set billingAddress(Address value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasBillingAddress() => $_has(13);
  @$pb.TagNumber(14)
  void clearBillingAddress() => $_clearField(14);
  @$pb.TagNumber(14)
  Address ensureBillingAddress() => $_ensure(13);

  @$pb.TagNumber(15)
  $pb.PbList<OrderStatusHistory> get statusHistory => $_getList(14);

  @$pb.TagNumber(16)
  $core.String get trackingNumber => $_getSZ(15);
  @$pb.TagNumber(16)
  set trackingNumber($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasTrackingNumber() => $_has(15);
  @$pb.TagNumber(16)
  void clearTrackingNumber() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get carrier => $_getSZ(16);
  @$pb.TagNumber(17)
  set carrier($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCarrier() => $_has(16);
  @$pb.TagNumber(17)
  void clearCarrier() => $_clearField(17);

  @$pb.TagNumber(18)
  $fixnum.Int64 get createdAt => $_getI64(17);
  @$pb.TagNumber(18)
  set createdAt($fixnum.Int64 value) => $_setInt64(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);

  @$pb.TagNumber(19)
  $fixnum.Int64 get updatedAt => $_getI64(18);
  @$pb.TagNumber(19)
  set updatedAt($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(19)
  $core.bool hasUpdatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdatedAt() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get shippedAt => $_getI64(19);
  @$pb.TagNumber(20)
  set shippedAt($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasShippedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearShippedAt() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get deliveredAt => $_getI64(20);
  @$pb.TagNumber(21)
  set deliveredAt($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasDeliveredAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearDeliveredAt() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get customerNotes => $_getSZ(21);
  @$pb.TagNumber(22)
  set customerNotes($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasCustomerNotes() => $_has(21);
  @$pb.TagNumber(22)
  void clearCustomerNotes() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get internalNotes => $_getSZ(22);
  @$pb.TagNumber(23)
  set internalNotes($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasInternalNotes() => $_has(22);
  @$pb.TagNumber(23)
  void clearInternalNotes() => $_clearField(23);

  @$pb.TagNumber(24)
  $pb.PbList<Coupon> get appliedCoupons => $_getList(23);

  @$pb.TagNumber(25)
  ShippingMethod get shippingMethod => $_getN(24);
  @$pb.TagNumber(25)
  set shippingMethod(ShippingMethod value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasShippingMethod() => $_has(24);
  @$pb.TagNumber(25)
  void clearShippingMethod() => $_clearField(25);
  @$pb.TagNumber(25)
  ShippingMethod ensureShippingMethod() => $_ensure(24);

  @$pb.TagNumber(26)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(25);
}

class OrderItem extends $pb.GeneratedMessage {
  factory OrderItem({
    $core.String? orderItemId,
    $fixnum.Int64? productId,
    $core.String? variantId,
    $core.String? productName,
    $core.String? variantName,
    $core.String? sku,
    $core.int? quantity,
    $core.double? unitPrice,
    $core.double? totalPrice,
    $core.double? taxAmount,
    $core.double? discountAmount,
    $core.String? imageUrl,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? attributes,
  }) {
    final result = create();
    if (orderItemId != null) result.orderItemId = orderItemId;
    if (productId != null) result.productId = productId;
    if (variantId != null) result.variantId = variantId;
    if (productName != null) result.productName = productName;
    if (variantName != null) result.variantName = variantName;
    if (sku != null) result.sku = sku;
    if (quantity != null) result.quantity = quantity;
    if (unitPrice != null) result.unitPrice = unitPrice;
    if (totalPrice != null) result.totalPrice = totalPrice;
    if (taxAmount != null) result.taxAmount = taxAmount;
    if (discountAmount != null) result.discountAmount = discountAmount;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (attributes != null) result.attributes.addEntries(attributes);
    return result;
  }

  OrderItem._();

  factory OrderItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrderItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderItemId')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'productId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'variantId')
    ..aOS(4, _omitFieldNames ? '' : 'productName')
    ..aOS(5, _omitFieldNames ? '' : 'variantName')
    ..aOS(6, _omitFieldNames ? '' : 'sku')
    ..aI(7, _omitFieldNames ? '' : 'quantity', fieldType: $pb.PbFieldType.OU3)
    ..aD(8, _omitFieldNames ? '' : 'unitPrice')
    ..aD(9, _omitFieldNames ? '' : 'totalPrice')
    ..aD(10, _omitFieldNames ? '' : 'taxAmount')
    ..aD(11, _omitFieldNames ? '' : 'discountAmount')
    ..aOS(12, _omitFieldNames ? '' : 'imageUrl')
    ..m<$core.String, $core.String>(13, _omitFieldNames ? '' : 'attributes',
        entryClassName: 'OrderItem.AttributesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('benchmark'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderItem copyWith(void Function(OrderItem) updates) =>
      super.copyWith((message) => updates(message as OrderItem)) as OrderItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderItem create() => OrderItem._();
  @$core.override
  OrderItem createEmptyInstance() => create();
  static $pb.PbList<OrderItem> createRepeated() => $pb.PbList<OrderItem>();
  @$core.pragma('dart2js:noInline')
  static OrderItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderItem>(create);
  static OrderItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get productId => $_getI64(1);
  @$pb.TagNumber(2)
  set productId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get variantId => $_getSZ(2);
  @$pb.TagNumber(3)
  set variantId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVariantId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVariantId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productName => $_getSZ(3);
  @$pb.TagNumber(4)
  set productName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductName() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get variantName => $_getSZ(4);
  @$pb.TagNumber(5)
  set variantName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVariantName() => $_has(4);
  @$pb.TagNumber(5)
  void clearVariantName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sku => $_getSZ(5);
  @$pb.TagNumber(6)
  set sku($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSku() => $_has(5);
  @$pb.TagNumber(6)
  void clearSku() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get quantity => $_getIZ(6);
  @$pb.TagNumber(7)
  set quantity($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuantity() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuantity() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get unitPrice => $_getN(7);
  @$pb.TagNumber(8)
  set unitPrice($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnitPrice() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnitPrice() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get totalPrice => $_getN(8);
  @$pb.TagNumber(9)
  set totalPrice($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotalPrice() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalPrice() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get taxAmount => $_getN(9);
  @$pb.TagNumber(10)
  set taxAmount($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTaxAmount() => $_has(9);
  @$pb.TagNumber(10)
  void clearTaxAmount() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get discountAmount => $_getN(10);
  @$pb.TagNumber(11)
  set discountAmount($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDiscountAmount() => $_has(10);
  @$pb.TagNumber(11)
  void clearDiscountAmount() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get imageUrl => $_getSZ(11);
  @$pb.TagNumber(12)
  set imageUrl($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasImageUrl() => $_has(11);
  @$pb.TagNumber(12)
  void clearImageUrl() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbMap<$core.String, $core.String> get attributes => $_getMap(12);
}

class OrderStatusHistory extends $pb.GeneratedMessage {
  factory OrderStatusHistory({
    OrderStatus? status,
    $fixnum.Int64? timestamp,
    $core.String? note,
    $core.String? updatedBy,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (timestamp != null) result.timestamp = timestamp;
    if (note != null) result.note = note;
    if (updatedBy != null) result.updatedBy = updatedBy;
    return result;
  }

  OrderStatusHistory._();

  factory OrderStatusHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrderStatusHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderStatusHistory',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aE<OrderStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: OrderStatus.values)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aOS(4, _omitFieldNames ? '' : 'updatedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderStatusHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderStatusHistory copyWith(void Function(OrderStatusHistory) updates) =>
      super.copyWith((message) => updates(message as OrderStatusHistory))
          as OrderStatusHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderStatusHistory create() => OrderStatusHistory._();
  @$core.override
  OrderStatusHistory createEmptyInstance() => create();
  static $pb.PbList<OrderStatusHistory> createRepeated() =>
      $pb.PbList<OrderStatusHistory>();
  @$core.pragma('dart2js:noInline')
  static OrderStatusHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OrderStatusHistory>(create);
  static OrderStatusHistory? _defaultInstance;

  @$pb.TagNumber(1)
  OrderStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(OrderStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get updatedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set updatedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdatedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedBy() => $_clearField(4);
}

class PaymentInfo extends $pb.GeneratedMessage {
  factory PaymentInfo({
    $core.String? paymentId,
    $core.String? paymentMethodId,
    PaymentType? type,
    $core.double? amount,
    $core.String? currency,
    PaymentStatus? status,
    $core.String? transactionId,
    $core.String? provider,
    $fixnum.Int64? createdAt,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (paymentId != null) result.paymentId = paymentId;
    if (paymentMethodId != null) result.paymentMethodId = paymentMethodId;
    if (type != null) result.type = type;
    if (amount != null) result.amount = amount;
    if (currency != null) result.currency = currency;
    if (status != null) result.status = status;
    if (transactionId != null) result.transactionId = transactionId;
    if (provider != null) result.provider = provider;
    if (createdAt != null) result.createdAt = createdAt;
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  PaymentInfo._();

  factory PaymentInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PaymentInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaymentInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymentId')
    ..aOS(2, _omitFieldNames ? '' : 'paymentMethodId')
    ..aE<PaymentType>(3, _omitFieldNames ? '' : 'type',
        enumValues: PaymentType.values)
    ..aD(4, _omitFieldNames ? '' : 'amount')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..aE<PaymentStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: PaymentStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'transactionId')
    ..aOS(8, _omitFieldNames ? '' : 'provider')
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..m<$core.String, $core.String>(10, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'PaymentInfo.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('benchmark'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentInfo copyWith(void Function(PaymentInfo) updates) =>
      super.copyWith((message) => updates(message as PaymentInfo))
          as PaymentInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PaymentInfo create() => PaymentInfo._();
  @$core.override
  PaymentInfo createEmptyInstance() => create();
  static $pb.PbList<PaymentInfo> createRepeated() => $pb.PbList<PaymentInfo>();
  @$core.pragma('dart2js:noInline')
  static PaymentInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaymentInfo>(create);
  static PaymentInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPaymentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get paymentMethodId => $_getSZ(1);
  @$pb.TagNumber(2)
  set paymentMethodId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPaymentMethodId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentMethodId() => $_clearField(2);

  @$pb.TagNumber(3)
  PaymentType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(PaymentType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);

  @$pb.TagNumber(6)
  PaymentStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(PaymentStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get transactionId => $_getSZ(6);
  @$pb.TagNumber(7)
  set transactionId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTransactionId() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransactionId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get provider => $_getSZ(7);
  @$pb.TagNumber(8)
  set provider($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProvider() => $_has(7);
  @$pb.TagNumber(8)
  void clearProvider() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createdAt => $_getI64(8);
  @$pb.TagNumber(9)
  set createdAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(9);
}

class Coupon extends $pb.GeneratedMessage {
  factory Coupon({
    $core.String? couponId,
    $core.String? code,
    CouponType? type,
    $core.double? value,
    $core.double? minimumPurchase,
    $fixnum.Int64? expiryDate,
  }) {
    final result = create();
    if (couponId != null) result.couponId = couponId;
    if (code != null) result.code = code;
    if (type != null) result.type = type;
    if (value != null) result.value = value;
    if (minimumPurchase != null) result.minimumPurchase = minimumPurchase;
    if (expiryDate != null) result.expiryDate = expiryDate;
    return result;
  }

  Coupon._();

  factory Coupon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Coupon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Coupon',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'couponId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aE<CouponType>(3, _omitFieldNames ? '' : 'type',
        enumValues: CouponType.values)
    ..aD(4, _omitFieldNames ? '' : 'value')
    ..aD(5, _omitFieldNames ? '' : 'minimumPurchase')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'expiryDate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coupon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coupon copyWith(void Function(Coupon) updates) =>
      super.copyWith((message) => updates(message as Coupon)) as Coupon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Coupon create() => Coupon._();
  @$core.override
  Coupon createEmptyInstance() => create();
  static $pb.PbList<Coupon> createRepeated() => $pb.PbList<Coupon>();
  @$core.pragma('dart2js:noInline')
  static Coupon getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coupon>(create);
  static Coupon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get couponId => $_getSZ(0);
  @$pb.TagNumber(1)
  set couponId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCouponId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCouponId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  CouponType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(CouponType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get minimumPurchase => $_getN(4);
  @$pb.TagNumber(5)
  set minimumPurchase($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinimumPurchase() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinimumPurchase() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expiryDate => $_getI64(5);
  @$pb.TagNumber(6)
  set expiryDate($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiryDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiryDate() => $_clearField(6);
}

/// Aggregate message for comprehensive testing
class BenchmarkData extends $pb.GeneratedMessage {
  factory BenchmarkData({
    $core.Iterable<User>? users,
    $core.Iterable<Post>? posts,
    $core.Iterable<Product>? products,
    $core.Iterable<Order>? orders,
    $core.Iterable<$core.MapEntry<$fixnum.Int64, User>>? userIndex,
    $core.Iterable<$core.MapEntry<$fixnum.Int64, Product>>? productIndex,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? config,
    $fixnum.Int64? timestamp,
    $core.String? version,
    $core.List<$core.int>? rawData,
  }) {
    final result = create();
    if (users != null) result.users.addAll(users);
    if (posts != null) result.posts.addAll(posts);
    if (products != null) result.products.addAll(products);
    if (orders != null) result.orders.addAll(orders);
    if (userIndex != null) result.userIndex.addEntries(userIndex);
    if (productIndex != null) result.productIndex.addEntries(productIndex);
    if (config != null) result.config.addEntries(config);
    if (timestamp != null) result.timestamp = timestamp;
    if (version != null) result.version = version;
    if (rawData != null) result.rawData = rawData;
    return result;
  }

  BenchmarkData._();

  factory BenchmarkData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BenchmarkData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BenchmarkData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'benchmark'),
      createEmptyInstance: create)
    ..pPM<User>(1, _omitFieldNames ? '' : 'users', subBuilder: User.create)
    ..pPM<Post>(2, _omitFieldNames ? '' : 'posts', subBuilder: Post.create)
    ..pPM<Product>(3, _omitFieldNames ? '' : 'products',
        subBuilder: Product.create)
    ..pPM<Order>(4, _omitFieldNames ? '' : 'orders', subBuilder: Order.create)
    ..m<$fixnum.Int64, User>(5, _omitFieldNames ? '' : 'userIndex',
        entryClassName: 'BenchmarkData.UserIndexEntry',
        keyFieldType: $pb.PbFieldType.OU6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: User.create,
        valueDefaultOrMaker: User.getDefault,
        packageName: const $pb.PackageName('benchmark'))
    ..m<$fixnum.Int64, Product>(6, _omitFieldNames ? '' : 'productIndex',
        entryClassName: 'BenchmarkData.ProductIndexEntry',
        keyFieldType: $pb.PbFieldType.OU6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Product.create,
        valueDefaultOrMaker: Product.getDefault,
        packageName: const $pb.PackageName('benchmark'))
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'config',
        entryClassName: 'BenchmarkData.ConfigEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('benchmark'))
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(9, _omitFieldNames ? '' : 'version')
    ..a<$core.List<$core.int>>(
        10, _omitFieldNames ? '' : 'rawData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BenchmarkData copyWith(void Function(BenchmarkData) updates) =>
      super.copyWith((message) => updates(message as BenchmarkData))
          as BenchmarkData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BenchmarkData create() => BenchmarkData._();
  @$core.override
  BenchmarkData createEmptyInstance() => create();
  static $pb.PbList<BenchmarkData> createRepeated() =>
      $pb.PbList<BenchmarkData>();
  @$core.pragma('dart2js:noInline')
  static BenchmarkData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BenchmarkData>(create);
  static BenchmarkData? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<User> get users => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Post> get posts => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Product> get products => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<Order> get orders => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbMap<$fixnum.Int64, User> get userIndex => $_getMap(4);

  @$pb.TagNumber(6)
  $pb.PbMap<$fixnum.Int64, Product> get productIndex => $_getMap(5);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get config => $_getMap(6);

  @$pb.TagNumber(8)
  $fixnum.Int64 get timestamp => $_getI64(7);
  @$pb.TagNumber(8)
  set timestamp($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTimestamp() => $_has(7);
  @$pb.TagNumber(8)
  void clearTimestamp() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get version => $_getSZ(8);
  @$pb.TagNumber(9)
  set version($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearVersion() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.List<$core.int> get rawData => $_getN(9);
  @$pb.TagNumber(10)
  set rawData($core.List<$core.int> value) => $_setBytes(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRawData() => $_has(9);
  @$pb.TagNumber(10)
  void clearRawData() => $_clearField(10);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
