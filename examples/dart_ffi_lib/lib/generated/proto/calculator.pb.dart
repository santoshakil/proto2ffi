// This is a generated file - do not edit.
//
// Generated from calculator.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum CalculatorRequest_Operation { add, subtract, multiply, divide, notSet }

class CalculatorRequest extends $pb.GeneratedMessage {
  factory CalculatorRequest({
    BinaryOp? add,
    BinaryOp? subtract,
    BinaryOp? multiply,
    BinaryOp? divide,
  }) {
    final result = create();
    if (add != null) result.add = add;
    if (subtract != null) result.subtract = subtract;
    if (multiply != null) result.multiply = multiply;
    if (divide != null) result.divide = divide;
    return result;
  }

  CalculatorRequest._();

  factory CalculatorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CalculatorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CalculatorRequest_Operation>
      _CalculatorRequest_OperationByTag = {
    1: CalculatorRequest_Operation.add,
    2: CalculatorRequest_Operation.subtract,
    3: CalculatorRequest_Operation.multiply,
    4: CalculatorRequest_Operation.divide,
    0: CalculatorRequest_Operation.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalculatorRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<BinaryOp>(1, _omitFieldNames ? '' : 'add',
        subBuilder: BinaryOp.create)
    ..aOM<BinaryOp>(2, _omitFieldNames ? '' : 'subtract',
        subBuilder: BinaryOp.create)
    ..aOM<BinaryOp>(3, _omitFieldNames ? '' : 'multiply',
        subBuilder: BinaryOp.create)
    ..aOM<BinaryOp>(4, _omitFieldNames ? '' : 'divide',
        subBuilder: BinaryOp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculatorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculatorRequest copyWith(void Function(CalculatorRequest) updates) =>
      super.copyWith((message) => updates(message as CalculatorRequest))
          as CalculatorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculatorRequest create() => CalculatorRequest._();
  @$core.override
  CalculatorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CalculatorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculatorRequest>(create);
  static CalculatorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  CalculatorRequest_Operation whichOperation() =>
      _CalculatorRequest_OperationByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearOperation() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  BinaryOp get add => $_getN(0);
  @$pb.TagNumber(1)
  set add(BinaryOp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAdd() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdd() => $_clearField(1);
  @$pb.TagNumber(1)
  BinaryOp ensureAdd() => $_ensure(0);

  @$pb.TagNumber(2)
  BinaryOp get subtract => $_getN(1);
  @$pb.TagNumber(2)
  set subtract(BinaryOp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSubtract() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubtract() => $_clearField(2);
  @$pb.TagNumber(2)
  BinaryOp ensureSubtract() => $_ensure(1);

  @$pb.TagNumber(3)
  BinaryOp get multiply => $_getN(2);
  @$pb.TagNumber(3)
  set multiply(BinaryOp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMultiply() => $_has(2);
  @$pb.TagNumber(3)
  void clearMultiply() => $_clearField(3);
  @$pb.TagNumber(3)
  BinaryOp ensureMultiply() => $_ensure(2);

  @$pb.TagNumber(4)
  BinaryOp get divide => $_getN(3);
  @$pb.TagNumber(4)
  set divide(BinaryOp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDivide() => $_has(3);
  @$pb.TagNumber(4)
  void clearDivide() => $_clearField(4);
  @$pb.TagNumber(4)
  BinaryOp ensureDivide() => $_ensure(3);
}

class BinaryOp extends $pb.GeneratedMessage {
  factory BinaryOp({
    $fixnum.Int64? a,
    $fixnum.Int64? b,
  }) {
    final result = create();
    if (a != null) result.a = a;
    if (b != null) result.b = b;
    return result;
  }

  BinaryOp._();

  factory BinaryOp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BinaryOp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BinaryOp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'a')
    ..aInt64(2, _omitFieldNames ? '' : 'b')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BinaryOp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BinaryOp copyWith(void Function(BinaryOp) updates) =>
      super.copyWith((message) => updates(message as BinaryOp)) as BinaryOp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BinaryOp create() => BinaryOp._();
  @$core.override
  BinaryOp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BinaryOp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BinaryOp>(create);
  static BinaryOp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get a => $_getI64(0);
  @$pb.TagNumber(1)
  set a($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasA() => $_has(0);
  @$pb.TagNumber(1)
  void clearA() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get b => $_getI64(1);
  @$pb.TagNumber(2)
  set b($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasB() => $_has(1);
  @$pb.TagNumber(2)
  void clearB() => $_clearField(2);
}

enum CalculatorResponse_Result { value, error, notSet }

class CalculatorResponse extends $pb.GeneratedMessage {
  factory CalculatorResponse({
    $fixnum.Int64? value,
    ErrorResult? error,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (error != null) result.error = error;
    return result;
  }

  CalculatorResponse._();

  factory CalculatorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CalculatorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CalculatorResponse_Result>
      _CalculatorResponse_ResultByTag = {
    1: CalculatorResponse_Result.value,
    2: CalculatorResponse_Result.error,
    0: CalculatorResponse_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalculatorResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aInt64(1, _omitFieldNames ? '' : 'value')
    ..aOM<ErrorResult>(2, _omitFieldNames ? '' : 'error',
        subBuilder: ErrorResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculatorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalculatorResponse copyWith(void Function(CalculatorResponse) updates) =>
      super.copyWith((message) => updates(message as CalculatorResponse))
          as CalculatorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculatorResponse create() => CalculatorResponse._();
  @$core.override
  CalculatorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CalculatorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CalculatorResponse>(create);
  static CalculatorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  CalculatorResponse_Result whichResult() =>
      _CalculatorResponse_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
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
  ErrorResult get error => $_getN(1);
  @$pb.TagNumber(2)
  set error(ErrorResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
  @$pb.TagNumber(2)
  ErrorResult ensureError() => $_ensure(1);
}

class ErrorResult extends $pb.GeneratedMessage {
  factory ErrorResult({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  ErrorResult._();

  factory ErrorResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'calculator'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResult copyWith(void Function(ErrorResult) updates) =>
      super.copyWith((message) => updates(message as ErrorResult))
          as ErrorResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorResult create() => ErrorResult._();
  @$core.override
  ErrorResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ErrorResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorResult>(create);
  static ErrorResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
