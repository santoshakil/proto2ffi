// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum TinyEnum {
  TINY_ZERO(0), // Value: 0
  TINY_ONE(1); // Value: 1

  const TinyEnum(this.value);
  final int value;
}

enum LargeEnum {
  VALUE_0(0), // Value: 0
  VALUE_1(1), // Value: 1
  VALUE_2(2), // Value: 2
  VALUE_3(3), // Value: 3
  VALUE_4(4), // Value: 4
  VALUE_5(5), // Value: 5
  VALUE_6(6), // Value: 6
  VALUE_7(7), // Value: 7
  VALUE_8(8), // Value: 8
  VALUE_9(9), // Value: 9
  VALUE_10(10), // Value: 10
  VALUE_11(11), // Value: 11
  VALUE_12(12), // Value: 12
  VALUE_13(13), // Value: 13
  VALUE_14(14), // Value: 14
  VALUE_15(15), // Value: 15
  VALUE_16(16), // Value: 16
  VALUE_17(17), // Value: 17
  VALUE_18(18), // Value: 18
  VALUE_19(19), // Value: 19
  VALUE_20(20), // Value: 20
  VALUE_21(21), // Value: 21
  VALUE_22(22), // Value: 22
  VALUE_23(23), // Value: 23
  VALUE_24(24), // Value: 24
  VALUE_25(25), // Value: 25
  VALUE_26(26), // Value: 26
  VALUE_27(27), // Value: 27
  VALUE_28(28), // Value: 28
  VALUE_29(29), // Value: 29
  VALUE_30(30), // Value: 30
  VALUE_31(31), // Value: 31
  VALUE_32(32), // Value: 32
  VALUE_33(33), // Value: 33
  VALUE_34(34), // Value: 34
  VALUE_35(35), // Value: 35
  VALUE_36(36), // Value: 36
  VALUE_37(37), // Value: 37
  VALUE_38(38), // Value: 38
  VALUE_39(39), // Value: 39
  VALUE_40(40), // Value: 40
  VALUE_41(41), // Value: 41
  VALUE_42(42), // Value: 42
  VALUE_43(43), // Value: 43
  VALUE_44(44), // Value: 44
  VALUE_45(45), // Value: 45
  VALUE_46(46), // Value: 46
  VALUE_47(47), // Value: 47
  VALUE_48(48), // Value: 48
  VALUE_49(49), // Value: 49
  VALUE_50(50), // Value: 50
  VALUE_51(51), // Value: 51
  VALUE_52(52), // Value: 52
  VALUE_53(53), // Value: 53
  VALUE_54(54), // Value: 54
  VALUE_55(55), // Value: 55
  VALUE_56(56), // Value: 56
  VALUE_57(57), // Value: 57
  VALUE_58(58), // Value: 58
  VALUE_59(59), // Value: 59
  VALUE_60(60), // Value: 60
  VALUE_61(61), // Value: 61
  VALUE_62(62), // Value: 62
  VALUE_63(63), // Value: 63
  VALUE_64(64), // Value: 64
  VALUE_65(65), // Value: 65
  VALUE_66(66), // Value: 66
  VALUE_67(67), // Value: 67
  VALUE_68(68), // Value: 68
  VALUE_69(69), // Value: 69
  VALUE_70(70), // Value: 70
  VALUE_71(71), // Value: 71
  VALUE_72(72), // Value: 72
  VALUE_73(73), // Value: 73
  VALUE_74(74), // Value: 74
  VALUE_75(75), // Value: 75
  VALUE_76(76), // Value: 76
  VALUE_77(77), // Value: 77
  VALUE_78(78), // Value: 78
  VALUE_79(79), // Value: 79
  VALUE_80(80), // Value: 80
  VALUE_81(81), // Value: 81
  VALUE_82(82), // Value: 82
  VALUE_83(83), // Value: 83
  VALUE_84(84), // Value: 84
  VALUE_85(85), // Value: 85
  VALUE_86(86), // Value: 86
  VALUE_87(87), // Value: 87
  VALUE_88(88), // Value: 88
  VALUE_89(89), // Value: 89
  VALUE_90(90), // Value: 90
  VALUE_91(91), // Value: 91
  VALUE_92(92), // Value: 92
  VALUE_93(93), // Value: 93
  VALUE_94(94), // Value: 94
  VALUE_95(95), // Value: 95
  VALUE_96(96), // Value: 96
  VALUE_97(97), // Value: 97
  VALUE_98(98), // Value: 98
  VALUE_99(99), // Value: 99
  VALUE_100(100), // Value: 100
  VALUE_101(101), // Value: 101
  VALUE_102(102), // Value: 102
  VALUE_103(103), // Value: 103
  VALUE_104(104), // Value: 104
  VALUE_105(105), // Value: 105
  VALUE_106(106), // Value: 106
  VALUE_107(107), // Value: 107
  VALUE_108(108), // Value: 108
  VALUE_109(109), // Value: 109
  VALUE_110(110); // Value: 110

  const LargeEnum(this.value);
  final int value;
}

const int LEVEL10_SIZE = 264;
const int LEVEL10_ALIGNMENT = 8;

final class Level10 extends ffi.Struct {
  @ffi.Int32()
  external int number;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level10> allocate() {
    return calloc<Level10>();
  }
}

const int LEVEL9_SIZE = 520;
const int LEVEL9_ALIGNMENT = 8;

final class Level9 extends ffi.Struct {
  external Level10 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level9> allocate() {
    return calloc<Level9>();
  }
}

const int LEVEL8_SIZE = 776;
const int LEVEL8_ALIGNMENT = 8;

final class Level8 extends ffi.Struct {
  external Level9 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level8> allocate() {
    return calloc<Level8>();
  }
}

const int LEVEL7_SIZE = 1032;
const int LEVEL7_ALIGNMENT = 8;

final class Level7 extends ffi.Struct {
  external Level8 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level7> allocate() {
    return calloc<Level7>();
  }
}

const int LEVEL6_SIZE = 1288;
const int LEVEL6_ALIGNMENT = 8;

final class Level6 extends ffi.Struct {
  external Level7 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level6> allocate() {
    return calloc<Level6>();
  }
}

const int LEVEL5_SIZE = 1544;
const int LEVEL5_ALIGNMENT = 8;

final class Level5 extends ffi.Struct {
  external Level6 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level5> allocate() {
    return calloc<Level5>();
  }
}

const int LEVEL4_SIZE = 1800;
const int LEVEL4_ALIGNMENT = 8;

final class Level4 extends ffi.Struct {
  external Level5 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level4> allocate() {
    return calloc<Level4>();
  }
}

const int LEVEL3_SIZE = 2056;
const int LEVEL3_ALIGNMENT = 8;

final class Level3 extends ffi.Struct {
  external Level4 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level3> allocate() {
    return calloc<Level3>();
  }
}

const int LEVEL2_SIZE = 2312;
const int LEVEL2_ALIGNMENT = 8;

final class Level2 extends ffi.Struct {
  external Level3 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level2> allocate() {
    return calloc<Level2>();
  }
}

const int LEVEL1_SIZE = 2568;
const int LEVEL1_ALIGNMENT = 8;

final class Level1 extends ffi.Struct {
  external Level2 nested;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<Level1> allocate() {
    return calloc<Level1>();
  }
}

const int INTEGERLIMITS_SIZE = 120;
const int INTEGERLIMITS_ALIGNMENT = 8;

final class IntegerLimits extends ffi.Struct {
  @ffi.Int64()
  external int int64_min;

  @ffi.Int64()
  external int int64_max;

  @ffi.Uint64()
  external int uint64_min;

  @ffi.Uint64()
  external int uint64_max;

  @ffi.Int64()
  external int sint64_min;

  @ffi.Int64()
  external int sint64_max;

  @ffi.Uint64()
  external int fixed64_min;

  @ffi.Uint64()
  external int fixed64_max;

  @ffi.Int64()
  external int sfixed64_min;

  @ffi.Int64()
  external int sfixed64_max;

  @ffi.Int32()
  external int int32_min;

  @ffi.Int32()
  external int int32_max;

  @ffi.Uint32()
  external int uint32_min;

  @ffi.Uint32()
  external int uint32_max;

  @ffi.Int32()
  external int sint32_min;

  @ffi.Int32()
  external int sint32_max;

  @ffi.Uint32()
  external int fixed32_min;

  @ffi.Uint32()
  external int fixed32_max;

  @ffi.Int32()
  external int sfixed32_min;

  @ffi.Int32()
  external int sfixed32_max;

  static ffi.Pointer<IntegerLimits> allocate() {
    return calloc<IntegerLimits>();
  }
}

const int FLOATEDGECASES_SIZE = 96;
const int FLOATEDGECASES_ALIGNMENT = 8;

final class FloatEdgeCases extends ffi.Struct {
  @ffi.Double()
  external double d_zero;

  @ffi.Double()
  external double d_negative_zero;

  @ffi.Double()
  external double d_infinity;

  @ffi.Double()
  external double d_negative_infinity;

  @ffi.Double()
  external double d_nan;

  @ffi.Double()
  external double d_min_positive;

  @ffi.Double()
  external double d_max_value;

  @ffi.Double()
  external double d_min_value;

  @ffi.Float()
  external double zero;

  @ffi.Float()
  external double negative_zero;

  @ffi.Float()
  external double infinity;

  @ffi.Float()
  external double negative_infinity;

  @ffi.Float()
  external double nan;

  @ffi.Float()
  external double min_positive;

  @ffi.Float()
  external double max_value;

  @ffi.Float()
  external double min_value;

  static ffi.Pointer<FloatEdgeCases> allocate() {
    return calloc<FloatEdgeCases>();
  }
}

const int STRINGSIZES_SIZE = 1024;
const int STRINGSIZES_ALIGNMENT = 8;

final class StringSizes extends ffi.Struct {
  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> empty;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> small_255;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> medium_1024;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> large_4096;

  String get empty_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (empty[i] == 0) break;
      bytes.add(empty[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set empty_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      empty[i] = bytes[i];
    }
    if (len < 256) {
      empty[len] = 0;
    }
  }

  String get small_255_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (small_255[i] == 0) break;
      bytes.add(small_255[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set small_255_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      small_255[i] = bytes[i];
    }
    if (len < 256) {
      small_255[len] = 0;
    }
  }

  String get medium_1024_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (medium_1024[i] == 0) break;
      bytes.add(medium_1024[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set medium_1024_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      medium_1024[i] = bytes[i];
    }
    if (len < 256) {
      medium_1024[len] = 0;
    }
  }

  String get large_4096_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (large_4096[i] == 0) break;
      bytes.add(large_4096[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set large_4096_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      large_4096[i] = bytes[i];
    }
    if (len < 256) {
      large_4096[len] = 0;
    }
  }

  static ffi.Pointer<StringSizes> allocate() {
    return calloc<StringSizes>();
  }
}

const int ARRAYSIZES_SIZE = 64;
const int ARRAYSIZES_ALIGNMENT = 8;

final class ArraySizes extends ffi.Struct {
  @ffi.Pointer<i32>
  external List<int> empty_array;

  @ffi.Pointer<i32>
  external List<int> small_array;

  @ffi.Pointer<i32>
  external List<int> medium_array;

  @ffi.Pointer<i32>
  external List<int> large_array;

  static ffi.Pointer<ArraySizes> allocate() {
    return calloc<ArraySizes>();
  }
}

const int BOOLEANONLY_SIZE = 8;
const int BOOLEANONLY_ALIGNMENT = 8;

final class BooleanOnly extends ffi.Struct {
  @ffi.Uint8()
  external int flag1;

  @ffi.Uint8()
  external int flag2;

  @ffi.Uint8()
  external int flag3;

  @ffi.Uint8()
  external int flag4;

  @ffi.Uint8()
  external int flag5;

  @ffi.Uint8()
  external int flag6;

  @ffi.Uint8()
  external int flag7;

  @ffi.Uint8()
  external int flag8;

  static ffi.Pointer<BooleanOnly> allocate() {
    return calloc<BooleanOnly>();
  }
}

const int ENUMONLY_SIZE = 32;
const int ENUMONLY_ALIGNMENT = 8;

final class EnumOnly extends ffi.Struct {
  @ffi.Uint32()
  external int e1;

  @ffi.Uint32()
  external int e2;

  @ffi.Uint32()
  external int e3;

  @ffi.Uint32()
  external int e4;

  @ffi.Uint32()
  external int e5;

  @ffi.Uint32()
  external int le1;

  @ffi.Uint32()
  external int le2;

  @ffi.Uint32()
  external int le3;

  static ffi.Pointer<EnumOnly> allocate() {
    return calloc<EnumOnly>();
  }
}

const int MANYFIELDS_SIZE = 224;
const int MANYFIELDS_ALIGNMENT = 8;

final class ManyFields extends ffi.Struct {
  @ffi.Int32()
  external int f1;

  @ffi.Int32()
  external int f2;

  @ffi.Int32()
  external int f3;

  @ffi.Int32()
  external int f4;

  @ffi.Int32()
  external int f5;

  @ffi.Int32()
  external int f6;

  @ffi.Int32()
  external int f7;

  @ffi.Int32()
  external int f8;

  @ffi.Int32()
  external int f9;

  @ffi.Int32()
  external int f10;

  @ffi.Int32()
  external int f11;

  @ffi.Int32()
  external int f12;

  @ffi.Int32()
  external int f13;

  @ffi.Int32()
  external int f14;

  @ffi.Int32()
  external int f15;

  @ffi.Int32()
  external int f16;

  @ffi.Int32()
  external int f17;

  @ffi.Int32()
  external int f18;

  @ffi.Int32()
  external int f19;

  @ffi.Int32()
  external int f20;

  @ffi.Int32()
  external int f21;

  @ffi.Int32()
  external int f22;

  @ffi.Int32()
  external int f23;

  @ffi.Int32()
  external int f24;

  @ffi.Int32()
  external int f25;

  @ffi.Int32()
  external int f26;

  @ffi.Int32()
  external int f27;

  @ffi.Int32()
  external int f28;

  @ffi.Int32()
  external int f29;

  @ffi.Int32()
  external int f30;

  @ffi.Int32()
  external int f31;

  @ffi.Int32()
  external int f32;

  @ffi.Int32()
  external int f33;

  @ffi.Int32()
  external int f34;

  @ffi.Int32()
  external int f35;

  @ffi.Int32()
  external int f36;

  @ffi.Int32()
  external int f37;

  @ffi.Int32()
  external int f38;

  @ffi.Int32()
  external int f39;

  @ffi.Int32()
  external int f40;

  @ffi.Int32()
  external int f41;

  @ffi.Int32()
  external int f42;

  @ffi.Int32()
  external int f43;

  @ffi.Int32()
  external int f44;

  @ffi.Int32()
  external int f45;

  @ffi.Int32()
  external int f46;

  @ffi.Int32()
  external int f47;

  @ffi.Int32()
  external int f48;

  @ffi.Int32()
  external int f49;

  @ffi.Int32()
  external int f50;

  @ffi.Int32()
  external int f51;

  @ffi.Int32()
  external int f52;

  @ffi.Int32()
  external int f53;

  @ffi.Int32()
  external int f54;

  @ffi.Int32()
  external int f55;

  static ffi.Pointer<ManyFields> allocate() {
    return calloc<ManyFields>();
  }
}

const int ALLTYPES_SIZE = 648;
const int ALLTYPES_ALIGNMENT = 8;

final class AllTypes extends ffi.Struct {
  @ffi.Int64()
  external int int64_field;

  @ffi.Uint64()
  external int uint64_field;

  @ffi.Int64()
  external int sint64_field;

  @ffi.Uint64()
  external int fixed64_field;

  @ffi.Int64()
  external int sfixed64_field;

  @ffi.Double()
  external double double_field;

  external Level10 nested_field;

  @ffi.Pointer<i32>
  external List<int> repeated_int;

  @ffi.Pointer<[u8; 256]>
  external List<String> repeated_string;

  @ffi.Pointer<Level10>
  external List<Level10> repeated_nested;

  @ffi.Int32()
  external int int32_field;

  @ffi.Uint32()
  external int uint32_field;

  @ffi.Int32()
  external int sint32_field;

  @ffi.Uint32()
  external int fixed32_field;

  @ffi.Int32()
  external int sfixed32_field;

  @ffi.Float()
  external double float_field;

  @ffi.Uint32()
  external int enum_field;

  @ffi.Uint8()
  external int bool_field;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> string_field;

  String get string_field_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (string_field[i] == 0) break;
      bytes.add(string_field[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set string_field_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      string_field[i] = bytes[i];
    }
    if (len < 256) {
      string_field[len] = 0;
    }
  }

  static ffi.Pointer<AllTypes> allocate() {
    return calloc<AllTypes>();
  }
}

const int EMPTYMESSAGE_SIZE = 0;
const int EMPTYMESSAGE_ALIGNMENT = 8;

final class EmptyMessage extends ffi.Struct {
  static ffi.Pointer<EmptyMessage> allocate() {
    return calloc<EmptyMessage>();
  }
}

const int SINGLEFIELD_SIZE = 256;
const int SINGLEFIELD_ALIGNMENT = 8;

final class SingleField extends ffi.Struct {
  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> value;

  String get value_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (value[i] == 0) break;
      bytes.add(value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      value[i] = bytes[i];
    }
    if (len < 256) {
      value[len] = 0;
    }
  }

  static ffi.Pointer<SingleField> allocate() {
    return calloc<SingleField>();
  }
}

class FFIBindings {
  static final _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libgenerated.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libgenerated.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('generated.dll');
    } else {
      return ffi.DynamicLibrary.open('libgenerated.so');
    }
  }

  late final level10_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level10_size');

  late final level10_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level10_alignment');

  late final level9_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level9_size');

  late final level9_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level9_alignment');

  late final level8_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level8_size');

  late final level8_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level8_alignment');

  late final level7_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level7_size');

  late final level7_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level7_alignment');

  late final level6_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level6_size');

  late final level6_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level6_alignment');

  late final level5_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level5_size');

  late final level5_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level5_alignment');

  late final level4_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level4_size');

  late final level4_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level4_alignment');

  late final level3_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level3_size');

  late final level3_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level3_alignment');

  late final level2_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level2_size');

  late final level2_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level2_alignment');

  late final level1_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level1_size');

  late final level1_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('level1_alignment');

  late final integerlimits_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('integerlimits_size');

  late final integerlimits_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('integerlimits_alignment');

  late final floatedgecases_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('floatedgecases_size');

  late final floatedgecases_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('floatedgecases_alignment');

  late final stringsizes_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('stringsizes_size');

  late final stringsizes_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('stringsizes_alignment');

  late final arraysizes_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('arraysizes_size');

  late final arraysizes_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('arraysizes_alignment');

  late final booleanonly_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('booleanonly_size');

  late final booleanonly_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('booleanonly_alignment');

  late final enumonly_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('enumonly_size');

  late final enumonly_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('enumonly_alignment');

  late final manyfields_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('manyfields_size');

  late final manyfields_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('manyfields_alignment');

  late final alltypes_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('alltypes_size');

  late final alltypes_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('alltypes_alignment');

  late final emptymessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('emptymessage_size');

  late final emptymessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('emptymessage_alignment');

  late final singlefield_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('singlefield_size');

  late final singlefield_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('singlefield_alignment');
}
