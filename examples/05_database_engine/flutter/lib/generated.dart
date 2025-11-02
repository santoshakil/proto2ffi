// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

export 'dart:typed_data' show ByteData, Endian;

enum DataType {
  NULL(0), // Value: 0
  INTEGER(1), // Value: 1
  REAL(2), // Value: 2
  TEXT(3), // Value: 3
  BLOB(4), // Value: 4
  BOOLEAN(5); // Value: 5

  const DataType(this.value);
  final int value;
}

enum TransactionState {
  IDLE(0), // Value: 0
  ACTIVE(1), // Value: 1
  COMMITTED(2), // Value: 2
  ROLLED_BACK(3); // Value: 3

  const TransactionState(this.value);
  final int value;
}

enum IsolationLevel {
  READ_UNCOMMITTED(0), // Value: 0
  READ_COMMITTED(1), // Value: 1
  REPEATABLE_READ(2), // Value: 2
  SERIALIZABLE(3); // Value: 3

  const IsolationLevel(this.value);
  final int value;
}

enum IndexType {
  BTREE(0), // Value: 0
  HASH(1), // Value: 1
  FULLTEXT(2); // Value: 2

  const IndexType(this.value);
  final int value;
}

const int VALUE_SIZE = 5144;
const int VALUE_ALIGNMENT = 8;

final class Value extends ffi.Struct {
  @ffi.Int64()
  external int int_value;

  @ffi.Double()
  external double real_value;

  @ffi.Uint32()
  external int type;

  @ffi.Array<ffi.Uint8>(1024)
  external ffi.Array<ffi.Uint8> text_value;

  @ffi.Array<ffi.Uint8>(4096)
  external ffi.Array<ffi.Uint8> blob_value;

  @ffi.Uint8()
  external int bool_value;

  String get text_value_str {
    final bytes = <int>[];
    for (int i = 0; i < 1024; i++) {
      if (text_value[i] == 0) break;
      bytes.add(text_value[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set text_value_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 1023 ? bytes.length : 1023;
    for (int i = 0; i < len; i++) {
      text_value[i] = bytes[i];
    }
    if (len < 1024) {
      text_value[len] = 0;
    }
  }

  static ffi.Pointer<Value> allocate() {
    return calloc<Value>();
  }
}

const int COLUMN_SIZE = 72;
const int COLUMN_ALIGNMENT = 8;

final class Column extends ffi.Struct {
  @ffi.Uint32()
  external int type;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Uint8()
  external int nullable;

  @ffi.Uint8()
  external int primary_key;

  @ffi.Uint8()
  external int unique;

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 64) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Column> allocate() {
    return calloc<Column>();
  }
}

const int ROW_SIZE = 164616;
const int ROW_ALIGNMENT = 8;

final class Row extends ffi.Struct {
  @ffi.Uint32()
  external int values_count;

  @ffi.Array<Value>(32)
  external ffi.Array<Value> values;

  @ffi.Uint32()
  external int column_count;

  List<Value> get values_list {
    return List.generate(
      values_count,
      (i) => values[i],
      growable: false,
    );
  }

  Value get_next_value() {
    if (values_count >= 32) {
      throw Exception('values array full');
    }
    final idx = values_count;
    values_count++;
    return values[idx];
  }

  static ffi.Pointer<Row> allocate() {
    return calloc<Row>();
  }
}

const int TABLE_SIZE = 2392;
const int TABLE_ALIGNMENT = 8;

final class Table extends ffi.Struct {
  @ffi.Uint32()
  external int columns_count;

  @ffi.Array<Column>(32)
  external ffi.Array<Column> columns;

  @ffi.Uint64()
  external int row_count;

  @ffi.Uint64()
  external int page_count;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> name;

  List<Column> get columns_list {
    return List.generate(
      columns_count,
      (i) => columns[i],
      growable: false,
    );
  }

  Column get_next_column() {
    if (columns_count >= 32) {
      throw Exception('columns array full');
    }
    final idx = columns_count;
    columns_count++;
    return columns[idx];
  }

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 64) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Table> allocate() {
    return calloc<Table>();
  }
}

const int QUERY_SIZE = 333320;
const int QUERY_ALIGNMENT = 8;

final class Query extends ffi.Struct {
  @ffi.Uint32()
  external int parameters_count;

  @ffi.Array<Value>(64)
  external ffi.Array<Value> parameters;

  @ffi.Uint32()
  external int timeout_ms;

  @ffi.Array<ffi.Uint8>(4096)
  external ffi.Array<ffi.Uint8> sql;

  List<Value> get parameters_list {
    return List.generate(
      parameters_count,
      (i) => parameters[i],
      growable: false,
    );
  }

  Value get_next_parameter() {
    if (parameters_count >= 64) {
      throw Exception('parameters array full');
    }
    final idx = parameters_count;
    parameters_count++;
    return parameters[idx];
  }

  String get sql_str {
    final bytes = <int>[];
    for (int i = 0; i < 4096; i++) {
      if (sql[i] == 0) break;
      bytes.add(sql[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set sql_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 4095 ? bytes.length : 4095;
    for (int i = 0; i < len; i++) {
      sql[i] = bytes[i];
    }
    if (len < 4096) {
      sql[len] = 0;
    }
  }

  static ffi.Pointer<Query> allocate() {
    return calloc<Query>();
  }
}

const int RESULTSET_SIZE = 164616024;
const int RESULTSET_ALIGNMENT = 8;

final class ResultSet extends ffi.Struct {
  @ffi.Uint32()
  external int rows_count;

  @ffi.Array<Row>(1000)
  external ffi.Array<Row> rows;

  @ffi.Uint64()
  external int last_insert_id;

  @ffi.Uint32()
  external int row_count;

  @ffi.Uint32()
  external int affected_rows;

  List<Row> get rows_list {
    return List.generate(
      rows_count,
      (i) => rows[i],
      growable: false,
    );
  }

  Row get_next_row() {
    if (rows_count >= 1000) {
      throw Exception('rows array full');
    }
    final idx = rows_count;
    rows_count++;
    return rows[idx];
  }

  static ffi.Pointer<ResultSet> allocate() {
    return calloc<ResultSet>();
  }
}

const int TRANSACTION_SIZE = 32;
const int TRANSACTION_ALIGNMENT = 8;

final class Transaction extends ffi.Struct {
  @ffi.Uint64()
  external int transaction_id;

  @ffi.Uint64()
  external int start_time;

  @ffi.Uint32()
  external int state;

  @ffi.Uint32()
  external int isolation;

  @ffi.Uint32()
  external int query_count;

  static ffi.Pointer<Transaction> allocate() {
    return calloc<Transaction>();
  }
}

const int INDEX_SIZE = 4240;
const int INDEX_ALIGNMENT = 8;

final class Index extends ffi.Struct {
  @ffi.Uint32()
  external int columns_count;

  @ffi.Array<ffi.Uint8>(4096)
  external ffi.Array<ffi.Uint8> columns;

  @ffi.Uint32()
  external int type;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> table_name;

  @ffi.Uint8()
  external int unique;

  List<String> get columns_list {
    final result = <String>[];
    for (var i = 0; i < columns_count && i < 16; i++) {
      final offset = i * 256;
      final bytes = <int>[];
      for (var j = 0; j < 256; j++) {
        if (columns[offset + j] == 0) break;
        bytes.add(columns[offset + j]);
      }
      result.add(String.fromCharCodes(bytes));
    }
    return result;
  }

  void set_column(int idx, String value) {
    if (idx >= 16) {
      throw Exception('columns array full');
    }
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    final offset = idx * 256;
    for (var i = 0; i < len; i++) {
      columns[offset + i] = bytes[i];
    }
    if (len < 256) {
      columns[offset + len] = 0;
    }
  }

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 64) {
      name[len] = 0;
    }
  }

  String get table_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (table_name[i] == 0) break;
      bytes.add(table_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set table_name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      table_name[i] = bytes[i];
    }
    if (len < 64) {
      table_name[len] = 0;
    }
  }

  static ffi.Pointer<Index> allocate() {
    return calloc<Index>();
  }
}

const int CURSOR_SIZE = 24;
const int CURSOR_ALIGNMENT = 8;

final class Cursor extends ffi.Struct {
  @ffi.Uint64()
  external int cursor_id;

  @ffi.Uint32()
  external int current_position;

  @ffi.Uint32()
  external int total_rows;

  @ffi.Uint8()
  external int is_open;

  @ffi.Uint8()
  external int is_eof;

  static ffi.Pointer<Cursor> allocate() {
    return calloc<Cursor>();
  }
}

const int DATABASESTATS_SIZE = 56;
const int DATABASESTATS_ALIGNMENT = 8;

final class DatabaseStats extends ffi.Struct {
  @ffi.Uint64()
  external int total_queries;

  @ffi.Uint64()
  external int total_transactions;

  @ffi.Uint64()
  external int cache_hits;

  @ffi.Uint64()
  external int cache_misses;

  @ffi.Uint64()
  external int page_reads;

  @ffi.Uint64()
  external int page_writes;

  @ffi.Double()
  external double avg_query_time_ms;

  static ffi.Pointer<DatabaseStats> allocate() {
    return calloc<DatabaseStats>();
  }
}

const int CONNECTIONINFO_SIZE = 280;
const int CONNECTIONINFO_ALIGNMENT = 8;

final class ConnectionInfo extends ffi.Struct {
  @ffi.Uint64()
  external int connection_id;

  @ffi.Uint64()
  external int connect_time;

  @ffi.Uint32()
  external int active_queries;

  @ffi.Uint32()
  external int active_transactions;

  @ffi.Array<ffi.Uint8>(256)
  external ffi.Array<ffi.Uint8> database_name;

  String get database_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 256; i++) {
      if (database_name[i] == 0) break;
      bytes.add(database_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set database_name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 255 ? bytes.length : 255;
    for (int i = 0; i < len; i++) {
      database_name[i] = bytes[i];
    }
    if (len < 256) {
      database_name[len] = 0;
    }
  }

  static ffi.Pointer<ConnectionInfo> allocate() {
    return calloc<ConnectionInfo>();
  }
}

const int LOCKINFO_SIZE = 88;
const int LOCKINFO_ALIGNMENT = 8;

final class LockInfo extends ffi.Struct {
  @ffi.Uint64()
  external int transaction_id;

  @ffi.Uint64()
  external int acquired_time;

  @ffi.Uint32()
  external int lock_type;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> table_name;

  String get table_name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (table_name[i] == 0) break;
      bytes.add(table_name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set table_name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      table_name[i] = bytes[i];
    }
    if (len < 64) {
      table_name[len] = 0;
    }
  }

  static ffi.Pointer<LockInfo> allocate() {
    return calloc<LockInfo>();
  }
}

const int QUERYPLAN_SIZE = 1368;
const int QUERYPLAN_ALIGNMENT = 8;

final class QueryPlan extends ffi.Struct {
  @ffi.Double()
  external double estimated_cost;

  @ffi.Uint64()
  external int estimated_rows;

  @ffi.Uint32()
  external int children_count;

  @ffi.Array<ffi.Uint8>(1216)
  external ffi.Array<ffi.Uint8> children;

  @ffi.Array<ffi.Uint8>(128)
  external ffi.Array<ffi.Uint8> operation;

  QueryPlanChild? get_child(int idx) {
    if (idx >= children_count || idx >= 8) {
      return null;
    }
    final offset = idx * 152;
    return QueryPlanChild._(children, offset);
  }
}

class QueryPlanChild {
  final ffi.Array<ffi.Uint8> _array;
  final int _offset;

  QueryPlanChild._(this._array, this._offset);

  double get estimated_cost {
    final data = ByteData(8);
    for (var i = 0; i < 8; i++) {
      data.setUint8(i, _array[_offset + i]);
    }
    return data.getFloat64(0, Endian.host);
  }

  set estimated_cost(double value) {
    final data = ByteData(8);
    data.setFloat64(0, value, Endian.host);
    for (var i = 0; i < 8; i++) {
      _array[_offset + i] = data.getUint8(i);
    }
  }

  int get estimated_rows {
    final data = ByteData(8);
    for (var i = 0; i < 8; i++) {
      data.setUint8(i, _array[_offset + 8 + i]);
    }
    return data.getUint64(0, Endian.host);
  }

  set estimated_rows(int value) {
    final data = ByteData(8);
    data.setUint64(0, value, Endian.host);
    for (var i = 0; i < 8; i++) {
      _array[_offset + 8 + i] = data.getUint8(i);
    }
  }

  int get children_count {
    final data = ByteData(4);
    for (var i = 0; i < 4; i++) {
      data.setUint8(i, _array[_offset + 16 + i]);
    }
    return data.getUint32(0, Endian.host);
  }

  set children_count(int value) {
    final data = ByteData(4);
    data.setUint32(0, value, Endian.host);
    for (var i = 0; i < 4; i++) {
      _array[_offset + 16 + i] = data.getUint8(i);
    }
  }

  String get operation_str {
    final bytes = <int>[];
    for (var i = 0; i < 128; i++) {
      if (_array[_offset + 20 + i] == 0) break;
      bytes.add(_array[_offset + 20 + i]);
    }
    return String.fromCharCodes(bytes);
  }

  set operation_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 127 ? bytes.length : 127;
    for (var i = 0; i < len; i++) {
      _array[_offset + 20 + i] = bytes[i];
    }
    if (len < 128) {
      _array[_offset + 20 + len] = 0;
    }
  }
}

extension QueryPlanExt on QueryPlan {
  String get operation_str {
    final bytes = <int>[];
    for (int i = 0; i < 128; i++) {
      if (operation[i] == 0) break;
      bytes.add(operation[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set operation_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 127 ? bytes.length : 127;
    for (int i = 0; i < len; i++) {
      operation[i] = bytes[i];
    }
    if (len < 128) {
      operation[len] = 0;
    }
  }

  static ffi.Pointer<QueryPlan> allocate() {
    return calloc<QueryPlan>();
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

  late final value_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('value_size');

  late final value_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('value_alignment');

  late final column_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('column_size');

  late final column_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('column_alignment');

  late final row_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('row_size');

  late final row_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('row_alignment');

  late final table_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('table_size');

  late final table_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('table_alignment');

  late final query_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('query_size');

  late final query_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('query_alignment');

  late final resultset_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('resultset_size');

  late final resultset_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('resultset_alignment');

  late final transaction_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transaction_size');

  late final transaction_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transaction_alignment');

  late final index_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('index_size');

  late final index_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('index_alignment');

  late final cursor_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('cursor_size');

  late final cursor_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('cursor_alignment');

  late final databasestats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('databasestats_size');

  late final databasestats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('databasestats_alignment');

  late final connectioninfo_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('connectioninfo_size');

  late final connectioninfo_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('connectioninfo_alignment');

  late final lockinfo_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('lockinfo_size');

  late final lockinfo_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('lockinfo_alignment');

  late final queryplan_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('queryplan_size');

  late final queryplan_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('queryplan_alignment');
}
