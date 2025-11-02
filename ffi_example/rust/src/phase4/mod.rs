pub mod generated;

use generated::*;
use std::sync::Mutex;

#[cfg(target_arch = "x86_64")]
use std::arch::x86_64::*;

static BATCH_STATS: Mutex<BatchStats> = Mutex::new(BatchStats {
    total_processed: 0,
    simd_operations: 0,
    scalar_operations: 0,
    avg_batch_size: 0.0,
});

#[no_mangle]
pub extern "C" fn vector4_add(a: *const Vector4, b: *const Vector4, result: *mut Vector4) {
    unsafe {
        let a = &*a;
        let b = &*b;
        let r = &mut *result;

        r.x = a.x + b.x;
        r.y = a.y + b.y;
        r.z = a.z + b.z;
        r.w = a.w + b.w;
    }
}

#[no_mangle]
pub extern "C" fn vector4_dot(a: *const Vector4, b: *const Vector4) -> f32 {
    unsafe {
        let a = &*a;
        let b = &*b;
        a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
    }
}

#[no_mangle]
pub extern "C" fn vector4_scale(v: *const Vector4, s: f32, result: *mut Vector4) {
    unsafe {
        let v = &*v;
        let r = &mut *result;

        r.x = v.x * s;
        r.y = v.y * s;
        r.z = v.z * s;
        r.w = v.w * s;
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn vector4_batch_add_simd(a: *const Vector4, b: *const Vector4, result: *mut Vector4, count: usize) {
    let chunks = count / 2;

    for i in 0..chunks {
        let idx = i * 2;

        let a_ptr = a.add(idx) as *const f32;
        let b_ptr = b.add(idx) as *const f32;
        let r_ptr = result.add(idx) as *mut f32;

        let va = _mm256_loadu_ps(a_ptr);
        let vb = _mm256_loadu_ps(b_ptr);
        let vr = _mm256_add_ps(va, vb);
        _mm256_storeu_ps(r_ptr, vr);
    }

    for i in (chunks * 2)..count {
        vector4_add(a.add(i), b.add(i), result.add(i));
    }
}

#[no_mangle]
pub extern "C" fn vector4_batch_add(a: *const Vector4, b: *const Vector4, result: *mut Vector4, count: usize) {
    #[cfg(target_arch = "x86_64")]
    {
        if is_x86_feature_detected!("avx2") && count >= 2 {
            let mut stats = BATCH_STATS.lock().unwrap();
            stats.simd_operations += 1;
            stats.total_processed += count as u64;
            drop(stats);

            unsafe {
                vector4_batch_add_simd(a, b, result, count);
            }
            return;
        }
    }

    let mut stats = BATCH_STATS.lock().unwrap();
    stats.scalar_operations += 1;
    stats.total_processed += count as u64;
    drop(stats);

    unsafe {
        for i in 0..count {
            vector4_add(a.add(i), b.add(i), result.add(i));
        }
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn vector4_batch_scale_simd(v: *const Vector4, s: f32, result: *mut Vector4, count: usize) {
    let scale_vec = _mm256_set1_ps(s);
    let chunks = count / 2;

    for i in 0..chunks {
        let idx = i * 2;

        let v_ptr = v.add(idx) as *const f32;
        let r_ptr = result.add(idx) as *mut f32;

        let vv = _mm256_loadu_ps(v_ptr);
        let vr = _mm256_mul_ps(vv, scale_vec);
        _mm256_storeu_ps(r_ptr, vr);
    }

    for i in (chunks * 2)..count {
        vector4_scale(v.add(i), s, result.add(i));
    }
}

#[no_mangle]
pub extern "C" fn vector4_batch_scale(v: *const Vector4, s: f32, result: *mut Vector4, count: usize) {
    #[cfg(target_arch = "x86_64")]
    {
        if is_x86_feature_detected!("avx2") && count >= 2 {
            let mut stats = BATCH_STATS.lock().unwrap();
            stats.simd_operations += 1;
            stats.total_processed += count as u64;
            drop(stats);

            unsafe {
                vector4_batch_scale_simd(v, s, result, count);
            }
            return;
        }
    }

    let mut stats = BATCH_STATS.lock().unwrap();
    stats.scalar_operations += 1;
    stats.total_processed += count as u64;
    drop(stats);

    unsafe {
        for i in 0..count {
            vector4_scale(v.add(i), s, result.add(i));
        }
    }
}

#[no_mangle]
pub extern "C" fn vector4_batch_dot(a: *const Vector4, b: *const Vector4, results: *mut f32, count: usize) {
    #[cfg(target_arch = "x86_64")]
    {
        if is_x86_feature_detected!("avx2") && count >= 2 {
            let mut stats = BATCH_STATS.lock().unwrap();
            stats.simd_operations += 1;
            stats.total_processed += count as u64;
            drop(stats);

            unsafe {
                vector4_batch_dot_simd(a, b, results, count);
            }
            return;
        }
    }

    let mut stats = BATCH_STATS.lock().unwrap();
    stats.scalar_operations += 1;
    stats.total_processed += count as u64;
    drop(stats);

    unsafe {
        for i in 0..count {
            *results.add(i) = vector4_dot(a.add(i), b.add(i));
        }
    }
}

#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn vector4_batch_dot_simd(a: *const Vector4, b: *const Vector4, results: *mut f32, count: usize) {
    for i in 0..count {
        let a_ptr = a.add(i) as *const f32;
        let b_ptr = b.add(i) as *const f32;

        let va = _mm_loadu_ps(a_ptr);
        let vb = _mm_loadu_ps(b_ptr);
        let vmul = _mm_mul_ps(va, vb);

        let vsum = _mm_hadd_ps(vmul, vmul);
        let vsum = _mm_hadd_ps(vsum, vsum);

        _mm_store_ss(results.add(i), vsum);
    }
}

#[no_mangle]
pub extern "C" fn batch_get_stats(stats: *mut BatchStats) {
    if !stats.is_null() {
        unsafe {
            let stats_guard = BATCH_STATS.lock().unwrap();
            *stats = *stats_guard;
        }
    }
}

#[no_mangle]
pub extern "C" fn batch_reset_stats() {
    let mut stats = BATCH_STATS.lock().unwrap();
    *stats = BatchStats::default();
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_vector4_add() {
        let a = Vector4 { x: 1.0, y: 2.0, z: 3.0, w: 4.0 };
        let b = Vector4 { x: 5.0, y: 6.0, z: 7.0, w: 8.0 };
        let mut result = Vector4::default();

        vector4_add(&a, &b, &mut result);

        assert_eq!(result.x, 6.0);
        assert_eq!(result.y, 8.0);
        assert_eq!(result.z, 10.0);
        assert_eq!(result.w, 12.0);
    }

    #[test]
    fn test_vector4_dot() {
        let a = Vector4 { x: 1.0, y: 2.0, z: 3.0, w: 4.0 };
        let b = Vector4 { x: 5.0, y: 6.0, z: 7.0, w: 8.0 };

        let dot = vector4_dot(&a, &b);

        assert_eq!(dot, 70.0);
    }

    #[test]
    fn test_vector4_batch_add() {
        let a = vec![
            Vector4 { x: 1.0, y: 2.0, z: 3.0, w: 4.0 },
            Vector4 { x: 5.0, y: 6.0, z: 7.0, w: 8.0 },
            Vector4 { x: 9.0, y: 10.0, z: 11.0, w: 12.0 },
        ];
        let b = vec![
            Vector4 { x: 1.0, y: 1.0, z: 1.0, w: 1.0 },
            Vector4 { x: 2.0, y: 2.0, z: 2.0, w: 2.0 },
            Vector4 { x: 3.0, y: 3.0, z: 3.0, w: 3.0 },
        ];
        let mut result = vec![Vector4::default(); 3];

        vector4_batch_add(a.as_ptr(), b.as_ptr(), result.as_mut_ptr(), 3);

        assert_eq!(result[0].x, 2.0);
        assert_eq!(result[1].y, 8.0);
        assert_eq!(result[2].z, 14.0);
    }
}
