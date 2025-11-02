mod generated;

use generated::*;
use std::sync::{Arc, Mutex};
use std::time::Instant;

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
        let u_slice = std::slice::from_raw_parts(u_plane, u_len as usize);
        let v_slice = std::slice::from_raw_parts(v_plane, v_len as usize);

        let compression_ratio = (quality * 0.1 + 0.05) as usize;
        let target_size = std::cmp::min(
            (y_len as usize + u_len as usize + v_len as usize) / compression_ratio,
            1048576
        );

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
            .unwrap()
            .as_micros() as u64;
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

#[no_mangle]
pub extern "C" fn video_pool_stats() -> (usize, usize, usize, usize) {
    (
        FRAME_METADATA_POOL.allocated_count(),
        FRAME_METADATA_POOL.capacity(),
        COMPRESSED_FRAME_POOL.allocated_count(),
        COMPRESSED_FRAME_POOL.capacity(),
    )
}
