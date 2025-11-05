// This is a generated file - do not edit.
//
// Generated from complex_data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use addressDescriptor instead')
const Address$json = {
  '1': 'Address',
  '2': [
    {'1': 'street', '3': 1, '4': 1, '5': 9, '10': 'street'},
    {'1': 'city', '3': 2, '4': 1, '5': 9, '10': 'city'},
    {'1': 'state', '3': 3, '4': 1, '5': 9, '10': 'state'},
    {'1': 'zip_code', '3': 4, '4': 1, '5': 9, '10': 'zipCode'},
    {'1': 'country', '3': 5, '4': 1, '5': 9, '10': 'country'},
    {'1': 'latitude', '3': 6, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 7, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode(
    'CgdBZGRyZXNzEhYKBnN0cmVldBgBIAEoCVIGc3RyZWV0EhIKBGNpdHkYAiABKAlSBGNpdHkSFA'
    'oFc3RhdGUYAyABKAlSBXN0YXRlEhkKCHppcF9jb2RlGAQgASgJUgd6aXBDb2RlEhgKB2NvdW50'
    'cnkYBSABKAlSB2NvdW50cnkSGgoIbGF0aXR1ZGUYBiABKAFSCGxhdGl0dWRlEhwKCWxvbmdpdH'
    'VkZRgHIAEoAVIJbG9uZ2l0dWRl');

@$core.Deprecated('Use personDescriptor instead')
const Person$json = {
  '1': 'Person',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'first_name', '3': 2, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'last_name', '3': 3, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'email', '3': 4, '4': 1, '5': 9, '10': 'email'},
    {'1': 'age', '3': 5, '4': 1, '5': 5, '10': 'age'},
    {
      '1': 'home_address',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.calculator.Address',
      '10': 'homeAddress'
    },
    {
      '1': 'work_address',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.calculator.Address',
      '10': 'workAddress'
    },
    {'1': 'phone_numbers', '3': 8, '4': 3, '5': 9, '10': 'phoneNumbers'},
    {
      '1': 'metadata',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.calculator.Person.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [Person_MetadataEntry$json],
};

@$core.Deprecated('Use personDescriptor instead')
const Person_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Person`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List personDescriptor = $convert.base64Decode(
    'CgZQZXJzb24SDgoCaWQYASABKAlSAmlkEh0KCmZpcnN0X25hbWUYAiABKAlSCWZpcnN0TmFtZR'
    'IbCglsYXN0X25hbWUYAyABKAlSCGxhc3ROYW1lEhQKBWVtYWlsGAQgASgJUgVlbWFpbBIQCgNh'
    'Z2UYBSABKAVSA2FnZRI2Cgxob21lX2FkZHJlc3MYBiABKAsyEy5jYWxjdWxhdG9yLkFkZHJlc3'
    'NSC2hvbWVBZGRyZXNzEjYKDHdvcmtfYWRkcmVzcxgHIAEoCzITLmNhbGN1bGF0b3IuQWRkcmVz'
    'c1ILd29ya0FkZHJlc3MSIwoNcGhvbmVfbnVtYmVycxgIIAMoCVIMcGhvbmVOdW1iZXJzEjwKCG'
    '1ldGFkYXRhGAkgAygLMiAuY2FsY3VsYXRvci5QZXJzb24uTWV0YWRhdGFFbnRyeVIIbWV0YWRh'
    'dGEaOwoNTWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdm'
    'FsdWU6AjgB');

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction$json = {
  '1': 'Transaction',
  '2': [
    {'1': 'transaction_id', '3': 1, '4': 1, '5': 9, '10': 'transactionId'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'currency', '3': 4, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'sender',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.calculator.Person',
      '10': 'sender'
    },
    {
      '1': 'receiver',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.calculator.Person',
      '10': 'receiver'
    },
    {'1': 'tags', '3': 7, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'fees',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.calculator.Transaction.FeesEntry',
      '10': 'fees'
    },
  ],
  '3': [Transaction_FeesEntry$json],
};

@$core.Deprecated('Use transactionDescriptor instead')
const Transaction_FeesEntry$json = {
  '1': 'FeesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Transaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionDescriptor = $convert.base64Decode(
    'CgtUcmFuc2FjdGlvbhIlCg50cmFuc2FjdGlvbl9pZBgBIAEoCVINdHJhbnNhY3Rpb25JZBIcCg'
    'l0aW1lc3RhbXAYAiABKANSCXRpbWVzdGFtcBIWCgZhbW91bnQYAyABKAFSBmFtb3VudBIaCghj'
    'dXJyZW5jeRgEIAEoCVIIY3VycmVuY3kSKgoGc2VuZGVyGAUgASgLMhIuY2FsY3VsYXRvci5QZX'
    'Jzb25SBnNlbmRlchIuCghyZWNlaXZlchgGIAEoCzISLmNhbGN1bGF0b3IuUGVyc29uUghyZWNl'
    'aXZlchISCgR0YWdzGAcgAygJUgR0YWdzEjUKBGZlZXMYCCADKAsyIS5jYWxjdWxhdG9yLlRyYW'
    '5zYWN0aW9uLkZlZXNFbnRyeVIEZmVlcxo3CglGZWVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkS'
    'FAoFdmFsdWUYAiABKAFSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use dataBatchDescriptor instead')
const DataBatch$json = {
  '1': 'DataBatch',
  '2': [
    {
      '1': 'transactions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.calculator.Transaction',
      '10': 'transactions'
    },
    {'1': 'batch_id', '3': 2, '4': 1, '5': 3, '10': 'batchId'},
    {'1': 'created_at', '3': 3, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `DataBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataBatchDescriptor = $convert.base64Decode(
    'CglEYXRhQmF0Y2gSOwoMdHJhbnNhY3Rpb25zGAEgAygLMhcuY2FsY3VsYXRvci5UcmFuc2FjdG'
    'lvblIMdHJhbnNhY3Rpb25zEhkKCGJhdGNoX2lkGAIgASgDUgdiYXRjaElkEh0KCmNyZWF0ZWRf'
    'YXQYAyABKANSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use complexCalculationRequestDescriptor instead')
const ComplexCalculationRequest$json = {
  '1': 'ComplexCalculationRequest',
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
    {
      '1': 'batch',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.calculator.BatchOperation',
      '9': 0,
      '10': 'batch'
    },
    {
      '1': 'complex',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.calculator.ComplexDataOperation',
      '9': 0,
      '10': 'complex'
    },
  ],
  '8': [
    {'1': 'operation'},
  ],
};

/// Descriptor for `ComplexCalculationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complexCalculationRequestDescriptor = $convert.base64Decode(
    'ChlDb21wbGV4Q2FsY3VsYXRpb25SZXF1ZXN0EigKA2FkZBgBIAEoCzIULmNhbGN1bGF0b3IuQm'
    'luYXJ5T3BIAFIDYWRkEjIKCHN1YnRyYWN0GAIgASgLMhQuY2FsY3VsYXRvci5CaW5hcnlPcEgA'
    'UghzdWJ0cmFjdBIyCghtdWx0aXBseRgDIAEoCzIULmNhbGN1bGF0b3IuQmluYXJ5T3BIAFIIbX'
    'VsdGlwbHkSLgoGZGl2aWRlGAQgASgLMhQuY2FsY3VsYXRvci5CaW5hcnlPcEgAUgZkaXZpZGUS'
    'MgoFYmF0Y2gYBSABKAsyGi5jYWxjdWxhdG9yLkJhdGNoT3BlcmF0aW9uSABSBWJhdGNoEjwKB2'
    'NvbXBsZXgYBiABKAsyIC5jYWxjdWxhdG9yLkNvbXBsZXhEYXRhT3BlcmF0aW9uSABSB2NvbXBs'
    'ZXhCCwoJb3BlcmF0aW9u');

@$core.Deprecated('Use batchOperationDescriptor instead')
const BatchOperation$json = {
  '1': 'BatchOperation',
  '2': [
    {
      '1': 'operations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.calculator.BinaryOp',
      '10': 'operations'
    },
  ],
};

/// Descriptor for `BatchOperation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchOperationDescriptor = $convert.base64Decode(
    'Cg5CYXRjaE9wZXJhdGlvbhI0CgpvcGVyYXRpb25zGAEgAygLMhQuY2FsY3VsYXRvci5CaW5hcn'
    'lPcFIKb3BlcmF0aW9ucw==');

@$core.Deprecated('Use complexDataOperationDescriptor instead')
const ComplexDataOperation$json = {
  '1': 'ComplexDataOperation',
  '2': [
    {
      '1': 'data',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.calculator.DataBatch',
      '10': 'data'
    },
    {'1': 'operation_type', '3': 2, '4': 1, '5': 9, '10': 'operationType'},
  ],
};

/// Descriptor for `ComplexDataOperation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complexDataOperationDescriptor = $convert.base64Decode(
    'ChRDb21wbGV4RGF0YU9wZXJhdGlvbhIpCgRkYXRhGAEgASgLMhUuY2FsY3VsYXRvci5EYXRhQm'
    'F0Y2hSBGRhdGESJQoOb3BlcmF0aW9uX3R5cGUYAiABKAlSDW9wZXJhdGlvblR5cGU=');

@$core.Deprecated('Use complexCalculationResponseDescriptor instead')
const ComplexCalculationResponse$json = {
  '1': 'ComplexCalculationResponse',
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
    {
      '1': 'batch_result',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.calculator.BatchResult',
      '9': 0,
      '10': 'batchResult'
    },
    {
      '1': 'complex_result',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.calculator.ComplexDataResult',
      '9': 0,
      '10': 'complexResult'
    },
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `ComplexCalculationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complexCalculationResponseDescriptor = $convert.base64Decode(
    'ChpDb21wbGV4Q2FsY3VsYXRpb25SZXNwb25zZRIWCgV2YWx1ZRgBIAEoA0gAUgV2YWx1ZRIvCg'
    'VlcnJvchgCIAEoCzIXLmNhbGN1bGF0b3IuRXJyb3JSZXN1bHRIAFIFZXJyb3ISPAoMYmF0Y2hf'
    'cmVzdWx0GAMgASgLMhcuY2FsY3VsYXRvci5CYXRjaFJlc3VsdEgAUgtiYXRjaFJlc3VsdBJGCg'
    '5jb21wbGV4X3Jlc3VsdBgEIAEoCzIdLmNhbGN1bGF0b3IuQ29tcGxleERhdGFSZXN1bHRIAFIN'
    'Y29tcGxleFJlc3VsdEIICgZyZXN1bHQ=');

@$core.Deprecated('Use batchResultDescriptor instead')
const BatchResult$json = {
  '1': 'BatchResult',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 3, '10': 'values'},
    {'1': 'success_count', '3': 2, '4': 1, '5': 5, '10': 'successCount'},
    {'1': 'error_count', '3': 3, '4': 1, '5': 5, '10': 'errorCount'},
  ],
};

/// Descriptor for `BatchResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchResultDescriptor = $convert.base64Decode(
    'CgtCYXRjaFJlc3VsdBIWCgZ2YWx1ZXMYASADKANSBnZhbHVlcxIjCg1zdWNjZXNzX2NvdW50GA'
    'IgASgFUgxzdWNjZXNzQ291bnQSHwoLZXJyb3JfY291bnQYAyABKAVSCmVycm9yQ291bnQ=');

@$core.Deprecated('Use complexDataResultDescriptor instead')
const ComplexDataResult$json = {
  '1': 'ComplexDataResult',
  '2': [
    {
      '1': 'transaction_count',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'transactionCount'
    },
    {'1': 'total_amount', '3': 2, '4': 1, '5': 1, '10': 'totalAmount'},
    {
      '1': 'processing_time_ns',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'processingTimeNs'
    },
    {
      '1': 'stats',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.calculator.ComplexDataResult.StatsEntry',
      '10': 'stats'
    },
  ],
  '3': [ComplexDataResult_StatsEntry$json],
};

@$core.Deprecated('Use complexDataResultDescriptor instead')
const ComplexDataResult_StatsEntry$json = {
  '1': 'StatsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ComplexDataResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complexDataResultDescriptor = $convert.base64Decode(
    'ChFDb21wbGV4RGF0YVJlc3VsdBIrChF0cmFuc2FjdGlvbl9jb3VudBgBIAEoBVIQdHJhbnNhY3'
    'Rpb25Db3VudBIhCgx0b3RhbF9hbW91bnQYAiABKAFSC3RvdGFsQW1vdW50EiwKEnByb2Nlc3Np'
    'bmdfdGltZV9ucxgDIAEoA1IQcHJvY2Vzc2luZ1RpbWVOcxI+CgVzdGF0cxgEIAMoCzIoLmNhbG'
    'N1bGF0b3IuQ29tcGxleERhdGFSZXN1bHQuU3RhdHNFbnRyeVIFc3RhdHMaOAoKU3RhdHNFbnRy'
    'eRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgB');
