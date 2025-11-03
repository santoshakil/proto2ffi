#[repr(C)]
pub struct ByteBuffer {
    pub ptr: *mut u8,
    pub len: usize,
    pub cap: usize,
}

impl ByteBuffer {
    pub fn from_vec(vec: Vec<u8>) -> Self {
        let mut vec = std::mem::ManuallyDrop::new(vec);
        Self {
            ptr: vec.as_mut_ptr(),
            len: vec.len(),
            cap: vec.capacity(),
        }
    }

    pub unsafe fn as_slice(&self) -> &[u8] {
        if self.ptr.is_null() || self.len == 0 {
            &[]
        } else {
            std::slice::from_raw_parts(self.ptr, self.len)
        }
    }

    pub unsafe fn into_vec(self) -> Vec<u8> {
        if self.ptr.is_null() || self.cap == 0 {
            Vec::new()
        } else {
            Vec::from_raw_parts(self.ptr, self.len, self.cap)
        }
    }

    pub fn null() -> Self {
        Self {
            ptr: std::ptr::null_mut(),
            len: 0,
            cap: 0,
        }
    }
}

impl Default for ByteBuffer {
    fn default() -> Self {
        Self::null()
    }
}

#[no_mangle]
pub unsafe extern "C" fn proto2ffi_free_byte_buffer(buffer: ByteBuffer) {
    if !buffer.ptr.is_null() && buffer.cap > 0 {
        let _ = Vec::from_raw_parts(buffer.ptr, buffer.len, buffer.cap);
    }
}
