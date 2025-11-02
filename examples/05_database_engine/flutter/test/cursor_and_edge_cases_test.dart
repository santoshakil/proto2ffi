import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import '../lib/generated.dart';

late ffi.DynamicLibrary dylib;

ffi.DynamicLibrary _loadLibrary() {
  if (Platform.isMacOS) {
    return ffi.DynamicLibrary.open('../rust/target/debug/librust.dylib');
  } else if (Platform.isLinux) {
    return ffi.DynamicLibrary.open('../rust/target/debug/librust.so');
  } else if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('../rust/target/debug/rust.dll');
  }
  throw UnsupportedError('Unsupported platform');
}

typedef DbInitNative = ffi.Void Function();
typedef DbInitDart = void Function();

typedef DbCreateCursorNative = ffi.Int32 Function(
    ffi.Pointer<Query>, ffi.Pointer<Cursor>);
typedef DbCreateCursorDart = int Function(
    ffi.Pointer<Query>, ffi.Pointer<Cursor>);

typedef DbFetchNextNative = ffi.Int32 Function(
    ffi.Pointer<Cursor>, ffi.Pointer<Row>);
typedef DbFetchNextDart = int Function(ffi.Pointer<Cursor>, ffi.Pointer<Row>);

typedef DbCloseCursorNative = ffi.Int32 Function(ffi.Pointer<Cursor>);
typedef DbCloseCursorDart = int Function(ffi.Pointer<Cursor>);

typedef DbGetConnectionInfoNative = ffi.Void Function(
    ffi.Pointer<ConnectionInfo>);
typedef DbGetConnectionInfoDart = void Function(ffi.Pointer<ConnectionInfo>);

typedef DbAcquireLockNative = ffi.Int32 Function(ffi.Pointer<LockInfo>);
typedef DbAcquireLockDart = int Function(ffi.Pointer<LockInfo>);

late DbInitDart dbInit;
late DbCreateCursorDart dbCreateCursor;
late DbFetchNextDart dbFetchNext;
late DbCloseCursorDart dbCloseCursor;
late DbGetConnectionInfoDart dbGetConnectionInfo;
late DbAcquireLockDart dbAcquireLock;

void main() {
  setUpAll(() {
    dylib = _loadLibrary();
    dbInit = dylib.lookupFunction<DbInitNative, DbInitDart>('db_init');
    dbCreateCursor = dylib.lookupFunction<DbCreateCursorNative, DbCreateCursorDart>(
        'db_create_cursor');
    dbFetchNext = dylib.lookupFunction<DbFetchNextNative, DbFetchNextDart>(
        'db_fetch_next');
    dbCloseCursor = dylib.lookupFunction<DbCloseCursorNative, DbCloseCursorDart>(
        'db_close_cursor');
    dbGetConnectionInfo = dylib.lookupFunction<DbGetConnectionInfoNative,
        DbGetConnectionInfoDart>('db_get_connection_info');
    dbAcquireLock = dylib.lookupFunction<DbAcquireLockNative, DbAcquireLockDart>(
        'db_acquire_lock');

    dbInit();
  });

  group('Cursor Operations', () {
    test('Create cursor', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users';

      final cursor = calloc<Cursor>();

      final result = dbCreateCursor(query, cursor);
      expect(result, equals(0));
      expect(cursor.ref.cursor_id, greaterThan(0));
      expect(cursor.ref.is_open, equals(1));

      calloc.free(query);
      calloc.free(cursor);
    });

    test('Fetch from cursor', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users';

      final cursor = calloc<Cursor>();
      dbCreateCursor(query, cursor);

      final row = calloc<Row>();

      final result = dbFetchNext(cursor, row);
      expect(result, equals(0));

      calloc.free(query);
      calloc.free(cursor);
      calloc.free(row);
    });

    test('Close cursor', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users';

      final cursor = calloc<Cursor>();
      dbCreateCursor(query, cursor);

      final result = dbCloseCursor(cursor);
      expect(result, equals(0));
      expect(cursor.ref.is_open, equals(0));

      calloc.free(query);
      calloc.free(cursor);
    });

    test('Cursor reaches EOF', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users';

      final cursor = calloc<Cursor>();
      cursor.ref.total_rows = 0;
      cursor.ref.current_position = 0;

      dbCreateCursor(query, cursor);

      final row = calloc<Row>();
      dbFetchNext(cursor, row);

      expect(cursor.ref.is_eof, equals(1));

      calloc.free(query);
      calloc.free(cursor);
      calloc.free(row);
    });

    test('Cursor position tracking', () {
      final cursor = calloc<Cursor>();
      cursor.ref.cursor_id = 1;
      cursor.ref.total_rows = 100;
      cursor.ref.current_position = 0;
      cursor.ref.is_open = 1;

      expect(cursor.ref.current_position, equals(0));

      calloc.free(cursor);
    });
  });

  group('Connection Information', () {
    test('Get connection info', () {
      final conn = calloc<ConnectionInfo>();

      dbGetConnectionInfo(conn);

      expect(conn.ref.connection_id, greaterThan(0));
      expect(conn.ref.database_name_str.isNotEmpty, true);

      calloc.free(conn);
    });

    test('Connection has database name', () {
      final conn = calloc<ConnectionInfo>();

      dbGetConnectionInfo(conn);

      final dbName = conn.ref.database_name_str;
      expect(dbName, equals('test_db'));

      calloc.free(conn);
    });

    test('Connection metrics', () {
      final conn = calloc<ConnectionInfo>();

      dbGetConnectionInfo(conn);

      expect(conn.ref.active_queries, greaterThanOrEqualTo(0));
      expect(conn.ref.active_transactions, greaterThanOrEqualTo(0));
      expect(conn.ref.connect_time, greaterThan(0));

      calloc.free(conn);
    });
  });

  group('Lock Management', () {
    test('Acquire table lock', () {
      final lock = calloc<LockInfo>();
      lock.ref.table_name_str = 'users';
      lock.ref.transaction_id = 1;
      lock.ref.lock_type = 1;

      final result = dbAcquireLock(lock);
      expect(result, equals(0));
      expect(lock.ref.acquired_time, greaterThan(0));

      calloc.free(lock);
    });

    test('Lock has transaction ID', () {
      final lock = calloc<LockInfo>();
      lock.ref.table_name_str = 'products';
      lock.ref.transaction_id = 42;
      lock.ref.lock_type = 2;

      dbAcquireLock(lock);

      expect(lock.ref.transaction_id, equals(42));

      calloc.free(lock);
    });
  });

  group('Edge Cases', () {
    test('Empty table name', () {
      final table = calloc<Table>();
      table.ref.name_str = '';
      table.ref.columns_count = 0;

      expect(table.ref.name_str, equals(''));

      calloc.free(table);
    });

    test('Zero columns', () {
      final table = calloc<Table>();
      table.ref.name_str = 'empty_table';
      table.ref.columns_count = 0;

      expect(table.ref.columns_count, equals(0));

      calloc.free(table);
    });

    test('Null value handling', () {
      final value = calloc<Value>();
      value.ref.type = DataType.NULL.value;

      expect(value.ref.type, equals(DataType.NULL.value));

      calloc.free(value);
    });

    test('Empty query string', () {
      final query = calloc<Query>();
      query.ref.sql_str = '';
      query.ref.timeout_ms = 0;

      expect(query.ref.sql_str, equals(''));

      calloc.free(query);
    });

    test('Maximum column count', () {
      final table = calloc<Table>();
      table.ref.columns_count = 32;

      for (var i = 0; i < 32; i++) {
        table.ref.columns[i].name_str = 'col_$i';
        table.ref.columns[i].type = DataType.INTEGER.value;
      }

      expect(table.ref.columns_count, equals(32));

      calloc.free(table);
    });

    test('Maximum parameter count', () {
      final query = calloc<Query>();
      query.ref.parameters_count = 64;

      for (var i = 0; i < 64; i++) {
        query.ref.parameters[i].type = DataType.INTEGER.value;
        query.ref.parameters[i].int_value = i;
      }

      expect(query.ref.parameters_count, equals(64));

      calloc.free(query);
    });

    test('Long SQL query', () {
      final query = calloc<Query>();

      final longSql = 'SELECT * FROM table WHERE ' + 'id = 1 OR ' * 100;
      query.ref.sql_str = longSql.substring(0, 4095);

      expect(query.ref.sql_str.isNotEmpty, true);

      calloc.free(query);
    });

    test('Boolean value edge cases', () {
      final value1 = calloc<Value>();
      value1.ref.type = DataType.BOOLEAN.value;
      value1.ref.bool_value = 0;

      final value2 = calloc<Value>();
      value2.ref.type = DataType.BOOLEAN.value;
      value2.ref.bool_value = 1;

      expect(value1.ref.bool_value, equals(0));
      expect(value2.ref.bool_value, equals(1));

      calloc.free(value1);
      calloc.free(value2);
    });

    test('Negative integer values', () {
      final value = calloc<Value>();
      value.ref.type = DataType.INTEGER.value;
      value.ref.int_value = -9223372036854775808;

      expect(value.ref.int_value, equals(-9223372036854775808));

      calloc.free(value);
    });

    test('Very large real numbers', () {
      final value = calloc<Value>();
      value.ref.type = DataType.REAL.value;
      value.ref.real_value = 1.7976931348623157e+308;

      expect(value.ref.real_value, closeTo(1.7976931348623157e+308, 1e+300));

      calloc.free(value);
    });

    test('Unicode text handling', () {
      final value = calloc<Value>();
      value.ref.type = DataType.TEXT.value;
      value.ref.text_value_str = 'Hello 世界 🌍';

      final retrieved = value.ref.text_value_str;
      expect(retrieved, equals('Hello 世界 🌍'));

      calloc.free(value);
    });
  });

  group('Keyword Escaping', () {
    test('Column with type keyword', () {
      final column = calloc<Column>();
      column.ref.name_str = 'type';
      column.ref.type = DataType.TEXT.value;

      expect(column.ref.name_str, equals('type'));

      calloc.free(column);
    });

    test('Access r#type field directly', () {
      final column = calloc<Column>();
      column.ref.type = DataType.INTEGER.value;

      expect(column.ref.type, equals(DataType.INTEGER.value));

      calloc.free(column);
    });

    test('Index type field', () {
      final index = calloc<Index>();
      index.ref.type = IndexType.BTREE.value;

      expect(index.ref.type, equals(IndexType.BTREE.value));

      calloc.free(index);
    });

    test('Value type field', () {
      final value = calloc<Value>();
      value.ref.type = DataType.TEXT.value;

      expect(value.ref.type, equals(DataType.TEXT.value));

      calloc.free(value);
    });
  });

  group('Boundary Values', () {
    test('Zero timeout', () {
      final query = calloc<Query>();
      query.ref.timeout_ms = 0;

      expect(query.ref.timeout_ms, equals(0));

      calloc.free(query);
    });

    test('Maximum timeout', () {
      final query = calloc<Query>();
      query.ref.timeout_ms = 4294967295;

      expect(query.ref.timeout_ms, equals(4294967295));

      calloc.free(query);
    });

    test('Zero row count', () {
      final result = calloc<ResultSet>();
      result.ref.row_count = 0;
      result.ref.rows_count = 0;

      expect(result.ref.row_count, equals(0));

      calloc.free(result);
    });

    test('Maximum estimated rows', () {
      final plan = calloc<QueryPlan>();
      plan.ref.estimated_rows = 18446744073709551615;

      expect(plan.ref.estimated_rows, equals(18446744073709551615));

      calloc.free(plan);
    });

    test('Zero estimated cost', () {
      final plan = calloc<QueryPlan>();
      plan.ref.estimated_cost = 0.0;

      expect(plan.ref.estimated_cost, equals(0.0));

      calloc.free(plan);
    });
  });

  group('Struct Size Verification', () {
    test('Verify Value size', () {
      expect(VALUE_SIZE, equals(5144));
    });

    test('Verify Column size', () {
      expect(COLUMN_SIZE, equals(72));
    });

    test('Verify Row size', () {
      expect(ROW_SIZE, equals(164616));
    });

    test('Verify Table size', () {
      expect(TABLE_SIZE, equals(2392));
    });

    test('Verify Query size', () {
      expect(QUERY_SIZE, equals(333320));
    });

    test('Verify ResultSet size', () {
      expect(RESULTSET_SIZE, equals(164616024));
    });

    test('Verify Transaction size', () {
      expect(TRANSACTION_SIZE, equals(32));
    });

    test('Verify Index size', () {
      expect(INDEX_SIZE, equals(4240));
    });

    test('Verify Cursor size', () {
      expect(CURSOR_SIZE, equals(24));
    });

    test('Verify DatabaseStats size', () {
      expect(DATABASESTATS_SIZE, equals(56));
    });

    test('Verify ConnectionInfo size', () {
      expect(CONNECTIONINFO_SIZE, equals(280));
    });

    test('Verify LockInfo size', () {
      expect(LOCKINFO_SIZE, equals(88));
    });

    test('Verify QueryPlan size', () {
      expect(QUERYPLAN_SIZE, equals(152));
    });
  });
}
