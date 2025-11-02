#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}
impl Point {
    pub const SIZE: usize = 16;
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
impl Default for Point {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn point_size() -> usize {
    Point::SIZE
}
#[no_mangle]
pub extern "C" fn point_alignment() -> usize {
    Point::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Counter {
    pub value: i64,
    pub timestamp: i64,
}
impl Counter {
    pub const SIZE: usize = 16;
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
impl Default for Counter {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn counter_size() -> usize {
    Counter::SIZE
}
#[no_mangle]
pub extern "C" fn counter_alignment() -> usize {
    Counter::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Stats {
    pub count: i64,
    pub sum: f64,
    pub min: f64,
    pub max: f64,
    pub avg: f64,
}
impl Stats {
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
impl Default for Stats {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn stats_size() -> usize {
    Stats::SIZE
}
#[no_mangle]
pub extern "C" fn stats_alignment() -> usize {
    Stats::ALIGNMENT
}
