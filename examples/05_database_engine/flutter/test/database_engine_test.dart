import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import '../lib/generated.dart';

late ffi.DynamicLibrary dylib;

ffi.DynamicLibrary _loadLibrary() {
  if (Platform.isMacOS) {
    return ffi.DynamicLibrary.open(
        '../rust/target/debug/librust.dylib');
  } else if (Platform.isLinux) {
    return ffi.DynamicLibrary.open(
        '../rust/target/debug/librust.so');
  } else if (Platform.isWindows) {
    return ffi.DynamicLibrary.open(
        '../rust/target/debug/rust.dll');
  }
  throw UnsupportedError('Unsupported platform');
}

typedef DbInitNative = ffi.Void Function();
typedef DbInitDart = void Function();

typedef DbCreateTableNative = ffi.Void Function(ffi.Pointer<Table>);
typedef DbCreateTableDart = void Function(ffi.Pointer<Table>);

typedef DbExecuteQueryNative = ffi.Int32 Function(
    ffi.Pointer<Query>, ffi.Pointer<ResultSet>);
typedef DbExecuteQueryDart = int Function(
    ffi.Pointer<Query>, ffi.Pointer<ResultSet>);

typedef DbInsertRowNative = ffi.Int64 Function(
    ffi.Pointer<Table>, ffi.Pointer<Row>);
typedef DbInsertRowDart = int Function(ffi.Pointer<Table>, ffi.Pointer<Row>);

typedef DbBeginTransactionNative = ffi.Uint64 Function(
    ffi.Pointer<Transaction>, ffi.Uint32);
typedef DbBeginTransactionDart = int Function(
    ffi.Pointer<Transaction>, int);

typedef DbCommitTransactionNative = ffi.Int32 Function(ffi.Uint64);
typedef DbCommitTransactionDart = int Function(int);

typedef DbRollbackTransactionNative = ffi.Int32 Function(ffi.Uint64);
typedef DbRollbackTransactionDart = int Function(int);

typedef DbCreateIndexNative = ffi.Int32 Function(ffi.Pointer<Index>);
typedef DbCreateIndexDart = int Function(ffi.Pointer<Index>);

typedef DbGetStatsNative = ffi.Void Function(ffi.Pointer<DatabaseStats>);
typedef DbGetStatsDart = void Function(ffi.Pointer<DatabaseStats>);

typedef DbGetTableInfoNative = ffi.Int32 Function(
    ffi.Pointer<ffi.Uint8>, ffi.Pointer<Table>);
typedef DbGetTableInfoDart = int Function(
    ffi.Pointer<ffi.Uint8>, ffi.Pointer<Table>);

typedef DbBulkInsertNative = ffi.Int32 Function(
    ffi.Pointer<Table>, ffi.Pointer<Row>, ffi.Uint32);
typedef DbBulkInsertDart = int Function(
    ffi.Pointer<Table>, ffi.Pointer<Row>, int);

late DbInitDart dbInit;
late DbCreateTableDart dbCreateTable;
late DbExecuteQueryDart dbExecuteQuery;
late DbInsertRowDart dbInsertRow;
late DbBeginTransactionDart dbBeginTransaction;
late DbCommitTransactionDart dbCommitTransaction;
late DbRollbackTransactionDart dbRollbackTransaction;
late DbCreateIndexDart dbCreateIndex;
late DbGetStatsDart dbGetStats;
late DbGetTableInfoDart dbGetTableInfo;
late DbBulkInsertDart dbBulkInsert;

void main() {
  setUpAll(() {
    dylib = _loadLibrary();
    dbInit = dylib.lookupFunction<DbInitNative, DbInitDart>('db_init');
    dbCreateTable = dylib.lookupFunction<DbCreateTableNative, DbCreateTableDart>(
        'db_create_table');
    dbExecuteQuery = dylib.lookupFunction<DbExecuteQueryNative, DbExecuteQueryDart>(
        'db_execute_query');
    dbInsertRow = dylib.lookupFunction<DbInsertRowNative, DbInsertRowDart>(
        'db_insert_row');
    dbBeginTransaction = dylib.lookupFunction<DbBeginTransactionNative,
        DbBeginTransactionDart>('db_begin_transaction');
    dbCommitTransaction = dylib.lookupFunction<DbCommitTransactionNative,
        DbCommitTransactionDart>('db_commit_transaction');
    dbRollbackTransaction = dylib.lookupFunction<DbRollbackTransactionNative,
        DbRollbackTransactionDart>('db_rollback_transaction');
    dbCreateIndex = dylib.lookupFunction<DbCreateIndexNative, DbCreateIndexDart>(
        'db_create_index');
    dbGetStats = dylib.lookupFunction<DbGetStatsNative, DbGetStatsDart>(
        'db_get_stats');
    dbGetTableInfo = dylib.lookupFunction<DbGetTableInfoNative, DbGetTableInfoDart>(
        'db_get_table_info');
    dbBulkInsert = dylib.lookupFunction<DbBulkInsertNative, DbBulkInsertDart>(
        'db_bulk_insert');

    dbInit();
  });

  group('Basic Database Operations', () {
    test('Initialize database', () {
      dbInit();
      expect(true, true);
    });

    test('Create table with columns', () {
      final table = calloc<Table>();

      table.ref.name_str = 'users';
      table.ref.columns_count = 3;

      final col1 = table.ref.columns[0];
      col1.name_str = 'id';
      col1.type = DataType.INTEGER.value;
      col1.nullable = 0;
      col1.primary_key = 1;

      final col2 = table.ref.columns[1];
      col2.name_str = 'name';
      col2.type = DataType.TEXT.value;
      col2.nullable = 0;

      final col3 = table.ref.columns[2];
      col3.name_str = 'active';
      col3.type = DataType.BOOLEAN.value;
      col3.nullable = 1;

      dbCreateTable(table);

      calloc.free(table);
    });

    test('Insert row', () {
      final table = calloc<Table>();
      table.ref.name_str = 'users';
      table.ref.columns_count = 2;

      final row = calloc<Row>();
      row.ref.values_count = 2;
      row.ref.column_count = 2;

      row.ref.values[0].type = DataType.INTEGER.value;
      row.ref.values[0].int_value = 1;

      row.ref.values[1].type = DataType.TEXT.value;
      row.ref.values[1].text_value_str = 'Alice';

      final result = dbInsertRow(table, row);
      expect(result, greaterThan(0));

      calloc.free(table);
      calloc.free(row);
    });

    test('Execute SELECT query', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users';
      query.ref.timeout_ms = 1000;

      final result = calloc<ResultSet>();

      final status = dbExecuteQuery(query, result);
      expect(status, equals(0));

      calloc.free(query);
      calloc.free(result);
    });

    test('Execute CREATE TABLE query', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'CREATE TABLE products (id, name)';

      final result = calloc<ResultSet>();

      final status = dbExecuteQuery(query, result);
      expect(status, equals(0));

      calloc.free(query);
      calloc.free(result);
    });
  });

  group('Column Type Handling', () {
    test('Handle INTEGER type', () {
      final value = calloc<Value>();
      value.ref.type = DataType.INTEGER.value;
      value.ref.int_value = 42;

      expect(value.ref.type, equals(DataType.INTEGER.value));
      expect(value.ref.int_value, equals(42));

      calloc.free(value);
    });

    test('Handle REAL type', () {
      final value = calloc<Value>();
      value.ref.type = DataType.REAL.value;
      value.ref.real_value = 3.14159;

      expect(value.ref.type, equals(DataType.REAL.value));
      expect(value.ref.real_value, closeTo(3.14159, 0.00001));

      calloc.free(value);
    });

    test('Handle TEXT type', () {
      final value = calloc<Value>();
      value.ref.type = DataType.TEXT.value;
      value.ref.text_value_str = 'Hello, World!';

      expect(value.ref.type, equals(DataType.TEXT.value));
      expect(value.ref.text_value_str, equals('Hello, World!'));

      calloc.free(value);
    });

    test('Handle BOOLEAN type', () {
      final value = calloc<Value>();
      value.ref.type = DataType.BOOLEAN.value;
      value.ref.bool_value = 1;

      expect(value.ref.type, equals(DataType.BOOLEAN.value));
      expect(value.ref.bool_value, equals(1));

      calloc.free(value);
    });

    test('Handle NULL type', () {
      final value = calloc<Value>();
      value.ref.type = DataType.NULL.value;

      expect(value.ref.type, equals(DataType.NULL.value));

      calloc.free(value);
    });

    test('Handle BLOB type', () {
      final value = calloc<Value>();
      value.ref.type = DataType.BLOB.value;

      for (var i = 0; i < 10; i++) {
        value.ref.blob_value[i] = i;
      }

      expect(value.ref.type, equals(DataType.BLOB.value));
      expect(value.ref.blob_value[0], equals(0));
      expect(value.ref.blob_value[9], equals(9));

      calloc.free(value);
    });
  });

  group('Transaction Handling', () {
    test('Begin transaction', () {
      final tx = calloc<Transaction>();

      final txId = dbBeginTransaction(tx, IsolationLevel.READ_COMMITTED.value);
      expect(txId, greaterThan(0));
      expect(tx.ref.state, equals(TransactionState.ACTIVE.value));

      calloc.free(tx);
    });

    test('Commit transaction', () {
      final tx = calloc<Transaction>();

      final txId = dbBeginTransaction(tx, IsolationLevel.READ_COMMITTED.value);
      expect(txId, greaterThan(0));

      final result = dbCommitTransaction(txId);
      expect(result, equals(0));

      calloc.free(tx);
    });

    test('Rollback transaction', () {
      final tx = calloc<Transaction>();

      final txId = dbBeginTransaction(tx, IsolationLevel.SERIALIZABLE.value);
      expect(txId, greaterThan(0));

      final result = dbRollbackTransaction(txId);
      expect(result, equals(0));

      calloc.free(tx);
    });

    test('Transaction with different isolation levels', () {
      final levels = [
        IsolationLevel.READ_UNCOMMITTED,
        IsolationLevel.READ_COMMITTED,
        IsolationLevel.REPEATABLE_READ,
        IsolationLevel.SERIALIZABLE,
      ];

      for (final level in levels) {
        final tx = calloc<Transaction>();
        final txId = dbBeginTransaction(tx, level.value);
        expect(txId, greaterThan(0));
        expect(tx.ref.isolation, equals(level.value));
        dbCommitTransaction(txId);
        calloc.free(tx);
      }
    });
  });

  group('Index Operations', () {
    test('Create BTREE index', () {
      final index = calloc<Index>();
      index.ref.name_str = 'idx_users_id';
      index.ref.table_name_str = 'users';
      index.ref.type = IndexType.BTREE.value;
      index.ref.unique = 1;

      final result = dbCreateIndex(index);
      expect(result, equals(0));

      calloc.free(index);
    });

    test('Create HASH index', () {
      final index = calloc<Index>();
      index.ref.name_str = 'idx_users_email';
      index.ref.table_name_str = 'users';
      index.ref.type = IndexType.HASH.value;
      index.ref.unique = 1;

      final result = dbCreateIndex(index);
      expect(result, equals(0));

      calloc.free(index);
    });

    test('Create FULLTEXT index', () {
      final index = calloc<Index>();
      index.ref.name_str = 'idx_products_desc';
      index.ref.table_name_str = 'products';
      index.ref.type = IndexType.FULLTEXT.value;
      index.ref.unique = 0;

      final result = dbCreateIndex(index);
      expect(result, equals(0));

      calloc.free(index);
    });
  });

  group('Database Statistics', () {
    test('Get database stats', () {
      final stats = calloc<DatabaseStats>();

      dbGetStats(stats);

      expect(stats.ref.total_queries, greaterThanOrEqualTo(0));
      expect(stats.ref.total_transactions, greaterThanOrEqualTo(0));
      expect(stats.ref.cache_hits, greaterThanOrEqualTo(0));
      expect(stats.ref.page_reads, greaterThanOrEqualTo(0));

      calloc.free(stats);
    });

    test('Stats updated after queries', () {
      final stats1 = calloc<DatabaseStats>();
      dbGetStats(stats1);
      final initialQueries = stats1.ref.total_queries;

      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users';
      final result = calloc<ResultSet>();
      dbExecuteQuery(query, result);

      final stats2 = calloc<DatabaseStats>();
      dbGetStats(stats2);

      expect(stats2.ref.total_queries, greaterThan(initialQueries));

      calloc.free(stats1);
      calloc.free(stats2);
      calloc.free(query);
      calloc.free(result);
    });
  });

  group('Table Information', () {
    test('Get table info', () {
      final table = calloc<Table>();
      table.ref.name_str = 'users';
      table.ref.columns_count = 2;

      final col1 = table.ref.columns[0];
      col1.name_str = 'id';
      col1.type = DataType.INTEGER.value;

      final col2 = table.ref.columns[1];
      col2.name_str = 'name';
      col2.type = DataType.TEXT.value;

      dbCreateTable(table);

      final tableName = 'users'.toNativeUtf8();
      final tableInfo = calloc<Table>();

      final result = dbGetTableInfo(tableName.cast(), tableInfo);
      expect(result, equals(0));

      calloc.free(tableName);
      calloc.free(table);
      calloc.free(tableInfo);
    });
  });
}
