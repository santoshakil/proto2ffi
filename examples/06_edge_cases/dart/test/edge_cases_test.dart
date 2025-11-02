import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:edge_cases/generated.dart';

typedef CreateIntegerLimitsNative = ffi.Pointer<IntegerLimits> Function(
  ffi.Int32, ffi.Int32, ffi.Uint32, ffi.Uint32,
  ffi.Int64, ffi.Int64, ffi.Uint64, ffi.Uint64,
  ffi.Int32, ffi.Int32, ffi.Int64, ffi.Int64,
  ffi.Uint32, ffi.Uint32, ffi.Uint64, ffi.Uint64,
  ffi.Int32, ffi.Int32, ffi.Int64, ffi.Int64,
);
typedef CreateIntegerLimits = ffi.Pointer<IntegerLimits> Function(
  int, int, int, int,
  int, int, int, int,
  int, int, int, int,
  int, int, int, int,
  int, int, int, int,
);

typedef CreateFloatEdgeCasesNative = ffi.Pointer<FloatEdgeCases> Function(
  ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float, ffi.Float,
  ffi.Double, ffi.Double, ffi.Double, ffi.Double, ffi.Double, ffi.Double, ffi.Double, ffi.Double,
);
typedef CreateFloatEdgeCases = ffi.Pointer<FloatEdgeCases> Function(
  double, double, double, double, double, double, double, double,
  double, double, double, double, double, double, double, double,
);

typedef CreateStringSizesNative = ffi.Pointer<StringSizes> Function(
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
);
typedef CreateStringSizes = ffi.Pointer<StringSizes> Function(
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
);

typedef CreateArraySizesNative = ffi.Pointer<ArraySizes> Function(
  ffi.Pointer<ffi.Int32>, ffi.Size,
  ffi.Pointer<ffi.Int32>, ffi.Size,
  ffi.Pointer<ffi.Int32>, ffi.Size,
  ffi.Pointer<ffi.Int32>, ffi.Size,
);
typedef CreateArraySizes = ffi.Pointer<ArraySizes> Function(
  ffi.Pointer<ffi.Int32>, int,
  ffi.Pointer<ffi.Int32>, int,
  ffi.Pointer<ffi.Int32>, int,
  ffi.Pointer<ffi.Int32>, int,
);

typedef CreateDeeplyNestedNative = ffi.Pointer<Level1> Function(
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Pointer<ffi.Uint8>, ffi.Size,
  ffi.Int32,
);
typedef CreateDeeplyNested = ffi.Pointer<Level1> Function(
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  ffi.Pointer<ffi.Uint8>, int,
  int,
);

typedef CreateManyFieldsNative = ffi.Pointer<ManyFields> Function(ffi.Pointer<ffi.Int32>);
typedef CreateManyFields = ffi.Pointer<ManyFields> Function(ffi.Pointer<ffi.Int32>);

typedef CreateBooleanOnlyNative = ffi.Pointer<BooleanOnly> Function(
  ffi.Bool, ffi.Bool, ffi.Bool, ffi.Bool, ffi.Bool, ffi.Bool, ffi.Bool, ffi.Bool,
);
typedef CreateBooleanOnly = ffi.Pointer<BooleanOnly> Function(
  bool, bool, bool, bool, bool, bool, bool, bool,
);

typedef CreateEnumOnlyNative = ffi.Pointer<EnumOnly> Function(
  ffi.Int32, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Int32, ffi.Int32,
);
typedef CreateEnumOnly = ffi.Pointer<EnumOnly> Function(
  int, int, int, int, int, int, int, int,
);

typedef CreateEmptyMessageNative = ffi.Pointer<EmptyMessage> Function();
typedef CreateEmptyMessage = ffi.Pointer<EmptyMessage> Function();

typedef CreateSingleFieldNative = ffi.Pointer<SingleField> Function(ffi.Pointer<ffi.Uint8>, ffi.Size);
typedef CreateSingleField = ffi.Pointer<SingleField> Function(ffi.Pointer<ffi.Uint8>, int);

typedef VerifyStringRoundtripNative = ffi.Bool Function(
  ffi.Pointer<StringSizes>,
  ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Pointer<ffi.Size>,
);
typedef VerifyStringRoundtrip = bool Function(
  ffi.Pointer<StringSizes>,
  ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Uint8>>, ffi.Pointer<ffi.Size>,
);

typedef VerifyArrayRoundtripNative = ffi.Bool Function(
  ffi.Pointer<ArraySizes>,
  ffi.Pointer<ffi.Pointer<ffi.Int32>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Int32>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Int32>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Int32>>, ffi.Pointer<ffi.Size>,
);
typedef VerifyArrayRoundtrip = bool Function(
  ffi.Pointer<ArraySizes>,
  ffi.Pointer<ffi.Pointer<ffi.Int32>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Int32>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Int32>>, ffi.Pointer<ffi.Size>,
  ffi.Pointer<ffi.Pointer<ffi.Int32>>, ffi.Pointer<ffi.Size>,
);

typedef GetDeeplyNestedValueNative = ffi.Int32 Function(ffi.Pointer<Level1>);
typedef GetDeeplyNestedValue = int Function(ffi.Pointer<Level1>);

typedef SumManyFieldsNative = ffi.Int64 Function(ffi.Pointer<ManyFields>);
typedef SumManyFields = int Function(ffi.Pointer<ManyFields>);

typedef CountTrueFlagsNative = ffi.Int32 Function(ffi.Pointer<BooleanOnly>);
typedef CountTrueFlags = int Function(ffi.Pointer<BooleanOnly>);

typedef FreeIntegerLimitsNative = ffi.Void Function(ffi.Pointer<IntegerLimits>);
typedef FreeIntegerLimits = void Function(ffi.Pointer<IntegerLimits>);

typedef FreeFloatEdgeCasesNative = ffi.Void Function(ffi.Pointer<FloatEdgeCases>);
typedef FreeFloatEdgeCases = void Function(ffi.Pointer<FloatEdgeCases>);

typedef FreeStringSizesNative = ffi.Void Function(ffi.Pointer<StringSizes>);
typedef FreeStringSizes = void Function(ffi.Pointer<StringSizes>);

typedef FreeArraySizesNative = ffi.Void Function(ffi.Pointer<ArraySizes>);
typedef FreeArraySizes = void Function(ffi.Pointer<ArraySizes>);

typedef FreeLevel1Native = ffi.Void Function(ffi.Pointer<Level1>);
typedef FreeLevel1 = void Function(ffi.Pointer<Level1>);

typedef FreeManyFieldsNative = ffi.Void Function(ffi.Pointer<ManyFields>);
typedef FreeManyFields = void Function(ffi.Pointer<ManyFields>);

typedef FreeBooleanOnlyNative = ffi.Void Function(ffi.Pointer<BooleanOnly>);
typedef FreeBooleanOnly = void Function(ffi.Pointer<BooleanOnly>);

typedef FreeEnumOnlyNative = ffi.Void Function(ffi.Pointer<EnumOnly>);
typedef FreeEnumOnly = void Function(ffi.Pointer<EnumOnly>);

typedef FreeEmptyMessageNative = ffi.Void Function(ffi.Pointer<EmptyMessage>);
typedef FreeEmptyMessage = void Function(ffi.Pointer<EmptyMessage>);

typedef FreeSingleFieldNative = ffi.Void Function(ffi.Pointer<SingleField>);
typedef FreeSingleField = void Function(ffi.Pointer<SingleField>);

late ffi.DynamicLibrary lib;
late CreateIntegerLimits createIntegerLimits;
late CreateFloatEdgeCases createFloatEdgeCases;
late CreateStringSizes createStringSizes;
late CreateArraySizes createArraySizes;
late CreateDeeplyNested createDeeplyNested;
late CreateManyFields createManyFields;
late CreateBooleanOnly createBooleanOnly;
late CreateEnumOnly createEnumOnly;
late CreateEmptyMessage createEmptyMessage;
late CreateSingleField createSingleField;
late VerifyStringRoundtrip verifyStringRoundtrip;
late VerifyArrayRoundtrip verifyArrayRoundtrip;
late GetDeeplyNestedValue getDeeplyNestedValue;
late SumManyFields sumManyFields;
late CountTrueFlags countTrueFlags;
late FreeIntegerLimits freeIntegerLimits;
late FreeFloatEdgeCases freeFloatEdgeCases;
late FreeStringSizes freeStringSizes;
late FreeArraySizes freeArraySizes;
late FreeLevel1 freeLevel1;
late FreeManyFields freeManyFields;
late FreeBooleanOnly freeBooleanOnly;
late FreeEnumOnly freeEnumOnly;
late FreeEmptyMessage freeEmptyMessage;
late FreeSingleField freeSingleField;

void main() {
  setUpAll(() {
    var libraryPath = '../rust/target/debug/libedge_cases.dylib';
    if (Platform.isMacOS) {
      libraryPath = '../rust/target/debug/libedge_cases.dylib';
    } else if (Platform.isLinux) {
      libraryPath = '../rust/target/debug/libedge_cases.so';
    } else if (Platform.isWindows) {
      libraryPath = '../rust/target/debug/edge_cases.dll';
    }

    lib = ffi.DynamicLibrary.open(libraryPath);

    createIntegerLimits = lib.lookup<ffi.NativeFunction<CreateIntegerLimitsNative>>('create_integer_limits').asFunction();
    createFloatEdgeCases = lib.lookup<ffi.NativeFunction<CreateFloatEdgeCasesNative>>('create_float_edge_cases').asFunction();
    createStringSizes = lib.lookup<ffi.NativeFunction<CreateStringSizesNative>>('create_string_sizes').asFunction();
    createArraySizes = lib.lookup<ffi.NativeFunction<CreateArraySizesNative>>('create_array_sizes').asFunction();
    createDeeplyNested = lib.lookup<ffi.NativeFunction<CreateDeeplyNestedNative>>('create_deeply_nested').asFunction();
    createManyFields = lib.lookup<ffi.NativeFunction<CreateManyFieldsNative>>('create_many_fields').asFunction();
    createBooleanOnly = lib.lookup<ffi.NativeFunction<CreateBooleanOnlyNative>>('create_boolean_only').asFunction();
    createEnumOnly = lib.lookup<ffi.NativeFunction<CreateEnumOnlyNative>>('create_enum_only').asFunction();
    createEmptyMessage = lib.lookup<ffi.NativeFunction<CreateEmptyMessageNative>>('create_empty_message').asFunction();
    createSingleField = lib.lookup<ffi.NativeFunction<CreateSingleFieldNative>>('create_single_field').asFunction();
    verifyStringRoundtrip = lib.lookup<ffi.NativeFunction<VerifyStringRoundtripNative>>('verify_string_roundtrip').asFunction();
    verifyArrayRoundtrip = lib.lookup<ffi.NativeFunction<VerifyArrayRoundtripNative>>('verify_array_roundtrip').asFunction();
    getDeeplyNestedValue = lib.lookup<ffi.NativeFunction<GetDeeplyNestedValueNative>>('get_deeply_nested_value').asFunction();
    sumManyFields = lib.lookup<ffi.NativeFunction<SumManyFieldsNative>>('sum_many_fields').asFunction();
    countTrueFlags = lib.lookup<ffi.NativeFunction<CountTrueFlagsNative>>('count_true_flags').asFunction();
    freeIntegerLimits = lib.lookup<ffi.NativeFunction<FreeIntegerLimitsNative>>('free_integer_limits').asFunction();
    freeFloatEdgeCases = lib.lookup<ffi.NativeFunction<FreeFloatEdgeCasesNative>>('free_float_edge_cases').asFunction();
    freeStringSizes = lib.lookup<ffi.NativeFunction<FreeStringSizesNative>>('free_string_sizes').asFunction();
    freeArraySizes = lib.lookup<ffi.NativeFunction<FreeArraySizesNative>>('free_array_sizes').asFunction();
    freeLevel1 = lib.lookup<ffi.NativeFunction<FreeLevel1Native>>('free_level1').asFunction();
    freeManyFields = lib.lookup<ffi.NativeFunction<FreeManyFieldsNative>>('free_many_fields').asFunction();
    freeBooleanOnly = lib.lookup<ffi.NativeFunction<FreeBooleanOnlyNative>>('free_boolean_only').asFunction();
    freeEnumOnly = lib.lookup<ffi.NativeFunction<FreeEnumOnlyNative>>('free_enum_only').asFunction();
    freeEmptyMessage = lib.lookup<ffi.NativeFunction<FreeEmptyMessageNative>>('free_empty_message').asFunction();
    freeSingleField = lib.lookup<ffi.NativeFunction<FreeSingleFieldNative>>('free_single_field').asFunction();
  });

  group('Integer Limits', () {
    test('int32 min/max values', () {
      final ptr = createIntegerLimits(
        -2147483648, 2147483647, 0, 4294967295,
        -9223372036854775808, 9223372036854775807, 0, 18446744073709551615,
        -2147483648, 2147483647, -9223372036854775808, 9223372036854775807,
        0, 4294967295, 0, 18446744073709551615,
        -2147483648, 2147483647, -9223372036854775808, 9223372036854775807,
      );

      expect(ptr.address, isNot(0));
      final msg = ptr.ref;
      expect(msg.int32_min, equals(-2147483648));
      expect(msg.int32_max, equals(2147483647));

      freeIntegerLimits(ptr);
    });

    test('uint32 min/max values', () {
      final ptr = createIntegerLimits(
        0, 0, 0, 4294967295,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 4294967295, 0, 0,
        0, 0, 0, 0,
      );

      final msg = ptr.ref;
      expect(msg.uint32_min, equals(0));
      expect(msg.uint32_max, equals(4294967295));

      freeIntegerLimits(ptr);
    });

    test('int64 min/max values', () {
      final ptr = createIntegerLimits(
        0, 0, 0, 0,
        -9223372036854775808, 9223372036854775807, 0, 0,
        0, 0, -9223372036854775808, 9223372036854775807,
        0, 0, 0, 0,
        0, 0, -9223372036854775808, 9223372036854775807,
      );

      final msg = ptr.ref;
      expect(msg.int64_min, equals(-9223372036854775808));
      expect(msg.int64_max, equals(9223372036854775807));

      freeIntegerLimits(ptr);
    });

    test('uint64 min/max values', () {
      final ptr = createIntegerLimits(
        0, 0, 0, 0,
        0, 0, 0, 18446744073709551615,
        0, 0, 0, 0,
        0, 0, 0, 18446744073709551615,
        0, 0, 0, 0,
      );

      final msg = ptr.ref;
      expect(msg.uint64_min, equals(0));
      expect(msg.uint64_max, equals(18446744073709551615));

      freeIntegerLimits(ptr);
    });
  });

  group('Float Edge Cases', () {
    test('zero and negative zero', () {
      final ptr = createFloatEdgeCases(
        0.0, -0.0, double.infinity, double.negativeInfinity, double.nan,
        1.0, 1.0, 1.0,
        0.0, -0.0, double.infinity, double.negativeInfinity, double.nan,
        1.0, 1.0, 1.0,
      );

      final msg = ptr.ref;
      expect(msg.zero, equals(0.0));
      expect(msg.negative_zero.isNegative, isFalse);
      expect(msg.d_zero, equals(0.0));

      freeFloatEdgeCases(ptr);
    });

    test('infinity values', () {
      final ptr = createFloatEdgeCases(
        0.0, 0.0, double.infinity, double.negativeInfinity, 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, double.infinity, double.negativeInfinity, 0.0,
        0.0, 0.0, 0.0,
      );

      final msg = ptr.ref;
      expect(msg.infinity.isInfinite, isTrue);
      expect(msg.infinity.isNegative, isFalse);
      expect(msg.negative_infinity.isInfinite, isTrue);
      expect(msg.negative_infinity.isNegative, isTrue);
      expect(msg.d_infinity.isInfinite, isTrue);
      expect(msg.d_negative_infinity.isInfinite, isTrue);

      freeFloatEdgeCases(ptr);
    });

    test('NaN values', () {
      final ptr = createFloatEdgeCases(
        0.0, 0.0, 0.0, 0.0, double.nan,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, double.nan,
        0.0, 0.0, 0.0,
      );

      final msg = ptr.ref;
      expect(msg.nan.isNaN, isTrue);
      expect(msg.d_nan.isNaN, isTrue);

      freeFloatEdgeCases(ptr);
    });

    test('extreme float values', () {
      final ptr = createFloatEdgeCases(
        0.0, 0.0, 0.0, 0.0, 0.0,
        1.17549435e-38, 3.40282347e+38, -3.40282347e+38,
        0.0, 0.0, 0.0, 0.0, 0.0,
        2.2250738585072014e-308, 1.7976931348623157e+308, -1.7976931348623157e+308,
      );

      final msg = ptr.ref;
      expect(msg.min_positive, greaterThan(0));
      expect(msg.max_value, greaterThan(0));
      expect(msg.min_value, lessThan(0));
      expect(msg.d_min_positive, greaterThan(0));
      expect(msg.d_max_value, greaterThan(0));
      expect(msg.d_min_value, lessThan(0));

      freeFloatEdgeCases(ptr);
    });
  });

  group('String Sizes', () {
    test('empty string', () {
      final empty = '';
      final emptyBytes = ffi.nullptr;
      final small = 'A' * 255;
      final smallBytes = Uint8List.fromList(small.codeUnits);
      final smallPtr = ffi.malloc<ffi.Uint8>(smallBytes.length);
      smallPtr.asTypedList(smallBytes.length).setAll(0, smallBytes);

      final ptr = createStringSizes(
        emptyBytes, 0,
        smallPtr, smallBytes.length,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
      );

      expect(ptr.address, isNot(0));

      ffi.malloc.free(smallPtr);
      freeStringSizes(ptr);
    });

    test('255 character string', () {
      final str = 'A' * 255;
      final bytes = Uint8List.fromList(str.codeUnits);
      final strPtr = ffi.malloc<ffi.Uint8>(bytes.length);
      strPtr.asTypedList(bytes.length).setAll(0, bytes);

      final ptr = createStringSizes(
        ffi.nullptr, 0,
        strPtr, bytes.length,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
      );

      final outEmptyPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outEmptyLen = ffi.malloc<ffi.Size>();
      final outSmallPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outSmallLen = ffi.malloc<ffi.Size>();
      final outMediumPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outMediumLen = ffi.malloc<ffi.Size>();
      final outLargePtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outLargeLen = ffi.malloc<ffi.Size>();

      final success = verifyStringRoundtrip(
        ptr,
        outEmptyPtr, outEmptyLen,
        outSmallPtr, outSmallLen,
        outMediumPtr, outMediumLen,
        outLargePtr, outLargeLen,
      );

      expect(success, isTrue);
      expect(outSmallLen.value, equals(255));

      ffi.malloc.free(outEmptyPtr);
      ffi.malloc.free(outEmptyLen);
      ffi.malloc.free(outSmallPtr);
      ffi.malloc.free(outSmallLen);
      ffi.malloc.free(outMediumPtr);
      ffi.malloc.free(outMediumLen);
      ffi.malloc.free(outLargePtr);
      ffi.malloc.free(outLargeLen);
      ffi.malloc.free(strPtr);
      freeStringSizes(ptr);
    });

    test('1024 character string', () {
      final str = 'B' * 1024;
      final bytes = Uint8List.fromList(str.codeUnits);
      final strPtr = ffi.malloc<ffi.Uint8>(bytes.length);
      strPtr.asTypedList(bytes.length).setAll(0, bytes);

      final ptr = createStringSizes(
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        strPtr, bytes.length,
        ffi.nullptr, 0,
      );

      final outEmptyPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outEmptyLen = ffi.malloc<ffi.Size>();
      final outSmallPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outSmallLen = ffi.malloc<ffi.Size>();
      final outMediumPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outMediumLen = ffi.malloc<ffi.Size>();
      final outLargePtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outLargeLen = ffi.malloc<ffi.Size>();

      final success = verifyStringRoundtrip(
        ptr,
        outEmptyPtr, outEmptyLen,
        outSmallPtr, outSmallLen,
        outMediumPtr, outMediumLen,
        outLargePtr, outLargeLen,
      );

      expect(success, isTrue);
      expect(outMediumLen.value, equals(1024));

      ffi.malloc.free(outEmptyPtr);
      ffi.malloc.free(outEmptyLen);
      ffi.malloc.free(outSmallPtr);
      ffi.malloc.free(outSmallLen);
      ffi.malloc.free(outMediumPtr);
      ffi.malloc.free(outMediumLen);
      ffi.malloc.free(outLargePtr);
      ffi.malloc.free(outLargeLen);
      ffi.malloc.free(strPtr);
      freeStringSizes(ptr);
    });

    test('4096 character string', () {
      final str = 'C' * 4096;
      final bytes = Uint8List.fromList(str.codeUnits);
      final strPtr = ffi.malloc<ffi.Uint8>(bytes.length);
      strPtr.asTypedList(bytes.length).setAll(0, bytes);

      final ptr = createStringSizes(
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        strPtr, bytes.length,
      );

      final outEmptyPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outEmptyLen = ffi.malloc<ffi.Size>();
      final outSmallPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outSmallLen = ffi.malloc<ffi.Size>();
      final outMediumPtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outMediumLen = ffi.malloc<ffi.Size>();
      final outLargePtr = ffi.malloc<ffi.Pointer<ffi.Uint8>>();
      final outLargeLen = ffi.malloc<ffi.Size>();

      final success = verifyStringRoundtrip(
        ptr,
        outEmptyPtr, outEmptyLen,
        outSmallPtr, outSmallLen,
        outMediumPtr, outMediumLen,
        outLargePtr, outLargeLen,
      );

      expect(success, isTrue);
      expect(outLargeLen.value, equals(4096));

      ffi.malloc.free(outEmptyPtr);
      ffi.malloc.free(outEmptyLen);
      ffi.malloc.free(outSmallPtr);
      ffi.malloc.free(outSmallLen);
      ffi.malloc.free(outMediumPtr);
      ffi.malloc.free(outMediumLen);
      ffi.malloc.free(outLargePtr);
      ffi.malloc.free(outLargeLen);
      ffi.malloc.free(strPtr);
      freeStringSizes(ptr);
    });
  });

  group('Array Sizes', () {
    test('empty array', () {
      final ptr = createArraySizes(
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
      );

      expect(ptr.address, isNot(0));
      freeArraySizes(ptr);
    });

    test('small array (100 elements)', () {
      final data = Int32List(100);
      for (var i = 0; i < 100; i++) {
        data[i] = i;
      }
      final dataPtr = ffi.malloc<ffi.Int32>(100);
      dataPtr.asTypedList(100).setAll(0, data);

      final ptr = createArraySizes(
        ffi.nullptr, 0,
        dataPtr, 100,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
      );

      final outEmptyPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outEmptyLen = ffi.malloc<ffi.Size>();
      final outSmallPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outSmallLen = ffi.malloc<ffi.Size>();
      final outMediumPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outMediumLen = ffi.malloc<ffi.Size>();
      final outLargePtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outLargeLen = ffi.malloc<ffi.Size>();

      final success = verifyArrayRoundtrip(
        ptr,
        outEmptyPtr, outEmptyLen,
        outSmallPtr, outSmallLen,
        outMediumPtr, outMediumLen,
        outLargePtr, outLargeLen,
      );

      expect(success, isTrue);
      expect(outSmallLen.value, equals(100));

      ffi.malloc.free(outEmptyPtr);
      ffi.malloc.free(outEmptyLen);
      ffi.malloc.free(outSmallPtr);
      ffi.malloc.free(outSmallLen);
      ffi.malloc.free(outMediumPtr);
      ffi.malloc.free(outMediumLen);
      ffi.malloc.free(outLargePtr);
      ffi.malloc.free(outLargeLen);
      ffi.malloc.free(dataPtr);
      freeArraySizes(ptr);
    });

    test('medium array (1000 elements)', () {
      final data = Int32List(1000);
      for (var i = 0; i < 1000; i++) {
        data[i] = i;
      }
      final dataPtr = ffi.malloc<ffi.Int32>(1000);
      dataPtr.asTypedList(1000).setAll(0, data);

      final ptr = createArraySizes(
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        dataPtr, 1000,
        ffi.nullptr, 0,
      );

      final outEmptyPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outEmptyLen = ffi.malloc<ffi.Size>();
      final outSmallPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outSmallLen = ffi.malloc<ffi.Size>();
      final outMediumPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outMediumLen = ffi.malloc<ffi.Size>();
      final outLargePtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outLargeLen = ffi.malloc<ffi.Size>();

      final success = verifyArrayRoundtrip(
        ptr,
        outEmptyPtr, outEmptyLen,
        outSmallPtr, outSmallLen,
        outMediumPtr, outMediumLen,
        outLargePtr, outLargeLen,
      );

      expect(success, isTrue);
      expect(outMediumLen.value, equals(1000));

      ffi.malloc.free(outEmptyPtr);
      ffi.malloc.free(outEmptyLen);
      ffi.malloc.free(outSmallPtr);
      ffi.malloc.free(outSmallLen);
      ffi.malloc.free(outMediumPtr);
      ffi.malloc.free(outMediumLen);
      ffi.malloc.free(outLargePtr);
      ffi.malloc.free(outLargeLen);
      ffi.malloc.free(dataPtr);
      freeArraySizes(ptr);
    });

    test('large array (10000 elements)', () {
      final data = Int32List(10000);
      for (var i = 0; i < 10000; i++) {
        data[i] = i;
      }
      final dataPtr = ffi.malloc<ffi.Int32>(10000);
      dataPtr.asTypedList(10000).setAll(0, data);

      final ptr = createArraySizes(
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        dataPtr, 10000,
      );

      final outEmptyPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outEmptyLen = ffi.malloc<ffi.Size>();
      final outSmallPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outSmallLen = ffi.malloc<ffi.Size>();
      final outMediumPtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outMediumLen = ffi.malloc<ffi.Size>();
      final outLargePtr = ffi.malloc<ffi.Pointer<ffi.Int32>>();
      final outLargeLen = ffi.malloc<ffi.Size>();

      final success = verifyArrayRoundtrip(
        ptr,
        outEmptyPtr, outEmptyLen,
        outSmallPtr, outSmallLen,
        outMediumPtr, outMediumLen,
        outLargePtr, outLargeLen,
      );

      expect(success, isTrue);
      expect(outLargeLen.value, equals(10000));

      ffi.malloc.free(outEmptyPtr);
      ffi.malloc.free(outEmptyLen);
      ffi.malloc.free(outSmallPtr);
      ffi.malloc.free(outSmallLen);
      ffi.malloc.free(outMediumPtr);
      ffi.malloc.free(outMediumLen);
      ffi.malloc.free(outLargePtr);
      ffi.malloc.free(outLargeLen);
      ffi.malloc.free(dataPtr);
      freeArraySizes(ptr);
    });
  });

  group('Deeply Nested Messages', () {
    test('10 levels deep nesting', () {
      final l1 = 'L1';
      final l2 = 'L2';
      final l3 = 'L3';
      final l4 = 'L4';
      final l5 = 'L5';
      final l6 = 'L6';
      final l7 = 'L7';
      final l8 = 'L8';
      final l9 = 'L9';
      final l10 = 'L10';

      final l1Bytes = Uint8List.fromList(l1.codeUnits);
      final l2Bytes = Uint8List.fromList(l2.codeUnits);
      final l3Bytes = Uint8List.fromList(l3.codeUnits);
      final l4Bytes = Uint8List.fromList(l4.codeUnits);
      final l5Bytes = Uint8List.fromList(l5.codeUnits);
      final l6Bytes = Uint8List.fromList(l6.codeUnits);
      final l7Bytes = Uint8List.fromList(l7.codeUnits);
      final l8Bytes = Uint8List.fromList(l8.codeUnits);
      final l9Bytes = Uint8List.fromList(l9.codeUnits);
      final l10Bytes = Uint8List.fromList(l10.codeUnits);

      final l1Ptr = ffi.malloc<ffi.Uint8>(l1Bytes.length);
      l1Ptr.asTypedList(l1Bytes.length).setAll(0, l1Bytes);
      final l2Ptr = ffi.malloc<ffi.Uint8>(l2Bytes.length);
      l2Ptr.asTypedList(l2Bytes.length).setAll(0, l2Bytes);
      final l3Ptr = ffi.malloc<ffi.Uint8>(l3Bytes.length);
      l3Ptr.asTypedList(l3Bytes.length).setAll(0, l3Bytes);
      final l4Ptr = ffi.malloc<ffi.Uint8>(l4Bytes.length);
      l4Ptr.asTypedList(l4Bytes.length).setAll(0, l4Bytes);
      final l5Ptr = ffi.malloc<ffi.Uint8>(l5Bytes.length);
      l5Ptr.asTypedList(l5Bytes.length).setAll(0, l5Bytes);
      final l6Ptr = ffi.malloc<ffi.Uint8>(l6Bytes.length);
      l6Ptr.asTypedList(l6Bytes.length).setAll(0, l6Bytes);
      final l7Ptr = ffi.malloc<ffi.Uint8>(l7Bytes.length);
      l7Ptr.asTypedList(l7Bytes.length).setAll(0, l7Bytes);
      final l8Ptr = ffi.malloc<ffi.Uint8>(l8Bytes.length);
      l8Ptr.asTypedList(l8Bytes.length).setAll(0, l8Bytes);
      final l9Ptr = ffi.malloc<ffi.Uint8>(l9Bytes.length);
      l9Ptr.asTypedList(l9Bytes.length).setAll(0, l9Bytes);
      final l10Ptr = ffi.malloc<ffi.Uint8>(l10Bytes.length);
      l10Ptr.asTypedList(l10Bytes.length).setAll(0, l10Bytes);

      final ptr = createDeeplyNested(
        l1Ptr, l1Bytes.length,
        l2Ptr, l2Bytes.length,
        l3Ptr, l3Bytes.length,
        l4Ptr, l4Bytes.length,
        l5Ptr, l5Bytes.length,
        l6Ptr, l6Bytes.length,
        l7Ptr, l7Bytes.length,
        l8Ptr, l8Bytes.length,
        l9Ptr, l9Bytes.length,
        l10Ptr, l10Bytes.length,
        42,
      );

      expect(ptr.address, isNot(0));
      final value = getDeeplyNestedValue(ptr);
      expect(value, equals(42));

      ffi.malloc.free(l1Ptr);
      ffi.malloc.free(l2Ptr);
      ffi.malloc.free(l3Ptr);
      ffi.malloc.free(l4Ptr);
      ffi.malloc.free(l5Ptr);
      ffi.malloc.free(l6Ptr);
      ffi.malloc.free(l7Ptr);
      ffi.malloc.free(l8Ptr);
      ffi.malloc.free(l9Ptr);
      ffi.malloc.free(l10Ptr);
      freeLevel1(ptr);
    });
  });

  group('Many Fields Message', () {
    test('message with 55 fields', () {
      final data = Int32List(55);
      for (var i = 0; i < 55; i++) {
        data[i] = i + 1;
      }
      final dataPtr = ffi.malloc<ffi.Int32>(55);
      dataPtr.asTypedList(55).setAll(0, data);

      final ptr = createManyFields(dataPtr);
      expect(ptr.address, isNot(0));

      final sum = sumManyFields(ptr);
      final expectedSum = (55 * 56) ~/ 2;
      expect(sum, equals(expectedSum));

      ffi.malloc.free(dataPtr);
      freeManyFields(ptr);
    });

    test('many fields with max values', () {
      final data = Int32List(55);
      for (var i = 0; i < 55; i++) {
        data[i] = 2147483647;
      }
      final dataPtr = ffi.malloc<ffi.Int32>(55);
      dataPtr.asTypedList(55).setAll(0, data);

      final ptr = createManyFields(dataPtr);
      expect(ptr.address, isNot(0));

      ffi.malloc.free(dataPtr);
      freeManyFields(ptr);
    });
  });

  group('Boolean Only Message', () {
    test('all true flags', () {
      final ptr = createBooleanOnly(true, true, true, true, true, true, true, true);
      expect(ptr.address, isNot(0));

      final count = countTrueFlags(ptr);
      expect(count, equals(8));

      freeBooleanOnly(ptr);
    });

    test('all false flags', () {
      final ptr = createBooleanOnly(false, false, false, false, false, false, false, false);
      expect(ptr.address, isNot(0));

      final count = countTrueFlags(ptr);
      expect(count, equals(0));

      freeBooleanOnly(ptr);
    });

    test('mixed flags', () {
      final ptr = createBooleanOnly(true, false, true, false, true, false, true, false);
      expect(ptr.address, isNot(0));

      final count = countTrueFlags(ptr);
      expect(count, equals(4));

      freeBooleanOnly(ptr);
    });
  });

  group('Enum Only Message', () {
    test('tiny enum values', () {
      final ptr = createEnumOnly(0, 1, 0, 1, 0, 0, 50, 110);
      expect(ptr.address, isNot(0));
      freeEnumOnly(ptr);
    });

    test('large enum values', () {
      final ptr = createEnumOnly(0, 0, 0, 0, 0, 0, 1, 110);
      expect(ptr.address, isNot(0));

      final msg = ptr.ref;
      expect(msg.le1, equals(0));
      expect(msg.le2, equals(1));
      expect(msg.le3, equals(110));

      freeEnumOnly(ptr);
    });
  });

  group('Edge Message Types', () {
    test('empty message', () {
      final ptr = createEmptyMessage();
      expect(ptr.address, isNot(0));
      freeEmptyMessage(ptr);
    });

    test('single field message', () {
      final str = 'Test';
      final bytes = Uint8List.fromList(str.codeUnits);
      final strPtr = ffi.malloc<ffi.Uint8>(bytes.length);
      strPtr.asTypedList(bytes.length).setAll(0, bytes);

      final ptr = createSingleField(strPtr, bytes.length);
      expect(ptr.address, isNot(0));

      ffi.malloc.free(strPtr);
      freeSingleField(ptr);
    });
  });

  group('Memory Safety', () {
    test('null pointer handling', () {
      final ptr = createStringSizes(
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
        ffi.nullptr, 0,
      );

      expect(ptr.address, isNot(0));
      freeStringSizes(ptr);
    });

    test('multiple allocations and frees', () {
      for (var i = 0; i < 100; i++) {
        final ptr = createEmptyMessage();
        expect(ptr.address, isNot(0));
        freeEmptyMessage(ptr);
      }
    });

    test('large memory allocations', () {
      final data = Int32List(10000);
      for (var i = 0; i < 10000; i++) {
        data[i] = i;
      }
      final dataPtr = ffi.malloc<ffi.Int32>(10000);
      dataPtr.asTypedList(10000).setAll(0, data);

      final ptr = createArraySizes(ffi.nullptr, 0, ffi.nullptr, 0, ffi.nullptr, 0, dataPtr, 10000);
      expect(ptr.address, isNot(0));

      ffi.malloc.free(dataPtr);
      freeArraySizes(ptr);
    });
  });
}
