#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum CodecType {
    H264 = 0,
    H265 = 1,
    VP8 = 2,
    VP9 = 3,
    AV1 = 4,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum FrameType {
    I_FRAME = 0,
    P_FRAME = 1,
    B_FRAME = 2,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum ChromaSubsampling {
    YUV420 = 0,
    YUV422 = 1,
    YUV444 = 2,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum BufferState {
    EMPTY = 0,
    FILLING = 1,
    FULL = 2,
    DRAINING = 3,
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct FrameMetadata {
    pub timestamp_us: u64,
    pub pts: u64,
    pub dts: u64,
    pub frame_type: u32,
    pub frame_number: u32,
    pub width: u32,
    pub height: u32,
    pub bitrate: u32,
    pub quality_score: f32,
    pub keyframe: u8,
}
impl FrameMetadata {
    pub const SIZE: usize = 56;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for FrameMetadata {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn framemetadata_size() -> usize {
    FrameMetadata::SIZE
}
#[no_mangle]
pub extern "C" fn framemetadata_alignment() -> usize {
    FrameMetadata::ALIGNMENT
}
pub struct FrameMetadataPool {
    inner: std::sync::Mutex<FrameMetadataPoolInner>,
}
struct FrameMetadataPoolInner {
    chunks: Vec<Box<[FrameMetadata; 100]>>,
    free_list: Vec<*mut FrameMetadata>,
    allocated: usize,
}
impl FrameMetadataPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = FrameMetadataPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        FrameMetadataPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut FrameMetadata {
        let mut inner = self.inner.lock().unwrap();
        if inner.free_list.is_empty() {
            inner.add_chunk();
        }
        let ptr = inner
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        inner.allocated += 1;
        ptr
    }
    pub fn free(&self, ptr: *mut FrameMetadata) {
        let mut inner = self.inner.lock().unwrap();
        inner.free_list.push(ptr);
        inner.allocated -= 1;
    }
    pub fn allocated_count(&self) -> usize {
        let inner = self.inner.lock().unwrap();
        inner.allocated
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        let inner = self.inner.lock().unwrap();
        inner.chunks.len() * CHUNK_SIZE
    }
}
impl FrameMetadataPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[FrameMetadata; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for FrameMetadataPool {}
unsafe impl Sync for FrameMetadataPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct CodecParameters {
    pub codec: u32,
    pub width: u32,
    pub height: u32,
    pub bitrate: u32,
    pub framerate: u32,
    pub gop_size: u32,
    pub chroma: u32,
    pub bit_depth: u32,
    pub profile: u32,
    pub level: u32,
}
impl CodecParameters {
    pub const SIZE: usize = 40;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for CodecParameters {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn codecparameters_size() -> usize {
    CodecParameters::SIZE
}
#[no_mangle]
pub extern "C" fn codecparameters_alignment() -> usize {
    CodecParameters::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_codec_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].codec as i32,
                chunk[6].codec as i32,
                chunk[5].codec as i32,
                chunk[4].codec as i32,
                chunk[3].codec as i32,
                chunk[2].codec as i32,
                chunk[1].codec as i32,
                chunk[0].codec as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.codec as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_width_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].width as i32,
                chunk[6].width as i32,
                chunk[5].width as i32,
                chunk[4].width as i32,
                chunk[3].width as i32,
                chunk[2].width as i32,
                chunk[1].width as i32,
                chunk[0].width as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.width as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_height_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].height as i32,
                chunk[6].height as i32,
                chunk[5].height as i32,
                chunk[4].height as i32,
                chunk[3].height as i32,
                chunk[2].height as i32,
                chunk[1].height as i32,
                chunk[0].height as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.height as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_bitrate_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].bitrate as i32,
                chunk[6].bitrate as i32,
                chunk[5].bitrate as i32,
                chunk[4].bitrate as i32,
                chunk[3].bitrate as i32,
                chunk[2].bitrate as i32,
                chunk[1].bitrate as i32,
                chunk[0].bitrate as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.bitrate as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_framerate_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].framerate as i32,
                chunk[6].framerate as i32,
                chunk[5].framerate as i32,
                chunk[4].framerate as i32,
                chunk[3].framerate as i32,
                chunk[2].framerate as i32,
                chunk[1].framerate as i32,
                chunk[0].framerate as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.framerate as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_gop_size_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].gop_size as i32,
                chunk[6].gop_size as i32,
                chunk[5].gop_size as i32,
                chunk[4].gop_size as i32,
                chunk[3].gop_size as i32,
                chunk[2].gop_size as i32,
                chunk[1].gop_size as i32,
                chunk[0].gop_size as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.gop_size as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_chroma_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].chroma as i32,
                chunk[6].chroma as i32,
                chunk[5].chroma as i32,
                chunk[4].chroma as i32,
                chunk[3].chroma as i32,
                chunk[2].chroma as i32,
                chunk[1].chroma as i32,
                chunk[0].chroma as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.chroma as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_bit_depth_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].bit_depth as i32,
                chunk[6].bit_depth as i32,
                chunk[5].bit_depth as i32,
                chunk[4].bit_depth as i32,
                chunk[3].bit_depth as i32,
                chunk[2].bit_depth as i32,
                chunk[1].bit_depth as i32,
                chunk[0].bit_depth as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.bit_depth as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_profile_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].profile as i32,
                chunk[6].profile as i32,
                chunk[5].profile as i32,
                chunk[4].profile as i32,
                chunk[3].profile as i32,
                chunk[2].profile as i32,
                chunk[1].profile as i32,
                chunk[0].profile as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.profile as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_level_batch(items: &[CodecParameters]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].level as i32,
                chunk[6].level as i32,
                chunk[5].level as i32,
                chunk[4].level as i32,
                chunk[3].level as i32,
                chunk[2].level as i32,
                chunk[1].level as i32,
                chunk[0].level as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.level as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct VideoFrame {
    pub metadata: FrameMetadata,
    pub y_plane_count: u32,
    pub y_plane: [u32; 8294400],
    pub u_plane_count: u32,
    pub u_plane: [u32; 2073600],
    pub v_plane_count: u32,
    pub v_plane: [u32; 2073600],
    pub y_stride: u32,
    pub u_stride: u32,
    pub v_stride: u32,
}
impl VideoFrame {
    pub const SIZE: usize = 49766480;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
    #[inline(always)]
    pub fn y_plane(&self) -> &[u32] {
        &self.y_plane[..self.y_plane_count as usize]
    }
    #[inline(always)]
    pub fn y_plane_mut(&mut self) -> &mut [u32] {
        let count = self.y_plane_count as usize;
        &mut self.y_plane[..count]
    }
    pub fn add_y_plane(&mut self, item: u32) -> Result<(), &'static str> {
        if self.y_plane_count >= 8294400 as u32 {
            return Err("Array full");
        }
        self.y_plane[self.y_plane_count as usize] = item;
        self.y_plane_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn u_plane(&self) -> &[u32] {
        &self.u_plane[..self.u_plane_count as usize]
    }
    #[inline(always)]
    pub fn u_plane_mut(&mut self) -> &mut [u32] {
        let count = self.u_plane_count as usize;
        &mut self.u_plane[..count]
    }
    pub fn add_u_plane(&mut self, item: u32) -> Result<(), &'static str> {
        if self.u_plane_count >= 2073600 as u32 {
            return Err("Array full");
        }
        self.u_plane[self.u_plane_count as usize] = item;
        self.u_plane_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn v_plane(&self) -> &[u32] {
        &self.v_plane[..self.v_plane_count as usize]
    }
    #[inline(always)]
    pub fn v_plane_mut(&mut self) -> &mut [u32] {
        let count = self.v_plane_count as usize;
        &mut self.v_plane[..count]
    }
    pub fn add_v_plane(&mut self, item: u32) -> Result<(), &'static str> {
        if self.v_plane_count >= 2073600 as u32 {
            return Err("Array full");
        }
        self.v_plane[self.v_plane_count as usize] = item;
        self.v_plane_count += 1;
        Ok(())
    }
}
impl Default for VideoFrame {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn videoframe_size() -> usize {
    VideoFrame::SIZE
}
#[no_mangle]
pub extern "C" fn videoframe_alignment() -> usize {
    VideoFrame::ALIGNMENT
}
pub struct VideoFramePool {
    inner: std::sync::Mutex<VideoFramePoolInner>,
}
struct VideoFramePoolInner {
    chunks: Vec<Box<[VideoFrame; 100]>>,
    free_list: Vec<*mut VideoFrame>,
    allocated: usize,
}
impl VideoFramePool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = VideoFramePoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        VideoFramePool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut VideoFrame {
        let mut inner = self.inner.lock().unwrap();
        if inner.free_list.is_empty() {
            inner.add_chunk();
        }
        let ptr = inner
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        inner.allocated += 1;
        ptr
    }
    pub fn free(&self, ptr: *mut VideoFrame) {
        let mut inner = self.inner.lock().unwrap();
        inner.free_list.push(ptr);
        inner.allocated -= 1;
    }
    pub fn allocated_count(&self) -> usize {
        let inner = self.inner.lock().unwrap();
        inner.allocated
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        let inner = self.inner.lock().unwrap();
        inner.chunks.len() * CHUNK_SIZE
    }
}
impl VideoFramePoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[VideoFrame; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for VideoFramePool {}
unsafe impl Sync for VideoFramePool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct CompressedFrame {
    pub metadata: FrameMetadata,
    pub data_count: u32,
    pub data: [u32; 1048576],
    pub data_size: u32,
    pub encrypted: u8,
}
impl CompressedFrame {
    pub const SIZE: usize = 4194376;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
    #[inline(always)]
    pub fn data(&self) -> &[u32] {
        &self.data[..self.data_count as usize]
    }
    #[inline(always)]
    pub fn data_mut(&mut self) -> &mut [u32] {
        let count = self.data_count as usize;
        &mut self.data[..count]
    }
    pub fn add_data(&mut self, item: u32) -> Result<(), &'static str> {
        if self.data_count >= 1048576 as u32 {
            return Err("Array full");
        }
        self.data[self.data_count as usize] = item;
        self.data_count += 1;
        Ok(())
    }
}
impl Default for CompressedFrame {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn compressedframe_size() -> usize {
    CompressedFrame::SIZE
}
#[no_mangle]
pub extern "C" fn compressedframe_alignment() -> usize {
    CompressedFrame::ALIGNMENT
}
pub struct CompressedFramePool {
    inner: std::sync::Mutex<CompressedFramePoolInner>,
}
struct CompressedFramePoolInner {
    chunks: Vec<Box<[CompressedFrame; 100]>>,
    free_list: Vec<*mut CompressedFrame>,
    allocated: usize,
}
impl CompressedFramePool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = CompressedFramePoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        CompressedFramePool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut CompressedFrame {
        let mut inner = self.inner.lock().unwrap();
        if inner.free_list.is_empty() {
            inner.add_chunk();
        }
        let ptr = inner
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        inner.allocated += 1;
        ptr
    }
    pub fn free(&self, ptr: *mut CompressedFrame) {
        let mut inner = self.inner.lock().unwrap();
        inner.free_list.push(ptr);
        inner.allocated -= 1;
    }
    pub fn allocated_count(&self) -> usize {
        let inner = self.inner.lock().unwrap();
        inner.allocated
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        let inner = self.inner.lock().unwrap();
        inner.chunks.len() * CHUNK_SIZE
    }
}
impl CompressedFramePoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[CompressedFrame; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for CompressedFramePool {}
unsafe impl Sync for CompressedFramePool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct TimestampSync {
    pub presentation_time: u64,
    pub decode_time: u64,
    pub capture_time: u64,
    pub render_time: u64,
    pub av_offset_us: i64,
    pub drift_compensation: i32,
}
impl TimestampSync {
    pub const SIZE: usize = 48;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for TimestampSync {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn timestampsync_size() -> usize {
    TimestampSync::SIZE
}
#[no_mangle]
pub extern "C" fn timestampsync_alignment() -> usize {
    TimestampSync::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_presentation_time_batch(items: &[TimestampSync]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].presentation_time;
            let v1 = chunk[1].presentation_time;
            let v2 = chunk[2].presentation_time;
            let v3 = chunk[3].presentation_time;
            let values = _mm256_set_epi64x(v3, v2, v1, v0);
            total = _mm256_add_epi64(total, values);
        }
        let mut sum = 0i64;
        sum += _mm256_extract_epi64(total, 0);
        sum += _mm256_extract_epi64(total, 1);
        sum += _mm256_extract_epi64(total, 2);
        sum += _mm256_extract_epi64(total, 3);
        let remainder = &items[items.len() & !3..];
        for item in remainder {
            sum += item.presentation_time;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_decode_time_batch(items: &[TimestampSync]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].decode_time;
            let v1 = chunk[1].decode_time;
            let v2 = chunk[2].decode_time;
            let v3 = chunk[3].decode_time;
            let values = _mm256_set_epi64x(v3, v2, v1, v0);
            total = _mm256_add_epi64(total, values);
        }
        let mut sum = 0i64;
        sum += _mm256_extract_epi64(total, 0);
        sum += _mm256_extract_epi64(total, 1);
        sum += _mm256_extract_epi64(total, 2);
        sum += _mm256_extract_epi64(total, 3);
        let remainder = &items[items.len() & !3..];
        for item in remainder {
            sum += item.decode_time;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_capture_time_batch(items: &[TimestampSync]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].capture_time;
            let v1 = chunk[1].capture_time;
            let v2 = chunk[2].capture_time;
            let v3 = chunk[3].capture_time;
            let values = _mm256_set_epi64x(v3, v2, v1, v0);
            total = _mm256_add_epi64(total, values);
        }
        let mut sum = 0i64;
        sum += _mm256_extract_epi64(total, 0);
        sum += _mm256_extract_epi64(total, 1);
        sum += _mm256_extract_epi64(total, 2);
        sum += _mm256_extract_epi64(total, 3);
        let remainder = &items[items.len() & !3..];
        for item in remainder {
            sum += item.capture_time;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_render_time_batch(items: &[TimestampSync]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].render_time;
            let v1 = chunk[1].render_time;
            let v2 = chunk[2].render_time;
            let v3 = chunk[3].render_time;
            let values = _mm256_set_epi64x(v3, v2, v1, v0);
            total = _mm256_add_epi64(total, values);
        }
        let mut sum = 0i64;
        sum += _mm256_extract_epi64(total, 0);
        sum += _mm256_extract_epi64(total, 1);
        sum += _mm256_extract_epi64(total, 2);
        sum += _mm256_extract_epi64(total, 3);
        let remainder = &items[items.len() & !3..];
        for item in remainder {
            sum += item.render_time;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_av_offset_us_batch(items: &[TimestampSync]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].av_offset_us;
            let v1 = chunk[1].av_offset_us;
            let v2 = chunk[2].av_offset_us;
            let v3 = chunk[3].av_offset_us;
            let values = _mm256_set_epi64x(v3, v2, v1, v0);
            total = _mm256_add_epi64(total, values);
        }
        let mut sum = 0i64;
        sum += _mm256_extract_epi64(total, 0);
        sum += _mm256_extract_epi64(total, 1);
        sum += _mm256_extract_epi64(total, 2);
        sum += _mm256_extract_epi64(total, 3);
        let remainder = &items[items.len() & !3..];
        for item in remainder {
            sum += item.av_offset_us;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_drift_compensation_batch(items: &[TimestampSync]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].drift_compensation as i32,
                chunk[6].drift_compensation as i32,
                chunk[5].drift_compensation as i32,
                chunk[4].drift_compensation as i32,
                chunk[3].drift_compensation as i32,
                chunk[2].drift_compensation as i32,
                chunk[1].drift_compensation as i32,
                chunk[0].drift_compensation as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.drift_compensation as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct BufferPool {
    pub buffer_ids_count: u32,
    pub buffer_ids: [u32; 64],
    pub buffer_states_count: u32,
    pub buffer_states: [u32; 64],
    pub total_memory_bytes: u64,
    pub total_buffers: u32,
    pub available_buffers: u32,
    pub used_buffers: u32,
}
impl BufferPool {
    pub const SIZE: usize = 544;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
    #[inline(always)]
    pub fn buffer_ids(&self) -> &[u32] {
        &self.buffer_ids[..self.buffer_ids_count as usize]
    }
    #[inline(always)]
    pub fn buffer_ids_mut(&mut self) -> &mut [u32] {
        let count = self.buffer_ids_count as usize;
        &mut self.buffer_ids[..count]
    }
    pub fn add_buffer_id(&mut self, item: u32) -> Result<(), &'static str> {
        if self.buffer_ids_count >= 64 as u32 {
            return Err("Array full");
        }
        self.buffer_ids[self.buffer_ids_count as usize] = item;
        self.buffer_ids_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn buffer_states(&self) -> &[u32] {
        &self.buffer_states[..self.buffer_states_count as usize]
    }
    #[inline(always)]
    pub fn buffer_states_mut(&mut self) -> &mut [u32] {
        let count = self.buffer_states_count as usize;
        &mut self.buffer_states[..count]
    }
    pub fn add_buffer_state(&mut self, item: u32) -> Result<(), &'static str> {
        if self.buffer_states_count >= 64 as u32 {
            return Err("Array full");
        }
        self.buffer_states[self.buffer_states_count as usize] = item;
        self.buffer_states_count += 1;
        Ok(())
    }
}
impl Default for BufferPool {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn bufferpool_size() -> usize {
    BufferPool::SIZE
}
#[no_mangle]
pub extern "C" fn bufferpool_alignment() -> usize {
    BufferPool::ALIGNMENT
}
pub struct BufferPoolPool {
    inner: std::sync::Mutex<BufferPoolPoolInner>,
}
struct BufferPoolPoolInner {
    chunks: Vec<Box<[BufferPool; 100]>>,
    free_list: Vec<*mut BufferPool>,
    allocated: usize,
}
impl BufferPoolPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = BufferPoolPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        BufferPoolPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut BufferPool {
        let mut inner = self.inner.lock().unwrap();
        if inner.free_list.is_empty() {
            inner.add_chunk();
        }
        let ptr = inner
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        inner.allocated += 1;
        ptr
    }
    pub fn free(&self, ptr: *mut BufferPool) {
        let mut inner = self.inner.lock().unwrap();
        inner.free_list.push(ptr);
        inner.allocated -= 1;
    }
    pub fn allocated_count(&self) -> usize {
        let inner = self.inner.lock().unwrap();
        inner.allocated
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        let inner = self.inner.lock().unwrap();
        inner.chunks.len() * CHUNK_SIZE
    }
}
impl BufferPoolPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[BufferPool; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for BufferPoolPool {}
unsafe impl Sync for BufferPoolPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct StreamStatistics {
    pub frames_processed: u64,
    pub frames_dropped: u64,
    pub bytes_processed: u64,
    pub average_bitrate: f32,
    pub average_framerate: f32,
    pub buffer_underruns: u32,
    pub buffer_overruns: u32,
    pub average_latency_ms: f32,
    pub jitter_ms: f32,
}
impl StreamStatistics {
    pub const SIZE: usize = 48;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for StreamStatistics {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn streamstatistics_size() -> usize {
    StreamStatistics::SIZE
}
#[no_mangle]
pub extern "C" fn streamstatistics_alignment() -> usize {
    StreamStatistics::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_frames_processed_batch(items: &[StreamStatistics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].frames_processed;
            let v1 = chunk[1].frames_processed;
            let v2 = chunk[2].frames_processed;
            let v3 = chunk[3].frames_processed;
            let values = _mm256_set_epi64x(v3, v2, v1, v0);
            total = _mm256_add_epi64(total, values);
        }
        let mut sum = 0i64;
        sum += _mm256_extract_epi64(total, 0);
        sum += _mm256_extract_epi64(total, 1);
        sum += _mm256_extract_epi64(total, 2);
        sum += _mm256_extract_epi64(total, 3);
        let remainder = &items[items.len() & !3..];
        for item in remainder {
            sum += item.frames_processed;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_frames_dropped_batch(items: &[StreamStatistics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].frames_dropped;
            let v1 = chunk[1].frames_dropped;
            let v2 = chunk[2].frames_dropped;
            let v3 = chunk[3].frames_dropped;
            let values = _mm256_set_epi64x(v3, v2, v1, v0);
            total = _mm256_add_epi64(total, values);
        }
        let mut sum = 0i64;
        sum += _mm256_extract_epi64(total, 0);
        sum += _mm256_extract_epi64(total, 1);
        sum += _mm256_extract_epi64(total, 2);
        sum += _mm256_extract_epi64(total, 3);
        let remainder = &items[items.len() & !3..];
        for item in remainder {
            sum += item.frames_dropped;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_bytes_processed_batch(items: &[StreamStatistics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].bytes_processed;
            let v1 = chunk[1].bytes_processed;
            let v2 = chunk[2].bytes_processed;
            let v3 = chunk[3].bytes_processed;
            let values = _mm256_set_epi64x(v3, v2, v1, v0);
            total = _mm256_add_epi64(total, values);
        }
        let mut sum = 0i64;
        sum += _mm256_extract_epi64(total, 0);
        sum += _mm256_extract_epi64(total, 1);
        sum += _mm256_extract_epi64(total, 2);
        sum += _mm256_extract_epi64(total, 3);
        let remainder = &items[items.len() & !3..];
        for item in remainder {
            sum += item.bytes_processed;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_buffer_underruns_batch(items: &[StreamStatistics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].buffer_underruns as i32,
                chunk[6].buffer_underruns as i32,
                chunk[5].buffer_underruns as i32,
                chunk[4].buffer_underruns as i32,
                chunk[3].buffer_underruns as i32,
                chunk[2].buffer_underruns as i32,
                chunk[1].buffer_underruns as i32,
                chunk[0].buffer_underruns as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.buffer_underruns as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_buffer_overruns_batch(items: &[StreamStatistics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].buffer_overruns as i32,
                chunk[6].buffer_overruns as i32,
                chunk[5].buffer_overruns as i32,
                chunk[4].buffer_overruns as i32,
                chunk[3].buffer_overruns as i32,
                chunk[2].buffer_overruns as i32,
                chunk[1].buffer_overruns as i32,
                chunk[0].buffer_overruns as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.buffer_overruns as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct EncodingConfig {
    pub params: CodecParameters,
    pub num_threads: u32,
    pub max_b_frames: u32,
    pub ref_frames: u32,
    pub rate_control_mode: u32,
    pub qp_min: u32,
    pub qp_max: u32,
    pub use_hardware_accel: u8,
    pub use_cabac: u8,
}
impl EncodingConfig {
    pub const SIZE: usize = 72;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for EncodingConfig {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn encodingconfig_size() -> usize {
    EncodingConfig::SIZE
}
#[no_mangle]
pub extern "C" fn encodingconfig_alignment() -> usize {
    EncodingConfig::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_num_threads_batch(items: &[EncodingConfig]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].num_threads as i32,
                chunk[6].num_threads as i32,
                chunk[5].num_threads as i32,
                chunk[4].num_threads as i32,
                chunk[3].num_threads as i32,
                chunk[2].num_threads as i32,
                chunk[1].num_threads as i32,
                chunk[0].num_threads as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.num_threads as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_max_b_frames_batch(items: &[EncodingConfig]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].max_b_frames as i32,
                chunk[6].max_b_frames as i32,
                chunk[5].max_b_frames as i32,
                chunk[4].max_b_frames as i32,
                chunk[3].max_b_frames as i32,
                chunk[2].max_b_frames as i32,
                chunk[1].max_b_frames as i32,
                chunk[0].max_b_frames as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.max_b_frames as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_ref_frames_batch(items: &[EncodingConfig]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].ref_frames as i32,
                chunk[6].ref_frames as i32,
                chunk[5].ref_frames as i32,
                chunk[4].ref_frames as i32,
                chunk[3].ref_frames as i32,
                chunk[2].ref_frames as i32,
                chunk[1].ref_frames as i32,
                chunk[0].ref_frames as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.ref_frames as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_rate_control_mode_batch(items: &[EncodingConfig]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].rate_control_mode as i32,
                chunk[6].rate_control_mode as i32,
                chunk[5].rate_control_mode as i32,
                chunk[4].rate_control_mode as i32,
                chunk[3].rate_control_mode as i32,
                chunk[2].rate_control_mode as i32,
                chunk[1].rate_control_mode as i32,
                chunk[0].rate_control_mode as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.rate_control_mode as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_qp_min_batch(items: &[EncodingConfig]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].qp_min as i32,
                chunk[6].qp_min as i32,
                chunk[5].qp_min as i32,
                chunk[4].qp_min as i32,
                chunk[3].qp_min as i32,
                chunk[2].qp_min as i32,
                chunk[1].qp_min as i32,
                chunk[0].qp_min as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.qp_min as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_qp_max_batch(items: &[EncodingConfig]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].qp_max as i32,
                chunk[6].qp_max as i32,
                chunk[5].qp_max as i32,
                chunk[4].qp_max as i32,
                chunk[3].qp_max as i32,
                chunk[2].qp_max as i32,
                chunk[1].qp_max as i32,
                chunk[0].qp_max as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.qp_max as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct DecodingResult {
    pub decode_time_us: u64,
    pub decoded_frames: u32,
    pub errors: u32,
    pub success: u8,
    pub error_message: [u8; 256],
}
impl DecodingResult {
    pub const SIZE: usize = 280;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for DecodingResult {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn decodingresult_size() -> usize {
    DecodingResult::SIZE
}
#[no_mangle]
pub extern "C" fn decodingresult_alignment() -> usize {
    DecodingResult::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct BitrateControl {
    pub target_bitrate: u32,
    pub min_bitrate: u32,
    pub max_bitrate: u32,
    pub current_bitrate: u32,
    pub buffer_fullness: f32,
    pub quantizer: u32,
    pub congestion_detected: u8,
}
impl BitrateControl {
    pub const SIZE: usize = 32;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
}
impl Default for BitrateControl {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn bitratecontrol_size() -> usize {
    BitrateControl::SIZE
}
#[no_mangle]
pub extern "C" fn bitratecontrol_alignment() -> usize {
    BitrateControl::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_target_bitrate_batch(items: &[BitrateControl]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].target_bitrate as i32,
                chunk[6].target_bitrate as i32,
                chunk[5].target_bitrate as i32,
                chunk[4].target_bitrate as i32,
                chunk[3].target_bitrate as i32,
                chunk[2].target_bitrate as i32,
                chunk[1].target_bitrate as i32,
                chunk[0].target_bitrate as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.target_bitrate as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_min_bitrate_batch(items: &[BitrateControl]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].min_bitrate as i32,
                chunk[6].min_bitrate as i32,
                chunk[5].min_bitrate as i32,
                chunk[4].min_bitrate as i32,
                chunk[3].min_bitrate as i32,
                chunk[2].min_bitrate as i32,
                chunk[1].min_bitrate as i32,
                chunk[0].min_bitrate as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.min_bitrate as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_max_bitrate_batch(items: &[BitrateControl]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].max_bitrate as i32,
                chunk[6].max_bitrate as i32,
                chunk[5].max_bitrate as i32,
                chunk[4].max_bitrate as i32,
                chunk[3].max_bitrate as i32,
                chunk[2].max_bitrate as i32,
                chunk[1].max_bitrate as i32,
                chunk[0].max_bitrate as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.max_bitrate as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_current_bitrate_batch(items: &[BitrateControl]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].current_bitrate as i32,
                chunk[6].current_bitrate as i32,
                chunk[5].current_bitrate as i32,
                chunk[4].current_bitrate as i32,
                chunk[3].current_bitrate as i32,
                chunk[2].current_bitrate as i32,
                chunk[1].current_bitrate as i32,
                chunk[0].current_bitrate as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.current_bitrate as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_quantizer_batch(items: &[BitrateControl]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].quantizer as i32,
                chunk[6].quantizer as i32,
                chunk[5].quantizer as i32,
                chunk[4].quantizer as i32,
                chunk[3].quantizer as i32,
                chunk[2].quantizer as i32,
                chunk[1].quantizer as i32,
                chunk[0].quantizer as i32,
            );
            total = _mm256_add_epi32(total, values);
        }
        let mut sum = 0i64;
        let result: [i32; 8] = std::mem::transmute(total);
        for val in &result {
            sum += *val as i64;
        }
        let remainder = &items[items.len() & !7..];
        for item in remainder {
            sum += item.quantizer as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct FrameBuffer {
    pub timestamp: u64,
    pub data_count: u32,
    pub data: [u32; 2097152],
    pub buffer_id: u32,
    pub state: u32,
    pub size: u32,
}
impl FrameBuffer {
    pub const SIZE: usize = 8388632;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
    #[inline(always)]
    pub fn data(&self) -> &[u32] {
        &self.data[..self.data_count as usize]
    }
    #[inline(always)]
    pub fn data_mut(&mut self) -> &mut [u32] {
        let count = self.data_count as usize;
        &mut self.data[..count]
    }
    pub fn add_data(&mut self, item: u32) -> Result<(), &'static str> {
        if self.data_count >= 2097152 as u32 {
            return Err("Array full");
        }
        self.data[self.data_count as usize] = item;
        self.data_count += 1;
        Ok(())
    }
}
impl Default for FrameBuffer {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn framebuffer_size() -> usize {
    FrameBuffer::SIZE
}
#[no_mangle]
pub extern "C" fn framebuffer_alignment() -> usize {
    FrameBuffer::ALIGNMENT
}
pub struct FrameBufferPool {
    inner: std::sync::Mutex<FrameBufferPoolInner>,
}
struct FrameBufferPoolInner {
    chunks: Vec<Box<[FrameBuffer; 100]>>,
    free_list: Vec<*mut FrameBuffer>,
    allocated: usize,
}
impl FrameBufferPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = FrameBufferPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        FrameBufferPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut FrameBuffer {
        let mut inner = self.inner.lock().unwrap();
        if inner.free_list.is_empty() {
            inner.add_chunk();
        }
        let ptr = inner
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        inner.allocated += 1;
        ptr
    }
    pub fn free(&self, ptr: *mut FrameBuffer) {
        let mut inner = self.inner.lock().unwrap();
        inner.free_list.push(ptr);
        inner.allocated -= 1;
    }
    pub fn allocated_count(&self) -> usize {
        let inner = self.inner.lock().unwrap();
        inner.allocated
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        let inner = self.inner.lock().unwrap();
        inner.chunks.len() * CHUNK_SIZE
    }
}
impl FrameBufferPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[FrameBuffer; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for FrameBufferPool {}
unsafe impl Sync for FrameBufferPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct NetworkPacket {
    pub timestamp: u64,
    pub payload_count: u32,
    pub payload: [u32; 1500],
    pub sequence_number: u32,
    pub payload_size: u32,
    pub marker_bit: u8,
}
impl NetworkPacket {
    pub const SIZE: usize = 6024;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
    #[inline(always)]
    pub fn payload(&self) -> &[u32] {
        &self.payload[..self.payload_count as usize]
    }
    #[inline(always)]
    pub fn payload_mut(&mut self) -> &mut [u32] {
        let count = self.payload_count as usize;
        &mut self.payload[..count]
    }
    pub fn add_payload(&mut self, item: u32) -> Result<(), &'static str> {
        if self.payload_count >= 1500 as u32 {
            return Err("Array full");
        }
        self.payload[self.payload_count as usize] = item;
        self.payload_count += 1;
        Ok(())
    }
}
impl Default for NetworkPacket {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn networkpacket_size() -> usize {
    NetworkPacket::SIZE
}
#[no_mangle]
pub extern "C" fn networkpacket_alignment() -> usize {
    NetworkPacket::ALIGNMENT
}
pub struct NetworkPacketPool {
    inner: std::sync::Mutex<NetworkPacketPoolInner>,
}
struct NetworkPacketPoolInner {
    chunks: Vec<Box<[NetworkPacket; 100]>>,
    free_list: Vec<*mut NetworkPacket>,
    allocated: usize,
}
impl NetworkPacketPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = NetworkPacketPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        NetworkPacketPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut NetworkPacket {
        let mut inner = self.inner.lock().unwrap();
        if inner.free_list.is_empty() {
            inner.add_chunk();
        }
        let ptr = inner
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        inner.allocated += 1;
        ptr
    }
    pub fn free(&self, ptr: *mut NetworkPacket) {
        let mut inner = self.inner.lock().unwrap();
        inner.free_list.push(ptr);
        inner.allocated -= 1;
    }
    pub fn allocated_count(&self) -> usize {
        let inner = self.inner.lock().unwrap();
        inner.allocated
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        let inner = self.inner.lock().unwrap();
        inner.chunks.len() * CHUNK_SIZE
    }
}
impl NetworkPacketPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[NetworkPacket; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for NetworkPacketPool {}
unsafe impl Sync for NetworkPacketPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct JitterBuffer {
    pub packet_sequence_count: u32,
    pub packet_sequence: [u32; 256],
    pub packet_timestamps_count: u32,
    pub packet_timestamps: [u64; 256],
    pub buffer_size: u32,
    pub head_index: u32,
    pub tail_index: u32,
    pub missing_packets: u32,
}
impl JitterBuffer {
    pub const SIZE: usize = 3104;
    pub const ALIGNMENT: usize = 8;
    #[inline(always)]
    pub unsafe fn from_ptr(ptr: *const u8) -> &'static Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr"
        );
        &*(ptr as *const Self)
    }
    #[inline(always)]
    pub unsafe fn from_ptr_mut(ptr: *mut u8) -> &'static mut Self {
        debug_assert!(!ptr.is_null(), "Null pointer passed to from_ptr_mut");
        debug_assert!(
            ptr as usize % Self::ALIGNMENT == 0,
            "Misaligned pointer passed to from_ptr_mut"
        );
        &mut *(ptr as *mut Self)
    }
    #[inline(always)]
    pub fn packet_sequence(&self) -> &[u32] {
        &self.packet_sequence[..self.packet_sequence_count as usize]
    }
    #[inline(always)]
    pub fn packet_sequence_mut(&mut self) -> &mut [u32] {
        let count = self.packet_sequence_count as usize;
        &mut self.packet_sequence[..count]
    }
    pub fn add_packet_sequence(&mut self, item: u32) -> Result<(), &'static str> {
        if self.packet_sequence_count >= 256 as u32 {
            return Err("Array full");
        }
        self.packet_sequence[self.packet_sequence_count as usize] = item;
        self.packet_sequence_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn packet_timestamps(&self) -> &[u64] {
        &self.packet_timestamps[..self.packet_timestamps_count as usize]
    }
    #[inline(always)]
    pub fn packet_timestamps_mut(&mut self) -> &mut [u64] {
        let count = self.packet_timestamps_count as usize;
        &mut self.packet_timestamps[..count]
    }
    pub fn add_packet_timestamp(&mut self, item: u64) -> Result<(), &'static str> {
        if self.packet_timestamps_count >= 256 as u32 {
            return Err("Array full");
        }
        self.packet_timestamps[self.packet_timestamps_count as usize] = item;
        self.packet_timestamps_count += 1;
        Ok(())
    }
}
impl Default for JitterBuffer {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn jitterbuffer_size() -> usize {
    JitterBuffer::SIZE
}
#[no_mangle]
pub extern "C" fn jitterbuffer_alignment() -> usize {
    JitterBuffer::ALIGNMENT
}
pub struct JitterBufferPool {
    inner: std::sync::Mutex<JitterBufferPoolInner>,
}
struct JitterBufferPoolInner {
    chunks: Vec<Box<[JitterBuffer; 100]>>,
    free_list: Vec<*mut JitterBuffer>,
    allocated: usize,
}
impl JitterBufferPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = JitterBufferPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        JitterBufferPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut JitterBuffer {
        let mut inner = self.inner.lock().unwrap();
        if inner.free_list.is_empty() {
            inner.add_chunk();
        }
        let ptr = inner
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        inner.allocated += 1;
        ptr
    }
    pub fn free(&self, ptr: *mut JitterBuffer) {
        let mut inner = self.inner.lock().unwrap();
        inner.free_list.push(ptr);
        inner.allocated -= 1;
    }
    pub fn allocated_count(&self) -> usize {
        let inner = self.inner.lock().unwrap();
        inner.allocated
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        let inner = self.inner.lock().unwrap();
        inner.chunks.len() * CHUNK_SIZE
    }
}
impl JitterBufferPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[JitterBuffer; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for JitterBufferPool {}
unsafe impl Sync for JitterBufferPool {}
