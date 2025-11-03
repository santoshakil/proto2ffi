use std::slice;

/// Converts a null-terminated C string to a Rust string slice
///
/// # Safety
///
/// The pointer must be valid and point to a null-terminated UTF-8 string.
/// The string must remain valid for the lifetime 'a.
#[inline]
pub unsafe fn str_from_c_buf<'a>(ptr: *const u8, max_len: usize) -> &'a str {
    if ptr.is_null() {
        return "";
    }

    let buf = slice::from_raw_parts(ptr, max_len);
    let len = buf.iter().position(|&b| b == 0).unwrap_or(max_len);

    std::str::from_utf8_unchecked(&buf[..len])
}

/// Copies a Rust string into a C buffer, adding null terminator
///
/// Returns the number of bytes written (including null terminator).
/// Truncates at UTF-8 character boundaries if necessary.
#[inline]
pub fn str_to_c_buf(s: &str, buf: &mut [u8]) -> usize {
    if buf.is_empty() {
        return 0;
    }

    let max_bytes = buf.len() - 1;
    let bytes = s.as_bytes();

    let copy_len = if bytes.len() <= max_bytes {
        bytes.len()
    } else {
        let mut len = max_bytes;
        while len > 0 && (bytes[len] & 0xC0) == 0x80 {
            len -= 1;
        }

        if len > 0 && (bytes[len] & 0x80) != 0 {
            let first_byte = bytes[len];
            let char_len = if (first_byte & 0xE0) == 0xC0 {
                2
            } else if (first_byte & 0xF0) == 0xE0 {
                3
            } else if (first_byte & 0xF8) == 0xF0 {
                4
            } else {
                1
            };

            if len + char_len > max_bytes {
                len -= 1;
                while len > 0 && (bytes[len] & 0xC0) == 0x80 {
                    len -= 1;
                }
            }
        }
        len
    };

    buf[..copy_len].copy_from_slice(&bytes[..copy_len]);
    buf[copy_len] = 0;

    copy_len + 1
}

/// Calculates the next aligned offset
#[inline]
pub const fn align_up(offset: usize, alignment: usize) -> usize {
    (offset + alignment - 1) & !(alignment - 1)
}

/// Calculates the previous aligned offset
#[inline]
pub const fn align_down(offset: usize, alignment: usize) -> usize {
    offset & !(alignment - 1)
}

/// Checks if an offset is aligned to the given alignment
#[inline]
pub const fn is_aligned(offset: usize, alignment: usize) -> bool {
    offset & (alignment - 1) == 0
}

/// Calculates padding needed to reach next aligned offset
#[inline]
pub const fn padding_needed(offset: usize, alignment: usize) -> usize {
    align_up(offset, alignment) - offset
}

/// Zero-copy conversion from bytes to struct
///
/// # Safety
///
/// The pointer must be properly aligned and point to valid memory
/// of at least size_of::<T>() bytes.
#[inline]
pub unsafe fn cast_from_bytes<T>(bytes: &[u8]) -> &T {
    assert!(bytes.len() >= std::mem::size_of::<T>());
    assert!(bytes.as_ptr() as usize % std::mem::align_of::<T>() == 0);
    &*(bytes.as_ptr() as *const T)
}

/// Zero-copy mutable conversion from bytes to struct
///
/// # Safety
///
/// The pointer must be properly aligned and point to valid memory
/// of at least size_of::<T>() bytes.
#[inline]
pub unsafe fn cast_from_bytes_mut<T>(bytes: &mut [u8]) -> &mut T {
    assert!(bytes.len() >= std::mem::size_of::<T>());
    assert!(bytes.as_ptr() as usize % std::mem::align_of::<T>() == 0);
    &mut *(bytes.as_mut_ptr() as *mut T)
}

/// Checks if a pointer is aligned for type T
#[inline]
pub fn is_ptr_aligned<T>(ptr: *const u8) -> bool {
    ptr as usize % std::mem::align_of::<T>() == 0
}

/// Converts snake_case to CamelCase
pub fn snake_to_camel(s: &str) -> String {
    s.split('_')
        .filter(|part| !part.is_empty())
        .map(|part| {
            let mut chars = part.chars();
            match chars.next() {
                None => String::new(),
                Some(first) => {
                    first.to_uppercase().collect::<String>() + &chars.as_str().to_lowercase()
                }
            }
        })
        .collect()
}

/// Converts CamelCase to snake_case
pub fn camel_to_snake(s: &str) -> String {
    let mut result = String::with_capacity(s.len() + s.len() / 2);
    let mut prev_lowercase = false;

    for (i, ch) in s.chars().enumerate() {
        if ch.is_uppercase() {
            if i > 0 && prev_lowercase {
                result.push('_');
            }
            result.push(ch.to_lowercase().next().unwrap());
            prev_lowercase = false;
        } else {
            result.push(ch);
            prev_lowercase = true;
        }
    }

    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_str_to_c_buf() {
        let mut buf = [0u8; 20];
        let written = str_to_c_buf("hello", &mut buf);
        assert_eq!(written, 6);
        assert_eq!(unsafe { str_from_c_buf(buf.as_ptr(), 20) }, "hello");
    }

    #[test]
    fn test_str_to_c_buf_truncation() {
        let mut buf = [0u8; 6];
        let written = str_to_c_buf("hello world", &mut buf);
        assert!(written <= 6);
        assert_eq!(unsafe { str_from_c_buf(buf.as_ptr(), 6) }, "hello");
    }

    #[test]
    fn test_align_up() {
        assert_eq!(align_up(0, 4), 0);
        assert_eq!(align_up(1, 4), 4);
        assert_eq!(align_up(4, 4), 4);
        assert_eq!(align_up(5, 4), 8);
        assert_eq!(align_up(7, 8), 8);
        assert_eq!(align_up(9, 8), 16);
    }

    #[test]
    fn test_align_down() {
        assert_eq!(align_down(0, 4), 0);
        assert_eq!(align_down(1, 4), 0);
        assert_eq!(align_down(4, 4), 4);
        assert_eq!(align_down(5, 4), 4);
        assert_eq!(align_down(7, 8), 0);
        assert_eq!(align_down(9, 8), 8);
    }

    #[test]
    fn test_is_aligned() {
        assert!(is_aligned(0, 4));
        assert!(!is_aligned(1, 4));
        assert!(is_aligned(4, 4));
        assert!(!is_aligned(5, 4));
        assert!(is_aligned(8, 8));
        assert!(!is_aligned(9, 8));
    }

    #[test]
    fn test_snake_to_camel() {
        assert_eq!(snake_to_camel("hello_world"), "HelloWorld");
        assert_eq!(snake_to_camel("foo_bar_baz"), "FooBarBaz");
        assert_eq!(snake_to_camel("single"), "Single");
        assert_eq!(snake_to_camel(""), "");
    }

    #[test]
    fn test_camel_to_snake() {
        assert_eq!(camel_to_snake("HelloWorld"), "hello_world");
        assert_eq!(camel_to_snake("FooBarBaz"), "foo_bar_baz");
        assert_eq!(camel_to_snake("Single"), "single");
        assert_eq!(camel_to_snake(""), "");
    }
}
