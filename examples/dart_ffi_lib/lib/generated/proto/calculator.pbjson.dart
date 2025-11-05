// This is a generated file - do not edit.
//
// Generated from calculator.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use calculatorRequestDescriptor instead')
const CalculatorRequest$json = {
  '1': 'CalculatorRequest',
  '2': [
    {
      '1': 'add',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.calculator.BinaryOp',
      '9': 0,
      '10': 'add'
    },
    {
      '1': 'subtract',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.calculator.BinaryOp',
      '9': 0,
      '10': 'subtract'
    },
    {
      '1': 'multiply',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.calculator.BinaryOp',
      '9': 0,
      '10': 'multiply'
    },
    {
      '1': 'divide',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.calculator.BinaryOp',
      '9': 0,
      '10': 'divide'
    },
  ],
  '8': [
    {'1': 'operation'},
  ],
};

/// Descriptor for `CalculatorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculatorRequestDescriptor = $convert.base64Decode(
    'ChFDYWxjdWxhdG9yUmVxdWVzdBIoCgNhZGQYASABKAsyFC5jYWxjdWxhdG9yLkJpbmFyeU9wSA'
    'BSA2FkZBIyCghzdWJ0cmFjdBgCIAEoCzIULmNhbGN1bGF0b3IuQmluYXJ5T3BIAFIIc3VidHJh'
    'Y3QSMgoIbXVsdGlwbHkYAyABKAsyFC5jYWxjdWxhdG9yLkJpbmFyeU9wSABSCG11bHRpcGx5Ei'
    '4KBmRpdmlkZRgEIAEoCzIULmNhbGN1bGF0b3IuQmluYXJ5T3BIAFIGZGl2aWRlQgsKCW9wZXJh'
    'dGlvbg==');

@$core.Deprecated('Use binaryOpDescriptor instead')
const BinaryOp$json = {
  '1': 'BinaryOp',
  '2': [
    {'1': 'a', '3': 1, '4': 1, '5': 3, '10': 'a'},
    {'1': 'b', '3': 2, '4': 1, '5': 3, '10': 'b'},
  ],
};

/// Descriptor for `BinaryOp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List binaryOpDescriptor = $convert
    .base64Decode('CghCaW5hcnlPcBIMCgFhGAEgASgDUgFhEgwKAWIYAiABKANSAWI=');

@$core.Deprecated('Use calculatorResponseDescriptor instead')
const CalculatorResponse$json = {
  '1': 'CalculatorResponse',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 3, '9': 0, '10': 'value'},
    {
      '1': 'error',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.calculator.ErrorResult',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `CalculatorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculatorResponseDescriptor = $convert.base64Decode(
    'ChJDYWxjdWxhdG9yUmVzcG9uc2USFgoFdmFsdWUYASABKANIAFIFdmFsdWUSLwoFZXJyb3IYAi'
    'ABKAsyFy5jYWxjdWxhdG9yLkVycm9yUmVzdWx0SABSBWVycm9yQggKBnJlc3VsdA==');

@$core.Deprecated('Use errorResultDescriptor instead')
const ErrorResult$json = {
  '1': 'ErrorResult',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ErrorResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorResultDescriptor = $convert
    .base64Decode('CgtFcnJvclJlc3VsdBIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');
