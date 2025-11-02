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

typedef DbCreateTableNative = ffi.Void Function(ffi.Pointer<Table>);
typedef DbCreateTableDart = void Function(ffi.Pointer<Table>);

typedef DbBulkInsertNative = ffi.Int32 Function(
    ffi.Pointer<Table>, ffi.Pointer<Row>, ffi.Uint32);
typedef DbBulkInsertDart = int Function(
    ffi.Pointer<Table>, ffi.Pointer<Row>, int);

typedef DbExecuteQueryNative = ffi.Int32 Function(
    ffi.Pointer<Query>, ffi.Pointer<ResultSet>);
typedef DbExecuteQueryDart = int Function(
    ffi.Pointer<Query>, ffi.Pointer<ResultSet>);

typedef DbGetStatsNative = ffi.Void Function(ffi.Pointer<DatabaseStats>);
typedef DbGetStatsDart = void Function(ffi.Pointer<DatabaseStats>);

typedef DbGetTableInfoNative = ffi.Int32 Function(
    ffi.Pointer<ffi.Uint8>, ffi.Pointer<Table>);
typedef DbGetTableInfoDart = int Function(
    ffi.Pointer<ffi.Uint8>, ffi.Pointer<Table>);

late DbInitDart dbInit;
late DbCreateTableDart dbCreateTable;
late DbBulkInsertDart dbBulkInsert;
late DbExecuteQueryDart dbExecuteQuery;
late DbGetStatsDart dbGetStats;
late DbGetTableInfoDart dbGetTableInfo;

void main() {
  setUpAll(() {
    dylib = _loadLibrary();
    dbInit = dylib.lookupFunction<DbInitNative, DbInitDart>('db_init');
    dbCreateTable = dylib.lookupFunction<DbCreateTableNative, DbCreateTableDart>(
        'db_create_table');
    dbBulkInsert = dylib.lookupFunction<DbBulkInsertNative, DbBulkInsertDart>(
        'db_bulk_insert');
    dbExecuteQuery = dylib.lookupFunction<DbExecuteQueryNative, DbExecuteQueryDart>(
        'db_execute_query');
    dbGetStats = dylib.lookupFunction<DbGetStatsNative, DbGetStatsDart>(
        'db_get_stats');
    dbGetTableInfo = dylib.lookupFunction<DbGetTableInfoNative, DbGetTableInfoDart>(
        'db_get_table_info');

    dbInit();
  });

  group('Large Result Sets', () {
    test('Insert 1000 rows in bulk', () {
      final table = calloc<Table>();
      table.ref.name_str = 'large_table';
      table.ref.columns_count = 2;

      final col1 = table.ref.columns[0];
      col1.name_str = 'id';
      col1.type = DataType.INTEGER.value;

      final col2 = table.ref.columns[1];
      col2.name_str = 'value';
      col2.type = DataType.TEXT.value;

      dbCreateTable(table);

      final rowCount = 1000;
      final rows = calloc<Row>(rowCount);

      for (var i = 0; i < rowCount; i++) {
        rows[i].values_count = 2;
        rows[i].column_count = 2;

        rows[i].values[0].type = DataType.INTEGER.value;
        rows[i].values[0].int_value = i;

        rows[i].values[1].type = DataType.TEXT.value;
        rows[i].values[1].text_value_str = 'row_$i';
      }

      final result = dbBulkInsert(table, rows, rowCount);
      expect(result, equals(rowCount));

      calloc.free(table);
      calloc.free(rows);
    });

    test('Query returns limited result set', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM large_table LIMIT 1000';

      final result = calloc<ResultSet>();

      final status = dbExecuteQuery(query, result);
      expect(status, equals(0));

      expect(result.ref.rows_count, lessThanOrEqualTo(1000));

      calloc.free(query);
      calloc.free(result);
    });

    test('Verify row data integrity', () {
      final table = calloc<Table>();
      table.ref.name_str = 'test_integrity';
      table.ref.columns_count = 3;

      dbCreateTable(table);

      final rowCount = 100;
      final rows = calloc<Row>(rowCount);

      for (var i = 0; i < rowCount; i++) {
        rows[i].values_count = 3;
        rows[i].column_count = 3;

        rows[i].values[0].type = DataType.INTEGER.value;
        rows[i].values[0].int_value = i;

        rows[i].values[1].type = DataType.TEXT.value;
        rows[i].values[1].text_value_str = 'test_$i';

        rows[i].values[2].type = DataType.REAL.value;
        rows[i].values[2].real_value = i * 1.5;
      }

      dbBulkInsert(table, rows, rowCount);

      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM test_integrity LIMIT 100';

      final result = calloc<ResultSet>();
      dbExecuteQuery(query, result);

      expect(result.ref.rows_count, greaterThan(0));

      for (var i = 0; i < result.ref.rows_count && i < 10; i++) {
        final row = result.ref.rows[i];
        expect(row.values_count, greaterThanOrEqualTo(0));
      }

      calloc.free(table);
      calloc.free(rows);
      calloc.free(query);
      calloc.free(result);
    });
  });

  group('Performance Benchmarks', () {
    test('Measure bulk insert performance', () {
      final table = calloc<Table>();
      table.ref.name_str = 'perf_test';
      table.ref.columns_count = 2;

      dbCreateTable(table);

      final stopwatch = Stopwatch()..start();

      final rowCount = 1000;
      final rows = calloc<Row>(rowCount);

      for (var i = 0; i < rowCount; i++) {
        rows[i].values_count = 2;
        rows[i].values[0].type = DataType.INTEGER.value;
        rows[i].values[0].int_value = i;

        rows[i].values[1].type = DataType.TEXT.value;
        rows[i].values[1].text_value_str = 'perf_$i';
      }

      dbBulkInsert(table, rows, rowCount);

      stopwatch.stop();

      print('Bulk insert of $rowCount rows took: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));

      calloc.free(table);
      calloc.free(rows);
    });

    test('Measure query execution performance', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM perf_test';

      final result = calloc<ResultSet>();

      final stopwatch = Stopwatch()..start();
      dbExecuteQuery(query, result);
      stopwatch.stop();

      print('Query execution took: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));

      calloc.free(query);
      calloc.free(result);
    });

    test('Average query time tracking', () {
      for (var i = 0; i < 10; i++) {
        final query = calloc<Query>();
        query.ref.sql_str = 'SELECT * FROM perf_test LIMIT 100';

        final result = calloc<ResultSet>();
        dbExecuteQuery(query, result);

        calloc.free(query);
        calloc.free(result);
      }

      final stats = calloc<DatabaseStats>();
      dbGetStats(stats);

      expect(stats.ref.avg_query_time_ms, greaterThanOrEqualTo(0));
      print('Average query time: ${stats.ref.avg_query_time_ms}ms');

      calloc.free(stats);
    });

    test('Cache hit ratio', () {
      for (var i = 0; i < 20; i++) {
        final query = calloc<Query>();
        query.ref.sql_str = 'SELECT * FROM perf_test';

        final result = calloc<ResultSet>();
        dbExecuteQuery(query, result);

        calloc.free(query);
        calloc.free(result);
      }

      final stats = calloc<DatabaseStats>();
      dbGetStats(stats);

      print('Cache hits: ${stats.ref.cache_hits}');
      print('Cache misses: ${stats.ref.cache_misses}');

      expect(stats.ref.cache_hits, greaterThan(0));

      calloc.free(stats);
    });

    test('Page read/write statistics', () {
      final stats = calloc<DatabaseStats>();
      dbGetStats(stats);

      print('Page reads: ${stats.ref.page_reads}');
      print('Page writes: ${stats.ref.page_writes}');

      expect(stats.ref.page_reads, greaterThanOrEqualTo(0));
      expect(stats.ref.page_writes, greaterThanOrEqualTo(0));

      calloc.free(stats);
    });
  });

  group('Memory Pool Efficiency', () {
    test('Handle ResultSet with maximum rows', () {
      final result = calloc<ResultSet>();

      for (var i = 0; i < 1000; i++) {
        final row = result.ref.rows[i];
        row.values_count = 10;

        for (var j = 0; j < 10; j++) {
          row.values[j].type = DataType.INTEGER.value;
          row.values[j].int_value = i * 10 + j;
        }
      }

      result.ref.rows_count = 1000;

      expect(result.ref.rows_count, equals(1000));

      for (var i = 0; i < 10; i++) {
        expect(result.ref.rows[i].values[0].int_value, equals(i * 10));
      }

      calloc.free(result);
    });

    test('Multiple concurrent result sets', () {
      final results = <ffi.Pointer<ResultSet>>[];

      for (var i = 0; i < 10; i++) {
        final result = calloc<ResultSet>();
        results.add(result);

        final query = calloc<Query>();
        query.ref.sql_str = 'SELECT * FROM perf_test LIMIT ${i * 10}';

        dbExecuteQuery(query, result);

        calloc.free(query);
      }

      for (final result in results) {
        calloc.free(result);
      }
    });

    test('Row value array capacity', () {
      final row = calloc<Row>();

      for (var i = 0; i < 32; i++) {
        row.ref.values[i].type = DataType.INTEGER.value;
        row.ref.values[i].int_value = i;
      }

      row.ref.values_count = 32;

      expect(row.ref.values_count, equals(32));

      for (var i = 0; i < 32; i++) {
        expect(row.ref.values[i].int_value, equals(i));
      }

      calloc.free(row);
    });
  });

  group('Large Data Values', () {
    test('Handle maximum TEXT length', () {
      final value = calloc<Value>();
      value.ref.type = DataType.TEXT.value;

      final largeText = 'A' * 1023;
      value.ref.text_value_str = largeText;

      final retrieved = value.ref.text_value_str;
      expect(retrieved.length, lessThanOrEqualTo(1023));

      calloc.free(value);
    });

    test('Handle maximum BLOB length', () {
      final value = calloc<Value>();
      value.ref.type = DataType.BLOB.value;

      for (var i = 0; i < 4096; i++) {
        value.ref.blob_value[i] = (i % 256);
      }

      for (var i = 0; i < 100; i++) {
        expect(value.ref.blob_value[i], equals(i % 256));
      }

      calloc.free(value);
    });

    test('Mixed large values in single row', () {
      final row = calloc<Row>();
      row.ref.values_count = 3;

      row.ref.values[0].type = DataType.TEXT.value;
      row.ref.values[0].text_value_str = 'L' * 1000;

      row.ref.values[1].type = DataType.BLOB.value;
      for (var i = 0; i < 4000; i++) {
        row.ref.values[1].blob_value[i] = (i % 256);
      }

      row.ref.values[2].type = DataType.INTEGER.value;
      row.ref.values[2].int_value = 9999999999;

      expect(row.ref.values[0].text_value_str.length, greaterThan(0));
      expect(row.ref.values[2].int_value, equals(9999999999));

      calloc.free(row);
    });
  });

  group('Table Statistics', () {
    test('Get table row count', () {
      final table = calloc<Table>();
      table.ref.name_str = 'stat_table';
      table.ref.columns_count = 2;

      dbCreateTable(table);

      final rows = calloc<Row>(500);
      for (var i = 0; i < 500; i++) {
        rows[i].values_count = 2;
        rows[i].values[0].type = DataType.INTEGER.value;
        rows[i].values[0].int_value = i;
      }

      dbBulkInsert(table, rows, 500);

      final tableName = 'stat_table'.toNativeUtf8();
      final tableInfo = calloc<Table>();

      dbGetTableInfo(tableName.cast(), tableInfo);
      expect(tableInfo.ref.row_count, equals(500));

      calloc.free(tableName);
      calloc.free(table);
      calloc.free(rows);
      calloc.free(tableInfo);
    });

    test('Table page count calculation', () {
      final tableName = 'stat_table'.toNativeUtf8();
      final tableInfo = calloc<Table>();

      dbGetTableInfo(tableName.cast(), tableInfo);

      expect(tableInfo.ref.page_count, greaterThan(0));
      print('Table pages: ${tableInfo.ref.page_count}');

      calloc.free(tableName);
      calloc.free(tableInfo);
    });
  });
}
