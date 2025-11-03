#![allow(dead_code)]
use super::ffi::*;
use super::proto::*;
impl User {
    #[doc = r" Convert to FFI representation (zero-copy where possible)"]
    pub fn to_ffi(&self) -> UserFFI {
        let mut ffi = UserFFI::default();
        ffi.user_id = self.user_id;
        ffi.date_of_birth = self.date_of_birth;
        ffi.created_at = self.created_at;
        ffi.updated_at = self.updated_at;
        ffi.account_balance = self.account_balance;
        ffi.reputation_score = self.reputation_score;
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
        {
            let bytes = self.first_name.as_bytes();
            let copy_len = bytes.len().min(ffi.first_name.len());
            ffi.first_name[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.first_name_len = copy_len as u32;
        }
        {
            let bytes = self.last_name.as_bytes();
            let copy_len = bytes.len().min(ffi.last_name.len());
            ffi.last_name[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.last_name_len = copy_len as u32;
        }
        {
            let bytes = self.display_name.as_bytes();
            let copy_len = bytes.len().min(ffi.display_name.len());
            ffi.display_name[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.display_name_len = copy_len as u32;
        }
        {
            let bytes = self.bio.as_bytes();
            let copy_len = bytes.len().min(ffi.bio.len());
            ffi.bio[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.bio_len = copy_len as u32;
        }
        {
            let bytes = self.avatar_url.as_bytes();
            let copy_len = bytes.len().min(ffi.avatar_url.len());
            ffi.avatar_url[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.avatar_url_len = copy_len as u32;
        }
        ffi.is_verified = self.is_verified;
        ffi.is_premium = self.is_premium;
        ffi
    }
    #[doc = r" Convert from FFI representation"]
    pub fn from_ffi(ffi: &UserFFI) -> Self {
        Self {
            user_id: ffi.user_id,
            date_of_birth: ffi.date_of_birth,
            created_at: ffi.created_at,
            updated_at: ffi.updated_at,
            account_balance: ffi.account_balance,
            reputation_score: ffi.reputation_score,
            username: {
                let len = ffi.username_len as usize;
                String::from_utf8_lossy(&ffi.username[..len]).into_owned()
            },
            email: {
                let len = ffi.email_len as usize;
                String::from_utf8_lossy(&ffi.email[..len]).into_owned()
            },
            first_name: {
                let len = ffi.first_name_len as usize;
                String::from_utf8_lossy(&ffi.first_name[..len]).into_owned()
            },
            last_name: {
                let len = ffi.last_name_len as usize;
                String::from_utf8_lossy(&ffi.last_name[..len]).into_owned()
            },
            display_name: {
                let len = ffi.display_name_len as usize;
                String::from_utf8_lossy(&ffi.display_name[..len]).into_owned()
            },
            bio: {
                let len = ffi.bio_len as usize;
                String::from_utf8_lossy(&ffi.bio[..len]).into_owned()
            },
            avatar_url: {
                let len = ffi.avatar_url_len as usize;
                String::from_utf8_lossy(&ffi.avatar_url[..len]).into_owned()
            },
            is_verified: ffi.is_verified,
            is_premium: ffi.is_premium,
        }
    }
}
impl Post {
    #[doc = r" Convert to FFI representation (zero-copy where possible)"]
    pub fn to_ffi(&self) -> PostFFI {
        let mut ffi = PostFFI::default();
        ffi.post_id = self.post_id;
        ffi.user_id = self.user_id;
        ffi.created_at = self.created_at;
        ffi.updated_at = self.updated_at;
        ffi.view_count = self.view_count;
        ffi.like_count = self.like_count;
        ffi.comment_count = self.comment_count;
        {
            let bytes = self.username.as_bytes();
            let copy_len = bytes.len().min(ffi.username.len());
            ffi.username[..copy_len].copy_from_slice(&bytes[..copy_len]);
            ffi.username_len = copy_len as u32;
        }
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
        ffi.is_edited = self.is_edited;
        ffi.is_pinned = self.is_pinned;
        ffi
    }
    #[doc = r" Convert from FFI representation"]
    pub fn from_ffi(ffi: &PostFFI) -> Self {
        Self {
            post_id: ffi.post_id,
            user_id: ffi.user_id,
            created_at: ffi.created_at,
            updated_at: ffi.updated_at,
            view_count: ffi.view_count,
            like_count: ffi.like_count,
            comment_count: ffi.comment_count,
            username: {
                let len = ffi.username_len as usize;
                String::from_utf8_lossy(&ffi.username[..len]).into_owned()
            },
            title: {
                let len = ffi.title_len as usize;
                String::from_utf8_lossy(&ffi.title[..len]).into_owned()
            },
            content: {
                let len = ffi.content_len as usize;
                String::from_utf8_lossy(&ffi.content[..len]).into_owned()
            },
            is_edited: ffi.is_edited,
            is_pinned: ffi.is_pinned,
        }
    }
}
