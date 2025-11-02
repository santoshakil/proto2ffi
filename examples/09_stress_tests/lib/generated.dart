// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

const int LEVEL10_SIZE = 8;
const int LEVEL10_ALIGNMENT = 8;

final class Level10 extends ffi.Struct {
  @ffi.Int32()
  external int value;

  @ffi.Int32()
  external int depth;

  static ffi.Pointer<Level10> allocate() {
    return calloc<Level10>();
  }
}

const int LEVEL9_SIZE = 24;
const int LEVEL9_ALIGNMENT = 8;

final class Level9 extends ffi.Struct {
  external Level10 next;

  @ffi.Pointer<i32>
  external List<int> data;

  static ffi.Pointer<Level9> allocate() {
    return calloc<Level9>();
  }
}

const int LEVEL8_SIZE = 40;
const int LEVEL8_ALIGNMENT = 8;

final class Level8 extends ffi.Struct {
  external Level9 next;

  @ffi.Pointer<f64>
  external List<double> values;

  static ffi.Pointer<Level8> allocate() {
    return calloc<Level8>();
  }
}

const int LEVEL7_SIZE = 56;
const int LEVEL7_ALIGNMENT = 8;

final class Level7 extends ffi.Struct {
  external Level8 next;

  @ffi.Pointer<Level10>
  external List<Level10> items;

  static ffi.Pointer<Level7> allocate() {
    return calloc<Level7>();
  }
}

const int LEVEL6_SIZE = 72;
const int LEVEL6_ALIGNMENT = 8;

final class Level6 extends ffi.Struct {
  external Level7 next;

  @ffi.Pointer<i64>
  external List<int> ids;

  static ffi.Pointer<Level6> allocate() {
    return calloc<Level6>();
  }
}

const int LEVEL5_SIZE = 88;
const int LEVEL5_ALIGNMENT = 8;

final class Level5 extends ffi.Struct {
  external Level6 next;

  @ffi.Pointer<Level9>
  external List<Level9> batch;

  static ffi.Pointer<Level5> allocate() {
    return calloc<Level5>();
  }
}

const int LEVEL4_SIZE = 104;
const int LEVEL4_ALIGNMENT = 8;

final class Level4 extends ffi.Struct {
  external Level5 next;

  @ffi.Pointer<f32>
  external List<double> measurements;

  static ffi.Pointer<Level4> allocate() {
    return calloc<Level4>();
  }
}

const int LEVEL3_SIZE = 120;
const int LEVEL3_ALIGNMENT = 8;

final class Level3 extends ffi.Struct {
  external Level4 next;

  @ffi.Pointer<Level8>
  external List<Level8> collection;

  static ffi.Pointer<Level3> allocate() {
    return calloc<Level3>();
  }
}

const int LEVEL2_SIZE = 136;
const int LEVEL2_ALIGNMENT = 8;

final class Level2 extends ffi.Struct {
  external Level3 next;

  @ffi.Pointer<u8>
  external List<int> flags;

  static ffi.Pointer<Level2> allocate() {
    return calloc<Level2>();
  }
}

const int LEVEL1_SIZE = 152;
const int LEVEL1_ALIGNMENT = 8;

final class Level1 extends ffi.Struct {
  external Level2 next;

  @ffi.Pointer<Level7>
  external List<Level7> cascade;

  static ffi.Pointer<Level1> allocate() {
    return calloc<Level1>();
  }
}

const int DEEPNESTINGROOT_SIZE = 168;
const int DEEPNESTINGROOT_ALIGNMENT = 8;

final class DeepNestingRoot extends ffi.Struct {
  external Level1 start;

  @ffi.Int64()
  external int test_id;

  @ffi.Int64()
  external int timestamp;

  static ffi.Pointer<DeepNestingRoot> allocate() {
    return calloc<DeepNestingRoot>();
  }
}

const int WIDEMESSAGE_SIZE = 208;
const int WIDEMESSAGE_ALIGNMENT = 8;

final class WideMessage extends ffi.Struct {
  @ffi.Int64()
  external int field_006;

  @ffi.Int64()
  external int field_007;

  @ffi.Int64()
  external int field_008;

  @ffi.Int64()
  external int field_009;

  @ffi.Int64()
  external int field_010;

  @ffi.Double()
  external double field_011;

  @ffi.Double()
  external double field_012;

  @ffi.Double()
  external double field_013;

  @ffi.Double()
  external double field_014;

  @ffi.Double()
  external double field_015;

  @ffi.Pointer<i32>
  external List<int> field_026;

  @ffi.Pointer<i64>
  external List<int> field_027;

  @ffi.Pointer<f64>
  external List<double> field_028;

  @ffi.Pointer<f32>
  external List<double> field_029;

  @ffi.Pointer<u8>
  external List<int> field_030;

  @ffi.Int32()
  external int field_001;

  @ffi.Int32()
  external int field_002;

  @ffi.Int32()
  external int field_003;

  @ffi.Int32()
  external int field_004;

  @ffi.Int32()
  external int field_005;

  @ffi.Float()
  external double field_016;

  @ffi.Float()
  external double field_017;

  @ffi.Float()
  external double field_018;

  @ffi.Float()
  external double field_019;

  @ffi.Float()
  external double field_020;

  @ffi.Uint8()
  external int field_021;

  @ffi.Uint8()
  external int field_022;

  @ffi.Uint8()
  external int field_023;

  @ffi.Uint8()
  external int field_024;

  @ffi.Uint8()
  external int field_025;

  static ffi.Pointer<WideMessage> allocate() {
    return calloc<WideMessage>();
  }
}

const int HUGEMESSAGE_SIZE = 272;
const int HUGEMESSAGE_ALIGNMENT = 8;

final class HugeMessage extends ffi.Struct {
  @ffi.Pointer<i32>
  external List<int> payload_1k;

  @ffi.Pointer<i64>
  external List<int> payload_2k;

  @ffi.Pointer<f64>
  external List<double> payload_3k;

  @ffi.Pointer<f32>
  external List<double> payload_4k;

  external WideMessage metadata;

  static ffi.Pointer<HugeMessage> allocate() {
    return calloc<HugeMessage>();
  }
}

const int MASSIVEARRAY_SIZE = 48;
const int MASSIVEARRAY_ALIGNMENT = 8;

final class MassiveArray extends ffi.Struct {
  @ffi.Pointer<i32>
  external List<int> numbers;

  @ffi.Pointer<f64>
  external List<double> values;

  @ffi.Pointer<i64>
  external List<int> ids;

  static ffi.Pointer<MassiveArray> allocate() {
    return calloc<MassiveArray>();
  }
}

const int RECURSIVENODE_SIZE = 32;
const int RECURSIVENODE_ALIGNMENT = 8;

final class RecursiveNode extends ffi.Struct {
  @ffi.Int64()
  external int node_id;

  @ffi.Pointer<RecursiveNode>
  external List<RecursiveNode> children;

  @ffi.Int32()
  external int depth;

  @ffi.Int32()
  external int value;

  static ffi.Pointer<RecursiveNode> allocate() {
    return calloc<RecursiveNode>();
  }
}

const int COMPLEXGRAPH_SIZE = 24;
const int COMPLEXGRAPH_ALIGNMENT = 8;

final class ComplexGraph extends ffi.Struct {
  @ffi.Pointer<RecursiveNode>
  external List<RecursiveNode> nodes;

  @ffi.Int32()
  external int node_count;

  @ffi.Int32()
  external int edge_count;

  static ffi.Pointer<ComplexGraph> allocate() {
    return calloc<ComplexGraph>();
  }
}

const int ALLOCATIONTEST_SIZE = 24;
const int ALLOCATIONTEST_ALIGNMENT = 8;

final class AllocationTest extends ffi.Struct {
  @ffi.Pointer<i64>
  external List<int> block_ids;

  @ffi.Int32()
  external int block_count;

  @ffi.Int32()
  external int total_size;

  static ffi.Pointer<AllocationTest> allocate() {
    return calloc<AllocationTest>();
  }
}

const int MIXEDCOMPLEXITY_SIZE = 776;
const int MIXEDCOMPLEXITY_ALIGNMENT = 8;

final class MixedComplexity extends ffi.Struct {
  external DeepNestingRoot deep;

  external WideMessage wide;

  external HugeMessage huge;

  external MassiveArray massive;

  external RecursiveNode recursive;

  external ComplexGraph graph;

  external AllocationTest allocation;

  static ffi.Pointer<MixedComplexity> allocate() {
    return calloc<MixedComplexity>();
  }
}

const int STRESSTESTSUITE_SIZE = 824;
const int STRESSTESTSUITE_ALIGNMENT = 8;

final class StressTestSuite extends ffi.Struct {
  external MixedComplexity mixed;

  @ffi.Pointer<DeepNestingRoot>
  external List<DeepNestingRoot> deep_array;

  @ffi.Pointer<WideMessage>
  external List<WideMessage> wide_array;

  @ffi.Pointer<HugeMessage>
  external List<HugeMessage> huge_array;

  static ffi.Pointer<StressTestSuite> allocate() {
    return calloc<StressTestSuite>();
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

  late final deepnestingroot_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('deepnestingroot_size');

  late final deepnestingroot_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('deepnestingroot_alignment');

  late final widemessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('widemessage_size');

  late final widemessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('widemessage_alignment');

  late final hugemessage_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hugemessage_size');

  late final hugemessage_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('hugemessage_alignment');

  late final massivearray_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('massivearray_size');

  late final massivearray_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('massivearray_alignment');

  late final recursivenode_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('recursivenode_size');

  late final recursivenode_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('recursivenode_alignment');

  late final complexgraph_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('complexgraph_size');

  late final complexgraph_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('complexgraph_alignment');

  late final allocationtest_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('allocationtest_size');

  late final allocationtest_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('allocationtest_alignment');

  late final mixedcomplexity_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mixedcomplexity_size');

  late final mixedcomplexity_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('mixedcomplexity_alignment');

  late final stresstestsuite_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('stresstestsuite_size');

  late final stresstestsuite_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('stresstestsuite_alignment');
}
