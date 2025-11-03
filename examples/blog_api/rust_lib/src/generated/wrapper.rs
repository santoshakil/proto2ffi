#![allow(dead_code)]
use super::ffi::*;
use super::proto::*;
use std::ptr;
# [doc = concat ! ("Creates a new " , stringify ! (User) , " on the heap")]
#[doc = ""]
#[doc = "Returns a pointer to the allocated FFI struct."]
#[doc = "Must be freed with the corresponding free function."]
#[no_mangle]
pub extern "C" fn user_create() -> *mut UserFFI {
    let ffi = unsafe { std::mem::zeroed::<UserFFI>() };
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Frees a " , stringify ! (User) , " allocated on the heap")]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must have been allocated by the create function."]
#[doc = "The pointer must not be used after calling this function."]
#[no_mangle]
pub unsafe extern "C" fn user_free(ptr: *mut UserFFI) {
    if !ptr.is_null() {
        let _ = Box::from_raw(ptr);
    }
}
# [doc = concat ! ("Clones a " , stringify ! (User) , " FFI struct")]
#[doc = ""]
#[doc = "Returns a new heap-allocated copy."]
#[doc = "Must be freed with the corresponding free function."]
#[no_mangle]
pub unsafe extern "C" fn user_clone(ptr: *const UserFFI) -> *mut UserFFI {
    if ptr.is_null() {
        return ptr::null_mut();
    }
    let ffi = *ptr;
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Sends a " , stringify ! (User) , " proto model to FFI")]
#[doc = ""]
#[doc = "Converts the proto model to FFI representation and allocates it on the heap."]
#[doc = "Returns a pointer that can be passed across FFI boundary."]
#[doc = ""]
#[doc = "# Example"]
#[doc = ""]
#[doc = "```"]
# [doc = concat ! ("let user = " , stringify ! (User) , " { /* fields */ };")]
# [doc = concat ! ("let ptr = " , stringify ! (send_user) , "(&user);")]
#[doc = "// Pass ptr to Dart/C"]
# [doc = concat ! ("// Later: unsafe { " , stringify ! (user_free) , "(ptr); }")]
#[doc = "```"]
pub fn send_user(msg: &User) -> *mut UserFFI {
    let ffi = msg.to_ffi();
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Receives a " , stringify ! (User) , " from FFI pointer")]
#[doc = ""]
#[doc = "Converts the FFI representation back to a proto model."]
#[doc = "Does NOT free the pointer - caller must manage memory."]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must be valid and properly aligned."]
#[doc = ""]
#[doc = "# Example"]
#[doc = ""]
#[doc = "```"]
#[doc = "// Received ptr from Dart/C"]
# [doc = concat ! ("let user = unsafe { " , stringify ! (receive_user) , "(ptr) };")]
#[doc = "// Use user as normal proto model"]
#[doc = "```"]
pub unsafe fn receive_user(ptr: *const UserFFI) -> User {
    assert!(!ptr.is_null(), "Null pointer passed to receive function");
    User::from_ffi(&*ptr)
}
# [doc = concat ! ("Receives and consumes a " , stringify ! (User) , " from FFI pointer")]
#[doc = ""]
#[doc = "Converts the FFI representation to proto model and FREES the pointer."]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must have been allocated by send or create function."]
#[doc = "The pointer must not be used after calling this function."]
pub unsafe fn receive_and_free_user(ptr: *mut UserFFI) -> User {
    assert!(!ptr.is_null(), "Null pointer passed to receive_and_free");
    let ffi = Box::from_raw(ptr);
    User::from_ffi(&*ffi)
}
# [doc = concat ! ("Creates a new " , stringify ! (Post) , " on the heap")]
#[doc = ""]
#[doc = "Returns a pointer to the allocated FFI struct."]
#[doc = "Must be freed with the corresponding free function."]
#[no_mangle]
pub extern "C" fn post_create() -> *mut PostFFI {
    let ffi = unsafe { std::mem::zeroed::<PostFFI>() };
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Frees a " , stringify ! (Post) , " allocated on the heap")]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must have been allocated by the create function."]
#[doc = "The pointer must not be used after calling this function."]
#[no_mangle]
pub unsafe extern "C" fn post_free(ptr: *mut PostFFI) {
    if !ptr.is_null() {
        let _ = Box::from_raw(ptr);
    }
}
# [doc = concat ! ("Clones a " , stringify ! (Post) , " FFI struct")]
#[doc = ""]
#[doc = "Returns a new heap-allocated copy."]
#[doc = "Must be freed with the corresponding free function."]
#[no_mangle]
pub unsafe extern "C" fn post_clone(ptr: *const PostFFI) -> *mut PostFFI {
    if ptr.is_null() {
        return ptr::null_mut();
    }
    let ffi = *ptr;
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Sends a " , stringify ! (Post) , " proto model to FFI")]
#[doc = ""]
#[doc = "Converts the proto model to FFI representation and allocates it on the heap."]
#[doc = "Returns a pointer that can be passed across FFI boundary."]
#[doc = ""]
#[doc = "# Example"]
#[doc = ""]
#[doc = "```"]
# [doc = concat ! ("let user = " , stringify ! (Post) , " { /* fields */ };")]
# [doc = concat ! ("let ptr = " , stringify ! (send_post) , "(&user);")]
#[doc = "// Pass ptr to Dart/C"]
# [doc = concat ! ("// Later: unsafe { " , stringify ! (post_free) , "(ptr); }")]
#[doc = "```"]
pub fn send_post(msg: &Post) -> *mut PostFFI {
    let ffi = msg.to_ffi();
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Receives a " , stringify ! (Post) , " from FFI pointer")]
#[doc = ""]
#[doc = "Converts the FFI representation back to a proto model."]
#[doc = "Does NOT free the pointer - caller must manage memory."]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must be valid and properly aligned."]
#[doc = ""]
#[doc = "# Example"]
#[doc = ""]
#[doc = "```"]
#[doc = "// Received ptr from Dart/C"]
# [doc = concat ! ("let user = unsafe { " , stringify ! (receive_post) , "(ptr) };")]
#[doc = "// Use user as normal proto model"]
#[doc = "```"]
pub unsafe fn receive_post(ptr: *const PostFFI) -> Post {
    assert!(!ptr.is_null(), "Null pointer passed to receive function");
    Post::from_ffi(&*ptr)
}
# [doc = concat ! ("Receives and consumes a " , stringify ! (Post) , " from FFI pointer")]
#[doc = ""]
#[doc = "Converts the FFI representation to proto model and FREES the pointer."]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must have been allocated by send or create function."]
#[doc = "The pointer must not be used after calling this function."]
pub unsafe fn receive_and_free_post(ptr: *mut PostFFI) -> Post {
    assert!(!ptr.is_null(), "Null pointer passed to receive_and_free");
    let ffi = Box::from_raw(ptr);
    Post::from_ffi(&*ffi)
}
# [doc = concat ! ("Creates a new " , stringify ! (Response) , " on the heap")]
#[doc = ""]
#[doc = "Returns a pointer to the allocated FFI struct."]
#[doc = "Must be freed with the corresponding free function."]
#[no_mangle]
pub extern "C" fn response_create() -> *mut ResponseFFI {
    let ffi = unsafe { std::mem::zeroed::<ResponseFFI>() };
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Frees a " , stringify ! (Response) , " allocated on the heap")]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must have been allocated by the create function."]
#[doc = "The pointer must not be used after calling this function."]
#[no_mangle]
pub unsafe extern "C" fn response_free(ptr: *mut ResponseFFI) {
    if !ptr.is_null() {
        let _ = Box::from_raw(ptr);
    }
}
# [doc = concat ! ("Clones a " , stringify ! (Response) , " FFI struct")]
#[doc = ""]
#[doc = "Returns a new heap-allocated copy."]
#[doc = "Must be freed with the corresponding free function."]
#[no_mangle]
pub unsafe extern "C" fn response_clone(ptr: *const ResponseFFI) -> *mut ResponseFFI {
    if ptr.is_null() {
        return ptr::null_mut();
    }
    let ffi = *ptr;
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Sends a " , stringify ! (Response) , " proto model to FFI")]
#[doc = ""]
#[doc = "Converts the proto model to FFI representation and allocates it on the heap."]
#[doc = "Returns a pointer that can be passed across FFI boundary."]
#[doc = ""]
#[doc = "# Example"]
#[doc = ""]
#[doc = "```"]
# [doc = concat ! ("let user = " , stringify ! (Response) , " { /* fields */ };")]
# [doc = concat ! ("let ptr = " , stringify ! (send_response) , "(&user);")]
#[doc = "// Pass ptr to Dart/C"]
# [doc = concat ! ("// Later: unsafe { " , stringify ! (response_free) , "(ptr); }")]
#[doc = "```"]
pub fn send_response(msg: &Response) -> *mut ResponseFFI {
    let ffi = msg.to_ffi();
    Box::into_raw(Box::new(ffi))
}
# [doc = concat ! ("Receives a " , stringify ! (Response) , " from FFI pointer")]
#[doc = ""]
#[doc = "Converts the FFI representation back to a proto model."]
#[doc = "Does NOT free the pointer - caller must manage memory."]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must be valid and properly aligned."]
#[doc = ""]
#[doc = "# Example"]
#[doc = ""]
#[doc = "```"]
#[doc = "// Received ptr from Dart/C"]
# [doc = concat ! ("let user = unsafe { " , stringify ! (receive_response) , "(ptr) };")]
#[doc = "// Use user as normal proto model"]
#[doc = "```"]
pub unsafe fn receive_response(ptr: *const ResponseFFI) -> Response {
    assert!(!ptr.is_null(), "Null pointer passed to receive function");
    Response::from_ffi(&*ptr)
}
# [doc = concat ! ("Receives and consumes a " , stringify ! (Response) , " from FFI pointer")]
#[doc = ""]
#[doc = "Converts the FFI representation to proto model and FREES the pointer."]
#[doc = ""]
#[doc = "# Safety"]
#[doc = ""]
#[doc = "The pointer must have been allocated by send or create function."]
#[doc = "The pointer must not be used after calling this function."]
pub unsafe fn receive_and_free_response(ptr: *mut ResponseFFI) -> Response {
    assert!(!ptr.is_null(), "Null pointer passed to receive_and_free");
    let ffi = Box::from_raw(ptr);
    Response::from_ffi(&*ffi)
}
