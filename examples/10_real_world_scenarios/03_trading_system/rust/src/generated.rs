#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum OrderSide {
    BUY = 0,
    SELL = 1,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum OrderType {
    MARKET = 0,
    LIMIT = 1,
    STOP = 2,
    STOP_LIMIT = 3,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum OrderStatus {
    PENDING = 0,
    OPEN = 1,
    PARTIALLY_FILLED = 2,
    FILLED = 3,
    CANCELLED = 4,
    REJECTED = 5,
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Price {
    pub value: i64,
    pub scale: u32,
}
impl Price {
    pub const SIZE: usize = 16;
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
impl Default for Price {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn price_size() -> usize {
    Price::SIZE
}
#[no_mangle]
pub extern "C" fn price_alignment() -> usize {
    Price::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_value_batch(items: &[Price]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].value;
            let v1 = chunk[1].value;
            let v2 = chunk[2].value;
            let v3 = chunk[3].value;
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
            sum += item.value;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_scale_batch(items: &[Price]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].scale as i32,
                chunk[6].scale as i32,
                chunk[5].scale as i32,
                chunk[4].scale as i32,
                chunk[3].scale as i32,
                chunk[2].scale as i32,
                chunk[1].scale as i32,
                chunk[0].scale as i32,
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
            sum += item.scale as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Order {
    pub order_id: u64,
    pub timestamp_ns: u64,
    pub price: Price,
    pub quantity: u64,
    pub filled_quantity: u64,
    pub remaining_quantity: u64,
    pub side: u32,
    pub order_type: u32,
    pub status: u32,
    pub symbol: [u8; 16],
}
impl Order {
    pub const SIZE: usize = 88;
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
impl Default for Order {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn order_size() -> usize {
    Order::SIZE
}
#[no_mangle]
pub extern "C" fn order_alignment() -> usize {
    Order::ALIGNMENT
}
pub struct OrderPool {
    inner: std::sync::Mutex<OrderPoolInner>,
}
struct OrderPoolInner {
    chunks: Vec<Box<[Order; 100]>>,
    free_list: Vec<*mut Order>,
    allocated: usize,
}
impl OrderPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = OrderPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        OrderPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Order {
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
    pub fn free(&self, ptr: *mut Order) {
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
impl OrderPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Order; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for OrderPool {}
unsafe impl Sync for OrderPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Trade {
    pub trade_id: u64,
    pub timestamp_ns: u64,
    pub buy_order_id: u64,
    pub sell_order_id: u64,
    pub price: Price,
    pub quantity: u64,
}
impl Trade {
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
impl Default for Trade {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn trade_size() -> usize {
    Trade::SIZE
}
#[no_mangle]
pub extern "C" fn trade_alignment() -> usize {
    Trade::ALIGNMENT
}
pub struct TradePool {
    inner: std::sync::Mutex<TradePoolInner>,
}
struct TradePoolInner {
    chunks: Vec<Box<[Trade; 100]>>,
    free_list: Vec<*mut Trade>,
    allocated: usize,
}
impl TradePool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = TradePoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        TradePool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Trade {
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
    pub fn free(&self, ptr: *mut Trade) {
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
impl TradePoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Trade; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for TradePool {}
unsafe impl Sync for TradePool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct OrderBook {
    pub bid_prices_count: u32,
    pub bid_prices: [Price; 100],
    pub bid_quantities_count: u32,
    pub bid_quantities: [u64; 100],
    pub ask_prices_count: u32,
    pub ask_prices: [Price; 100],
    pub ask_quantities_count: u32,
    pub ask_quantities: [u64; 100],
    pub sequence_number: u64,
    pub bid_count: u32,
    pub ask_count: u32,
    pub symbol: [u8; 16],
}
impl OrderBook {
    pub const SIZE: usize = 4864;
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
    pub fn bid_prices(&self) -> &[Price] {
        &self.bid_prices[..self.bid_prices_count as usize]
    }
    #[inline(always)]
    pub fn bid_prices_mut(&mut self) -> &mut [Price] {
        let count = self.bid_prices_count as usize;
        &mut self.bid_prices[..count]
    }
    pub fn add_bid_price(&mut self, item: Price) -> Result<(), &'static str> {
        if self.bid_prices_count >= 100 as u32 {
            return Err("Array full");
        }
        self.bid_prices[self.bid_prices_count as usize] = item;
        self.bid_prices_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn bid_quantities(&self) -> &[u64] {
        &self.bid_quantities[..self.bid_quantities_count as usize]
    }
    #[inline(always)]
    pub fn bid_quantities_mut(&mut self) -> &mut [u64] {
        let count = self.bid_quantities_count as usize;
        &mut self.bid_quantities[..count]
    }
    pub fn add_bid_quantitie(&mut self, item: u64) -> Result<(), &'static str> {
        if self.bid_quantities_count >= 100 as u32 {
            return Err("Array full");
        }
        self.bid_quantities[self.bid_quantities_count as usize] = item;
        self.bid_quantities_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn ask_prices(&self) -> &[Price] {
        &self.ask_prices[..self.ask_prices_count as usize]
    }
    #[inline(always)]
    pub fn ask_prices_mut(&mut self) -> &mut [Price] {
        let count = self.ask_prices_count as usize;
        &mut self.ask_prices[..count]
    }
    pub fn add_ask_price(&mut self, item: Price) -> Result<(), &'static str> {
        if self.ask_prices_count >= 100 as u32 {
            return Err("Array full");
        }
        self.ask_prices[self.ask_prices_count as usize] = item;
        self.ask_prices_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn ask_quantities(&self) -> &[u64] {
        &self.ask_quantities[..self.ask_quantities_count as usize]
    }
    #[inline(always)]
    pub fn ask_quantities_mut(&mut self) -> &mut [u64] {
        let count = self.ask_quantities_count as usize;
        &mut self.ask_quantities[..count]
    }
    pub fn add_ask_quantitie(&mut self, item: u64) -> Result<(), &'static str> {
        if self.ask_quantities_count >= 100 as u32 {
            return Err("Array full");
        }
        self.ask_quantities[self.ask_quantities_count as usize] = item;
        self.ask_quantities_count += 1;
        Ok(())
    }
}
impl Default for OrderBook {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn orderbook_size() -> usize {
    OrderBook::SIZE
}
#[no_mangle]
pub extern "C" fn orderbook_alignment() -> usize {
    OrderBook::ALIGNMENT
}
pub struct OrderBookPool {
    inner: std::sync::Mutex<OrderBookPoolInner>,
}
struct OrderBookPoolInner {
    chunks: Vec<Box<[OrderBook; 100]>>,
    free_list: Vec<*mut OrderBook>,
    allocated: usize,
}
impl OrderBookPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = OrderBookPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        OrderBookPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut OrderBook {
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
    pub fn free(&self, ptr: *mut OrderBook) {
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
impl OrderBookPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[OrderBook; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for OrderBookPool {}
unsafe impl Sync for OrderBookPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct MarketData {
    pub timestamp_ns: u64,
    pub last_price: Price,
    pub bid_price: Price,
    pub ask_price: Price,
    pub volume: u64,
    pub open: Price,
    pub high: Price,
    pub low: Price,
    pub symbol: [u8; 16],
}
impl MarketData {
    pub const SIZE: usize = 128;
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
impl Default for MarketData {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn marketdata_size() -> usize {
    MarketData::SIZE
}
#[no_mangle]
pub extern "C" fn marketdata_alignment() -> usize {
    MarketData::ALIGNMENT
}
pub struct MarketDataPool {
    inner: std::sync::Mutex<MarketDataPoolInner>,
}
struct MarketDataPoolInner {
    chunks: Vec<Box<[MarketData; 100]>>,
    free_list: Vec<*mut MarketData>,
    allocated: usize,
}
impl MarketDataPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = MarketDataPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        MarketDataPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut MarketData {
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
    pub fn free(&self, ptr: *mut MarketData) {
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
impl MarketDataPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[MarketData; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for MarketDataPool {}
unsafe impl Sync for MarketDataPool {}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_timestamp_ns_batch(items: &[MarketData]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].timestamp_ns;
            let v1 = chunk[1].timestamp_ns;
            let v2 = chunk[2].timestamp_ns;
            let v3 = chunk[3].timestamp_ns;
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
            sum += item.timestamp_ns;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_volume_batch(items: &[MarketData]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].volume;
            let v1 = chunk[1].volume;
            let v2 = chunk[2].volume;
            let v3 = chunk[3].volume;
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
            sum += item.volume;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct RiskLimits {
    pub max_position_size: u64,
    pub max_order_value: u64,
    pub max_price_deviation: Price,
    pub max_orders_per_second: u32,
}
impl RiskLimits {
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
impl Default for RiskLimits {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn risklimits_size() -> usize {
    RiskLimits::SIZE
}
#[no_mangle]
pub extern "C" fn risklimits_alignment() -> usize {
    RiskLimits::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_max_position_size_batch(items: &[RiskLimits]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].max_position_size;
            let v1 = chunk[1].max_position_size;
            let v2 = chunk[2].max_position_size;
            let v3 = chunk[3].max_position_size;
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
            sum += item.max_position_size;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_max_order_value_batch(items: &[RiskLimits]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].max_order_value;
            let v1 = chunk[1].max_order_value;
            let v2 = chunk[2].max_order_value;
            let v3 = chunk[3].max_order_value;
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
            sum += item.max_order_value;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_max_orders_per_second_batch(items: &[RiskLimits]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].max_orders_per_second as i32,
                chunk[6].max_orders_per_second as i32,
                chunk[5].max_orders_per_second as i32,
                chunk[4].max_orders_per_second as i32,
                chunk[3].max_orders_per_second as i32,
                chunk[2].max_orders_per_second as i32,
                chunk[1].max_orders_per_second as i32,
                chunk[0].max_orders_per_second as i32,
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
            sum += item.max_orders_per_second as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Position {
    pub quantity: i64,
    pub average_price: Price,
    pub unrealized_pnl: Price,
    pub realized_pnl: Price,
    pub symbol: [u8; 16],
}
impl Position {
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
impl Default for Position {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn position_size() -> usize {
    Position::SIZE
}
#[no_mangle]
pub extern "C" fn position_alignment() -> usize {
    Position::ALIGNMENT
}
pub struct PositionPool {
    inner: std::sync::Mutex<PositionPoolInner>,
}
struct PositionPoolInner {
    chunks: Vec<Box<[Position; 100]>>,
    free_list: Vec<*mut Position>,
    allocated: usize,
}
impl PositionPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = PositionPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        PositionPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Position {
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
    pub fn free(&self, ptr: *mut Position) {
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
impl PositionPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Position; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for PositionPool {}
unsafe impl Sync for PositionPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct TradingStats {
    pub total_orders: u64,
    pub total_trades: u64,
    pub total_volume: u64,
    pub average_latency_ns: u64,
    pub orders_per_second: u32,
    pub trades_per_second: u32,
}
impl TradingStats {
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
impl Default for TradingStats {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn tradingstats_size() -> usize {
    TradingStats::SIZE
}
#[no_mangle]
pub extern "C" fn tradingstats_alignment() -> usize {
    TradingStats::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_total_orders_batch(items: &[TradingStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].total_orders;
            let v1 = chunk[1].total_orders;
            let v2 = chunk[2].total_orders;
            let v3 = chunk[3].total_orders;
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
            sum += item.total_orders;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_total_trades_batch(items: &[TradingStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].total_trades;
            let v1 = chunk[1].total_trades;
            let v2 = chunk[2].total_trades;
            let v3 = chunk[3].total_trades;
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
            sum += item.total_trades;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_total_volume_batch(items: &[TradingStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].total_volume;
            let v1 = chunk[1].total_volume;
            let v2 = chunk[2].total_volume;
            let v3 = chunk[3].total_volume;
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
            sum += item.total_volume;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_average_latency_ns_batch(items: &[TradingStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].average_latency_ns;
            let v1 = chunk[1].average_latency_ns;
            let v2 = chunk[2].average_latency_ns;
            let v3 = chunk[3].average_latency_ns;
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
            sum += item.average_latency_ns;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_orders_per_second_batch(items: &[TradingStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].orders_per_second as i32,
                chunk[6].orders_per_second as i32,
                chunk[5].orders_per_second as i32,
                chunk[4].orders_per_second as i32,
                chunk[3].orders_per_second as i32,
                chunk[2].orders_per_second as i32,
                chunk[1].orders_per_second as i32,
                chunk[0].orders_per_second as i32,
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
            sum += item.orders_per_second as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_trades_per_second_batch(items: &[TradingStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].trades_per_second as i32,
                chunk[6].trades_per_second as i32,
                chunk[5].trades_per_second as i32,
                chunk[4].trades_per_second as i32,
                chunk[3].trades_per_second as i32,
                chunk[2].trades_per_second as i32,
                chunk[1].trades_per_second as i32,
                chunk[0].trades_per_second as i32,
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
            sum += item.trades_per_second as i64;
        }
        sum
    }
}
