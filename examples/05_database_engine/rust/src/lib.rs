mod generated;

use generated::*;
use std::collections::HashMap;
use std::sync::RwLock;
use std::time::{SystemTime, UNIX_EPOCH};

struct DatabaseEngine {
    tables: HashMap<String, TableData>,
    indexes: HashMap<String, IndexData>,
    transactions: HashMap<u64, TransactionData>,
    next_tx_id: u64,
    stats: Stats,
}

struct TableData {
    schema: Vec<(String, DataType)>,
    rows: Vec<Vec<ValueData>>,
}

struct IndexData {
    table: String,
    columns: Vec<String>,
    index_type: IndexType,
    unique: bool,
}

struct TransactionData {
    state: TransactionState,
    isolation: IsolationLevel,
    start_time: u64,
    query_count: u32,
}

struct Stats {
    total_queries: u64,
    total_transactions: u64,
    cache_hits: u64,
    cache_misses: u64,
    page_reads: u64,
    page_writes: u64,
    query_times: Vec<f64>,
}

#[derive(Clone)]
enum ValueData {
    Null,
    Integer(i64),
    Real(f64),
    Text(String),
    Blob(Vec<u8>),
    Boolean(bool),
}

static DB: RwLock<Option<DatabaseEngine>> = RwLock::new(None);

impl DatabaseEngine {
    fn new() -> Self {
        Self {
            tables: HashMap::new(),
            indexes: HashMap::new(),
            transactions: HashMap::new(),
            next_tx_id: 1,
            stats: Stats {
                total_queries: 0,
                total_transactions: 0,
                cache_hits: 0,
                cache_misses: 0,
                page_reads: 0,
                page_writes: 0,
                query_times: Vec::new(),
            },
        }
    }

    fn create_table(&mut self, name: &str, columns: Vec<(String, DataType)>) {
        self.tables.insert(
            name.to_string(),
            TableData {
                schema: columns,
                rows: Vec::new(),
            },
        );
    }

    fn insert_row(&mut self, table: &str, values: Vec<ValueData>) -> Result<u64, String> {
        let table_data = self.tables.get_mut(table)
            .ok_or_else(|| format!("Table {} not found", table))?;

        if values.len() != table_data.schema.len() {
            return Err("Column count mismatch".to_string());
        }

        table_data.rows.push(values);
        self.stats.page_writes += 1;
        Ok(table_data.rows.len() as u64)
    }

    fn select_rows(&mut self, table: &str, limit: Option<usize>) -> Result<Vec<Vec<ValueData>>, String> {
        let table_data = self.tables.get(table)
            .ok_or_else(|| format!("Table {} not found", table))?;

        self.stats.page_reads += table_data.rows.len() as u64 / 100;
        self.stats.cache_hits += 1;

        let rows = if let Some(lim) = limit {
            table_data.rows.iter().take(lim).cloned().collect()
        } else {
            table_data.rows.clone()
        };

        Ok(rows)
    }

    fn begin_transaction(&mut self, isolation: IsolationLevel) -> u64 {
        let tx_id = self.next_tx_id;
        self.next_tx_id += 1;

        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs();

        self.transactions.insert(
            tx_id,
            TransactionData {
                state: TransactionState::ACTIVE,
                isolation,
                start_time: now,
                query_count: 0,
            },
        );

        self.stats.total_transactions += 1;
        tx_id
    }

    fn commit_transaction(&mut self, tx_id: u64) -> Result<(), String> {
        let tx = self.transactions.get_mut(&tx_id)
            .ok_or_else(|| "Transaction not found".to_string())?;

        tx.state = TransactionState::COMMITTED;
        Ok(())
    }

    fn rollback_transaction(&mut self, tx_id: u64) -> Result<(), String> {
        let tx = self.transactions.get_mut(&tx_id)
            .ok_or_else(|| "Transaction not found".to_string())?;

        tx.state = TransactionState::ROLLED_BACK;
        Ok(())
    }

    fn create_index(&mut self, name: &str, table: &str, columns: Vec<String>,
                    index_type: IndexType, unique: bool) {
        self.indexes.insert(
            name.to_string(),
            IndexData {
                table: table.to_string(),
                columns,
                index_type,
                unique,
            },
        );
    }

    fn execute_query(&mut self, sql: &str) -> Result<(Vec<Vec<ValueData>>, u32), String> {
        let start = SystemTime::now();
        self.stats.total_queries += 1;

        let result = if sql.starts_with("SELECT") {
            self.parse_select(sql)
        } else if sql.starts_with("INSERT") {
            self.parse_insert(sql)
        } else if sql.starts_with("CREATE TABLE") {
            self.parse_create_table(sql)
        } else if sql.starts_with("CREATE INDEX") {
            self.parse_create_index(sql)
        } else {
            Err("Unsupported query".to_string())
        };

        let elapsed = SystemTime::now()
            .duration_since(start)
            .unwrap()
            .as_secs_f64() * 1000.0;
        self.stats.query_times.push(elapsed);

        result
    }

    fn parse_select(&mut self, sql: &str) -> Result<(Vec<Vec<ValueData>>, u32), String> {
        let parts: Vec<&str> = sql.split_whitespace().collect();

        let table = parts.iter()
            .position(|&s| s.eq_ignore_ascii_case("FROM"))
            .and_then(|i| parts.get(i + 1))
            .ok_or("Invalid SELECT syntax")?;

        let limit = parts.iter()
            .position(|&s| s.eq_ignore_ascii_case("LIMIT"))
            .and_then(|i| parts.get(i + 1))
            .and_then(|s| s.parse::<usize>().ok());

        let rows = self.select_rows(table, limit)?;
        let count = rows.len() as u32;
        Ok((rows, count))
    }

    fn parse_insert(&mut self, sql: &str) -> Result<(Vec<Vec<ValueData>>, u32), String> {
        let parts: Vec<&str> = sql.split_whitespace().collect();

        let table = parts.iter()
            .position(|&s| s.eq_ignore_ascii_case("INTO"))
            .and_then(|i| parts.get(i + 1))
            .ok_or("Invalid INSERT syntax")?;

        let values_str = parts.iter()
            .position(|&s| s.eq_ignore_ascii_case("VALUES"))
            .and_then(|i| parts.get(i + 1))
            .ok_or("Invalid INSERT syntax")?;

        let values = self.parse_values(values_str)?;
        let _last_id = self.insert_row(table, values)?;

        Ok((vec![], 1))
    }

    fn parse_create_table(&mut self, sql: &str) -> Result<(Vec<Vec<ValueData>>, u32), String> {
        let parts: Vec<&str> = sql.split_whitespace().collect();

        let table = parts.get(2).ok_or("Invalid CREATE TABLE syntax")?;

        let columns = vec![
            ("id".to_string(), DataType::INTEGER),
            ("name".to_string(), DataType::TEXT),
        ];

        self.create_table(table, columns);
        Ok((vec![], 0))
    }

    fn parse_create_index(&mut self, sql: &str) -> Result<(Vec<Vec<ValueData>>, u32), String> {
        let parts: Vec<&str> = sql.split_whitespace().collect();

        let index_name = parts.get(2).ok_or("Invalid CREATE INDEX syntax")?;
        let table = parts.iter()
            .position(|&s| s.eq_ignore_ascii_case("ON"))
            .and_then(|i| parts.get(i + 1))
            .ok_or("Invalid CREATE INDEX syntax")?;

        self.create_index(
            index_name,
            table,
            vec!["id".to_string()],
            IndexType::BTREE,
            false,
        );

        Ok((vec![], 0))
    }

    fn parse_values(&self, _values_str: &str) -> Result<Vec<ValueData>, String> {
        Ok(vec![
            ValueData::Integer(1),
            ValueData::Text("test".to_string()),
        ])
    }
}

fn copy_str_to_array(src: &str, dst: &mut [u8]) {
    let bytes = src.as_bytes();
    let len = bytes.len().min(dst.len() - 1);
    dst[..len].copy_from_slice(&bytes[..len]);
    dst[len] = 0;
}

fn value_to_ffi(src: &ValueData, dst: &mut Value) {
    match src {
        ValueData::Null => {
            dst.r#type = DataType::NULL as u32;
        }
        ValueData::Integer(v) => {
            dst.r#type = DataType::INTEGER as u32;
            dst.int_value = *v;
        }
        ValueData::Real(v) => {
            dst.r#type = DataType::REAL as u32;
            dst.real_value = *v;
        }
        ValueData::Text(v) => {
            dst.r#type = DataType::TEXT as u32;
            copy_str_to_array(v, &mut dst.text_value);
        }
        ValueData::Blob(v) => {
            dst.r#type = DataType::BLOB as u32;
            let len = v.len().min(dst.blob_value.len());
            dst.blob_value[..len].copy_from_slice(&v[..len]);
        }
        ValueData::Boolean(v) => {
            dst.r#type = DataType::BOOLEAN as u32;
            dst.bool_value = if *v { 1 } else { 0 };
        }
    }
}

fn value_from_ffi(src: &Value) -> ValueData {
    match src.r#type {
        x if x == DataType::NULL as u32 => ValueData::Null,
        x if x == DataType::INTEGER as u32 => ValueData::Integer(src.int_value),
        x if x == DataType::REAL as u32 => ValueData::Real(src.real_value),
        x if x == DataType::TEXT as u32 => {
            let len = src.text_value.iter().position(|&b| b == 0).unwrap_or(src.text_value.len());
            let s = String::from_utf8_lossy(&src.text_value[..len]).to_string();
            ValueData::Text(s)
        }
        x if x == DataType::BLOB as u32 => {
            ValueData::Blob(src.blob_value.to_vec())
        }
        x if x == DataType::BOOLEAN as u32 => ValueData::Boolean(src.bool_value != 0),
        _ => ValueData::Null,
    }
}

#[no_mangle]
pub extern "C" fn db_init() {
    let mut db = DB.write().unwrap();
    *db = Some(DatabaseEngine::new());
}

#[no_mangle]
pub extern "C" fn db_create_table(table_ptr: *mut Table) {
    if table_ptr.is_null() {
        return;
    }

    let table = unsafe { &*table_ptr };
    let name_len = table.name.iter().position(|&b| b == 0).unwrap_or(table.name.len());
    let name = String::from_utf8_lossy(&table.name[..name_len]).to_string();

    let mut columns = Vec::new();
    for i in 0..table.columns_count as usize {
        let col = &table.columns[i];
        let col_name_len = col.name.iter().position(|&b| b == 0).unwrap_or(col.name.len());
        let col_name = String::from_utf8_lossy(&col.name[..col_name_len]).to_string();

        let data_type = match col.r#type {
            x if x == DataType::INTEGER as u32 => DataType::INTEGER,
            x if x == DataType::REAL as u32 => DataType::REAL,
            x if x == DataType::TEXT as u32 => DataType::TEXT,
            x if x == DataType::BLOB as u32 => DataType::BLOB,
            x if x == DataType::BOOLEAN as u32 => DataType::BOOLEAN,
            _ => DataType::NULL,
        };

        columns.push((col_name, data_type));
    }

    let mut db = DB.write().unwrap();
    if let Some(engine) = db.as_mut() {
        engine.create_table(&name, columns);
    }
}

#[no_mangle]
pub extern "C" fn db_execute_query(query_ptr: *mut Query, result_ptr: *mut ResultSet) -> i32 {
    if query_ptr.is_null() || result_ptr.is_null() {
        return -1;
    }

    let query = unsafe { &*query_ptr };
    let result = unsafe { &mut *result_ptr };

    let sql_len = query.sql.iter().position(|&b| b == 0).unwrap_or(query.sql.len());
    let sql = String::from_utf8_lossy(&query.sql[..sql_len]).to_string();

    let mut db = DB.write().unwrap();
    if let Some(engine) = db.as_mut() {
        match engine.execute_query(&sql) {
            Ok((rows, affected)) => {
                result.row_count = rows.len() as u32;
                result.affected_rows = affected;
                result.rows_count = rows.len().min(1000) as u32;

                for (i, row_values) in rows.iter().enumerate().take(1000) {
                    let row = &mut result.rows[i];
                    row.column_count = row_values.len() as u32;
                    row.values_count = row_values.len().min(32) as u32;

                    for (j, value) in row_values.iter().enumerate().take(32) {
                        value_to_ffi(value, &mut row.values[j]);
                    }
                }

                0
            }
            Err(_) => -1,
        }
    } else {
        -1
    }
}

#[no_mangle]
pub extern "C" fn db_insert_row(table_ptr: *mut Table, row_ptr: *mut Row) -> i64 {
    if table_ptr.is_null() || row_ptr.is_null() {
        return -1;
    }

    let table = unsafe { &*table_ptr };
    let row = unsafe { &*row_ptr };

    let name_len = table.name.iter().position(|&b| b == 0).unwrap_or(table.name.len());
    let name = String::from_utf8_lossy(&table.name[..name_len]).to_string();

    let mut values = Vec::new();
    for i in 0..row.values_count as usize {
        values.push(value_from_ffi(&row.values[i]));
    }

    let mut db = DB.write().unwrap();
    if let Some(engine) = db.as_mut() {
        engine.insert_row(&name, values).unwrap_or(0) as i64
    } else {
        -1
    }
}

#[no_mangle]
pub extern "C" fn db_begin_transaction(tx_ptr: *mut Transaction, isolation: u32) -> u64 {
    if tx_ptr.is_null() {
        return 0;
    }

    let iso = match isolation {
        0 => IsolationLevel::READ_UNCOMMITTED,
        1 => IsolationLevel::READ_COMMITTED,
        2 => IsolationLevel::REPEATABLE_READ,
        3 => IsolationLevel::SERIALIZABLE,
        _ => IsolationLevel::READ_COMMITTED,
    };

    let mut db = DB.write().unwrap();
    if let Some(engine) = db.as_mut() {
        let tx_id = engine.begin_transaction(iso);

        let tx = unsafe { &mut *tx_ptr };
        tx.transaction_id = tx_id;
        tx.state = TransactionState::ACTIVE as u32;
        tx.isolation = iso as u32;
        tx.start_time = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs();
        tx.query_count = 0;

        tx_id
    } else {
        0
    }
}

#[no_mangle]
pub extern "C" fn db_commit_transaction(tx_id: u64) -> i32 {
    let mut db = DB.write().unwrap();
    if let Some(engine) = db.as_mut() {
        match engine.commit_transaction(tx_id) {
            Ok(_) => 0,
            Err(_) => -1,
        }
    } else {
        -1
    }
}

#[no_mangle]
pub extern "C" fn db_rollback_transaction(tx_id: u64) -> i32 {
    let mut db = DB.write().unwrap();
    if let Some(engine) = db.as_mut() {
        match engine.rollback_transaction(tx_id) {
            Ok(_) => 0,
            Err(_) => -1,
        }
    } else {
        -1
    }
}

#[no_mangle]
pub extern "C" fn db_create_index(index_ptr: *mut Index) -> i32 {
    if index_ptr.is_null() {
        return -1;
    }

    let index = unsafe { &*index_ptr };

    let name_len = index.name.iter().position(|&b| b == 0).unwrap_or(index.name.len());
    let name = String::from_utf8_lossy(&index.name[..name_len]).to_string();

    let table_len = index.table_name.iter().position(|&b| b == 0).unwrap_or(index.table_name.len());
    let table = String::from_utf8_lossy(&index.table_name[..table_len]).to_string();

    let idx_type = match index.r#type {
        0 => IndexType::BTREE,
        1 => IndexType::HASH,
        2 => IndexType::FULLTEXT,
        _ => IndexType::BTREE,
    };

    let columns = vec!["id".to_string()];

    let mut db = DB.write().unwrap();
    if let Some(engine) = db.as_mut() {
        engine.create_index(&name, &table, columns, idx_type, index.unique != 0);
        0
    } else {
        -1
    }
}

#[no_mangle]
pub extern "C" fn db_get_stats(stats_ptr: *mut DatabaseStats) {
    if stats_ptr.is_null() {
        return;
    }

    let db = DB.read().unwrap();
    if let Some(engine) = db.as_ref() {
        let stats = unsafe { &mut *stats_ptr };
        stats.total_queries = engine.stats.total_queries;
        stats.total_transactions = engine.stats.total_transactions;
        stats.cache_hits = engine.stats.cache_hits;
        stats.cache_misses = engine.stats.cache_misses;
        stats.page_reads = engine.stats.page_reads;
        stats.page_writes = engine.stats.page_writes;

        let avg = if engine.stats.query_times.is_empty() {
            0.0
        } else {
            engine.stats.query_times.iter().sum::<f64>() / engine.stats.query_times.len() as f64
        };
        stats.avg_query_time_ms = avg;
    }
}

#[no_mangle]
pub extern "C" fn db_create_cursor(query_ptr: *mut Query, cursor_ptr: *mut Cursor) -> i32 {
    if query_ptr.is_null() || cursor_ptr.is_null() {
        return -1;
    }

    let cursor = unsafe { &mut *cursor_ptr };
    cursor.cursor_id = 1;
    cursor.current_position = 0;
    cursor.total_rows = 0;
    cursor.is_open = 1;
    cursor.is_eof = 0;

    0
}

#[no_mangle]
pub extern "C" fn db_fetch_next(cursor_ptr: *mut Cursor, row_ptr: *mut Row) -> i32 {
    if cursor_ptr.is_null() || row_ptr.is_null() {
        return -1;
    }

    let cursor = unsafe { &mut *cursor_ptr };

    if cursor.current_position >= cursor.total_rows {
        cursor.is_eof = 1;
        return 0;
    }

    cursor.current_position += 1;
    0
}

#[no_mangle]
pub extern "C" fn db_close_cursor(cursor_ptr: *mut Cursor) -> i32 {
    if cursor_ptr.is_null() {
        return -1;
    }

    let cursor = unsafe { &mut *cursor_ptr };
    cursor.is_open = 0;
    0
}

#[no_mangle]
pub extern "C" fn db_build_query_plan(query_ptr: *mut Query, plan_ptr: *mut QueryPlan) -> i32 {
    if query_ptr.is_null() || plan_ptr.is_null() {
        return -1;
    }

    let plan = unsafe { &mut *plan_ptr };

    copy_str_to_array("SeqScan", &mut plan.operation);
    plan.estimated_cost = 100.0;
    plan.estimated_rows = 1000;
    plan.children_count = 0;

    0
}

#[no_mangle]
pub extern "C" fn db_build_complex_query_plan(plan_ptr: *mut QueryPlan, depth: u32) -> i32 {
    if plan_ptr.is_null() {
        return -1;
    }

    let plan = unsafe { &mut *plan_ptr };

    copy_str_to_array("Join", &mut plan.operation);
    plan.estimated_cost = 500.0;
    plan.estimated_rows = 5000;

    if depth > 0 && depth <= 3 {
        plan.children_count = 2;

        if let Some(left) = plan.get_child_mut(0) {
            copy_str_to_array("SeqScan", &mut left.operation);
            left.estimated_cost = 100.0;
            left.estimated_rows = 1000;
            left.children_count = 0;
        }

        if let Some(right) = plan.get_child_mut(1) {
            copy_str_to_array("IndexScan", &mut right.operation);
            right.estimated_cost = 50.0;
            right.estimated_rows = 500;
            right.children_count = 0;
        }
    }

    0
}

#[no_mangle]
pub extern "C" fn db_execute_plan(plan_ptr: *mut QueryPlan, result_ptr: *mut ResultSet) -> i32 {
    if plan_ptr.is_null() || result_ptr.is_null() {
        return -1;
    }

    let result = unsafe { &mut *result_ptr };
    result.row_count = 10;
    result.affected_rows = 0;
    result.rows_count = 10;

    for i in 0..10 {
        let row = &mut result.rows[i];
        row.column_count = 2;
        row.values_count = 2;

        row.values[0].r#type = DataType::INTEGER as u32;
        row.values[0].int_value = i as i64 + 1;

        row.values[1].r#type = DataType::TEXT as u32;
        copy_str_to_array(&format!("row_{}", i + 1), &mut row.values[1].text_value);
    }

    0
}

#[no_mangle]
pub extern "C" fn db_get_table_info(table_name: *const u8, table_ptr: *mut Table) -> i32 {
    if table_name.is_null() || table_ptr.is_null() {
        return -1;
    }

    let name = unsafe {
        std::ffi::CStr::from_ptr(table_name as *const i8)
            .to_string_lossy()
            .to_string()
    };

    let db = DB.read().unwrap();
    if let Some(engine) = db.as_ref() {
        if let Some(table_data) = engine.tables.get(&name) {
            let table = unsafe { &mut *table_ptr };

            copy_str_to_array(&name, &mut table.name);
            table.row_count = table_data.rows.len() as u64;
            table.page_count = (table_data.rows.len() as u64 + 99) / 100;
            table.columns_count = table_data.schema.len().min(32) as u32;

            for (i, (col_name, col_type)) in table_data.schema.iter().enumerate().take(32) {
                let col = &mut table.columns[i];
                copy_str_to_array(col_name, &mut col.name);
                col.r#type = *col_type as u32;
                col.nullable = 1;
                col.primary_key = if i == 0 { 1 } else { 0 };
                col.unique = 0;
            }

            return 0;
        }
    }

    -1
}

#[no_mangle]
pub extern "C" fn db_bulk_insert(table_ptr: *mut Table, rows_ptr: *mut Row, count: u32) -> i32 {
    if table_ptr.is_null() || rows_ptr.is_null() {
        return -1;
    }

    let table = unsafe { &*table_ptr };
    let name_len = table.name.iter().position(|&b| b == 0).unwrap_or(table.name.len());
    let name = String::from_utf8_lossy(&table.name[..name_len]).to_string();

    let mut db = DB.write().unwrap();
    if let Some(engine) = db.as_mut() {
        let rows = unsafe { std::slice::from_raw_parts(rows_ptr, count as usize) };

        for row in rows {
            let mut values = Vec::new();
            for i in 0..row.values_count as usize {
                values.push(value_from_ffi(&row.values[i]));
            }

            if engine.insert_row(&name, values).is_err() {
                return -1;
            }
        }

        count as i32
    } else {
        -1
    }
}

#[no_mangle]
pub extern "C" fn db_get_connection_info(conn_ptr: *mut ConnectionInfo) {
    if conn_ptr.is_null() {
        return;
    }

    let db = DB.read().unwrap();
    if db.is_some() {
        let conn = unsafe { &mut *conn_ptr };
        conn.connection_id = 1;
        copy_str_to_array("test_db", &mut conn.database_name);
        conn.connect_time = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs();
        conn.active_queries = 0;
        conn.active_transactions = 0;
    }
}

#[no_mangle]
pub extern "C" fn db_acquire_lock(lock_ptr: *mut LockInfo) -> i32 {
    if lock_ptr.is_null() {
        return -1;
    }

    let lock = unsafe { &mut *lock_ptr };
    lock.acquired_time = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_secs();

    0
}
