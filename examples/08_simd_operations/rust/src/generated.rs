#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct I32ArrayOps {
    pub data: *const i32,
    pub count: u32,
    pub sum: i32,
    pub min: i32,
    pub max: i32,
    pub average: f32,
}
impl I32ArrayOps {
    pub const SIZE: usize = 40;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for I32ArrayOps {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn i32arrayops_size() -> usize {
    I32ArrayOps::SIZE
}
#[no_mangle]
pub extern "C" fn i32arrayops_alignment() -> usize {
    I32ArrayOps::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct I64ArrayOps {
    pub data: *const i64,
    pub sum: i64,
    pub min: i64,
    pub max: i64,
    pub average: f64,
    pub count: u32,
}
impl I64ArrayOps {
    pub const SIZE: usize = 56;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for I64ArrayOps {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn i64arrayops_size() -> usize {
    I64ArrayOps::SIZE
}
#[no_mangle]
pub extern "C" fn i64arrayops_alignment() -> usize {
    I64ArrayOps::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct U32ArrayOps {
    pub data: *const u32,
    pub count: u32,
    pub sum: u32,
    pub min: u32,
    pub max: u32,
    pub average: f32,
}
impl U32ArrayOps {
    pub const SIZE: usize = 40;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for U32ArrayOps {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn u32arrayops_size() -> usize {
    U32ArrayOps::SIZE
}
#[no_mangle]
pub extern "C" fn u32arrayops_alignment() -> usize {
    U32ArrayOps::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct U64ArrayOps {
    pub data: *const u64,
    pub sum: u64,
    pub min: u64,
    pub max: u64,
    pub average: f64,
    pub count: u32,
}
impl U64ArrayOps {
    pub const SIZE: usize = 56;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for U64ArrayOps {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn u64arrayops_size() -> usize {
    U64ArrayOps::SIZE
}
#[no_mangle]
pub extern "C" fn u64arrayops_alignment() -> usize {
    U64ArrayOps::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct F32ArrayOps {
    pub data: *const f32,
    pub count: u32,
    pub sum: f32,
    pub min: f32,
    pub max: f32,
    pub average: f32,
    pub has_nan: u8,
    pub has_infinity: u8,
}
impl F32ArrayOps {
    pub const SIZE: usize = 40;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for F32ArrayOps {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn f32arrayops_size() -> usize {
    F32ArrayOps::SIZE
}
#[no_mangle]
pub extern "C" fn f32arrayops_alignment() -> usize {
    F32ArrayOps::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct F64ArrayOps {
    pub data: *const f64,
    pub sum: f64,
    pub min: f64,
    pub max: f64,
    pub average: f64,
    pub count: u32,
    pub has_nan: u8,
    pub has_infinity: u8,
}
impl F64ArrayOps {
    pub const SIZE: usize = 56;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for F64ArrayOps {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn f64arrayops_size() -> usize {
    F64ArrayOps::SIZE
}
#[no_mangle]
pub extern "C" fn f64arrayops_alignment() -> usize {
    F64ArrayOps::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct BenchmarkResult {
    pub simd_time_ns: u64,
    pub scalar_time_ns: u64,
    pub speedup_factor: f32,
    pub elements_processed: u32,
    pub operation_name: [u8; 256],
}
impl BenchmarkResult {
    pub const SIZE: usize = 280;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for BenchmarkResult {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn benchmarkresult_size() -> usize {
    BenchmarkResult::SIZE
}
#[no_mangle]
pub extern "C" fn benchmarkresult_alignment() -> usize {
    BenchmarkResult::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct TestConfig {
    pub unaligned_sizes: *const u32,
    pub small_size: u32,
    pub medium_size: u32,
    pub large_size: u32,
    pub huge_size: u32,
    pub unaligned_count: u32,
}
impl TestConfig {
    pub const SIZE: usize = 40;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for TestConfig {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn testconfig_size() -> usize {
    TestConfig::SIZE
}
#[no_mangle]
pub extern "C" fn testconfig_alignment() -> usize {
    TestConfig::ALIGNMENT
}
