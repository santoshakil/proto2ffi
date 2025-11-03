mod generated;
pub use generated::*;


#[no_mangle]
pub extern "C" fn i32_array_sum_simd(data: *const I32ArrayOps, result: *mut I32ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let sum = i32_sum_avx2(slice);
                dst.sum = sum;
                dst.count = src.count;
                return true;
            }
        }

        dst.sum = i32_sum_scalar(slice);
        dst.count = src.count;
        true
    }
}

#[no_mangle]
pub extern "C" fn i32_array_sum_scalar(data: *const I32ArrayOps, result: *mut I32ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);
        dst.sum = i32_sum_scalar(slice);
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn i32_sum_avx2(data: &[i32]) -> i32 {
    use std::arch::x86_64::*;

    let mut sum = _mm256_setzero_si256();
    let mut i = 0;

    while i + 8 <= data.len() {
        let vec = _mm256_loadu_si256(data.as_ptr().add(i) as *const __m256i);
        sum = _mm256_add_epi32(sum, vec);
        i += 8;
    }

    let mut result_array = [0i32; 8];
    _mm256_storeu_si256(result_array.as_mut_ptr() as *mut __m256i, sum);
    let mut total = result_array.iter().sum::<i32>();

    while i < data.len() {
        total = total.wrapping_add(data[i]);
        i += 1;
    }

    total
}

fn i32_sum_scalar(data: &[i32]) -> i32 {
    data.iter().fold(0i32, |acc, &x| acc.wrapping_add(x))
}

#[no_mangle]
pub extern "C" fn i32_array_min_max_simd(data: *const I32ArrayOps, result: *mut I32ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let (min, max) = i32_min_max_avx2(slice);
                dst.min = min;
                dst.max = max;
                dst.count = src.count;
                return true;
            }
        }

        let (min, max) = i32_min_max_scalar(slice);
        dst.min = min;
        dst.max = max;
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn i32_min_max_avx2(data: &[i32]) -> (i32, i32) {
    use std::arch::x86_64::*;

    if data.is_empty() {
        return (i32::MAX, i32::MIN);
    }

    let mut min_vec = _mm256_set1_epi32(i32::MAX);
    let mut max_vec = _mm256_set1_epi32(i32::MIN);
    let mut i = 0;

    while i + 8 <= data.len() {
        let vec = _mm256_loadu_si256(data.as_ptr().add(i) as *const __m256i);
        min_vec = _mm256_min_epi32(min_vec, vec);
        max_vec = _mm256_max_epi32(max_vec, vec);
        i += 8;
    }

    let mut min_array = [0i32; 8];
    let mut max_array = [0i32; 8];
    _mm256_storeu_si256(min_array.as_mut_ptr() as *mut __m256i, min_vec);
    _mm256_storeu_si256(max_array.as_mut_ptr() as *mut __m256i, max_vec);

    let mut min_val = *min_array.iter().min().unwrap();
    let mut max_val = *max_array.iter().max().unwrap();

    while i < data.len() {
        min_val = min_val.min(data[i]);
        max_val = max_val.max(data[i]);
        i += 1;
    }

    (min_val, max_val)
}

fn i32_min_max_scalar(data: &[i32]) -> (i32, i32) {
    if data.is_empty() {
        return (i32::MAX, i32::MIN);
    }

    let mut min = data[0];
    let mut max = data[0];

    for &val in &data[1..] {
        min = min.min(val);
        max = max.max(val);
    }

    (min, max)
}

#[no_mangle]
pub extern "C" fn i32_array_average_simd(data: *const I32ArrayOps, result: *mut I32ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let sum = i32_sum_avx2(slice);
                dst.sum = sum;
                dst.average = sum as f32 / src.count as f32;
                dst.count = src.count;
                return true;
            }
        }

        let sum = i32_sum_scalar(slice);
        dst.sum = sum;
        dst.average = sum as f32 / src.count as f32;
        dst.count = src.count;
        true
    }
}

#[no_mangle]
pub extern "C" fn u32_array_sum_simd(data: *const U32ArrayOps, result: *mut U32ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let sum = u32_sum_avx2(slice);
                dst.sum = sum;
                dst.count = src.count;
                return true;
            }
        }

        dst.sum = u32_sum_scalar(slice);
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn u32_sum_avx2(data: &[u32]) -> u32 {
    use std::arch::x86_64::*;

    let mut sum = _mm256_setzero_si256();
    let mut i = 0;

    while i + 8 <= data.len() {
        let vec = _mm256_loadu_si256(data.as_ptr().add(i) as *const __m256i);
        sum = _mm256_add_epi32(sum, vec);
        i += 8;
    }

    let mut result_array = [0u32; 8];
    _mm256_storeu_si256(result_array.as_mut_ptr() as *mut __m256i, sum);
    let mut total = result_array.iter().sum::<u32>();

    while i < data.len() {
        total = total.wrapping_add(data[i]);
        i += 1;
    }

    total
}

fn u32_sum_scalar(data: &[u32]) -> u32 {
    data.iter().fold(0u32, |acc, &x| acc.wrapping_add(x))
}

#[no_mangle]
pub extern "C" fn u32_array_min_max_simd(data: *const U32ArrayOps, result: *mut U32ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let (min, max) = u32_min_max_avx2(slice);
                dst.min = min;
                dst.max = max;
                dst.count = src.count;
                return true;
            }
        }

        let (min, max) = u32_min_max_scalar(slice);
        dst.min = min;
        dst.max = max;
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn u32_min_max_avx2(data: &[u32]) -> (u32, u32) {
    use std::arch::x86_64::*;

    if data.is_empty() {
        return (u32::MAX, u32::MIN);
    }

    let mut min_vec = _mm256_set1_epi32(i32::MAX);
    let mut max_vec = _mm256_set1_epi32(0);
    let mut i = 0;

    while i + 8 <= data.len() {
        let vec = _mm256_loadu_si256(data.as_ptr().add(i) as *const __m256i);
        min_vec = _mm256_min_epu32(min_vec, vec);
        max_vec = _mm256_max_epu32(max_vec, vec);
        i += 8;
    }

    let mut min_array = [0u32; 8];
    let mut max_array = [0u32; 8];
    _mm256_storeu_si256(min_array.as_mut_ptr() as *mut __m256i, min_vec);
    _mm256_storeu_si256(max_array.as_mut_ptr() as *mut __m256i, max_vec);

    let mut min_val = *min_array.iter().min().unwrap();
    let mut max_val = *max_array.iter().max().unwrap();

    while i < data.len() {
        min_val = min_val.min(data[i]);
        max_val = max_val.max(data[i]);
        i += 1;
    }

    (min_val, max_val)
}

fn u32_min_max_scalar(data: &[u32]) -> (u32, u32) {
    if data.is_empty() {
        return (u32::MAX, u32::MIN);
    }

    let mut min = data[0];
    let mut max = data[0];

    for &val in &data[1..] {
        min = min.min(val);
        max = max.max(val);
    }

    (min, max)
}

#[no_mangle]
pub extern "C" fn i64_array_sum_simd(data: *const I64ArrayOps, result: *mut I64ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let sum = i64_sum_avx2(slice);
                dst.sum = sum;
                dst.count = src.count;
                return true;
            }
        }

        dst.sum = i64_sum_scalar(slice);
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn i64_sum_avx2(data: &[i64]) -> i64 {
    use std::arch::x86_64::*;

    let mut sum = _mm256_setzero_si256();
    let mut i = 0;

    while i + 4 <= data.len() {
        let vec = _mm256_loadu_si256(data.as_ptr().add(i) as *const __m256i);
        sum = _mm256_add_epi64(sum, vec);
        i += 4;
    }

    let mut result_array = [0i64; 4];
    _mm256_storeu_si256(result_array.as_mut_ptr() as *mut __m256i, sum);
    let mut total = result_array.iter().sum::<i64>();

    while i < data.len() {
        total = total.wrapping_add(data[i]);
        i += 1;
    }

    total
}

fn i64_sum_scalar(data: &[i64]) -> i64 {
    data.iter().fold(0i64, |acc, &x| acc.wrapping_add(x))
}

#[no_mangle]
pub extern "C" fn i64_array_min_max_simd(data: *const I64ArrayOps, result: *mut I64ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);
        let (min, max) = i64_min_max_scalar(slice);
        dst.min = min;
        dst.max = max;
        dst.count = src.count;
        true
    }
}

fn i64_min_max_scalar(data: &[i64]) -> (i64, i64) {
    if data.is_empty() {
        return (i64::MAX, i64::MIN);
    }

    let mut min = data[0];
    let mut max = data[0];

    for &val in &data[1..] {
        min = min.min(val);
        max = max.max(val);
    }

    (min, max)
}

#[no_mangle]
pub extern "C" fn u64_array_sum_simd(data: *const U64ArrayOps, result: *mut U64ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let sum = u64_sum_avx2(slice);
                dst.sum = sum;
                dst.count = src.count;
                return true;
            }
        }

        dst.sum = u64_sum_scalar(slice);
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn u64_sum_avx2(data: &[u64]) -> u64 {
    use std::arch::x86_64::*;

    let mut sum = _mm256_setzero_si256();
    let mut i = 0;

    while i + 4 <= data.len() {
        let vec = _mm256_loadu_si256(data.as_ptr().add(i) as *const __m256i);
        sum = _mm256_add_epi64(sum, vec);
        i += 4;
    }

    let mut result_array = [0u64; 4];
    _mm256_storeu_si256(result_array.as_mut_ptr() as *mut __m256i, sum);
    let mut total = result_array.iter().sum::<u64>();

    while i < data.len() {
        total = total.wrapping_add(data[i]);
        i += 1;
    }

    total
}

fn u64_sum_scalar(data: &[u64]) -> u64 {
    data.iter().fold(0u64, |acc, &x| acc.wrapping_add(x))
}

#[no_mangle]
pub extern "C" fn f32_array_sum_simd(data: *const F32ArrayOps, result: *mut F32ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let (sum, has_nan, has_inf) = f32_sum_avx2(slice);
                dst.sum = sum;
                dst.has_nan = has_nan as u8;
                dst.has_infinity = has_inf as u8;
                dst.count = src.count;
                return true;
            }
        }

        let (sum, has_nan, has_inf) = f32_sum_scalar(slice);
        dst.sum = sum;
        dst.has_nan = has_nan as u8;
        dst.has_infinity = has_inf as u8;
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn f32_sum_avx2(data: &[f32]) -> (f32, bool, bool) {
    use std::arch::x86_64::*;

    let mut sum = _mm256_setzero_ps();
    let mut has_nan = false;
    let mut has_inf = false;
    let mut i = 0;

    while i + 8 <= data.len() {
        let vec = _mm256_loadu_ps(data.as_ptr().add(i));
        sum = _mm256_add_ps(sum, vec);
        i += 8;
    }

    let mut result_array = [0.0f32; 8];
    _mm256_storeu_ps(result_array.as_mut_ptr(), sum);
    let mut total = result_array.iter().sum::<f32>();

    while i < data.len() {
        let val = data[i];
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
        total += val;
        i += 1;
    }

    for &val in &result_array {
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
    }

    (total, has_nan, has_inf)
}

fn f32_sum_scalar(data: &[f32]) -> (f32, bool, bool) {
    let mut sum = 0.0f32;
    let mut has_nan = false;
    let mut has_inf = false;

    for &val in data {
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
        sum += val;
    }

    (sum, has_nan, has_inf)
}

#[no_mangle]
pub extern "C" fn f32_array_min_max_simd(data: *const F32ArrayOps, result: *mut F32ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let (min, max, has_nan, has_inf) = f32_min_max_avx2(slice);
                dst.min = min;
                dst.max = max;
                dst.has_nan = has_nan as u8;
                dst.has_infinity = has_inf as u8;
                dst.count = src.count;
                return true;
            }
        }

        let (min, max, has_nan, has_inf) = f32_min_max_scalar(slice);
        dst.min = min;
        dst.max = max;
        dst.has_nan = has_nan as u8;
        dst.has_infinity = has_inf as u8;
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn f32_min_max_avx2(data: &[f32]) -> (f32, f32, bool, bool) {
    use std::arch::x86_64::*;

    if data.is_empty() {
        return (f32::MAX, f32::MIN, false, false);
    }

    let mut min_vec = _mm256_set1_ps(f32::MAX);
    let mut max_vec = _mm256_set1_ps(f32::MIN);
    let mut has_nan = false;
    let mut has_inf = false;
    let mut i = 0;

    while i + 8 <= data.len() {
        let vec = _mm256_loadu_ps(data.as_ptr().add(i));
        min_vec = _mm256_min_ps(min_vec, vec);
        max_vec = _mm256_max_ps(max_vec, vec);
        i += 8;
    }

    let mut min_array = [0.0f32; 8];
    let mut max_array = [0.0f32; 8];
    _mm256_storeu_ps(min_array.as_mut_ptr(), min_vec);
    _mm256_storeu_ps(max_array.as_mut_ptr(), max_vec);

    let mut min_val = min_array[0];
    let mut max_val = max_array[0];

    for &val in &min_array[1..] {
        if !val.is_nan() && val < min_val {
            min_val = val;
        }
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
    }

    for &val in &max_array[1..] {
        if !val.is_nan() && val > max_val {
            max_val = val;
        }
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
    }

    while i < data.len() {
        let val = data[i];
        if val.is_nan() {
            has_nan = true;
        } else {
            min_val = min_val.min(val);
            max_val = max_val.max(val);
        }
        if val.is_infinite() {
            has_inf = true;
        }
        i += 1;
    }

    (min_val, max_val, has_nan, has_inf)
}

fn f32_min_max_scalar(data: &[f32]) -> (f32, f32, bool, bool) {
    if data.is_empty() {
        return (f32::MAX, f32::MIN, false, false);
    }

    let mut min = f32::MAX;
    let mut max = f32::MIN;
    let mut has_nan = false;
    let mut has_inf = false;

    for &val in data {
        if val.is_nan() {
            has_nan = true;
        } else {
            min = min.min(val);
            max = max.max(val);
        }
        if val.is_infinite() {
            has_inf = true;
        }
    }

    (min, max, has_nan, has_inf)
}

#[no_mangle]
pub extern "C" fn f64_array_sum_simd(data: *const F64ArrayOps, result: *mut F64ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let (sum, has_nan, has_inf) = f64_sum_avx2(slice);
                dst.sum = sum;
                dst.has_nan = has_nan as u8;
                dst.has_infinity = has_inf as u8;
                dst.count = src.count;
                return true;
            }
        }

        let (sum, has_nan, has_inf) = f64_sum_scalar(slice);
        dst.sum = sum;
        dst.has_nan = has_nan as u8;
        dst.has_infinity = has_inf as u8;
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn f64_sum_avx2(data: &[f64]) -> (f64, bool, bool) {
    use std::arch::x86_64::*;

    let mut sum = _mm256_setzero_pd();
    let mut has_nan = false;
    let mut has_inf = false;
    let mut i = 0;

    while i + 4 <= data.len() {
        let vec = _mm256_loadu_pd(data.as_ptr().add(i));
        sum = _mm256_add_pd(sum, vec);
        i += 4;
    }

    let mut result_array = [0.0f64; 4];
    _mm256_storeu_pd(result_array.as_mut_ptr(), sum);
    let mut total = result_array.iter().sum::<f64>();

    while i < data.len() {
        let val = data[i];
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
        total += val;
        i += 1;
    }

    for &val in &result_array {
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
    }

    (total, has_nan, has_inf)
}

fn f64_sum_scalar(data: &[f64]) -> (f64, bool, bool) {
    let mut sum = 0.0f64;
    let mut has_nan = false;
    let mut has_inf = false;

    for &val in data {
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
        sum += val;
    }

    (sum, has_nan, has_inf)
}

#[no_mangle]
pub extern "C" fn f64_array_min_max_simd(data: *const F64ArrayOps, result: *mut F64ArrayOps) -> bool {
    if data.is_null() || result.is_null() {
        return false;
    }

    unsafe {
        let src = &*data;
        let dst = &mut *result;

        if src.data.is_null() || src.count == 0 {
            return false;
        }

        let slice = std::slice::from_raw_parts(src.data, src.count as usize);

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                let (min, max, has_nan, has_inf) = f64_min_max_avx2(slice);
                dst.min = min;
                dst.max = max;
                dst.has_nan = has_nan as u8;
                dst.has_infinity = has_inf as u8;
                dst.count = src.count;
                return true;
            }
        }

        let (min, max, has_nan, has_inf) = f64_min_max_scalar(slice);
        dst.min = min;
        dst.max = max;
        dst.has_nan = has_nan as u8;
        dst.has_infinity = has_inf as u8;
        dst.count = src.count;
        true
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn f64_min_max_avx2(data: &[f64]) -> (f64, f64, bool, bool) {
    use std::arch::x86_64::*;

    if data.is_empty() {
        return (f64::MAX, f64::MIN, false, false);
    }

    let mut min_vec = _mm256_set1_pd(f64::MAX);
    let mut max_vec = _mm256_set1_pd(f64::MIN);
    let mut has_nan = false;
    let mut has_inf = false;
    let mut i = 0;

    while i + 4 <= data.len() {
        let vec = _mm256_loadu_pd(data.as_ptr().add(i));
        min_vec = _mm256_min_pd(min_vec, vec);
        max_vec = _mm256_max_pd(max_vec, vec);
        i += 4;
    }

    let mut min_array = [0.0f64; 4];
    let mut max_array = [0.0f64; 4];
    _mm256_storeu_pd(min_array.as_mut_ptr(), min_vec);
    _mm256_storeu_pd(max_array.as_mut_ptr(), max_vec);

    let mut min_val = min_array[0];
    let mut max_val = max_array[0];

    for &val in &min_array[1..] {
        if !val.is_nan() && val < min_val {
            min_val = val;
        }
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
    }

    for &val in &max_array[1..] {
        if !val.is_nan() && val > max_val {
            max_val = val;
        }
        if val.is_nan() {
            has_nan = true;
        }
        if val.is_infinite() {
            has_inf = true;
        }
    }

    while i < data.len() {
        let val = data[i];
        if val.is_nan() {
            has_nan = true;
        } else {
            min_val = min_val.min(val);
            max_val = max_val.max(val);
        }
        if val.is_infinite() {
            has_inf = true;
        }
        i += 1;
    }

    (min_val, max_val, has_nan, has_inf)
}

fn f64_min_max_scalar(data: &[f64]) -> (f64, f64, bool, bool) {
    if data.is_empty() {
        return (f64::MAX, f64::MIN, false, false);
    }

    let mut min = f64::MAX;
    let mut max = f64::MIN;
    let mut has_nan = false;
    let mut has_inf = false;

    for &val in data {
        if val.is_nan() {
            has_nan = true;
        } else {
            min = min.min(val);
            max = max.max(val);
        }
        if val.is_infinite() {
            has_inf = true;
        }
    }

    (min, max, has_nan, has_inf)
}

#[no_mangle]
pub extern "C" fn benchmark_operation(
    op_name: *const u8,
    op_name_len: usize,
    simd_time_ns: u64,
    scalar_time_ns: u64,
    elements: u32,
    result: *mut BenchmarkResult
) -> bool {
    if result.is_null() {
        return false;
    }

    unsafe {
        let dst = &mut *result;
        dst.simd_time_ns = simd_time_ns;
        dst.scalar_time_ns = scalar_time_ns;
        dst.speedup_factor = scalar_time_ns as f32 / simd_time_ns.max(1) as f32;
        dst.elements_processed = elements;

        if !op_name.is_null() && op_name_len > 0 {
            let copy_len = op_name_len.min(255);
            let name_slice = std::slice::from_raw_parts(op_name, copy_len);
            dst.operation_name[..copy_len].copy_from_slice(name_slice);
            if copy_len < 256 {
                dst.operation_name[copy_len] = 0;
            }
        }

        true
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_i32_sum_scalar() {
        assert_eq!(i32_sum_scalar(&[1, 2, 3, 4, 5]), 15);
        assert_eq!(i32_sum_scalar(&[]), 0);
        assert_eq!(i32_sum_scalar(&[-1, -2, -3]), -6);
        assert_eq!(i32_sum_scalar(&[i32::MAX, 1]), i32::MIN);
    }

    #[test]
    fn test_i32_min_max_scalar() {
        assert_eq!(i32_min_max_scalar(&[5, 2, 8, 1, 9]), (1, 9));
        assert_eq!(i32_min_max_scalar(&[42]), (42, 42));
        assert_eq!(i32_min_max_scalar(&[-5, -2, -8]), (-8, -2));
        assert_eq!(i32_min_max_scalar(&[]), (i32::MAX, i32::MIN));
    }

    #[test]
    fn test_u32_sum_scalar() {
        assert_eq!(u32_sum_scalar(&[1, 2, 3, 4, 5]), 15);
        assert_eq!(u32_sum_scalar(&[]), 0);
        assert_eq!(u32_sum_scalar(&[u32::MAX, 1]), 0);
    }

    #[test]
    fn test_u32_min_max_scalar() {
        assert_eq!(u32_min_max_scalar(&[5, 2, 8, 1, 9]), (1, 9));
        assert_eq!(u32_min_max_scalar(&[42]), (42, 42));
        assert_eq!(u32_min_max_scalar(&[]), (u32::MAX, u32::MIN));
    }

    #[test]
    fn test_i64_sum_scalar() {
        assert_eq!(i64_sum_scalar(&[1, 2, 3, 4, 5]), 15);
        assert_eq!(i64_sum_scalar(&[]), 0);
        assert_eq!(i64_sum_scalar(&[-100, -200, -300]), -600);
    }

    #[test]
    fn test_i64_min_max_scalar() {
        assert_eq!(i64_min_max_scalar(&[5, 2, 8, 1, 9]), (1, 9));
        assert_eq!(i64_min_max_scalar(&[]), (i64::MAX, i64::MIN));
    }

    #[test]
    fn test_u64_sum_scalar() {
        assert_eq!(u64_sum_scalar(&[1, 2, 3, 4, 5]), 15);
        assert_eq!(u64_sum_scalar(&[]), 0);
    }

    #[test]
    fn test_f32_sum_scalar() {
        let (sum, has_nan, has_inf) = f32_sum_scalar(&[1.0, 2.0, 3.0]);
        assert_eq!(sum, 6.0);
        assert!(!has_nan);
        assert!(!has_inf);
        
        let (_, has_nan, _) = f32_sum_scalar(&[1.0, f32::NAN, 3.0]);
        assert!(has_nan);
        
        let (_, _, has_inf) = f32_sum_scalar(&[1.0, f32::INFINITY, 3.0]);
        assert!(has_inf);
    }

    #[test]
    fn test_f32_min_max_scalar() {
        let (min, max, has_nan, has_inf) = f32_min_max_scalar(&[5.0, 2.0, 8.0, 1.0]);
        assert_eq!(min, 1.0);
        assert_eq!(max, 8.0);
        assert!(!has_nan);
        assert!(!has_inf);
        
        let (_, _, has_nan, _) = f32_min_max_scalar(&[1.0, f32::NAN, 3.0]);
        assert!(has_nan);
    }

    #[test]
    fn test_f64_sum_scalar() {
        let (sum, has_nan, has_inf) = f64_sum_scalar(&[1.0, 2.0, 3.0]);
        assert_eq!(sum, 6.0);
        assert!(!has_nan);
        assert!(!has_inf);
        
        let (_, has_nan, _) = f64_sum_scalar(&[1.0, f64::NAN, 3.0]);
        assert!(has_nan);
    }

    #[test]
    fn test_f64_min_max_scalar() {
        let (min, max, has_nan, has_inf) = f64_min_max_scalar(&[5.0, 2.0, 8.0, 1.0]);
        assert_eq!(min, 1.0);
        assert_eq!(max, 8.0);
        assert!(!has_nan);
        assert!(!has_inf);
    }
}
