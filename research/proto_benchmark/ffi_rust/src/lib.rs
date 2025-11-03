mod generated;
use generated::ffi::*;
use generated::*;

use prost::Message;

mod proto {
    include!(concat!(env!("OUT_DIR"), "/benchmark.rs"));
}

#[repr(C)]
pub struct ByteBuffer {
    ptr: *mut u8,
    len: usize,
    cap: usize,
}

// FFI echo functions - they receive data and return it back
// This measures pure FFI overhead without any business logic

#[no_mangle]
pub unsafe extern "C" fn echo_user(user_ptr: *const UserFFI) -> *mut UserFFI {
    if user_ptr.is_null() {
        return std::ptr::null_mut();
    }

    let user_ffi = &*user_ptr;
    let user = User::from_ffi(user_ffi);
    let result_ffi = user.to_ffi();
    Box::into_raw(Box::new(result_ffi))
}

#[no_mangle]
pub unsafe extern "C" fn echo_post(post_ptr: *const PostFFI) -> *mut PostFFI {
    if post_ptr.is_null() {
        return std::ptr::null_mut();
    }

    let post_ffi = &*post_ptr;
    let post = Post::from_ffi(post_ffi);
    let result_ffi = post.to_ffi();
    Box::into_raw(Box::new(result_ffi))
}

#[no_mangle]
pub unsafe extern "C" fn echo_user_proto(data_ptr: *const u8, data_len: usize) -> ByteBuffer {
    if data_ptr.is_null() || data_len == 0 {
        return ByteBuffer {
            ptr: std::ptr::null_mut(),
            len: 0,
            cap: 0,
        };
    }

    let bytes = std::slice::from_raw_parts(data_ptr, data_len);

    let user = match proto::User::decode(bytes) {
        Ok(u) => u,
        Err(_) => {
            return ByteBuffer {
                ptr: std::ptr::null_mut(),
                len: 0,
                cap: 0,
            };
        }
    };

    let mut result_bytes = Vec::new();
    if user.encode(&mut result_bytes).is_err() {
        return ByteBuffer {
            ptr: std::ptr::null_mut(),
            len: 0,
            cap: 0,
        };
    }

    let ptr = result_bytes.as_mut_ptr();
    let len = result_bytes.len();
    let cap = result_bytes.capacity();
    std::mem::forget(result_bytes);

    ByteBuffer { ptr, len, cap }
}

#[no_mangle]
pub unsafe extern "C" fn echo_post_proto(data_ptr: *const u8, data_len: usize) -> ByteBuffer {
    if data_ptr.is_null() || data_len == 0 {
        return ByteBuffer {
            ptr: std::ptr::null_mut(),
            len: 0,
            cap: 0,
        };
    }

    let bytes = std::slice::from_raw_parts(data_ptr, data_len);

    let post = match proto::Post::decode(bytes) {
        Ok(p) => p,
        Err(_) => {
            return ByteBuffer {
                ptr: std::ptr::null_mut(),
                len: 0,
                cap: 0,
            };
        }
    };

    let mut result_bytes = Vec::new();
    if post.encode(&mut result_bytes).is_err() {
        return ByteBuffer {
            ptr: std::ptr::null_mut(),
            len: 0,
            cap: 0,
        };
    }

    let ptr = result_bytes.as_mut_ptr();
    let len = result_bytes.len();
    let cap = result_bytes.capacity();
    std::mem::forget(result_bytes);

    ByteBuffer { ptr, len, cap }
}

#[no_mangle]
pub unsafe extern "C" fn free_byte_buffer(buf: ByteBuffer) {
    if !buf.ptr.is_null() && buf.cap > 0 {
        let _ = Vec::from_raw_parts(buf.ptr, buf.len, buf.cap);
    }
}
