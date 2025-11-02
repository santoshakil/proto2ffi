#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum TinyEnum {
    TINY_ZERO = 0,
    TINY_ONE = 1,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum LargeEnum {
    VALUE_0 = 0,
    VALUE_1 = 1,
    VALUE_2 = 2,
    VALUE_3 = 3,
    VALUE_4 = 4,
    VALUE_5 = 5,
    VALUE_6 = 6,
    VALUE_7 = 7,
    VALUE_8 = 8,
    VALUE_9 = 9,
    VALUE_10 = 10,
    VALUE_11 = 11,
    VALUE_12 = 12,
    VALUE_13 = 13,
    VALUE_14 = 14,
    VALUE_15 = 15,
    VALUE_16 = 16,
    VALUE_17 = 17,
    VALUE_18 = 18,
    VALUE_19 = 19,
    VALUE_20 = 20,
    VALUE_21 = 21,
    VALUE_22 = 22,
    VALUE_23 = 23,
    VALUE_24 = 24,
    VALUE_25 = 25,
    VALUE_26 = 26,
    VALUE_27 = 27,
    VALUE_28 = 28,
    VALUE_29 = 29,
    VALUE_30 = 30,
    VALUE_31 = 31,
    VALUE_32 = 32,
    VALUE_33 = 33,
    VALUE_34 = 34,
    VALUE_35 = 35,
    VALUE_36 = 36,
    VALUE_37 = 37,
    VALUE_38 = 38,
    VALUE_39 = 39,
    VALUE_40 = 40,
    VALUE_41 = 41,
    VALUE_42 = 42,
    VALUE_43 = 43,
    VALUE_44 = 44,
    VALUE_45 = 45,
    VALUE_46 = 46,
    VALUE_47 = 47,
    VALUE_48 = 48,
    VALUE_49 = 49,
    VALUE_50 = 50,
    VALUE_51 = 51,
    VALUE_52 = 52,
    VALUE_53 = 53,
    VALUE_54 = 54,
    VALUE_55 = 55,
    VALUE_56 = 56,
    VALUE_57 = 57,
    VALUE_58 = 58,
    VALUE_59 = 59,
    VALUE_60 = 60,
    VALUE_61 = 61,
    VALUE_62 = 62,
    VALUE_63 = 63,
    VALUE_64 = 64,
    VALUE_65 = 65,
    VALUE_66 = 66,
    VALUE_67 = 67,
    VALUE_68 = 68,
    VALUE_69 = 69,
    VALUE_70 = 70,
    VALUE_71 = 71,
    VALUE_72 = 72,
    VALUE_73 = 73,
    VALUE_74 = 74,
    VALUE_75 = 75,
    VALUE_76 = 76,
    VALUE_77 = 77,
    VALUE_78 = 78,
    VALUE_79 = 79,
    VALUE_80 = 80,
    VALUE_81 = 81,
    VALUE_82 = 82,
    VALUE_83 = 83,
    VALUE_84 = 84,
    VALUE_85 = 85,
    VALUE_86 = 86,
    VALUE_87 = 87,
    VALUE_88 = 88,
    VALUE_89 = 89,
    VALUE_90 = 90,
    VALUE_91 = 91,
    VALUE_92 = 92,
    VALUE_93 = 93,
    VALUE_94 = 94,
    VALUE_95 = 95,
    VALUE_96 = 96,
    VALUE_97 = 97,
    VALUE_98 = 98,
    VALUE_99 = 99,
    VALUE_100 = 100,
    VALUE_101 = 101,
    VALUE_102 = 102,
    VALUE_103 = 103,
    VALUE_104 = 104,
    VALUE_105 = 105,
    VALUE_106 = 106,
    VALUE_107 = 107,
    VALUE_108 = 108,
    VALUE_109 = 109,
    VALUE_110 = 110,
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level10 {
    pub number: i32,
    pub value: [u8; 256],
}
impl Level10 {
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
impl Default for Level10 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level10_size() -> usize {
    Level10::SIZE
}
#[no_mangle]
pub extern "C" fn level10_alignment() -> usize {
    Level10::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level9 {
    pub nested: Level10,
    pub value: [u8; 256],
}
impl Level9 {
    pub const SIZE: usize = 520;
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
impl Default for Level9 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level9_size() -> usize {
    Level9::SIZE
}
#[no_mangle]
pub extern "C" fn level9_alignment() -> usize {
    Level9::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level8 {
    pub nested: Level9,
    pub value: [u8; 256],
}
impl Level8 {
    pub const SIZE: usize = 776;
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
impl Default for Level8 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level8_size() -> usize {
    Level8::SIZE
}
#[no_mangle]
pub extern "C" fn level8_alignment() -> usize {
    Level8::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level7 {
    pub nested: Level8,
    pub value: [u8; 256],
}
impl Level7 {
    pub const SIZE: usize = 1032;
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
impl Default for Level7 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level7_size() -> usize {
    Level7::SIZE
}
#[no_mangle]
pub extern "C" fn level7_alignment() -> usize {
    Level7::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level6 {
    pub nested: Level7,
    pub value: [u8; 256],
}
impl Level6 {
    pub const SIZE: usize = 1288;
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
impl Default for Level6 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level6_size() -> usize {
    Level6::SIZE
}
#[no_mangle]
pub extern "C" fn level6_alignment() -> usize {
    Level6::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level5 {
    pub nested: Level6,
    pub value: [u8; 256],
}
impl Level5 {
    pub const SIZE: usize = 1544;
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
impl Default for Level5 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level5_size() -> usize {
    Level5::SIZE
}
#[no_mangle]
pub extern "C" fn level5_alignment() -> usize {
    Level5::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level4 {
    pub nested: Level5,
    pub value: [u8; 256],
}
impl Level4 {
    pub const SIZE: usize = 1800;
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
impl Default for Level4 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level4_size() -> usize {
    Level4::SIZE
}
#[no_mangle]
pub extern "C" fn level4_alignment() -> usize {
    Level4::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level3 {
    pub nested: Level4,
    pub value: [u8; 256],
}
impl Level3 {
    pub const SIZE: usize = 2056;
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
impl Default for Level3 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level3_size() -> usize {
    Level3::SIZE
}
#[no_mangle]
pub extern "C" fn level3_alignment() -> usize {
    Level3::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level2 {
    pub nested: Level3,
    pub value: [u8; 256],
}
impl Level2 {
    pub const SIZE: usize = 2312;
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
impl Default for Level2 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level2_size() -> usize {
    Level2::SIZE
}
#[no_mangle]
pub extern "C" fn level2_alignment() -> usize {
    Level2::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Level1 {
    pub nested: Level2,
    pub value: [u8; 256],
}
impl Level1 {
    pub const SIZE: usize = 2568;
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
impl Default for Level1 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn level1_size() -> usize {
    Level1::SIZE
}
#[no_mangle]
pub extern "C" fn level1_alignment() -> usize {
    Level1::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct IntegerLimits {
    pub int64_min: i64,
    pub int64_max: i64,
    pub uint64_min: u64,
    pub uint64_max: u64,
    pub sint64_min: i64,
    pub sint64_max: i64,
    pub fixed64_min: u64,
    pub fixed64_max: u64,
    pub sfixed64_min: i64,
    pub sfixed64_max: i64,
    pub int32_min: i32,
    pub int32_max: i32,
    pub uint32_min: u32,
    pub uint32_max: u32,
    pub sint32_min: i32,
    pub sint32_max: i32,
    pub fixed32_min: u32,
    pub fixed32_max: u32,
    pub sfixed32_min: i32,
    pub sfixed32_max: i32,
}
impl IntegerLimits {
    pub const SIZE: usize = 120;
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
impl Default for IntegerLimits {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn integerlimits_size() -> usize {
    IntegerLimits::SIZE
}
#[no_mangle]
pub extern "C" fn integerlimits_alignment() -> usize {
    IntegerLimits::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct FloatEdgeCases {
    pub d_zero: f64,
    pub d_negative_zero: f64,
    pub d_infinity: f64,
    pub d_negative_infinity: f64,
    pub d_nan: f64,
    pub d_min_positive: f64,
    pub d_max_value: f64,
    pub d_min_value: f64,
    pub zero: f32,
    pub negative_zero: f32,
    pub infinity: f32,
    pub negative_infinity: f32,
    pub nan: f32,
    pub min_positive: f32,
    pub max_value: f32,
    pub min_value: f32,
}
impl FloatEdgeCases {
    pub const SIZE: usize = 96;
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
impl Default for FloatEdgeCases {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn floatedgecases_size() -> usize {
    FloatEdgeCases::SIZE
}
#[no_mangle]
pub extern "C" fn floatedgecases_alignment() -> usize {
    FloatEdgeCases::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct StringSizes {
    pub empty: [u8; 256],
    pub small_255: [u8; 256],
    pub medium_1024: [u8; 256],
    pub large_4096: [u8; 256],
}
impl StringSizes {
    pub const SIZE: usize = 1024;
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
impl Default for StringSizes {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn stringsizes_size() -> usize {
    StringSizes::SIZE
}
#[no_mangle]
pub extern "C" fn stringsizes_alignment() -> usize {
    StringSizes::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct ArraySizes {
    pub empty_array: *const i32,
    pub small_array: *const i32,
    pub medium_array: *const i32,
    pub large_array: *const i32,
}
impl ArraySizes {
    pub const SIZE: usize = 64;
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
impl Default for ArraySizes {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn arraysizes_size() -> usize {
    ArraySizes::SIZE
}
#[no_mangle]
pub extern "C" fn arraysizes_alignment() -> usize {
    ArraySizes::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct BooleanOnly {
    pub flag1: u8,
    pub flag2: u8,
    pub flag3: u8,
    pub flag4: u8,
    pub flag5: u8,
    pub flag6: u8,
    pub flag7: u8,
    pub flag8: u8,
}
impl BooleanOnly {
    pub const SIZE: usize = 8;
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
impl Default for BooleanOnly {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn booleanonly_size() -> usize {
    BooleanOnly::SIZE
}
#[no_mangle]
pub extern "C" fn booleanonly_alignment() -> usize {
    BooleanOnly::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct EnumOnly {
    pub e1: u32,
    pub e2: u32,
    pub e3: u32,
    pub e4: u32,
    pub e5: u32,
    pub le1: u32,
    pub le2: u32,
    pub le3: u32,
}
impl EnumOnly {
    pub const SIZE: usize = 32;
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
impl Default for EnumOnly {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn enumonly_size() -> usize {
    EnumOnly::SIZE
}
#[no_mangle]
pub extern "C" fn enumonly_alignment() -> usize {
    EnumOnly::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct ManyFields {
    pub f1: i32,
    pub f2: i32,
    pub f3: i32,
    pub f4: i32,
    pub f5: i32,
    pub f6: i32,
    pub f7: i32,
    pub f8: i32,
    pub f9: i32,
    pub f10: i32,
    pub f11: i32,
    pub f12: i32,
    pub f13: i32,
    pub f14: i32,
    pub f15: i32,
    pub f16: i32,
    pub f17: i32,
    pub f18: i32,
    pub f19: i32,
    pub f20: i32,
    pub f21: i32,
    pub f22: i32,
    pub f23: i32,
    pub f24: i32,
    pub f25: i32,
    pub f26: i32,
    pub f27: i32,
    pub f28: i32,
    pub f29: i32,
    pub f30: i32,
    pub f31: i32,
    pub f32: i32,
    pub f33: i32,
    pub f34: i32,
    pub f35: i32,
    pub f36: i32,
    pub f37: i32,
    pub f38: i32,
    pub f39: i32,
    pub f40: i32,
    pub f41: i32,
    pub f42: i32,
    pub f43: i32,
    pub f44: i32,
    pub f45: i32,
    pub f46: i32,
    pub f47: i32,
    pub f48: i32,
    pub f49: i32,
    pub f50: i32,
    pub f51: i32,
    pub f52: i32,
    pub f53: i32,
    pub f54: i32,
    pub f55: i32,
}
impl ManyFields {
    pub const SIZE: usize = 224;
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
impl Default for ManyFields {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn manyfields_size() -> usize {
    ManyFields::SIZE
}
#[no_mangle]
pub extern "C" fn manyfields_alignment() -> usize {
    ManyFields::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct AllTypes {
    pub int64_field: i64,
    pub uint64_field: u64,
    pub sint64_field: i64,
    pub fixed64_field: u64,
    pub sfixed64_field: i64,
    pub double_field: f64,
    pub nested_field: Level10,
    pub repeated_int: *const i32,
    pub repeated_string: *const [u8; 256],
    pub repeated_nested: *const Level10,
    pub int32_field: i32,
    pub uint32_field: u32,
    pub sint32_field: i32,
    pub fixed32_field: u32,
    pub sfixed32_field: i32,
    pub float_field: f32,
    pub enum_field: u32,
    pub bool_field: u8,
    pub string_field: [u8; 256],
}
impl AllTypes {
    pub const SIZE: usize = 648;
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
impl Default for AllTypes {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn alltypes_size() -> usize {
    AllTypes::SIZE
}
#[no_mangle]
pub extern "C" fn alltypes_alignment() -> usize {
    AllTypes::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct EmptyMessage {}
impl EmptyMessage {
    pub const SIZE: usize = 0;
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
impl Default for EmptyMessage {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn emptymessage_size() -> usize {
    EmptyMessage::SIZE
}
#[no_mangle]
pub extern "C" fn emptymessage_alignment() -> usize {
    EmptyMessage::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct SingleField {
    pub value: [u8; 256],
}
impl SingleField {
    pub const SIZE: usize = 256;
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
impl Default for SingleField {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn singlefield_size() -> usize {
    SingleField::SIZE
}
#[no_mangle]
pub extern "C" fn singlefield_alignment() -> usize {
    SingleField::ALIGNMENT
}
