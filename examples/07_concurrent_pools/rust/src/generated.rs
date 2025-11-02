#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct SmallMessage {
    pub id: i32,
    pub name: [u8; 256],
}
impl SmallMessage {
    pub const SIZE: usize = 264;
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
impl Default for SmallMessage {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn smallmessage_size() -> usize {
    SmallMessage::SIZE
}
#[no_mangle]
pub extern "C" fn smallmessage_alignment() -> usize {
    SmallMessage::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct MediumMessage {
    pub tags: *const i32,
    pub id: i32,
    pub title: [u8; 256],
    pub description: [u8; 256],
}
impl MediumMessage {
    pub const SIZE: usize = 536;
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
impl Default for MediumMessage {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn mediummessage_size() -> usize {
    MediumMessage::SIZE
}
#[no_mangle]
pub extern "C" fn mediummessage_alignment() -> usize {
    MediumMessage::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct LargeMessage {
    pub children: *const SmallMessage,
    pub keywords: *const [u8; 256],
    pub timestamps: *const i64,
    pub id: i32,
    pub title: [u8; 256],
    pub description: [u8; 256],
    pub payload: [u8; 1024],
}
impl LargeMessage {
    pub const SIZE: usize = 1592;
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
impl Default for LargeMessage {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn largemessage_size() -> usize {
    LargeMessage::SIZE
}
#[no_mangle]
pub extern "C" fn largemessage_alignment() -> usize {
    LargeMessage::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct StressTestMessage {
    pub thread_id: i64,
    pub sequence: i64,
    pub timestamp: i64,
    pub data: [u8; 1024],
}
impl StressTestMessage {
    pub const SIZE: usize = 1048;
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
impl Default for StressTestMessage {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn stresstestmessage_size() -> usize {
    StressTestMessage::SIZE
}
#[no_mangle]
pub extern "C" fn stresstestmessage_alignment() -> usize {
    StressTestMessage::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct PoolStatsMessage {
    pub total_allocated: u64,
    pub total_freed: u64,
    pub active_count: u64,
    pub pool_size: u64,
    pub growth_count: u64,
}
impl PoolStatsMessage {
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
impl Default for PoolStatsMessage {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn poolstatsmessage_size() -> usize {
    PoolStatsMessage::SIZE
}
#[no_mangle]
pub extern "C" fn poolstatsmessage_alignment() -> usize {
    PoolStatsMessage::ALIGNMENT
}
