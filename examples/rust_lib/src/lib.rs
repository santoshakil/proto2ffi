mod core;

use core::calculator::{BasicCalculator, Calculator};
use once_cell::sync::Lazy;
use prost::Message;
use std::slice;

static CALCULATOR: Lazy<BasicCalculator> = Lazy::new(|| BasicCalculator);

include!(concat!(env!("OUT_DIR"), "/calculator.rs"));

#[repr(C)]
pub struct ByteBuffer {
    ptr: *mut u8,
    len: usize,
}

#[no_mangle]
pub extern "C" fn calculator_process(data_ptr: *const u8, data_len: usize) -> ByteBuffer {
    if data_ptr.is_null() || data_len == 0 {
        return error_response("Invalid input data");
    }

    let data = unsafe { slice::from_raw_parts(data_ptr, data_len) };

    let request = match ComplexCalculationRequest::decode(data) {
        Ok(req) => req,
        Err(e) => return error_response(&format!("Failed to decode request: {}", e)),
    };

    let response = process_request(&*CALCULATOR, request);

    encode_response(response)
}

#[inline(always)]
fn process_request(calc: &impl Calculator, request: ComplexCalculationRequest) -> ComplexCalculationResponse {
    use complex_calculation_request::Operation;

    let operation = match request.operation {
        Some(op) => op,
        None => return error_result("No operation specified"),
    };

    match operation {
        Operation::Add(op) => {
            let result = calc.add(op.a, op.b);
            success_result(result)
        }
        Operation::Subtract(op) => {
            let result = calc.subtract(op.a, op.b);
            success_result(result)
        }
        Operation::Multiply(op) => {
            let result = calc.multiply(op.a, op.b);
            success_result(result)
        }
        Operation::Divide(op) => match calc.divide(op.a, op.b) {
            Some(result) => success_result(result),
            None => error_result("Division by zero"),
        },
        Operation::Batch(batch_op) => process_batch(calc, batch_op),
        Operation::Complex(complex_op) => process_complex(complex_op),
    }
}

fn process_batch(calc: &impl Calculator, batch: BatchOperation) -> ComplexCalculationResponse {
    let start = std::time::Instant::now();
    let mut results = Vec::with_capacity(batch.operations.len());
    let mut success_count = 0;
    let error_count = 0;

    for op in batch.operations {
        let result = calc.add(op.a, op.b);
        results.push(result);
        success_count += 1;
    }

    let _elapsed = start.elapsed();

    ComplexCalculationResponse {
        result: Some(complex_calculation_response::Result::BatchResult(
            BatchResult {
                values: results,
                success_count,
                error_count,
            },
        )),
    }
}

fn process_complex(complex: ComplexDataOperation) -> ComplexCalculationResponse {
    let start = std::time::Instant::now();

    let data_batch = match complex.data {
        Some(batch) => batch,
        None => return error_result("No data batch provided"),
    };

    let transaction_count = data_batch.transactions.len() as i32;
    let mut total_amount = 0.0;
    let mut stats = std::collections::HashMap::new();

    for tx in &data_batch.transactions {
        total_amount += tx.amount;

        *stats.entry(tx.currency.clone()).or_insert(0) += 1;

        for tag in &tx.tags {
            *stats.entry(format!("tag_{}", tag)).or_insert(0) += 1;
        }
    }

    let processing_time_ns = start.elapsed().as_nanos() as i64;

    ComplexCalculationResponse {
        result: Some(complex_calculation_response::Result::ComplexResult(
            ComplexDataResult {
                transaction_count,
                total_amount,
                processing_time_ns,
                stats,
            },
        )),
    }
}

#[inline(always)]
fn success_result(value: i64) -> ComplexCalculationResponse {
    ComplexCalculationResponse {
        result: Some(complex_calculation_response::Result::Value(value)),
    }
}

#[inline(always)]
fn error_result(msg: &str) -> ComplexCalculationResponse {
    ComplexCalculationResponse {
        result: Some(complex_calculation_response::Result::Error(ErrorResult {
            message: msg.to_string(),
        })),
    }
}

#[inline(always)]
fn error_response(msg: &str) -> ByteBuffer {
    encode_response(error_result(msg))
}

#[inline(always)]
fn encode_response(response: ComplexCalculationResponse) -> ByteBuffer {
    let mut buf = Vec::new();
    if response.encode(&mut buf).is_err() {
        buf.clear();
        let error = error_result("Failed to encode response");
        let _ = error.encode(&mut buf);
    }

    let len = buf.len();
    let ptr = buf.as_mut_ptr();
    std::mem::forget(buf);

    ByteBuffer { ptr, len }
}

#[no_mangle]
pub extern "C" fn calculator_free_buffer(buffer: ByteBuffer) {
    if !buffer.ptr.is_null() && buffer.len > 0 {
        let _ = unsafe { Vec::from_raw_parts(buffer.ptr, buffer.len, buffer.len) };
    }
}
