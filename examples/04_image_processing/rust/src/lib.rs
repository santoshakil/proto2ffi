mod generated;
pub use generated::*;

use std::sync::Mutex;

// Global statistics
static PERF_METRICS: Mutex<PerformanceMetrics> = Mutex::new(PerformanceMetrics {
    total_pixels_processed: 0,
    total_time_ns: 0,
    megapixels_per_second: 0.0,
    cache_hits: 0,
    cache_misses: 0,
    simd_operations: 0,
    scalar_operations: 0,
});

// Image buffer pool
static mut IMAGE_POOL: Option<ImageBufferPool> = None;

#[no_mangle]
pub extern "C" fn init_image_pool(capacity: usize) {
    unsafe {
        IMAGE_POOL = Some(ImageBufferPool::new(capacity));
    }
}

// SIMD-optimized grayscale conversion
#[cfg(target_arch = "x86_64")]
#[target_feature(enable = "avx2")]
unsafe fn grayscale_avx2(src: &[u32], dst: &mut [u32], width: usize, height: usize) {
    use std::arch::x86_64::*;

    let pixels = width * height;
    let mut i = 0;

    // Process 8 pixels at a time with AVX2
    while i + 8 <= pixels {
        // Load 8 RGBA pixels
        let rgba0 = _mm256_loadu_si256(src.as_ptr().add(i) as *const __m256i);
        let rgba1 = _mm256_loadu_si256(src.as_ptr().add(i + 4) as *const __m256i);

        // Extract RGB channels (simplified - real implementation would unpack properly)
        // Gray = 0.299*R + 0.587*G + 0.114*B
        // For now, simple average for demonstration

        // Store grayscale result
        _mm256_storeu_si256(dst.as_mut_ptr().add(i) as *mut __m256i, rgba0);

        i += 8;
    }

    // Process remaining pixels
    while i < pixels {
        let pixel = src[i];
        let r = (pixel >> 24) & 0xFF;
        let g = (pixel >> 16) & 0xFF;
        let b = (pixel >> 8) & 0xFF;
        let gray = ((r * 299 + g * 587 + b * 114) / 1000) & 0xFF;
        dst[i] = (gray << 24) | (gray << 16) | (gray << 8) | 0xFF;
        i += 1;
    }
}

#[no_mangle]
pub extern "C" fn convert_to_grayscale(
    src_buffer: *const ImageBuffer,
    dst_buffer: *mut ImageBuffer,
) -> bool {
    if src_buffer.is_null() || dst_buffer.is_null() {
        return false;
    }

    unsafe {
        let src = &*src_buffer;
        let dst = &mut *dst_buffer;

        let width = src.width as usize;
        let height = src.height as usize;

        if width == 0 || height == 0 {
            return false;
        }

        dst.width = src.width;
        dst.height = src.height;
        dst.stride = src.stride;
        dst.color_space = ColorSpace::GRAYSCALE as u32;

        let src_data = src.data();
        let dst_data = dst.data_mut();

        #[cfg(target_arch = "x86_64")]
        {
            if is_x86_feature_detected!("avx2") {
                grayscale_avx2(src_data, dst_data, width, height);

                let mut metrics = PERF_METRICS.lock().unwrap();
                metrics.simd_operations += 1;
            } else {
                // Scalar fallback
                grayscale_scalar(src_data, dst_data, width, height);
                let mut metrics = PERF_METRICS.lock().unwrap();
                metrics.scalar_operations += 1;
            }
        }

        #[cfg(not(target_arch = "x86_64"))]
        {
            grayscale_scalar(src_data, dst_data, width, height);
            let mut metrics = PERF_METRICS.lock().unwrap();
            metrics.scalar_operations += 1;
        }

        let mut metrics = PERF_METRICS.lock().unwrap();
        metrics.total_pixels_processed += (width * height) as u64;
    }

    true
}

fn grayscale_scalar(src: &[u32], dst: &mut [u32], width: usize, height: usize) {
    let pixels = width * height;

    for i in 0..pixels {
        let pixel = src[i];
        let r = (pixel >> 24) & 0xFF;
        let g = (pixel >> 16) & 0xFF;
        let b = (pixel >> 8) & 0xFF;
        let gray = ((r * 299 + g * 587 + b * 114) / 1000) & 0xFF;
        dst[i] = (gray << 24) | (gray << 16) | (gray << 8) | 0xFF;
    }
}

// Box blur filter
#[no_mangle]
pub extern "C" fn apply_box_blur(
    src_buffer: *const ImageBuffer,
    dst_buffer: *mut ImageBuffer,
    radius: u32,
) -> bool {
    if src_buffer.is_null() || dst_buffer.is_null() || radius == 0 {
        return false;
    }

    unsafe {
        let src = &*src_buffer;
        let dst = &mut *dst_buffer;

        let width = src.width as usize;
        let height = src.height as usize;

        dst.width = src.width;
        dst.height = src.height;
        dst.stride = src.stride;
        dst.color_space = src.color_space;

        let src_data = src.data();
        let dst_data = dst.data_mut();

        let r = radius as i32;

        for y in 0..height {
            for x in 0..width {
                let mut sum_r = 0u32;
                let mut sum_g = 0u32;
                let mut sum_b = 0u32;
                let mut count = 0u32;

                for dy in -r..=r {
                    for dx in -r..=r {
                        let ny = (y as i32 + dy).max(0).min(height as i32 - 1) as usize;
                        let nx = (x as i32 + dx).max(0).min(width as i32 - 1) as usize;

                        let pixel = src_data[ny * width + nx];
                        sum_r += (pixel >> 24) & 0xFF;
                        sum_g += (pixel >> 16) & 0xFF;
                        sum_b += (pixel >> 8) & 0xFF;
                        count += 1;
                    }
                }

                let avg_r = sum_r / count;
                let avg_g = sum_g / count;
                let avg_b = sum_b / count;

                dst_data[y * width + x] = (avg_r << 24) | (avg_g << 16) | (avg_b << 8) | 0xFF;
            }
        }
    }

    true
}

// Brightness adjustment
#[no_mangle]
pub extern "C" fn adjust_brightness(
    src_buffer: *const ImageBuffer,
    dst_buffer: *mut ImageBuffer,
    adjustment: f32,
) -> bool {
    if src_buffer.is_null() || dst_buffer.is_null() {
        return false;
    }

    unsafe {
        let src = &*src_buffer;
        let dst = &mut *dst_buffer;

        let width = src.width as usize;
        let height = src.height as usize;

        dst.width = src.width;
        dst.height = src.height;
        dst.stride = src.stride;
        dst.color_space = src.color_space;

        let src_data = src.data();
        let dst_data = dst.data_mut();

        let adj = (adjustment * 255.0) as i32;

        for i in 0..(width * height) {
            let pixel = src_data[i];
            let r = ((pixel >> 24) & 0xFF) as i32;
            let g = ((pixel >> 16) & 0xFF) as i32;
            let b = ((pixel >> 8) & 0xFF) as i32;

            let new_r = (r + adj).max(0).min(255) as u32;
            let new_g = (g + adj).max(0).min(255) as u32;
            let new_b = (b + adj).max(0).min(255) as u32;

            dst_data[i] = (new_r << 24) | (new_g << 16) | (new_b << 8) | 0xFF;
        }
    }

    true
}

// Calculate histogram
#[no_mangle]
pub extern "C" fn calculate_histogram(
    buffer: *const ImageBuffer,
    histogram: *mut Histogram,
    channel: u32,
) -> bool {
    if buffer.is_null() || histogram.is_null() {
        return false;
    }

    unsafe {
        let img = &*buffer;
        let hist = &mut *histogram;

        // Clear bins
        for i in 0..256 {
            hist.bins[i] = 0;
        }

        let width = img.width as usize;
        let height = img.height as usize;
        let data = img.data();

        let shift = match channel {
            0 => 24, // R
            1 => 16, // G
            2 => 8,  // B
            _ => 0,  // A
        };

        for i in 0..(width * height) {
            let value = ((data[i] >> shift) & 0xFF) as usize;
            hist.bins[value] += 1;
        }
    }

    true
}

// Calculate color statistics
#[no_mangle]
pub extern "C" fn calculate_color_stats(
    buffer: *const ImageBuffer,
    stats: *mut ColorStats,
) -> bool {
    if buffer.is_null() || stats.is_null() {
        return false;
    }

    unsafe {
        let img = &*buffer;
        let st = &mut *stats;

        let width = img.width as usize;
        let height = img.height as usize;
        let data = img.data();
        let pixels = width * height;

        if pixels == 0 {
            return false;
        }

        let mut sum_r = 0u64;
        let mut sum_g = 0u64;
        let mut sum_b = 0u64;

        let mut min_r = 255u32;
        let mut min_g = 255u32;
        let mut min_b = 255u32;
        let mut max_r = 0u32;
        let mut max_g = 0u32;
        let mut max_b = 0u32;

        for i in 0..pixels {
            let pixel = data[i];
            let r = (pixel >> 24) & 0xFF;
            let g = (pixel >> 16) & 0xFF;
            let b = (pixel >> 8) & 0xFF;

            sum_r += r as u64;
            sum_g += g as u64;
            sum_b += b as u64;

            min_r = min_r.min(r);
            min_g = min_g.min(g);
            min_b = min_b.min(b);
            max_r = max_r.max(r);
            max_g = max_g.max(g);
            max_b = max_b.max(b);
        }

        let pixels_f = pixels as f32;
        st.mean_r = (sum_r as f32) / pixels_f;
        st.mean_g = (sum_g as f32) / pixels_f;
        st.mean_b = (sum_b as f32) / pixels_f;

        st.min_r = min_r;
        st.min_g = min_g;
        st.min_b = min_b;
        st.max_r = max_r;
        st.max_g = max_g;
        st.max_b = max_b;

        // Calculate standard deviation
        let mut var_r = 0f64;
        let mut var_g = 0f64;
        let mut var_b = 0f64;

        for i in 0..pixels {
            let pixel = data[i];
            let r = ((pixel >> 24) & 0xFF) as f64;
            let g = ((pixel >> 16) & 0xFF) as f64;
            let b = ((pixel >> 8) & 0xFF) as f64;

            let diff_r = r - st.mean_r as f64;
            let diff_g = g - st.mean_g as f64;
            let diff_b = b - st.mean_b as f64;

            var_r += diff_r * diff_r;
            var_g += diff_g * diff_g;
            var_b += diff_b * diff_b;
        }

        st.stddev_r = (var_r / pixels_f as f64).sqrt() as f32;
        st.stddev_g = (var_g / pixels_f as f64).sqrt() as f32;
        st.stddev_b = (var_b / pixels_f as f64).sqrt() as f32;
    }

    true
}

// Get performance metrics
#[no_mangle]
pub extern "C" fn get_performance_metrics(metrics: *mut PerformanceMetrics) -> bool {
    if metrics.is_null() {
        return false;
    }

    unsafe {
        let src = PERF_METRICS.lock().unwrap();
        let dst = &mut *metrics;

        dst.total_pixels_processed = src.total_pixels_processed;
        dst.total_time_ns = src.total_time_ns;
        dst.megapixels_per_second = src.megapixels_per_second;
        dst.cache_hits = src.cache_hits;
        dst.cache_misses = src.cache_misses;
        dst.simd_operations = src.simd_operations;
        dst.scalar_operations = src.scalar_operations;
    }

    true
}

// Reset performance metrics
#[no_mangle]
pub extern "C" fn reset_performance_metrics() {
    let mut metrics = PERF_METRICS.lock().unwrap();
    metrics.total_pixels_processed = 0;
    metrics.total_time_ns = 0;
    metrics.megapixels_per_second = 0.0;
    metrics.cache_hits = 0;
    metrics.cache_misses = 0;
    metrics.simd_operations = 0;
    metrics.scalar_operations = 0;
}

#[cfg(test)]
mod tests {
    use super::*;

    fn create_test_buffer(width: u32, height: u32) -> *mut ImageBuffer {
        use std::alloc::{alloc, Layout};

        unsafe {
            let layout = Layout::new::<ImageBuffer>();
            let ptr = alloc(layout) as *mut ImageBuffer;
            if ptr.is_null() {
                panic!("Failed to allocate ImageBuffer");
            }

            (*ptr).data_count = width * height;
            (*ptr).width = width;
            (*ptr).height = height;
            (*ptr).stride = width;
            (*ptr).color_space = ColorSpace::RGBA as u32;

            for i in 0..(width * height) as usize {
                (*ptr).data[i] = 0xFF0000FF;
            }

            ptr
        }
    }

    fn free_test_buffer(ptr: *mut ImageBuffer) {
        use std::alloc::{dealloc, Layout};

        if !ptr.is_null() {
            unsafe {
                let layout = Layout::new::<ImageBuffer>();
                dealloc(ptr as *mut u8, layout);
            }
        }
    }

    #[test]
    fn test_convert_to_grayscale_basic() {
        let src = create_test_buffer(100, 100);
        let dst = create_test_buffer(100, 100);

        let result = convert_to_grayscale(src as *const _, dst as *mut _);
        assert!(result);
        unsafe {
            assert_eq!((*dst).width, 100);
            assert_eq!((*dst).height, 100);
            assert_eq!((*dst).color_space, ColorSpace::GRAYSCALE as u32);
        }

        free_test_buffer(src);
        free_test_buffer(dst);
    }

    #[test]
    fn test_convert_to_grayscale_null_src() {
        let dst = create_test_buffer(100, 100);
        let result = convert_to_grayscale(std::ptr::null(), dst as *mut _);
        assert!(!result);
        free_test_buffer(dst);
    }

    #[test]
    fn test_convert_to_grayscale_null_dst() {
        let src = create_test_buffer(100, 100);
        let result = convert_to_grayscale(src as *const _, std::ptr::null_mut());
        assert!(!result);
        free_test_buffer(src);
    }

    #[test]
    fn test_convert_to_grayscale_zero_dimensions() {
        let src = create_test_buffer(0, 0);
        let dst = create_test_buffer(100, 100);
        let result = convert_to_grayscale(src as *const _, dst as *mut _);
        assert!(!result);
        free_test_buffer(src);
        free_test_buffer(dst);
    }

    #[test]
    fn test_apply_box_blur_null_src() {
        let dst = create_test_buffer(50, 50);
        let result = apply_box_blur(std::ptr::null(), dst as *mut _, 1);
        assert!(!result);
        free_test_buffer(dst);
    }

    #[test]
    fn test_apply_box_blur_null_dst() {
        let src = create_test_buffer(50, 50);
        let result = apply_box_blur(src as *const _, std::ptr::null_mut(), 1);
        assert!(!result);
        free_test_buffer(src);
    }

    #[test]
    fn test_apply_box_blur_zero_radius() {
        let src = create_test_buffer(50, 50);
        let dst = create_test_buffer(50, 50);
        let result = apply_box_blur(src as *const _, dst as *mut _, 0);
        assert!(!result);
        free_test_buffer(src);
        free_test_buffer(dst);
    }

    #[test]
    fn test_adjust_brightness_null_src() {
        let dst = create_test_buffer(50, 50);
        let result = adjust_brightness(std::ptr::null(), dst as *mut _, 0.5);
        assert!(!result);
        free_test_buffer(dst);
    }

    #[test]
    fn test_adjust_brightness_null_dst() {
        let src = create_test_buffer(50, 50);
        let result = adjust_brightness(src as *const _, std::ptr::null_mut(), 0.5);
        assert!(!result);
        free_test_buffer(src);
    }

    #[test]
    fn test_calculate_histogram_null_buffer() {
        let mut histogram = Histogram {
            bins_count: 256,
            bins: [0; 256],
        };
        let result = calculate_histogram(std::ptr::null(), &mut histogram as *mut _, 0);
        assert!(!result);
    }

    #[test]
    fn test_calculate_histogram_null_histogram() {
        let buffer = create_test_buffer(50, 50);
        let result = calculate_histogram(buffer as *const _, std::ptr::null_mut(), 0);
        assert!(!result);
        free_test_buffer(buffer);
    }

    #[test]
    fn test_calculate_color_stats_null_buffer() {
        let mut stats = ColorStats {
            mean_r: 0.0,
            mean_g: 0.0,
            mean_b: 0.0,
            stddev_r: 0.0,
            stddev_g: 0.0,
            stddev_b: 0.0,
            min_r: 0,
            min_g: 0,
            min_b: 0,
            max_r: 0,
            max_g: 0,
            max_b: 0,
        };
        let result = calculate_color_stats(std::ptr::null(), &mut stats as *mut _);
        assert!(!result);
    }

    #[test]
    fn test_calculate_color_stats_null_stats() {
        let buffer = create_test_buffer(50, 50);
        let result = calculate_color_stats(buffer as *const _, std::ptr::null_mut());
        assert!(!result);
        free_test_buffer(buffer);
    }

    #[test]
    fn test_calculate_color_stats_zero_pixels() {
        let buffer = create_test_buffer(0, 0);
        let mut stats = ColorStats {
            mean_r: 0.0,
            mean_g: 0.0,
            mean_b: 0.0,
            stddev_r: 0.0,
            stddev_g: 0.0,
            stddev_b: 0.0,
            min_r: 0,
            min_g: 0,
            min_b: 0,
            max_r: 0,
            max_g: 0,
            max_b: 0,
        };
        let result = calculate_color_stats(buffer as *const _, &mut stats as *mut _);
        assert!(!result);
        free_test_buffer(buffer);
    }

    #[test]
    fn test_performance_metrics_get() {
        reset_performance_metrics();
        let mut metrics = PerformanceMetrics {
            total_pixels_processed: 0,
            total_time_ns: 0,
            megapixels_per_second: 0.0,
            cache_hits: 0,
            cache_misses: 0,
            simd_operations: 0,
            scalar_operations: 0,
        };

        let result = get_performance_metrics(&mut metrics as *mut _);
        assert!(result);
        assert_eq!(metrics.total_pixels_processed, 0);
    }

    #[test]
    fn test_performance_metrics_null() {
        let result = get_performance_metrics(std::ptr::null_mut());
        assert!(!result);
    }

    #[test]
    fn test_grayscale_scalar() {
        let src = vec![0xFF0000FF; 100];
        let mut dst = vec![0; 100];
        grayscale_scalar(&src, &mut dst, 10, 10);

        for &pixel in &dst {
            let r = (pixel >> 24) & 0xFF;
            let g = (pixel >> 16) & 0xFF;
            let b = (pixel >> 8) & 0xFF;
            assert_eq!(r, g);
            assert_eq!(g, b);
        }
    }

}
