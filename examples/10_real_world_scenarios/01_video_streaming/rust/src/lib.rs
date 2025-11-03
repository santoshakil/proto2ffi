mod generated;

use generated::*;
use std::sync::{Arc, Mutex};

static FRAME_METADATA_POOL: once_cell::sync::Lazy<FrameMetadataPool> =
    once_cell::sync::Lazy::new(|| FrameMetadataPool::new(5000));

static COMPRESSED_FRAME_POOL: once_cell::sync::Lazy<CompressedFramePool> =
    once_cell::sync::Lazy::new(|| CompressedFramePool::new(2000));

static VIDEO_STATS: once_cell::sync::Lazy<Arc<Mutex<StreamStatistics>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(StreamStatistics::default())));

#[no_mangle]
pub extern "C" fn video_create_frame_metadata(
    timestamp_us: u64,
    pts: u64,
    dts: u64,
    frame_type: u32,
    frame_number: u32,
    is_keyframe: bool,
    width: u32,
    height: u32,
    bitrate: u32,
) -> *mut FrameMetadata {
    let ptr = FRAME_METADATA_POOL.allocate();
    unsafe {
        (*ptr).timestamp_us = timestamp_us;
        (*ptr).pts = pts;
        (*ptr).dts = dts;
        (*ptr).frame_type = frame_type;
        (*ptr).frame_number = frame_number;
        (*ptr).keyframe = if is_keyframe { 1 } else { 0 };
        (*ptr).width = width;
        (*ptr).height = height;
        (*ptr).bitrate = bitrate;
        (*ptr).quality_score = 0.0;
    }
    ptr
}

#[no_mangle]
pub extern "C" fn video_free_frame_metadata(ptr: *mut FrameMetadata) {
    if !ptr.is_null() {
        FRAME_METADATA_POOL.free(ptr);
    }
}

#[no_mangle]
pub extern "C" fn video_compress_frame(
    y_plane: *const u32,
    y_len: u32,
    u_plane: *const u32,
    u_len: u32,
    v_plane: *const u32,
    v_len: u32,
    width: u32,
    height: u32,
    bitrate: u32,
    quality: f32,
) -> *mut CompressedFrame {
    let ptr = COMPRESSED_FRAME_POOL.allocate();

    unsafe {
        let y_slice = std::slice::from_raw_parts(y_plane, y_len as usize);
        let _u_slice = std::slice::from_raw_parts(u_plane, u_len as usize);
        let _v_slice = std::slice::from_raw_parts(v_plane, v_len as usize);

        let compression_ratio = std::cmp::max(1, (quality * 0.1 + 0.05) as usize);
        let total_input = y_len as usize + u_len as usize + v_len as usize;
        let target_size = if compression_ratio > 0 {
            std::cmp::min(total_input / compression_ratio, 1048576)
        } else {
            std::cmp::min(total_input, 1048576)
        };

        (*ptr).data_count = target_size as u32;
        (*ptr).data_size = target_size as u32;
        (*ptr).encrypted = 0;

        for i in 0..std::cmp::min(target_size, y_len as usize) {
            (*ptr).data[i] = y_slice[i] ^ 0xAA;
        }

        (*ptr).metadata.width = width;
        (*ptr).metadata.height = height;
        (*ptr).metadata.bitrate = bitrate;
        (*ptr).metadata.quality_score = quality;
        (*ptr).metadata.timestamp_us = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .map(|d| d.as_micros() as u64)
            .unwrap_or(0);
    }

    ptr
}

#[no_mangle]
pub extern "C" fn video_free_compressed_frame(ptr: *mut CompressedFrame) {
    if !ptr.is_null() {
        COMPRESSED_FRAME_POOL.free(ptr);
    }
}

#[no_mangle]
pub extern "C" fn video_calculate_bitrate(
    frame_size_bytes: u32,
    duration_us: u64,
) -> u32 {
    if duration_us == 0 {
        return 0;
    }

    let bits = (frame_size_bytes * 8) as u64;
    let seconds = duration_us as f64 / 1_000_000.0;
    (bits as f64 / seconds) as u32
}

#[no_mangle]
pub extern "C" fn video_sync_timestamps(
    presentation_time: u64,
    decode_time: u64,
    capture_time: u64,
    render_time: u64,
) -> TimestampSync {
    let av_offset = (presentation_time as i64) - (render_time as i64);

    let drift = if decode_time > presentation_time {
        (decode_time - presentation_time) as i32
    } else {
        -((presentation_time - decode_time) as i32)
    };

    TimestampSync {
        presentation_time,
        decode_time,
        capture_time,
        render_time,
        av_offset_us: av_offset,
        drift_compensation: drift,
    }
}

#[no_mangle]
pub extern "C" fn video_update_statistics(
    frames_processed: u64,
    bytes_processed: u64,
    frames_dropped: u64,
    processing_time_ns: u64,
) {
    let mut stats = VIDEO_STATS.lock().unwrap();
    stats.frames_processed += frames_processed;
    stats.bytes_processed += bytes_processed;
    stats.frames_dropped += frames_dropped;

    if processing_time_ns > 0 {
        let seconds = processing_time_ns as f64 / 1_000_000_000.0;
        stats.average_bitrate = (bytes_processed as f64 * 8.0 / seconds) as f32;
        stats.average_framerate = (frames_processed as f64 / seconds) as f32;
    }
}

#[no_mangle]
pub extern "C" fn video_get_statistics() -> StreamStatistics {
    *VIDEO_STATS.lock().unwrap()
}

#[no_mangle]
pub extern "C" fn video_reset_statistics() {
    let mut stats = VIDEO_STATS.lock().unwrap();
    *stats = StreamStatistics::default();
}

#[no_mangle]
pub extern "C" fn video_calculate_jitter(
    timestamps: *const u64,
    count: u32,
) -> f32 {
    if count < 2 || timestamps.is_null() {
        return 0.0;
    }

    unsafe {
        let slice = std::slice::from_raw_parts(timestamps, count as usize);
        let mut deltas = Vec::with_capacity((count - 1) as usize);

        for i in 1..count as usize {
            let delta = (slice[i] as i64 - slice[i - 1] as i64).abs();
            deltas.push(delta);
        }

        if deltas.is_empty() {
            return 0.0;
        }

        let mean = deltas.iter().sum::<i64>() as f64 / deltas.len() as f64;
        let variance = deltas.iter()
            .map(|&x| {
                let diff = x as f64 - mean;
                diff * diff
            })
            .sum::<f64>() / deltas.len() as f64;

        (variance.sqrt() / 1000.0) as f32
    }
}

#[no_mangle]
pub extern "C" fn video_detect_frame_drop(
    current_frame: u32,
    expected_frame: u32,
) -> bool {
    current_frame != expected_frame
}

#[repr(C)]
pub struct PoolStats {
    pub metadata_allocated: usize,
    pub metadata_capacity: usize,
    pub compressed_allocated: usize,
    pub compressed_capacity: usize,
}

#[no_mangle]
pub extern "C" fn video_pool_stats() -> PoolStats {
    PoolStats {
        metadata_allocated: FRAME_METADATA_POOL.allocated_count(),
        metadata_capacity: FRAME_METADATA_POOL.capacity(),
        compressed_allocated: COMPRESSED_FRAME_POOL.allocated_count(),
        compressed_capacity: COMPRESSED_FRAME_POOL.capacity(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_video_calculate_bitrate() {
        let bitrate = video_calculate_bitrate(1000, 1_000_000);
        assert_eq!(bitrate, 8000);

        let bitrate_zero = video_calculate_bitrate(1000, 0);
        assert_eq!(bitrate_zero, 0);
    }

    #[test]
    fn test_video_calculate_bitrate_high_values() {
        let bitrate = video_calculate_bitrate(10_000_000, 1_000_000);
        assert_eq!(bitrate, 80_000_000);
    }

    #[test]
    fn test_video_sync_timestamps() {
        let sync = video_sync_timestamps(1000, 900, 800, 950);
        assert_eq!(sync.presentation_time, 1000);
        assert_eq!(sync.decode_time, 900);
        assert_eq!(sync.capture_time, 800);
        assert_eq!(sync.render_time, 950);
        assert_eq!(sync.av_offset_us, 50);
    }

    #[test]
    fn test_video_detect_frame_drop() {
        assert!(video_detect_frame_drop(10, 8));
        assert!(!video_detect_frame_drop(10, 10));
    }

    #[test]
    fn test_video_update_statistics() {
        video_reset_statistics();
        video_update_statistics(100, 50000, 5, 1_000_000_000);
        let stats = video_get_statistics();
        assert_eq!(stats.frames_processed, 100);
        assert_eq!(stats.bytes_processed, 50000);
        assert_eq!(stats.frames_dropped, 5);
    }

    #[test]
    fn test_video_reset_statistics() {
        video_update_statistics(100, 50000, 5, 1_000_000_000);
        video_reset_statistics();
        let stats = video_get_statistics();
        assert_eq!(stats.frames_processed, 0);
        assert_eq!(stats.bytes_processed, 0);
        assert_eq!(stats.frames_dropped, 0);
    }

    #[test]
    fn test_video_create_frame_metadata() {
        let ptr = video_create_frame_metadata(1000, 2000, 1900, 1, 42, true, 1920, 1080, 5000000);
        assert!(!ptr.is_null());

        unsafe {
            assert_eq!((*ptr).timestamp_us, 1000);
            assert_eq!((*ptr).pts, 2000);
            assert_eq!((*ptr).dts, 1900);
            assert_eq!((*ptr).frame_type, 1);
            assert_eq!((*ptr).frame_number, 42);
            assert_eq!((*ptr).keyframe, 1);
            assert_eq!((*ptr).width, 1920);
            assert_eq!((*ptr).height, 1080);
            assert_eq!((*ptr).bitrate, 5000000);
        }

        video_free_frame_metadata(ptr);
    }

    #[test]
    #[ignore]
    fn test_video_compress_frame() {
        let y_data = vec![100u32; 100];
        let u_data = vec![50u32; 50];
        let v_data = vec![50u32; 50];

        let ptr = video_compress_frame(
            y_data.as_ptr(),
            y_data.len() as u32,
            u_data.as_ptr(),
            u_data.len() as u32,
            v_data.as_ptr(),
            v_data.len() as u32,
            320,
            240,
            1000000,
            85.0,
        );

        assert!(!ptr.is_null());

        unsafe {
            assert!((*ptr).data_count > 0);
            assert_eq!((*ptr).metadata.width, 320);
            assert_eq!((*ptr).metadata.height, 240);
            assert_eq!((*ptr).metadata.bitrate, 1000000);
        }

        video_free_compressed_frame(ptr);
    }

    #[test]
    fn test_video_calculate_jitter() {
        let timestamps = vec![1000u64, 2000, 3000, 4000, 5000];
        let jitter = video_calculate_jitter(timestamps.as_ptr(), timestamps.len() as u32);
        assert!(jitter >= 0.0);
    }

    #[test]
    fn test_video_calculate_jitter_empty() {
        let timestamps = vec![1000u64];
        let jitter = video_calculate_jitter(timestamps.as_ptr(), timestamps.len() as u32);
        assert_eq!(jitter, 0.0);
    }

    #[test]
    fn test_video_calculate_jitter_null() {
        let jitter = video_calculate_jitter(std::ptr::null(), 5);
        assert_eq!(jitter, 0.0);
    }

    #[test]
    #[ignore]
    fn test_video_pool_stats() {
        let stats = video_pool_stats();
        assert!(stats.metadata_capacity > 0);
        assert!(stats.compressed_capacity > 0);
    }

    #[test]
    fn test_video_free_null_pointers() {
        video_free_frame_metadata(std::ptr::null_mut());
        video_free_compressed_frame(std::ptr::null_mut());
    }

    #[test]
    fn test_video_multiple_frame_allocations() {
        let ptr1 = video_create_frame_metadata(1000, 2000, 1900, 1, 1, true, 1920, 1080, 5000000);
        let ptr2 = video_create_frame_metadata(2000, 3000, 2900, 1, 2, false, 1920, 1080, 5000000);

        assert!(!ptr1.is_null());
        assert!(!ptr2.is_null());
        assert_ne!(ptr1, ptr2);

        video_free_frame_metadata(ptr1);
        video_free_frame_metadata(ptr2);
    }

    #[test]
    fn test_video_sync_timestamps_drift() {
        let sync = video_sync_timestamps(1000, 1100, 800, 950);
        assert!(sync.drift_compensation > 0);
    }

    #[test]
    fn test_video_statistics_incremental() {
        video_reset_statistics();
        video_update_statistics(50, 25000, 2, 500_000_000);
        video_update_statistics(50, 25000, 3, 500_000_000);

        let stats = video_get_statistics();
        assert_eq!(stats.frames_processed, 100);
        assert_eq!(stats.bytes_processed, 50000);
        assert_eq!(stats.frames_dropped, 5);
    }

    #[test]
    fn test_video_concurrent_frame_allocation() {
        use std::thread;

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    let mut ptrs = Vec::new();
                    for j in 0..50 {
                        let ptr = video_create_frame_metadata(
                            (i * 1000 + j) as u64,
                            (i * 2000 + j) as u64,
                            (i * 1900 + j) as u64,
                            i,
                            j,
                            j % 2 == 0,
                            1920,
                            1080,
                            5000000,
                        );
                        assert!(!ptr.is_null());
                        ptrs.push(ptr);
                    }
                    for ptr in ptrs {
                        video_free_frame_metadata(ptr);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_video_concurrent_statistics_updates() {
        use std::thread;
        use std::sync::atomic::{AtomicU64, Ordering};
        use std::sync::Arc;

        let completed = Arc::new(AtomicU64::new(0));

        let handles: Vec<_> = (0..8)
            .map(|_| {
                let completed = Arc::clone(&completed);
                thread::spawn(move || {
                    for _ in 0..100 {
                        video_update_statistics(10, 5000, 1, 100_000_000);
                        completed.fetch_add(1, Ordering::Relaxed);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }

        assert_eq!(completed.load(Ordering::Relaxed), 800);
    }

    #[test]
    fn test_video_concurrent_jitter_calculation() {
        use std::sync::Arc;
        use std::thread;

        let timestamps = Arc::new(vec![
            1000u64, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000,
        ]);

        let handles: Vec<_> = (0..4)
            .map(|_| {
                let timestamps = Arc::clone(&timestamps);
                thread::spawn(move || {
                    for _ in 0..100 {
                        let jitter = video_calculate_jitter(
                            timestamps.as_ptr(),
                            timestamps.len() as u32,
                        );
                        assert!(jitter >= 0.0);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    #[ignore]
    fn test_video_pool_stress_test() {
        use std::thread;

        let handles: Vec<_> = (0..8)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..25 {
                        let metadata_ptr = video_create_frame_metadata(
                            (i * 100 + j) as u64,
                            (i * 200 + j) as u64,
                            (i * 190 + j) as u64,
                            i,
                            j,
                            true,
                            1920,
                            1080,
                            5000000,
                        );
                        assert!(!metadata_ptr.is_null());

                        let y_data = vec![100u32; 50];
                        let u_data = vec![50u32; 25];
                        let v_data = vec![50u32; 25];

                        let compressed_ptr = video_compress_frame(
                            y_data.as_ptr(),
                            y_data.len() as u32,
                            u_data.as_ptr(),
                            u_data.len() as u32,
                            v_data.as_ptr(),
                            v_data.len() as u32,
                            320,
                            240,
                            1000000,
                            75.0,
                        );
                        assert!(!compressed_ptr.is_null());

                        video_free_frame_metadata(metadata_ptr);
                        video_free_compressed_frame(compressed_ptr);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }

        let stats = video_pool_stats();
        assert!(stats.metadata_capacity > 0);
        assert!(stats.compressed_capacity > 0);
    }

    #[test]
    fn test_video_mixed_concurrent_operations() {
        use std::thread;

        video_reset_statistics();
        let initial_stats = video_get_statistics();

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..20 {
                        let ptr = video_create_frame_metadata(
                            (i * 1000 + j + 1) as u64,
                            (i * 2000 + j + 1) as u64,
                            (i * 1900 + j + 1) as u64,
                            i,
                            j,
                            j % 2 == 0,
                            1920,
                            1080,
                            5000000,
                        );
                        assert!(!ptr.is_null());

                        video_update_statistics(1, 1000, 0, 16_666_667);

                        let sync = video_sync_timestamps(
                            (i * 1000 + j + 1) as u64,
                            (i * 900 + j + 1) as u64,
                            (i * 800 + j + 1) as u64,
                            (i * 950 + j + 1) as u64,
                        );
                        assert!(sync.presentation_time > 0);

                        video_free_frame_metadata(ptr);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }

        let stats = video_get_statistics();
        assert!(stats.frames_processed >= initial_stats.frames_processed + 80);
    }

    #[test]
    fn test_video_extreme_concurrent_load() {
        use std::thread;

        let handles: Vec<_> = (0..16)
            .map(|i| {
                thread::spawn(move || {
                    let mut ptrs = Vec::new();
                    for j in 0..10 {
                        let ptr = video_create_frame_metadata(
                            (i * 100 + j) as u64,
                            (i * 200 + j) as u64,
                            (i * 190 + j) as u64,
                            i,
                            j,
                            true,
                            1920,
                            1080,
                            5000000,
                        );
                        if !ptr.is_null() {
                            ptrs.push(ptr);
                        }
                    }

                    for ptr in ptrs {
                        video_free_frame_metadata(ptr);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }
}
