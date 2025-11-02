#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum SensorType {
    TEMPERATURE = 0,
    HUMIDITY = 1,
    PRESSURE = 2,
    LIGHT = 3,
    MOTION = 4,
    PROXIMITY = 5,
    ACCELEROMETER = 6,
    GYROSCOPE = 7,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum DeviceStatus {
    ONLINE = 0,
    OFFLINE = 1,
    ERROR = 2,
    MAINTENANCE = 3,
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct SensorReading {
    pub device_id: u64,
    pub timestamp_us: u64,
    pub sensor_type: u32,
    pub value: f32,
    pub quality: u32,
}
impl SensorReading {
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
impl Default for SensorReading {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn sensorreading_size() -> usize {
    SensorReading::SIZE
}
#[no_mangle]
pub extern "C" fn sensorreading_alignment() -> usize {
    SensorReading::ALIGNMENT
}
pub struct SensorReadingPool {
    inner: std::sync::Mutex<SensorReadingPoolInner>,
}
struct SensorReadingPoolInner {
    chunks: Vec<Box<[SensorReading; 100]>>,
    free_list: Vec<*mut SensorReading>,
    allocated: usize,
}
impl SensorReadingPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = SensorReadingPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        SensorReadingPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut SensorReading {
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
    pub fn free(&self, ptr: *mut SensorReading) {
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
impl SensorReadingPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[SensorReading; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for SensorReadingPool {}
unsafe impl Sync for SensorReadingPool {}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_device_id_batch(items: &[SensorReading]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].device_id;
            let v1 = chunk[1].device_id;
            let v2 = chunk[2].device_id;
            let v3 = chunk[3].device_id;
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
            sum += item.device_id;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_timestamp_us_batch(items: &[SensorReading]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].timestamp_us;
            let v1 = chunk[1].timestamp_us;
            let v2 = chunk[2].timestamp_us;
            let v3 = chunk[3].timestamp_us;
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
            sum += item.timestamp_us;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_sensor_type_batch(items: &[SensorReading]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].sensor_type as i32,
                chunk[6].sensor_type as i32,
                chunk[5].sensor_type as i32,
                chunk[4].sensor_type as i32,
                chunk[3].sensor_type as i32,
                chunk[2].sensor_type as i32,
                chunk[1].sensor_type as i32,
                chunk[0].sensor_type as i32,
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
            sum += item.sensor_type as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_quality_batch(items: &[SensorReading]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].quality as i32,
                chunk[6].quality as i32,
                chunk[5].quality as i32,
                chunk[4].quality as i32,
                chunk[3].quality as i32,
                chunk[2].quality as i32,
                chunk[1].quality as i32,
                chunk[0].quality as i32,
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
            sum += item.quality as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct DeviceTelemetry {
    pub device_id: u64,
    pub timestamp_us: u64,
    pub battery_level: u32,
    pub temperature: f32,
    pub signal_strength: u32,
    pub memory_usage: u32,
    pub cpu_usage: u32,
    pub status: u32,
}
impl DeviceTelemetry {
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
impl Default for DeviceTelemetry {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn devicetelemetry_size() -> usize {
    DeviceTelemetry::SIZE
}
#[no_mangle]
pub extern "C" fn devicetelemetry_alignment() -> usize {
    DeviceTelemetry::ALIGNMENT
}
pub struct DeviceTelemetryPool {
    inner: std::sync::Mutex<DeviceTelemetryPoolInner>,
}
struct DeviceTelemetryPoolInner {
    chunks: Vec<Box<[DeviceTelemetry; 100]>>,
    free_list: Vec<*mut DeviceTelemetry>,
    allocated: usize,
}
impl DeviceTelemetryPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = DeviceTelemetryPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        DeviceTelemetryPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut DeviceTelemetry {
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
    pub fn free(&self, ptr: *mut DeviceTelemetry) {
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
impl DeviceTelemetryPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[DeviceTelemetry; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for DeviceTelemetryPool {}
unsafe impl Sync for DeviceTelemetryPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct TimeSeriesData {
    pub device_id: u64,
    pub timestamps_count: u32,
    pub timestamps: [u64; 1000],
    pub values_count: u32,
    pub values: [f32; 1000],
    pub sensor_type: u32,
    pub count: u32,
}
impl TimeSeriesData {
    pub const SIZE: usize = 12024;
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
    pub fn timestamps(&self) -> &[u64] {
        &self.timestamps[..self.timestamps_count as usize]
    }
    #[inline(always)]
    pub fn timestamps_mut(&mut self) -> &mut [u64] {
        let count = self.timestamps_count as usize;
        &mut self.timestamps[..count]
    }
    pub fn add_timestamp(&mut self, item: u64) -> Result<(), &'static str> {
        if self.timestamps_count >= 1000 as u32 {
            return Err("Array full");
        }
        self.timestamps[self.timestamps_count as usize] = item;
        self.timestamps_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn values(&self) -> &[f32] {
        &self.values[..self.values_count as usize]
    }
    #[inline(always)]
    pub fn values_mut(&mut self) -> &mut [f32] {
        let count = self.values_count as usize;
        &mut self.values[..count]
    }
    pub fn add_value(&mut self, item: f32) -> Result<(), &'static str> {
        if self.values_count >= 1000 as u32 {
            return Err("Array full");
        }
        self.values[self.values_count as usize] = item;
        self.values_count += 1;
        Ok(())
    }
}
impl Default for TimeSeriesData {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn timeseriesdata_size() -> usize {
    TimeSeriesData::SIZE
}
#[no_mangle]
pub extern "C" fn timeseriesdata_alignment() -> usize {
    TimeSeriesData::ALIGNMENT
}
pub struct TimeSeriesDataPool {
    inner: std::sync::Mutex<TimeSeriesDataPoolInner>,
}
struct TimeSeriesDataPoolInner {
    chunks: Vec<Box<[TimeSeriesData; 100]>>,
    free_list: Vec<*mut TimeSeriesData>,
    allocated: usize,
}
impl TimeSeriesDataPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = TimeSeriesDataPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        TimeSeriesDataPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut TimeSeriesData {
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
    pub fn free(&self, ptr: *mut TimeSeriesData) {
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
impl TimeSeriesDataPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[TimeSeriesData; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for TimeSeriesDataPool {}
unsafe impl Sync for TimeSeriesDataPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct AggregatedMetrics {
    pub device_id: u64,
    pub start_time_us: u64,
    pub end_time_us: u64,
    pub min_value: f32,
    pub max_value: f32,
    pub avg_value: f32,
    pub stddev: f32,
    pub sample_count: u32,
}
impl AggregatedMetrics {
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
impl Default for AggregatedMetrics {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn aggregatedmetrics_size() -> usize {
    AggregatedMetrics::SIZE
}
#[no_mangle]
pub extern "C" fn aggregatedmetrics_alignment() -> usize {
    AggregatedMetrics::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_device_id_batch(items: &[AggregatedMetrics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].device_id;
            let v1 = chunk[1].device_id;
            let v2 = chunk[2].device_id;
            let v3 = chunk[3].device_id;
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
            sum += item.device_id;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_start_time_us_batch(items: &[AggregatedMetrics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].start_time_us;
            let v1 = chunk[1].start_time_us;
            let v2 = chunk[2].start_time_us;
            let v3 = chunk[3].start_time_us;
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
            sum += item.start_time_us;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_end_time_us_batch(items: &[AggregatedMetrics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].end_time_us;
            let v1 = chunk[1].end_time_us;
            let v2 = chunk[2].end_time_us;
            let v3 = chunk[3].end_time_us;
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
            sum += item.end_time_us;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_sample_count_batch(items: &[AggregatedMetrics]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].sample_count as i32,
                chunk[6].sample_count as i32,
                chunk[5].sample_count as i32,
                chunk[4].sample_count as i32,
                chunk[3].sample_count as i32,
                chunk[2].sample_count as i32,
                chunk[1].sample_count as i32,
                chunk[0].sample_count as i32,
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
            sum += item.sample_count as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct DeviceGroup {
    pub device_ids_count: u32,
    pub device_ids: [u64; 256],
    pub group_id: u32,
    pub device_count: u32,
    pub group_name: [u8; 64],
}
impl DeviceGroup {
    pub const SIZE: usize = 2128;
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
    pub fn device_ids(&self) -> &[u64] {
        &self.device_ids[..self.device_ids_count as usize]
    }
    #[inline(always)]
    pub fn device_ids_mut(&mut self) -> &mut [u64] {
        let count = self.device_ids_count as usize;
        &mut self.device_ids[..count]
    }
    pub fn add_device_id(&mut self, item: u64) -> Result<(), &'static str> {
        if self.device_ids_count >= 256 as u32 {
            return Err("Array full");
        }
        self.device_ids[self.device_ids_count as usize] = item;
        self.device_ids_count += 1;
        Ok(())
    }
}
impl Default for DeviceGroup {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn devicegroup_size() -> usize {
    DeviceGroup::SIZE
}
#[no_mangle]
pub extern "C" fn devicegroup_alignment() -> usize {
    DeviceGroup::ALIGNMENT
}
pub struct DeviceGroupPool {
    inner: std::sync::Mutex<DeviceGroupPoolInner>,
}
struct DeviceGroupPoolInner {
    chunks: Vec<Box<[DeviceGroup; 100]>>,
    free_list: Vec<*mut DeviceGroup>,
    allocated: usize,
}
impl DeviceGroupPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = DeviceGroupPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        DeviceGroupPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut DeviceGroup {
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
    pub fn free(&self, ptr: *mut DeviceGroup) {
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
impl DeviceGroupPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[DeviceGroup; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for DeviceGroupPool {}
unsafe impl Sync for DeviceGroupPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct EventStream {
    pub event_id: u64,
    pub timestamp_us: u64,
    pub device_id: u64,
    pub event_type: u32,
    pub payload: [u8; 256],
}
impl EventStream {
    pub const SIZE: usize = 288;
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
impl Default for EventStream {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn eventstream_size() -> usize {
    EventStream::SIZE
}
#[no_mangle]
pub extern "C" fn eventstream_alignment() -> usize {
    EventStream::ALIGNMENT
}
pub struct EventStreamPool {
    inner: std::sync::Mutex<EventStreamPoolInner>,
}
struct EventStreamPoolInner {
    chunks: Vec<Box<[EventStream; 100]>>,
    free_list: Vec<*mut EventStream>,
    allocated: usize,
}
impl EventStreamPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = EventStreamPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        EventStreamPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut EventStream {
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
    pub fn free(&self, ptr: *mut EventStream) {
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
impl EventStreamPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[EventStream; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for EventStreamPool {}
unsafe impl Sync for EventStreamPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct SystemStats {
    pub total_devices: u64,
    pub online_devices: u64,
    pub total_readings: u64,
    pub bytes_processed: u64,
    pub readings_per_second: u32,
    pub average_latency_ms: f32,
}
impl SystemStats {
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
impl Default for SystemStats {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn systemstats_size() -> usize {
    SystemStats::SIZE
}
#[no_mangle]
pub extern "C" fn systemstats_alignment() -> usize {
    SystemStats::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_total_devices_batch(items: &[SystemStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].total_devices;
            let v1 = chunk[1].total_devices;
            let v2 = chunk[2].total_devices;
            let v3 = chunk[3].total_devices;
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
            sum += item.total_devices;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_online_devices_batch(items: &[SystemStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].online_devices;
            let v1 = chunk[1].online_devices;
            let v2 = chunk[2].online_devices;
            let v3 = chunk[3].online_devices;
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
            sum += item.online_devices;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_total_readings_batch(items: &[SystemStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].total_readings;
            let v1 = chunk[1].total_readings;
            let v2 = chunk[2].total_readings;
            let v3 = chunk[3].total_readings;
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
            sum += item.total_readings;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_bytes_processed_batch(items: &[SystemStats]) -> i64 {
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
    pub unsafe fn sum_readings_per_second_batch(items: &[SystemStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].readings_per_second as i32,
                chunk[6].readings_per_second as i32,
                chunk[5].readings_per_second as i32,
                chunk[4].readings_per_second as i32,
                chunk[3].readings_per_second as i32,
                chunk[2].readings_per_second as i32,
                chunk[1].readings_per_second as i32,
                chunk[0].readings_per_second as i32,
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
            sum += item.readings_per_second as i64;
        }
        sum
    }
}
