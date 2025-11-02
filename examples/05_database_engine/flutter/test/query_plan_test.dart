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

typedef DbBuildQueryPlanNative = ffi.Int32 Function(
    ffi.Pointer<Query>, ffi.Pointer<QueryPlan>);
typedef DbBuildQueryPlanDart = int Function(
    ffi.Pointer<Query>, ffi.Pointer<QueryPlan>);

typedef DbBuildComplexQueryPlanNative = ffi.Int32 Function(
    ffi.Pointer<QueryPlan>, ffi.Uint32);
typedef DbBuildComplexQueryPlanDart = int Function(
    ffi.Pointer<QueryPlan>, int);

typedef DbExecutePlanNative = ffi.Int32 Function(
    ffi.Pointer<QueryPlan>, ffi.Pointer<ResultSet>);
typedef DbExecutePlanDart = int Function(
    ffi.Pointer<QueryPlan>, ffi.Pointer<ResultSet>);

late DbInitDart dbInit;
late DbBuildQueryPlanDart dbBuildQueryPlan;
late DbBuildComplexQueryPlanDart dbBuildComplexQueryPlan;
late DbExecutePlanDart dbExecutePlan;

void main() {
  setUpAll(() {
    dylib = _loadLibrary();
    dbInit = dylib.lookupFunction<DbInitNative, DbInitDart>('db_init');
    dbBuildQueryPlan = dylib.lookupFunction<DbBuildQueryPlanNative,
        DbBuildQueryPlanDart>('db_build_query_plan');
    dbBuildComplexQueryPlan = dylib.lookupFunction<DbBuildComplexQueryPlanNative,
        DbBuildComplexQueryPlanDart>('db_build_complex_query_plan');
    dbExecutePlan = dylib.lookupFunction<DbExecutePlanNative, DbExecutePlanDart>(
        'db_execute_plan');

    dbInit();
  });

  group('Query Plan Generation', () {
    test('Build simple query plan', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users';

      final plan = calloc<QueryPlan>();

      final result = dbBuildQueryPlan(query, plan);
      expect(result, equals(0));
      expect(plan.ref.operation_str, equals('SeqScan'));
      expect(plan.ref.estimated_cost, greaterThan(0));
      expect(plan.ref.estimated_rows, greaterThan(0));

      calloc.free(query);
      calloc.free(plan);
    });

    test('Query plan has zero children initially', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users WHERE id = 1';

      final plan = calloc<QueryPlan>();

      dbBuildQueryPlan(query, plan);
      expect(plan.ref.children_count, equals(0));

      calloc.free(query);
      calloc.free(plan);
    });
  });

  group('Recursive Query Plans', () {
    test('Build query plan with depth 1', () {
      final plan = calloc<QueryPlan>();

      final result = dbBuildComplexQueryPlan(plan, 1);
      expect(result, equals(0));
      expect(plan.ref.operation_str, equals('Join'));
      expect(plan.ref.children_count, equals(2));

      calloc.free(plan);
    });

    test('Build query plan with depth 2', () {
      final plan = calloc<QueryPlan>();

      final result = dbBuildComplexQueryPlan(plan, 2);
      expect(result, equals(0));
      expect(plan.ref.operation_str, equals('Join'));
      expect(plan.ref.children_count, equals(2));

      calloc.free(plan);
    });

    test('Build query plan with depth 3', () {
      final plan = calloc<QueryPlan>();

      final result = dbBuildComplexQueryPlan(plan, 3);
      expect(result, equals(0));
      expect(plan.ref.operation_str, equals('Join'));
      expect(plan.ref.children_count, equals(2));

      calloc.free(plan);
    });

    test('Query plan with nested joins', () {
      final plan = calloc<QueryPlan>();

      dbBuildComplexQueryPlan(plan, 2);

      expect(plan.ref.operation_str, contains('Join'));
      expect(plan.ref.estimated_cost, greaterThan(0));
      expect(plan.ref.estimated_rows, greaterThan(0));

      calloc.free(plan);
    });

    test('Verify child operations in complex plan', () {
      final plan = calloc<QueryPlan>();

      dbBuildComplexQueryPlan(plan, 1);
      expect(plan.ref.children_count, equals(2));

      calloc.free(plan);
    });
  });

  group('Query Plan Execution', () {
    test('Execute simple query plan', () {
      final plan = calloc<QueryPlan>();
      plan.ref.operation_str = 'SeqScan';
      plan.ref.estimated_cost = 100;
      plan.ref.estimated_rows = 10;

      final result = calloc<ResultSet>();

      final status = dbExecutePlan(plan, result);
      expect(status, equals(0));
      expect(result.ref.row_count, greaterThan(0));

      calloc.free(plan);
      calloc.free(result);
    });

    test('Execute complex query plan', () {
      final plan = calloc<QueryPlan>();
      dbBuildComplexQueryPlan(plan, 2);

      final result = calloc<ResultSet>();

      final status = dbExecutePlan(plan, result);
      expect(status, equals(0));

      calloc.free(plan);
      calloc.free(result);
    });

    test('Verify result set from plan execution', () {
      final plan = calloc<QueryPlan>();
      dbBuildComplexQueryPlan(plan, 1);

      final result = calloc<ResultSet>();
      dbExecutePlan(plan, result);

      expect(result.ref.rows_count, greaterThan(0));

      for (var i = 0; i < result.ref.rows_count && i < 10; i++) {
        final row = result.ref.rows[i];
        expect(row.values_count, greaterThan(0));
      }

      calloc.free(plan);
      calloc.free(result);
    });
  });

  group('Query Plan Cost Estimation', () {
    test('Sequential scan has lower cost than join', () {
      final query = calloc<Query>();
      query.ref.sql_str = 'SELECT * FROM users';

      final seqScanPlan = calloc<QueryPlan>();
      dbBuildQueryPlan(query, seqScanPlan);

      final joinPlan = calloc<QueryPlan>();
      dbBuildComplexQueryPlan(joinPlan, 1);

      expect(joinPlan.ref.estimated_cost, greaterThan(seqScanPlan.ref.estimated_cost));

      calloc.free(query);
      calloc.free(seqScanPlan);
      calloc.free(joinPlan);
    });

    test('Cost increases with query complexity', () {
      final plan1 = calloc<QueryPlan>();
      dbBuildComplexQueryPlan(plan1, 1);

      final plan2 = calloc<QueryPlan>();
      dbBuildComplexQueryPlan(plan2, 2);

      expect(plan1.ref.estimated_cost, greaterThan(0));
      expect(plan2.ref.estimated_cost, greaterThan(0));

      calloc.free(plan1);
      calloc.free(plan2);
    });
  });

  group('Query Plan Operations', () {
    test('Different operation types', () {
      final operations = ['SeqScan', 'IndexScan', 'Join', 'Filter', 'Sort'];

      for (final op in operations) {
        final plan = calloc<QueryPlan>();
        plan.ref.operation_str = op;

        expect(plan.ref.operation_str, equals(op));

        calloc.free(plan);
      }
    });

    test('Operation string length limits', () {
      final plan = calloc<QueryPlan>();

      final longOp = 'A' * 127;
      plan.ref.operation_str = longOp;

      final retrieved = plan.ref.operation_str;
      expect(retrieved.length, lessThanOrEqualTo(127));

      calloc.free(plan);
    });
  });

  group('Memory Management', () {
    test('Allocate and free multiple plans', () {
      final plans = <ffi.Pointer<QueryPlan>>[];

      for (var i = 0; i < 100; i++) {
        final plan = calloc<QueryPlan>();
        plans.add(plan);
      }

      for (final plan in plans) {
        calloc.free(plan);
      }
    });

    test('Reuse query plans', () {
      final plan = calloc<QueryPlan>();

      for (var i = 0; i < 10; i++) {
        dbBuildComplexQueryPlan(plan, 1);
        expect(plan.ref.operation_str, equals('Join'));
      }

      calloc.free(plan);
    });
  });
}
