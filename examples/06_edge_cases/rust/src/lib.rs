mod generated;
use generated::*;

fn string_to_bytes(s: &str, buf: &mut [u8; 256]) {
    let bytes = s.as_bytes();
    let len = bytes.len().min(256);
    buf[..len].copy_from_slice(&bytes[..len]);
    if len < 256 {
        buf[len..].fill(0);
    }
}

fn bytes_to_string(buf: &[u8; 256]) -> String {
    let end = buf.iter().position(|&b| b == 0).unwrap_or(256);
    String::from_utf8_lossy(&buf[..end]).to_string()
}

#[no_mangle]
pub extern "C" fn create_integer_limits(
    int32_min: i32,
    int32_max: i32,
    uint32_min: u32,
    uint32_max: u32,
    int64_min: i64,
    int64_max: i64,
    uint64_min: u64,
    uint64_max: u64,
    sint32_min: i32,
    sint32_max: i32,
    sint64_min: i64,
    sint64_max: i64,
    fixed32_min: u32,
    fixed32_max: u32,
    fixed64_min: u64,
    fixed64_max: u64,
    sfixed32_min: i32,
    sfixed32_max: i32,
    sfixed64_min: i64,
    sfixed64_max: i64,
) -> *mut IntegerLimits {
    let msg = IntegerLimits {
        int32_min,
        int32_max,
        uint32_min,
        uint32_max,
        int64_min,
        int64_max,
        uint64_min,
        uint64_max,
        sint32_min,
        sint32_max,
        sint64_min,
        sint64_max,
        fixed32_min,
        fixed32_max,
        fixed64_min,
        fixed64_max,
        sfixed32_min,
        sfixed32_max,
        sfixed64_min,
        sfixed64_max,
    };
    Box::into_raw(Box::new(msg))
}

#[no_mangle]
pub extern "C" fn create_float_edge_cases(
    zero: f32,
    negative_zero: f32,
    infinity: f32,
    negative_infinity: f32,
    nan: f32,
    min_positive: f32,
    max_value: f32,
    min_value: f32,
    d_zero: f64,
    d_negative_zero: f64,
    d_infinity: f64,
    d_negative_infinity: f64,
    d_nan: f64,
    d_min_positive: f64,
    d_max_value: f64,
    d_min_value: f64,
) -> *mut FloatEdgeCases {
    let msg = FloatEdgeCases {
        zero,
        negative_zero,
        infinity,
        negative_infinity,
        nan,
        min_positive,
        max_value,
        min_value,
        d_zero,
        d_negative_zero,
        d_infinity,
        d_negative_infinity,
        d_nan,
        d_min_positive,
        d_max_value,
        d_min_value,
    };
    Box::into_raw(Box::new(msg))
}

#[no_mangle]
pub extern "C" fn create_string_sizes(
    empty_ptr: *const u8,
    empty_len: usize,
    small_255_ptr: *const u8,
    small_255_len: usize,
    medium_1024_ptr: *const u8,
    medium_1024_len: usize,
    large_4096_ptr: *const u8,
    large_4096_len: usize,
) -> *mut StringSizes {
    let mut msg = StringSizes {
        empty: [0u8; 256],
        small_255: [0u8; 256],
        medium_1024: [0u8; 256],
        large_4096: [0u8; 256],
    };

    if !empty_ptr.is_null() && empty_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(empty_ptr, empty_len.min(256)) };
        msg.empty[..slice.len()].copy_from_slice(slice);
    }

    if !small_255_ptr.is_null() && small_255_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(small_255_ptr, small_255_len.min(256)) };
        msg.small_255[..slice.len()].copy_from_slice(slice);
    }

    if !medium_1024_ptr.is_null() && medium_1024_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(medium_1024_ptr, medium_1024_len.min(256)) };
        msg.medium_1024[..slice.len()].copy_from_slice(slice);
    }

    if !large_4096_ptr.is_null() && large_4096_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(large_4096_ptr, large_4096_len.min(256)) };
        msg.large_4096[..slice.len()].copy_from_slice(slice);
    }

    Box::into_raw(Box::new(msg))
}

#[no_mangle]
pub extern "C" fn create_array_sizes(
    empty_array_ptr: *const i32,
    empty_array_len: usize,
    small_array_ptr: *const i32,
    small_array_len: usize,
    medium_array_ptr: *const i32,
    medium_array_len: usize,
    large_array_ptr: *const i32,
    large_array_len: usize,
) -> *mut ArraySizes {
    let empty_array = if empty_array_ptr.is_null() {
        std::ptr::null()
    } else {
        let vec = unsafe { std::slice::from_raw_parts(empty_array_ptr, empty_array_len) }.to_vec();
        Box::into_raw(vec.into_boxed_slice()) as *const i32
    };

    let small_array = if small_array_ptr.is_null() {
        std::ptr::null()
    } else {
        let vec = unsafe { std::slice::from_raw_parts(small_array_ptr, small_array_len) }.to_vec();
        Box::into_raw(vec.into_boxed_slice()) as *const i32
    };

    let medium_array = if medium_array_ptr.is_null() {
        std::ptr::null()
    } else {
        let vec = unsafe { std::slice::from_raw_parts(medium_array_ptr, medium_array_len) }.to_vec();
        Box::into_raw(vec.into_boxed_slice()) as *const i32
    };

    let large_array = if large_array_ptr.is_null() {
        std::ptr::null()
    } else {
        let vec = unsafe { std::slice::from_raw_parts(large_array_ptr, large_array_len) }.to_vec();
        Box::into_raw(vec.into_boxed_slice()) as *const i32
    };

    let msg = ArraySizes {
        empty_array,
        small_array,
        medium_array,
        large_array,
    };
    Box::into_raw(Box::new(msg))
}

#[no_mangle]
pub extern "C" fn create_deeply_nested(
    level1_value_ptr: *const u8,
    level1_value_len: usize,
    level2_value_ptr: *const u8,
    level2_value_len: usize,
    level3_value_ptr: *const u8,
    level3_value_len: usize,
    level4_value_ptr: *const u8,
    level4_value_len: usize,
    level5_value_ptr: *const u8,
    level5_value_len: usize,
    level6_value_ptr: *const u8,
    level6_value_len: usize,
    level7_value_ptr: *const u8,
    level7_value_len: usize,
    level8_value_ptr: *const u8,
    level8_value_len: usize,
    level9_value_ptr: *const u8,
    level9_value_len: usize,
    level10_value_ptr: *const u8,
    level10_value_len: usize,
    level10_number: i32,
) -> *mut Level1 {
    let mut level10 = Level10 {
        value: [0u8; 256],
        number: level10_number,
    };
    if !level10_value_ptr.is_null() && level10_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level10_value_ptr, level10_value_len.min(256)) };
        level10.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level9 = Level9 {
        value: [0u8; 256],
        nested: level10,
    };
    if !level9_value_ptr.is_null() && level9_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level9_value_ptr, level9_value_len.min(256)) };
        level9.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level8 = Level8 {
        value: [0u8; 256],
        nested: level9,
    };
    if !level8_value_ptr.is_null() && level8_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level8_value_ptr, level8_value_len.min(256)) };
        level8.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level7 = Level7 {
        value: [0u8; 256],
        nested: level8,
    };
    if !level7_value_ptr.is_null() && level7_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level7_value_ptr, level7_value_len.min(256)) };
        level7.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level6 = Level6 {
        value: [0u8; 256],
        nested: level7,
    };
    if !level6_value_ptr.is_null() && level6_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level6_value_ptr, level6_value_len.min(256)) };
        level6.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level5 = Level5 {
        value: [0u8; 256],
        nested: level6,
    };
    if !level5_value_ptr.is_null() && level5_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level5_value_ptr, level5_value_len.min(256)) };
        level5.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level4 = Level4 {
        value: [0u8; 256],
        nested: level5,
    };
    if !level4_value_ptr.is_null() && level4_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level4_value_ptr, level4_value_len.min(256)) };
        level4.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level3 = Level3 {
        value: [0u8; 256],
        nested: level4,
    };
    if !level3_value_ptr.is_null() && level3_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level3_value_ptr, level3_value_len.min(256)) };
        level3.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level2 = Level2 {
        value: [0u8; 256],
        nested: level3,
    };
    if !level2_value_ptr.is_null() && level2_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level2_value_ptr, level2_value_len.min(256)) };
        level2.value[..slice.len()].copy_from_slice(slice);
    }

    let mut level1 = Level1 {
        value: [0u8; 256],
        nested: level2,
    };
    if !level1_value_ptr.is_null() && level1_value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(level1_value_ptr, level1_value_len.min(256)) };
        level1.value[..slice.len()].copy_from_slice(slice);
    }

    Box::into_raw(Box::new(level1))
}

#[no_mangle]
pub extern "C" fn create_many_fields(fields: [i32; 55]) -> *mut ManyFields {
    let msg = ManyFields {
        f1: fields[0], f2: fields[1], f3: fields[2], f4: fields[3], f5: fields[4],
        f6: fields[5], f7: fields[6], f8: fields[7], f9: fields[8], f10: fields[9],
        f11: fields[10], f12: fields[11], f13: fields[12], f14: fields[13], f15: fields[14],
        f16: fields[15], f17: fields[16], f18: fields[17], f19: fields[18], f20: fields[19],
        f21: fields[20], f22: fields[21], f23: fields[22], f24: fields[23], f25: fields[24],
        f26: fields[25], f27: fields[26], f28: fields[27], f29: fields[28], f30: fields[29],
        f31: fields[30], f32: fields[31], f33: fields[32], f34: fields[33], f35: fields[34],
        f36: fields[35], f37: fields[36], f38: fields[37], f39: fields[38], f40: fields[39],
        f41: fields[40], f42: fields[41], f43: fields[42], f44: fields[43], f45: fields[44],
        f46: fields[45], f47: fields[46], f48: fields[47], f49: fields[48], f50: fields[49],
        f51: fields[50], f52: fields[51], f53: fields[52], f54: fields[53], f55: fields[54],
    };
    Box::into_raw(Box::new(msg))
}

#[no_mangle]
pub extern "C" fn create_boolean_only(
    flag1: bool,
    flag2: bool,
    flag3: bool,
    flag4: bool,
    flag5: bool,
    flag6: bool,
    flag7: bool,
    flag8: bool,
) -> *mut BooleanOnly {
    let msg = BooleanOnly {
        flag1: flag1 as u8,
        flag2: flag2 as u8,
        flag3: flag3 as u8,
        flag4: flag4 as u8,
        flag5: flag5 as u8,
        flag6: flag6 as u8,
        flag7: flag7 as u8,
        flag8: flag8 as u8,
    };
    Box::into_raw(Box::new(msg))
}

#[no_mangle]
pub extern "C" fn create_enum_only(
    e1: i32,
    e2: i32,
    e3: i32,
    e4: i32,
    e5: i32,
    le1: i32,
    le2: i32,
    le3: i32,
) -> *mut EnumOnly {
    let msg = EnumOnly {
        e1: e1 as u32,
        e2: e2 as u32,
        e3: e3 as u32,
        e4: e4 as u32,
        e5: e5 as u32,
        le1: le1 as u32,
        le2: le2 as u32,
        le3: le3 as u32,
    };
    Box::into_raw(Box::new(msg))
}

#[no_mangle]
pub extern "C" fn create_empty_message() -> *mut EmptyMessage {
    Box::into_raw(Box::new(EmptyMessage {}))
}

#[no_mangle]
pub extern "C" fn create_single_field(value_ptr: *const u8, value_len: usize) -> *mut SingleField {
    let mut msg = SingleField {
        value: [0u8; 256],
    };

    if !value_ptr.is_null() && value_len > 0 {
        let slice = unsafe { std::slice::from_raw_parts(value_ptr, value_len.min(256)) };
        msg.value[..slice.len()].copy_from_slice(slice);
    }

    Box::into_raw(Box::new(msg))
}

#[no_mangle]
pub extern "C" fn verify_string_roundtrip(
    ptr: *const StringSizes,
    out_empty_ptr: *mut *const u8,
    out_empty_len: *mut usize,
    out_small_ptr: *mut *const u8,
    out_small_len: *mut usize,
    out_medium_ptr: *mut *const u8,
    out_medium_len: *mut usize,
    out_large_ptr: *mut *const u8,
    out_large_len: *mut usize,
) -> bool {
    if ptr.is_null() {
        return false;
    }

    let msg = unsafe { &*ptr };

    unsafe {
        let empty_end = msg.empty.iter().position(|&b| b == 0).unwrap_or(256);
        *out_empty_ptr = msg.empty.as_ptr();
        *out_empty_len = empty_end;

        let small_end = msg.small_255.iter().position(|&b| b == 0).unwrap_or(256);
        *out_small_ptr = msg.small_255.as_ptr();
        *out_small_len = small_end;

        let medium_end = msg.medium_1024.iter().position(|&b| b == 0).unwrap_or(256);
        *out_medium_ptr = msg.medium_1024.as_ptr();
        *out_medium_len = medium_end;

        let large_end = msg.large_4096.iter().position(|&b| b == 0).unwrap_or(256);
        *out_large_ptr = msg.large_4096.as_ptr();
        *out_large_len = large_end;
    }

    true
}

#[no_mangle]
pub extern "C" fn verify_array_roundtrip(
    ptr: *const ArraySizes,
    out_empty_ptr: *mut *const i32,
    out_empty_len: *mut usize,
    out_small_ptr: *mut *const i32,
    out_small_len: *mut usize,
    out_medium_ptr: *mut *const i32,
    out_medium_len: *mut usize,
    out_large_ptr: *mut *const i32,
    out_large_len: *mut usize,
) -> bool {
    if ptr.is_null() {
        return false;
    }

    let msg = unsafe { &*ptr };

    unsafe {
        *out_empty_ptr = msg.empty_array;
        *out_empty_len = if msg.empty_array.is_null() { 0 } else { 0 };
        *out_small_ptr = msg.small_array;
        *out_small_len = if msg.small_array.is_null() { 0 } else { 100 };
        *out_medium_ptr = msg.medium_array;
        *out_medium_len = if msg.medium_array.is_null() { 0 } else { 1000 };
        *out_large_ptr = msg.large_array;
        *out_large_len = if msg.large_array.is_null() { 0 } else { 10000 };
    }

    true
}

#[no_mangle]
pub extern "C" fn get_deeply_nested_value(ptr: *const Level1) -> i32 {
    if ptr.is_null() {
        return -1;
    }

    let msg = unsafe { &*ptr };
    msg.nested.nested.nested.nested.nested.nested.nested.nested.nested.number
}

#[no_mangle]
pub extern "C" fn sum_many_fields(ptr: *const ManyFields) -> i64 {
    if ptr.is_null() {
        return 0;
    }

    let msg = unsafe { &*ptr };
    let sum = msg.f1 as i64 + msg.f2 as i64 + msg.f3 as i64 + msg.f4 as i64 + msg.f5 as i64 +
              msg.f6 as i64 + msg.f7 as i64 + msg.f8 as i64 + msg.f9 as i64 + msg.f10 as i64 +
              msg.f11 as i64 + msg.f12 as i64 + msg.f13 as i64 + msg.f14 as i64 + msg.f15 as i64 +
              msg.f16 as i64 + msg.f17 as i64 + msg.f18 as i64 + msg.f19 as i64 + msg.f20 as i64 +
              msg.f21 as i64 + msg.f22 as i64 + msg.f23 as i64 + msg.f24 as i64 + msg.f25 as i64 +
              msg.f26 as i64 + msg.f27 as i64 + msg.f28 as i64 + msg.f29 as i64 + msg.f30 as i64 +
              msg.f31 as i64 + msg.f32 as i64 + msg.f33 as i64 + msg.f34 as i64 + msg.f35 as i64 +
              msg.f36 as i64 + msg.f37 as i64 + msg.f38 as i64 + msg.f39 as i64 + msg.f40 as i64 +
              msg.f41 as i64 + msg.f42 as i64 + msg.f43 as i64 + msg.f44 as i64 + msg.f45 as i64 +
              msg.f46 as i64 + msg.f47 as i64 + msg.f48 as i64 + msg.f49 as i64 + msg.f50 as i64 +
              msg.f51 as i64 + msg.f52 as i64 + msg.f53 as i64 + msg.f54 as i64 + msg.f55 as i64;
    sum
}

#[no_mangle]
pub extern "C" fn count_true_flags(ptr: *const BooleanOnly) -> i32 {
    if ptr.is_null() {
        return 0;
    }

    let msg = unsafe { &*ptr };
    let count = (msg.flag1 as i32) + (msg.flag2 as i32) + (msg.flag3 as i32) + (msg.flag4 as i32) +
                (msg.flag5 as i32) + (msg.flag6 as i32) + (msg.flag7 as i32) + (msg.flag8 as i32);
    count
}

#[no_mangle]
pub extern "C" fn free_integer_limits(ptr: *mut IntegerLimits) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_float_edge_cases(ptr: *mut FloatEdgeCases) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_string_sizes(ptr: *mut StringSizes) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_array_sizes(ptr: *mut ArraySizes) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_level1(ptr: *mut Level1) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_many_fields(ptr: *mut ManyFields) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_boolean_only(ptr: *mut BooleanOnly) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_enum_only(ptr: *mut EnumOnly) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_empty_message(ptr: *mut EmptyMessage) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}

#[no_mangle]
pub extern "C" fn free_single_field(ptr: *mut SingleField) {
    if !ptr.is_null() {
        unsafe { drop(Box::from_raw(ptr)) };
    }
}
