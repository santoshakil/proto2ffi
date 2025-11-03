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

pub fn dot_product_f32(a: &[f32], b: &[f32]) -> f32 {
    assert_eq!(a.len(), b.len());
    a.iter().zip(b.iter()).map(|(x, y)| x * y).sum()
}

pub fn dot_product_f64(a: &[f64], b: &[f64]) -> f64 {
    assert_eq!(a.len(), b.len());
    a.iter().zip(b.iter()).map(|(x, y)| x * y).sum()
}

pub fn vector_add_f32(a: &[f32], b: &[f32], result: &mut [f32]) {
    assert_eq!(a.len(), b.len());
    assert_eq!(a.len(), result.len());
    for i in 0..a.len() {
        result[i] = a[i] + b[i];
    }
}

pub fn vector_scale_f32(vec: &[f32], scalar: f32, result: &mut [f32]) {
    assert_eq!(vec.len(), result.len());
    for i in 0..vec.len() {
        result[i] = vec[i] * scalar;
    }
}

#[cfg(test)]
mod advanced_tests {
    use super::*;

    #[test]
    fn test_dot_product_f32() {
        let a = vec![1.0, 2.0, 3.0, 4.0];
        let b = vec![5.0, 6.0, 7.0, 8.0];
        let result = dot_product_f32(&a, &b);
        assert_eq!(result, 70.0);
    }

    #[test]
    fn test_dot_product_f64() {
        let a = vec![1.0, 2.0, 3.0];
        let b = vec![4.0, 5.0, 6.0];
        let result = dot_product_f64(&a, &b);
        assert_eq!(result, 32.0);
    }

    #[test]
    fn test_vector_add_f32() {
        let a = vec![1.0, 2.0, 3.0];
        let b = vec![4.0, 5.0, 6.0];
        let mut result = vec![0.0; 3];
        vector_add_f32(&a, &b, &mut result);
        assert_eq!(result, vec![5.0, 7.0, 9.0]);
    }

    #[test]
    fn test_vector_scale_f32() {
        let vec = vec![1.0, 2.0, 3.0, 4.0];
        let mut result = vec![0.0; 4];
        vector_scale_f32(&vec, 2.5, &mut result);
        assert_eq!(result, vec![2.5, 5.0, 7.5, 10.0]);
    }

    #[test]
    fn test_dot_product_zero() {
        let a = vec![0.0; 100];
        let b = vec![1.0; 100];
        assert_eq!(dot_product_f32(&a, &b), 0.0);
    }

    #[test]
    fn test_vector_scale_zero() {
        let vec = vec![1.0, 2.0, 3.0];
        let mut result = vec![0.0; 3];
        vector_scale_f32(&vec, 0.0, &mut result);
        assert_eq!(result, vec![0.0, 0.0, 0.0]);
    }
}

pub fn matrix_multiply_f32(a: &[f32], a_rows: usize, a_cols: usize,
                             b: &[f32], b_rows: usize, b_cols: usize,
                             result: &mut [f32]) {
    assert_eq!(a_cols, b_rows);
    assert_eq!(a.len(), a_rows * a_cols);
    assert_eq!(b.len(), b_rows * b_cols);
    assert_eq!(result.len(), a_rows * b_cols);

    for i in 0..a_rows {
        for j in 0..b_cols {
            let mut sum = 0.0;
            for k in 0..a_cols {
                sum += a[i * a_cols + k] * b[k * b_cols + j];
            }
            result[i * b_cols + j] = sum;
        }
    }
}

pub fn matrix_transpose_f32(matrix: &[f32], rows: usize, cols: usize, result: &mut [f32]) {
    assert_eq!(matrix.len(), rows * cols);
    assert_eq!(result.len(), rows * cols);

    for i in 0..rows {
        for j in 0..cols {
            result[j * rows + i] = matrix[i * cols + j];
        }
    }
}

pub fn vector_subtract_f32(a: &[f32], b: &[f32], result: &mut [f32]) {
    assert_eq!(a.len(), b.len());
    assert_eq!(a.len(), result.len());
    for i in 0..a.len() {
        result[i] = a[i] - b[i];
    }
}

pub fn vector_magnitude_f32(vec: &[f32]) -> f32 {
    vec.iter().map(|&x| x * x).sum::<f32>().sqrt()
}

pub fn vector_normalize_f32(vec: &[f32], result: &mut [f32]) {
    assert_eq!(vec.len(), result.len());
    let mag = vector_magnitude_f32(vec);
    if mag > 0.0 {
        for i in 0..vec.len() {
            result[i] = vec[i] / mag;
        }
    }
}

pub fn convolution_1d_f32(signal: &[f32], kernel: &[f32], result: &mut [f32]) {
    let result_len = signal.len() + kernel.len() - 1;
    assert_eq!(result.len(), result_len);

    for i in 0..result.len() {
        result[i] = 0.0;
    }

    for i in 0..signal.len() {
        for j in 0..kernel.len() {
            result[i + j] += signal[i] * kernel[j];
        }
    }
}

pub fn moving_average_f32(data: &[f32], window_size: usize, result: &mut [f32]) {
    assert!(window_size > 0);
    assert_eq!(data.len(), result.len());

    for i in 0..data.len() {
        let start = if i >= window_size { i - window_size + 1 } else { 0 };
        let end = i + 1;
        let sum: f32 = data[start..end].iter().sum();
        result[i] = sum / (end - start) as f32;
    }
}

pub fn cross_correlation_f32(a: &[f32], b: &[f32], max_lag: usize, result: &mut [f32]) {
    let result_len = 2 * max_lag + 1;
    assert_eq!(result.len(), result_len);
    assert!(max_lag < a.len().min(b.len()));

    for lag_idx in 0..result_len {
        let lag = lag_idx as isize - max_lag as isize;
        let mut sum = 0.0;
        let mut count = 0;

        for i in 0..a.len() {
            let j = i as isize + lag;
            if j >= 0 && (j as usize) < b.len() {
                sum += a[i] * b[j as usize];
                count += 1;
            }
        }

        result[lag_idx] = if count > 0 { sum / count as f32 } else { 0.0 };
    }
}

#[cfg(test)]
mod matrix_tests {
    use super::*;

    #[test]
    fn test_matrix_multiply() {
        let a = vec![1.0, 2.0, 3.0, 4.0];
        let b = vec![5.0, 6.0, 7.0, 8.0];
        let mut result = vec![0.0; 4];
        matrix_multiply_f32(&a, 2, 2, &b, 2, 2, &mut result);
        assert_eq!(result, vec![19.0, 22.0, 43.0, 50.0]);
    }

    #[test]
    fn test_matrix_transpose() {
        let matrix = vec![1.0, 2.0, 3.0, 4.0, 5.0, 6.0];
        let mut result = vec![0.0; 6];
        matrix_transpose_f32(&matrix, 2, 3, &mut result);
        assert_eq!(result, vec![1.0, 4.0, 2.0, 5.0, 3.0, 6.0]);
    }

    #[test]
    fn test_vector_subtract() {
        let a = vec![5.0, 7.0, 9.0];
        let b = vec![1.0, 2.0, 3.0];
        let mut result = vec![0.0; 3];
        vector_subtract_f32(&a, &b, &mut result);
        assert_eq!(result, vec![4.0, 5.0, 6.0]);
    }

    #[test]
    fn test_vector_magnitude() {
        let vec = vec![3.0, 4.0];
        let mag = vector_magnitude_f32(&vec);
        assert_eq!(mag, 5.0);
    }

    #[test]
    fn test_vector_normalize() {
        let vec = vec![3.0, 4.0];
        let mut result = vec![0.0; 2];
        vector_normalize_f32(&vec, &mut result);
        assert!((result[0] - 0.6).abs() < 0.001);
        assert!((result[1] - 0.8).abs() < 0.001);
    }

    #[test]
    fn test_convolution_1d() {
        let signal = vec![1.0, 2.0, 3.0];
        let kernel = vec![1.0, 0.5];
        let mut result = vec![0.0; 4];
        convolution_1d_f32(&signal, &kernel, &mut result);
        assert_eq!(result, vec![1.0, 2.5, 4.0, 1.5]);
    }

    #[test]
    fn test_moving_average() {
        let data = vec![1.0, 2.0, 3.0, 4.0, 5.0];
        let mut result = vec![0.0; 5];
        moving_average_f32(&data, 3, &mut result);
        assert_eq!(result[0], 1.0);
        assert_eq!(result[1], 1.5);
        assert_eq!(result[2], 2.0);
        assert_eq!(result[3], 3.0);
        assert_eq!(result[4], 4.0);
    }

    #[test]
    fn test_cross_correlation() {
        let a = vec![1.0, 2.0, 3.0, 4.0, 5.0];
        let b = vec![1.0, 2.0, 3.0, 4.0, 5.0];
        let mut result = vec![0.0; 5];
        cross_correlation_f32(&a, &b, 2, &mut result);
        assert!(result[2] > result[0]);
        assert!(result[2] > result[4]);
    }

    #[test]
    fn test_matrix_identity_multiply() {
        let a = vec![1.0, 2.0, 3.0, 4.0];
        let identity = vec![1.0, 0.0, 0.0, 1.0];
        let mut result = vec![0.0; 4];
        matrix_multiply_f32(&a, 2, 2, &identity, 2, 2, &mut result);
        assert_eq!(result, a);
    }

    #[test]
    fn test_vector_normalize_zero() {
        let vec = vec![0.0, 0.0];
        let mut result = vec![1.0; 2];
        vector_normalize_f32(&vec, &mut result);
    }

    #[test]
    fn test_concurrent_simd_add() {
        use std::thread;

        let handles: Vec<_> = (0..8)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..50 {
                        let a: Vec<f32> = (0..100).map(|x| (i * 100 + j + x) as f32).collect();
                        let b: Vec<f32> = (0..100).map(|x| (x + 1) as f32).collect();
                        let mut result = vec![0.0; 100];

                        vector_add_f32(&a, &b, &mut result);

                        for k in 0..100 {
                            assert_eq!(result[k], a[k] + b[k]);
                        }
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_concurrent_matrix_operations() {
        use std::thread;

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..100 {
                        let a = vec![
                            (i + j + 1) as f32, (i + j + 2) as f32,
                            (i + j + 3) as f32, (i + j + 4) as f32,
                        ];
                        let b = vec![
                            (j + 1) as f32, (j + 2) as f32,
                            (j + 3) as f32, (j + 4) as f32,
                        ];
                        let mut result = vec![0.0; 4];

                        matrix_multiply_f32(&a, 2, 2, &b, 2, 2, &mut result);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_large_vector_operations() {
        let size = 10000;
        let a: Vec<f32> = (0..size).map(|x| x as f32).collect();
        let b: Vec<f32> = (0..size).map(|x| (x + 1) as f32).collect();
        let mut result = vec![0.0; size];

        vector_add_f32(&a, &b, &mut result);
        for i in 0..size {
            assert_eq!(result[i], a[i] + b[i]);
        }

        vector_subtract_f32(&a, &b, &mut result);
        for i in 0..size {
            assert_eq!(result[i], a[i] - b[i]);
        }
    }

    #[test]
    fn test_simd_edge_cases_empty() {
        let a: Vec<f32> = vec![];
        let b: Vec<f32> = vec![];
        let mut result: Vec<f32> = vec![];

        vector_add_f32(&a, &b, &mut result);
        assert_eq!(result.len(), 0);
    }

    #[test]
    fn test_simd_edge_cases_single() {
        let a = vec![5.0];
        let b = vec![3.0];
        let mut result = vec![0.0];

        vector_add_f32(&a, &b, &mut result);
        assert_eq!(result[0], 8.0);

        vector_subtract_f32(&a, &b, &mut result);
        assert_eq!(result[0], 2.0);
    }

    #[test]
    fn test_simd_non_aligned_sizes() {
        for size in [7, 13, 21, 37, 63, 127] {
            let a: Vec<f32> = (0..size).map(|x| x as f32).collect();
            let b: Vec<f32> = (0..size).map(|x| (x + 1) as f32).collect();
            let mut result = vec![0.0; size];

            vector_add_f32(&a, &b, &mut result);
            for i in 0..size {
                assert_eq!(result[i], a[i] + b[i]);
            }
        }
    }

    #[test]
    fn test_concurrent_convolution() {
        use std::thread;

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..25 {
                        let signal: Vec<f32> = (0..50).map(|x| (i * 10 + j + x) as f32).collect();
                        let kernel = vec![1.0, 2.0, 1.0];
                        let mut result = vec![0.0; signal.len() + kernel.len() - 1];

                        convolution_1d_f32(&signal, &kernel, &mut result);
                        assert!(result.len() == signal.len() + kernel.len() - 1);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_concurrent_vector_normalization() {
        use std::thread;

        let handles: Vec<_> = (0..8)
            .map(|i| {
                thread::spawn(move || {
                    for j in 1..50 {
                        let vec: Vec<f32> = (1..=100).map(|x| (i * 10 + j + x) as f32).collect();
                        let mut result = vec![0.0; vec.len()];

                        vector_normalize_f32(&vec, &mut result);

                        let magnitude: f32 = result.iter().map(|x| x * x).sum::<f32>().sqrt();
                        assert!((magnitude - 1.0).abs() < 0.01);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_mixed_concurrent_simd_operations() {
        use std::thread;

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..20 {
                        let size = 100;
                        let a: Vec<f32> = (0..size).map(|x| (i * 100 + j + x) as f32).collect();
                        let b: Vec<f32> = (0..size).map(|x| (x + 1) as f32).collect();
                        let mut result = vec![0.0; size];

                        vector_add_f32(&a, &b, &mut result);
                        vector_subtract_f32(&a, &b, &mut result);
                        vector_scale_f32(&a, 2.0, &mut result);

                        let mag = vector_magnitude_f32(&a);
                        assert!(mag > 0.0);

                        vector_normalize_f32(&a, &mut result);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_extreme_concurrent_simd_load() {
        use std::thread;

        let handles: Vec<_> = (0..16)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..10 {
                        let a: Vec<f32> = (0..50).map(|x| (i * 10 + j + x) as f32).collect();
                        let b: Vec<f32> = (0..50).map(|x| (x + 1) as f32).collect();
                        let mut result = vec![0.0; 50];

                        vector_add_f32(&a, &b, &mut result);
                        let _mag = vector_magnitude_f32(&result);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }
}
