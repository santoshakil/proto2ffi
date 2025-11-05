// This is a generated file - do not edit.
//
// Generated from complex_data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'calculator.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Address extends $pb.GeneratedMessage {
  factory Address({
    $core.String? street,
    $core.String? city,
    $core.String? state,
    $core.String? zipCode,
    $core.String? country,
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final result = create();
    if (street != null) result.street = street;
    if (city != null) result.city = city;
    if (state != null) result.state = state;
    if (zipCode != null) result.zipCode = zipCode;
    if (country != null) result.country = country;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'street')
    ..aOS(2, _omitFieldNames ? '' : 'city')
    ..aOS(3, _omitFieldNames ? '' : 'state')
    ..aOS(4, _omitFieldNames ? '' : 'zipCode')
    ..aOS(5, _omitFieldNames ? '' : 'country')
    ..aD(6, _omitFieldNames ? '' : 'latitude')
    ..aD(7, _omitFieldNames ? '' : 'longitude')
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
  @$core.pragma('dart2js:noInline')
  static Address getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Address>(create);
  static Address? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get street => $_getSZ(0);
  @$pb.TagNumber(1)
  set street($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStreet() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreet() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get city => $_getSZ(1);
  @$pb.TagNumber(2)
  set city($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCity() => $_has(1);
  @$pb.TagNumber(2)
  void clearCity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get state => $_getSZ(2);
  @$pb.TagNumber(3)
  set state($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get zipCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set zipCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasZipCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearZipCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get country => $_getSZ(4);
  @$pb.TagNumber(5)
  set country($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCountry() => $_has(4);
  @$pb.TagNumber(5)
  void clearCountry() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get latitude => $_getN(5);
  @$pb.TagNumber(6)
  set latitude($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLatitude() => $_has(5);
  @$pb.TagNumber(6)
  void clearLatitude() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get longitude => $_getN(6);
  @$pb.TagNumber(7)
  set longitude($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLongitude() => $_has(6);
  @$pb.TagNumber(7)
  void clearLongitude() => $_clearField(7);
}

class Person extends $pb.GeneratedMessage {
  factory Person({
    $core.String? id,
    $core.String? firstName,
    $core.String? lastName,
    $core.String? email,
    $core.int? age,
    Address? homeAddress,
    Address? workAddress,
    $core.Iterable<$core.String>? phoneNumbers,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (email != null) result.email = email;
    if (age != null) result.age = age;
    if (homeAddress != null) result.homeAddress = homeAddress;
    if (workAddress != null) result.workAddress = workAddress;
    if (phoneNumbers != null) result.phoneNumbers.addAll(phoneNumbers);
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  Person._();

  factory Person.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Person.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Person',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'firstName')
    ..aOS(3, _omitFieldNames ? '' : 'lastName')
    ..aOS(4, _omitFieldNames ? '' : 'email')
    ..aI(5, _omitFieldNames ? '' : 'age')
    ..aOM<Address>(6, _omitFieldNames ? '' : 'homeAddress',
        subBuilder: Address.create)
    ..aOM<Address>(7, _omitFieldNames ? '' : 'workAddress',
        subBuilder: Address.create)
    ..pPS(8, _omitFieldNames ? '' : 'phoneNumbers')
    ..m<$core.String, $core.String>(9, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'Person.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('calculator'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Person clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Person copyWith(void Function(Person) updates) =>
      super.copyWith((message) => updates(message as Person)) as Person;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Person create() => Person._();
  @$core.override
  Person createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Person getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Person>(create);
  static Person? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get firstName => $_getSZ(1);
  @$pb.TagNumber(2)
  set firstName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFirstName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFirstName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lastName => $_getSZ(2);
  @$pb.TagNumber(3)
  set lastName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastName() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get email => $_getSZ(3);
  @$pb.TagNumber(4)
  set email($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get age => $_getIZ(4);
  @$pb.TagNumber(5)
  set age($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAge() => $_has(4);
  @$pb.TagNumber(5)
  void clearAge() => $_clearField(5);

  @$pb.TagNumber(6)
  Address get homeAddress => $_getN(5);
  @$pb.TagNumber(6)
  set homeAddress(Address value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasHomeAddress() => $_has(5);
  @$pb.TagNumber(6)
  void clearHomeAddress() => $_clearField(6);
  @$pb.TagNumber(6)
  Address ensureHomeAddress() => $_ensure(5);

  @$pb.TagNumber(7)
  Address get workAddress => $_getN(6);
  @$pb.TagNumber(7)
  set workAddress(Address value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasWorkAddress() => $_has(6);
  @$pb.TagNumber(7)
  void clearWorkAddress() => $_clearField(7);
  @$pb.TagNumber(7)
  Address ensureWorkAddress() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get phoneNumbers => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(8);
}

class Transaction extends $pb.GeneratedMessage {
  factory Transaction({
    $core.String? transactionId,
    $fixnum.Int64? timestamp,
    $core.double? amount,
    $core.String? currency,
    Person? sender,
    Person? receiver,
    $core.Iterable<$core.String>? tags,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? fees,
  }) {
    final result = create();
    if (transactionId != null) result.transactionId = transactionId;
    if (timestamp != null) result.timestamp = timestamp;
    if (amount != null) result.amount = amount;
    if (currency != null) result.currency = currency;
    if (sender != null) result.sender = sender;
    if (receiver != null) result.receiver = receiver;
    if (tags != null) result.tags.addAll(tags);
    if (fees != null) result.fees.addEntries(fees);
    return result;
  }

  Transaction._();

  factory Transaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Transaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Transaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transactionId')
    ..aInt64(2, _omitFieldNames ? '' : 'timestamp')
    ..aD(3, _omitFieldNames ? '' : 'amount')
    ..aOS(4, _omitFieldNames ? '' : 'currency')
    ..aOM<Person>(5, _omitFieldNames ? '' : 'sender', subBuilder: Person.create)
    ..aOM<Person>(6, _omitFieldNames ? '' : 'receiver',
        subBuilder: Person.create)
    ..pPS(7, _omitFieldNames ? '' : 'tags')
    ..m<$core.String, $core.double>(8, _omitFieldNames ? '' : 'fees',
        entryClassName: 'Transaction.FeesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('calculator'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transaction copyWith(void Function(Transaction) updates) =>
      super.copyWith((message) => updates(message as Transaction))
          as Transaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Transaction create() => Transaction._();
  @$core.override
  Transaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Transaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Transaction>(create);
  static Transaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transactionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transactionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransactionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransactionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get currency => $_getSZ(3);
  @$pb.TagNumber(4)
  set currency($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrency() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrency() => $_clearField(4);

  @$pb.TagNumber(5)
  Person get sender => $_getN(4);
  @$pb.TagNumber(5)
  set sender(Person value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSender() => $_has(4);
  @$pb.TagNumber(5)
  void clearSender() => $_clearField(5);
  @$pb.TagNumber(5)
  Person ensureSender() => $_ensure(4);

  @$pb.TagNumber(6)
  Person get receiver => $_getN(5);
  @$pb.TagNumber(6)
  set receiver(Person value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReceiver() => $_has(5);
  @$pb.TagNumber(6)
  void clearReceiver() => $_clearField(6);
  @$pb.TagNumber(6)
  Person ensureReceiver() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get tags => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.double> get fees => $_getMap(7);
}

class DataBatch extends $pb.GeneratedMessage {
  factory DataBatch({
    $core.Iterable<Transaction>? transactions,
    $fixnum.Int64? batchId,
    $fixnum.Int64? createdAt,
  }) {
    final result = create();
    if (transactions != null) result.transactions.addAll(transactions);
    if (batchId != null) result.batchId = batchId;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  DataBatch._();

  factory DataBatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DataBatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DataBatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..pPM<Transaction>(1, _omitFieldNames ? '' : 'transactions',
        subBuilder: Transaction.create)
    ..aInt64(2, _omitFieldNames ? '' : 'batchId')
    ..aInt64(3, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataBatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataBatch copyWith(void Function(DataBatch) updates) =>
      super.copyWith((message) => updates(message as DataBatch)) as DataBatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataBatch create() => DataBatch._();
  @$core.override
  DataBatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DataBatch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataBatch>(create);
  static DataBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Transaction> get transactions => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get batchId => $_getI64(1);
  @$pb.TagNumber(2)
  set batchId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBatchId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBatchId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createdAt => $_getI64(2);
  @$pb.TagNumber(3)
  set createdAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
}

enum ComplexCalculationRequest_Operation {
  add,
  subtract,
  multiply,
  divide,
  batch,
  complex,
  notSet
}

class ComplexCalculationRequest extends $pb.GeneratedMessage {
  factory ComplexCalculationRequest({
    $0.BinaryOp? add,
    $0.BinaryOp? subtract,
    $0.BinaryOp? multiply,
    $0.BinaryOp? divide,
    BatchOperation? batch,
    ComplexDataOperation? complex,
  }) {
    final result = create();
    if (add != null) result.add = add;
    if (subtract != null) result.subtract = subtract;
    if (multiply != null) result.multiply = multiply;
    if (divide != null) result.divide = divide;
    if (batch != null) result.batch = batch;
    if (complex != null) result.complex = complex;
    return result;
  }

  ComplexCalculationRequest._();

  factory ComplexCalculationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComplexCalculationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ComplexCalculationRequest_Operation>
      _ComplexCalculationRequest_OperationByTag = {
    1: ComplexCalculationRequest_Operation.add,
    2: ComplexCalculationRequest_Operation.subtract,
    3: ComplexCalculationRequest_Operation.multiply,
    4: ComplexCalculationRequest_Operation.divide,
    5: ComplexCalculationRequest_Operation.batch,
    6: ComplexCalculationRequest_Operation.complex,
    0: ComplexCalculationRequest_Operation.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComplexCalculationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<$0.BinaryOp>(1, _omitFieldNames ? '' : 'add',
        subBuilder: $0.BinaryOp.create)
    ..aOM<$0.BinaryOp>(2, _omitFieldNames ? '' : 'subtract',
        subBuilder: $0.BinaryOp.create)
    ..aOM<$0.BinaryOp>(3, _omitFieldNames ? '' : 'multiply',
        subBuilder: $0.BinaryOp.create)
    ..aOM<$0.BinaryOp>(4, _omitFieldNames ? '' : 'divide',
        subBuilder: $0.BinaryOp.create)
    ..aOM<BatchOperation>(5, _omitFieldNames ? '' : 'batch',
        subBuilder: BatchOperation.create)
    ..aOM<ComplexDataOperation>(6, _omitFieldNames ? '' : 'complex',
        subBuilder: ComplexDataOperation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplexCalculationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplexCalculationRequest copyWith(
          void Function(ComplexCalculationRequest) updates) =>
      super.copyWith((message) => updates(message as ComplexCalculationRequest))
          as ComplexCalculationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComplexCalculationRequest create() => ComplexCalculationRequest._();
  @$core.override
  ComplexCalculationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ComplexCalculationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComplexCalculationRequest>(create);
  static ComplexCalculationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  ComplexCalculationRequest_Operation whichOperation() =>
      _ComplexCalculationRequest_OperationByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  void clearOperation() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.BinaryOp get add => $_getN(0);
  @$pb.TagNumber(1)
  set add($0.BinaryOp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAdd() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdd() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.BinaryOp ensureAdd() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.BinaryOp get subtract => $_getN(1);
  @$pb.TagNumber(2)
  set subtract($0.BinaryOp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSubtract() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubtract() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.BinaryOp ensureSubtract() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.BinaryOp get multiply => $_getN(2);
  @$pb.TagNumber(3)
  set multiply($0.BinaryOp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMultiply() => $_has(2);
  @$pb.TagNumber(3)
  void clearMultiply() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.BinaryOp ensureMultiply() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.BinaryOp get divide => $_getN(3);
  @$pb.TagNumber(4)
  set divide($0.BinaryOp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDivide() => $_has(3);
  @$pb.TagNumber(4)
  void clearDivide() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.BinaryOp ensureDivide() => $_ensure(3);

  @$pb.TagNumber(5)
  BatchOperation get batch => $_getN(4);
  @$pb.TagNumber(5)
  set batch(BatchOperation value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBatch() => $_has(4);
  @$pb.TagNumber(5)
  void clearBatch() => $_clearField(5);
  @$pb.TagNumber(5)
  BatchOperation ensureBatch() => $_ensure(4);

  @$pb.TagNumber(6)
  ComplexDataOperation get complex => $_getN(5);
  @$pb.TagNumber(6)
  set complex(ComplexDataOperation value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasComplex() => $_has(5);
  @$pb.TagNumber(6)
  void clearComplex() => $_clearField(6);
  @$pb.TagNumber(6)
  ComplexDataOperation ensureComplex() => $_ensure(5);
}

class BatchOperation extends $pb.GeneratedMessage {
  factory BatchOperation({
    $core.Iterable<$0.BinaryOp>? operations,
  }) {
    final result = create();
    if (operations != null) result.operations.addAll(operations);
    return result;
  }

  BatchOperation._();

  factory BatchOperation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchOperation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchOperation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..pPM<$0.BinaryOp>(1, _omitFieldNames ? '' : 'operations',
        subBuilder: $0.BinaryOp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchOperation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchOperation copyWith(void Function(BatchOperation) updates) =>
      super.copyWith((message) => updates(message as BatchOperation))
          as BatchOperation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchOperation create() => BatchOperation._();
  @$core.override
  BatchOperation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchOperation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchOperation>(create);
  static BatchOperation? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.BinaryOp> get operations => $_getList(0);
}

class ComplexDataOperation extends $pb.GeneratedMessage {
  factory ComplexDataOperation({
    DataBatch? data,
    $core.String? operationType,
  }) {
    final result = create();
    if (data != null) result.data = data;
    if (operationType != null) result.operationType = operationType;
    return result;
  }

  ComplexDataOperation._();

  factory ComplexDataOperation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComplexDataOperation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComplexDataOperation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..aOM<DataBatch>(1, _omitFieldNames ? '' : 'data',
        subBuilder: DataBatch.create)
    ..aOS(2, _omitFieldNames ? '' : 'operationType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplexDataOperation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplexDataOperation copyWith(void Function(ComplexDataOperation) updates) =>
      super.copyWith((message) => updates(message as ComplexDataOperation))
          as ComplexDataOperation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComplexDataOperation create() => ComplexDataOperation._();
  @$core.override
  ComplexDataOperation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ComplexDataOperation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComplexDataOperation>(create);
  static ComplexDataOperation? _defaultInstance;

  @$pb.TagNumber(1)
  DataBatch get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(DataBatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);
  @$pb.TagNumber(1)
  DataBatch ensureData() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get operationType => $_getSZ(1);
  @$pb.TagNumber(2)
  set operationType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOperationType() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperationType() => $_clearField(2);
}

enum ComplexCalculationResponse_Result {
  value,
  error,
  batchResult,
  complexResult,
  notSet
}

class ComplexCalculationResponse extends $pb.GeneratedMessage {
  factory ComplexCalculationResponse({
    $fixnum.Int64? value,
    $0.ErrorResult? error,
    BatchResult? batchResult,
    ComplexDataResult? complexResult,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (error != null) result.error = error;
    if (batchResult != null) result.batchResult = batchResult;
    if (complexResult != null) result.complexResult = complexResult;
    return result;
  }

  ComplexCalculationResponse._();

  factory ComplexCalculationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComplexCalculationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ComplexCalculationResponse_Result>
      _ComplexCalculationResponse_ResultByTag = {
    1: ComplexCalculationResponse_Result.value,
    2: ComplexCalculationResponse_Result.error,
    3: ComplexCalculationResponse_Result.batchResult,
    4: ComplexCalculationResponse_Result.complexResult,
    0: ComplexCalculationResponse_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComplexCalculationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aInt64(1, _omitFieldNames ? '' : 'value')
    ..aOM<$0.ErrorResult>(2, _omitFieldNames ? '' : 'error',
        subBuilder: $0.ErrorResult.create)
    ..aOM<BatchResult>(3, _omitFieldNames ? '' : 'batchResult',
        subBuilder: BatchResult.create)
    ..aOM<ComplexDataResult>(4, _omitFieldNames ? '' : 'complexResult',
        subBuilder: ComplexDataResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplexCalculationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplexCalculationResponse copyWith(
          void Function(ComplexCalculationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ComplexCalculationResponse))
          as ComplexCalculationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComplexCalculationResponse create() => ComplexCalculationResponse._();
  @$core.override
  ComplexCalculationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ComplexCalculationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComplexCalculationResponse>(create);
  static ComplexCalculationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  ComplexCalculationResponse_Result whichResult() =>
      _ComplexCalculationResponse_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get value => $_getI64(0);
  @$pb.TagNumber(1)
  set value($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.ErrorResult get error => $_getN(1);
  @$pb.TagNumber(2)
  set error($0.ErrorResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.ErrorResult ensureError() => $_ensure(1);

  @$pb.TagNumber(3)
  BatchResult get batchResult => $_getN(2);
  @$pb.TagNumber(3)
  set batchResult(BatchResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBatchResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearBatchResult() => $_clearField(3);
  @$pb.TagNumber(3)
  BatchResult ensureBatchResult() => $_ensure(2);

  @$pb.TagNumber(4)
  ComplexDataResult get complexResult => $_getN(3);
  @$pb.TagNumber(4)
  set complexResult(ComplexDataResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasComplexResult() => $_has(3);
  @$pb.TagNumber(4)
  void clearComplexResult() => $_clearField(4);
  @$pb.TagNumber(4)
  ComplexDataResult ensureComplexResult() => $_ensure(3);
}

class BatchResult extends $pb.GeneratedMessage {
  factory BatchResult({
    $core.Iterable<$fixnum.Int64>? values,
    $core.int? successCount,
    $core.int? errorCount,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    if (successCount != null) result.successCount = successCount;
    if (errorCount != null) result.errorCount = errorCount;
    return result;
  }

  BatchResult._();

  factory BatchResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.K6)
    ..aI(2, _omitFieldNames ? '' : 'successCount')
    ..aI(3, _omitFieldNames ? '' : 'errorCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchResult copyWith(void Function(BatchResult) updates) =>
      super.copyWith((message) => updates(message as BatchResult))
          as BatchResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchResult create() => BatchResult._();
  @$core.override
  BatchResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchResult>(create);
  static BatchResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get values => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get successCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set successCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccessCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccessCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get errorCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set errorCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorCount() => $_clearField(3);
}

class ComplexDataResult extends $pb.GeneratedMessage {
  factory ComplexDataResult({
    $core.int? transactionCount,
    $core.double? totalAmount,
    $fixnum.Int64? processingTimeNs,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? stats,
  }) {
    final result = create();
    if (transactionCount != null) result.transactionCount = transactionCount;
    if (totalAmount != null) result.totalAmount = totalAmount;
    if (processingTimeNs != null) result.processingTimeNs = processingTimeNs;
    if (stats != null) result.stats.addEntries(stats);
    return result;
  }

  ComplexDataResult._();

  factory ComplexDataResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComplexDataResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComplexDataResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'transactionCount')
    ..aD(2, _omitFieldNames ? '' : 'totalAmount')
    ..aInt64(3, _omitFieldNames ? '' : 'processingTimeNs')
    ..m<$core.String, $core.int>(4, _omitFieldNames ? '' : 'stats',
        entryClassName: 'ComplexDataResult.StatsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('calculator'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplexDataResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComplexDataResult copyWith(void Function(ComplexDataResult) updates) =>
      super.copyWith((message) => updates(message as ComplexDataResult))
          as ComplexDataResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComplexDataResult create() => ComplexDataResult._();
  @$core.override
  ComplexDataResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ComplexDataResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComplexDataResult>(create);
  static ComplexDataResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get transactionCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set transactionCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransactionCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransactionCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get totalAmount => $_getN(1);
  @$pb.TagNumber(2)
  set totalAmount($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get processingTimeNs => $_getI64(2);
  @$pb.TagNumber(3)
  set processingTimeNs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProcessingTimeNs() => $_has(2);
  @$pb.TagNumber(3)
  void clearProcessingTimeNs() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.int> get stats => $_getMap(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
