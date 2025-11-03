#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
# [doc = concat ! ("Proto message: " , "User")]
#[doc = ""]
# [doc = concat ! ("Size: " , 1200 , " bytes")]
# [doc = concat ! ("Alignment: " , 8 , " bytes")]
# [doc = concat ! ("Fields: " , 15usize)]
#[doc = ""]
#[doc = "Zero-copy FFI compatible struct with C representation."]
#[doc = "Use `from_ptr` and `from_ptr_mut` for safe pointer conversion."]
#[doc = ""]
#[doc = "Internal FFI type - users interact with proto models instead."]
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct UserFFI {
    pub user_id: u64,
    pub date_of_birth: u64,
    pub created_at: u64,
    pub updated_at: u64,
    pub account_balance: f64,
    pub reputation_score: u32,
    pub username: [u8; 64],
    pub username_len: u32,
    pub email: [u8; 128],
    pub email_len: u32,
    pub first_name: [u8; 64],
    pub first_name_len: u32,
    pub last_name: [u8; 64],
    pub last_name_len: u32,
    pub display_name: [u8; 64],
    pub display_name_len: u32,
    pub bio: [u8; 512],
    pub bio_len: u32,
    pub avatar_url: [u8; 256],
    pub avatar_url_len: u32,
    pub is_verified: u8,
    pub is_premium: u8,
}
impl UserFFI {
    #[doc = "Compile-time constant for struct size in bytes"]
    pub const SIZE: usize = 1200;
    #[doc = "Compile-time constant for struct alignment in bytes"]
    pub const ALIGNMENT: usize = 8;
    #[doc = "Converts a raw pointer to a reference to this message type"]
    #[doc = ""]
    #[doc = "# Safety"]
    #[doc = ""]
    #[doc = "The pointer must be non-null, properly aligned, and point to valid memory"]
    #[doc = "containing a valid instance of this message type. The lifetime is 'static,"]
    #[doc = "so the caller must ensure the memory remains valid for the program lifetime"]
    #[doc = "or manually limit the reference lifetime."]
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr: {:p} (alignment: {})",
            ptr,
            Self::ALIGNMENT
        );
        &*(ptr as *const Self)
    }
    #[doc = "Converts a raw pointer to a mutable reference to this message type"]
    #[doc = ""]
    #[doc = "# Safety"]
    #[doc = ""]
    #[doc = "The pointer must be non-null, properly aligned, and point to valid memory"]
    #[doc = "containing a valid instance of this message type. The lifetime is 'static,"]
    #[doc = "so the caller must ensure the memory remains valid for the program lifetime"]
    #[doc = "or manually limit the reference lifetime. No other references to this memory"]
    #[doc = "must exist."]
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut: {:p} (alignment: {})",
            ptr,
            Self::ALIGNMENT
        );
        &mut *(ptr as *mut Self)
    }
}
#[doc = "Default implementation returns a zeroed instance"]
#[doc = ""]
#[doc = "All numeric fields will be 0, all boolean fields false."]
impl Default for UserFFI {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
# [doc = concat ! ("Returns the size in bytes of " , "User")]
#[doc = ""]
#[doc = "FFI-safe function for determining struct size at runtime."]
#[doc = "Use for allocating memory buffers for this message type."]
#[no_mangle]
pub extern "C" fn user_size() -> usize {
    UserFFI::SIZE
}
# [doc = concat ! ("Returns the alignment requirement of " , "User")]
#[doc = ""]
#[doc = "FFI-safe function for determining struct alignment at runtime."]
#[doc = "Use for properly aligning memory buffers for this message type."]
#[no_mangle]
pub extern "C" fn user_alignment() -> usize {
    UserFFI::ALIGNMENT
}
# [doc = concat ! ("Proto message: " , "Post")]
#[doc = ""]
# [doc = concat ! ("Size: " , 4480 , " bytes")]
# [doc = concat ! ("Alignment: " , 8 , " bytes")]
# [doc = concat ! ("Fields: " , 9usize)]
#[doc = ""]
#[doc = "Zero-copy FFI compatible struct with C representation."]
#[doc = "Use `from_ptr` and `from_ptr_mut` for safe pointer conversion."]
#[doc = ""]
#[doc = "Internal FFI type - users interact with proto models instead."]
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct PostFFI {
    pub post_id: u64,
    pub user_id: u64,
    pub created_at: u64,
    pub updated_at: u64,
    pub view_count: u64,
    pub like_count: u64,
    pub comment_count: u64,
    pub username: [u8; 64],
    pub username_len: u32,
    pub title: [u8; 256],
    pub title_len: u32,
    pub content: [u8; 4096],
    pub content_len: u32,
    pub is_edited: u8,
    pub is_pinned: u8,
}
impl PostFFI {
    #[doc = "Compile-time constant for struct size in bytes"]
    pub const SIZE: usize = 4480;
    #[doc = "Compile-time constant for struct alignment in bytes"]
    pub const ALIGNMENT: usize = 8;
    #[doc = "Converts a raw pointer to a reference to this message type"]
    #[doc = ""]
    #[doc = "# Safety"]
    #[doc = ""]
    #[doc = "The pointer must be non-null, properly aligned, and point to valid memory"]
    #[doc = "containing a valid instance of this message type. The lifetime is 'static,"]
    #[doc = "so the caller must ensure the memory remains valid for the program lifetime"]
    #[doc = "or manually limit the reference lifetime."]
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr: {:p} (alignment: {})",
            ptr,
            Self::ALIGNMENT
        );
        &*(ptr as *const Self)
    }
    #[doc = "Converts a raw pointer to a mutable reference to this message type"]
    #[doc = ""]
    #[doc = "# Safety"]
    #[doc = ""]
    #[doc = "The pointer must be non-null, properly aligned, and point to valid memory"]
    #[doc = "containing a valid instance of this message type. The lifetime is 'static,"]
    #[doc = "so the caller must ensure the memory remains valid for the program lifetime"]
    #[doc = "or manually limit the reference lifetime. No other references to this memory"]
    #[doc = "must exist."]
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut: {:p} (alignment: {})",
            ptr,
            Self::ALIGNMENT
        );
        &mut *(ptr as *mut Self)
    }
}
#[doc = "Default implementation returns a zeroed instance"]
#[doc = ""]
#[doc = "All numeric fields will be 0, all boolean fields false."]
impl Default for PostFFI {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
# [doc = concat ! ("Returns the size in bytes of " , "Post")]
#[doc = ""]
#[doc = "FFI-safe function for determining struct size at runtime."]
#[doc = "Use for allocating memory buffers for this message type."]
#[no_mangle]
pub extern "C" fn post_size() -> usize {
    PostFFI::SIZE
}
# [doc = concat ! ("Returns the alignment requirement of " , "Post")]
#[doc = ""]
#[doc = "FFI-safe function for determining struct alignment at runtime."]
#[doc = "Use for properly aligning memory buffers for this message type."]
#[no_mangle]
pub extern "C" fn post_alignment() -> usize {
    PostFFI::ALIGNMENT
}
