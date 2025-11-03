#![allow(dead_code)]
use super::ffi::*;
use super::proto::*;
impl User {
    #[doc = r" Convert to FFI representation (zero-copy where possible)"]
    pub fn to_ffi(&self) -> UserFFI {
        let mut ffi = UserFFI::default();
        ffi.created_at = self.created_at;
        ffi.id = self.id;
        {
            let bytes = self.username.as_bytes();
            let copy_len = bytes.len().min(ffi.username.len());
            ffi.username[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.username_len = copy_len as u32;
        }
        {
            let bytes = self.email.as_bytes();
            let copy_len = bytes.len().min(ffi.email.len());
            ffi.email[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.email_len = copy_len as u32;
        }
        ffi
    }
    #[doc = r" Convert from FFI representation"]
    pub fn from_ffi(ffi: &UserFFI) -> Self {
        Self {
            created_at: ffi.created_at,
            id: ffi.id,
            username: {
                let len = ffi.username_len as usize;
                String::from_utf8_lossy(&ffi.username[..len]).into_owned()
            },
            email: {
                let len = ffi.email_len as usize;
                String::from_utf8_lossy(&ffi.email[..len]).into_owned()
            },
        }
    }
}
impl Post {
    #[doc = r" Convert to FFI representation (zero-copy where possible)"]
    pub fn to_ffi(&self) -> PostFFI {
        let mut ffi = PostFFI::default();
        ffi.created_at = self.created_at;
        ffi.id = self.id;
        ffi.author_id = self.author_id;
        ffi.likes = self.likes;
        {
            let bytes = self.title.as_bytes();
            let copy_len = bytes.len().min(ffi.title.len());
            ffi.title[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.title_len = copy_len as u32;
        }
        {
            let bytes = self.content.as_bytes();
            let copy_len = bytes.len().min(ffi.content.len());
            ffi.content[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.content_len = copy_len as u32;
        }
        ffi
    }
    #[doc = r" Convert from FFI representation"]
    pub fn from_ffi(ffi: &PostFFI) -> Self {
        Self {
            created_at: ffi.created_at,
            id: ffi.id,
            author_id: ffi.author_id,
            likes: ffi.likes,
            title: {
                let len = ffi.title_len as usize;
                String::from_utf8_lossy(&ffi.title[..len]).into_owned()
            },
            content: {
                let len = ffi.content_len as usize;
                String::from_utf8_lossy(&ffi.content[..len]).into_owned()
            },
        }
    }
}
impl Response {
    #[doc = r" Convert to FFI representation (zero-copy where possible)"]
    pub fn to_ffi(&self) -> ResponseFFI {
        let mut ffi = ResponseFFI::default();
        ffi.affected_id = self.affected_id;
        ffi.success = self.success;
        {
            let bytes = self.message.as_bytes();
            let copy_len = bytes.len().min(ffi.message.len());
            ffi.message[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.message_len = copy_len as u32;
        }
        ffi
    }
    #[doc = r" Convert from FFI representation"]
    pub fn from_ffi(ffi: &ResponseFFI) -> Self {
        Self {
            affected_id: ffi.affected_id,
            success: ffi.success,
            message: {
                let len = ffi.message_len as usize;
                String::from_utf8_lossy(&ffi.message[..len]).into_owned()
            },
        }
    }
}
