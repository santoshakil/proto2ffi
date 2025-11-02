#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum TransactionStatus {
    PENDING = 0,
    CONFIRMED = 1,
    FAILED = 2,
    DROPPED = 3,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum ContractType {
    TRANSFER = 0,
    SMART_CONTRACT = 1,
    TOKEN_MINT = 2,
    TOKEN_BURN = 3,
    NFT_MINT = 4,
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Hash256 {
    pub data: [u8; 32],
}
impl Hash256 {
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
impl Default for Hash256 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn hash256_size() -> usize {
    Hash256::SIZE
}
#[no_mangle]
pub extern "C" fn hash256_alignment() -> usize {
    Hash256::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Address {
    pub data: [u8; 20],
}
impl Address {
    pub const SIZE: usize = 24;
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
impl Default for Address {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn address_size() -> usize {
    Address::SIZE
}
#[no_mangle]
pub extern "C" fn address_alignment() -> usize {
    Address::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Signature {
    pub v: u32,
    pub r: [u8; 32],
    pub s: [u8; 32],
}
impl Signature {
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
impl Default for Signature {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn signature_size() -> usize {
    Signature::SIZE
}
#[no_mangle]
pub extern "C" fn signature_alignment() -> usize {
    Signature::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Transaction {
    pub value: u64,
    pub nonce: u64,
    pub gas_limit: u64,
    pub gas_price: u64,
    pub gas_used: u64,
    pub block_number: u64,
    pub timestamp: u64,
    pub status: u32,
    pub transaction_index: u32,
    pub hash: [u8; 32],
    pub from_address: [u8; 20],
    pub to_address: [u8; 20],
    pub data: [u8; 4096],
}
impl Transaction {
    pub const SIZE: usize = 4232;
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
impl Default for Transaction {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn transaction_size() -> usize {
    Transaction::SIZE
}
#[no_mangle]
pub extern "C" fn transaction_alignment() -> usize {
    Transaction::ALIGNMENT
}
pub struct TransactionPool {
    inner: std::sync::Mutex<TransactionPoolInner>,
}
struct TransactionPoolInner {
    chunks: Vec<Box<[Transaction; 100]>>,
    free_list: Vec<*mut Transaction>,
    allocated: usize,
}
impl TransactionPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = TransactionPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        TransactionPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Transaction {
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
    pub fn free(&self, ptr: *mut Transaction) {
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
impl TransactionPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Transaction; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for TransactionPool {}
unsafe impl Sync for TransactionPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Block {
    pub block_number: u64,
    pub difficulty: u64,
    pub total_difficulty: u64,
    pub size: u64,
    pub gas_limit: u64,
    pub gas_used: u64,
    pub timestamp: u64,
    pub nonce: u64,
    pub transaction_count: u32,
    pub hash: [u8; 32],
    pub previous_hash: [u8; 32],
    pub state_root: [u8; 32],
    pub transactions_root: [u8; 32],
    pub receipts_root: [u8; 32],
    pub miner_address: [u8; 20],
}
impl Block {
    pub const SIZE: usize = 248;
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
impl Default for Block {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn block_size() -> usize {
    Block::SIZE
}
#[no_mangle]
pub extern "C" fn block_alignment() -> usize {
    Block::ALIGNMENT
}
pub struct BlockPool {
    inner: std::sync::Mutex<BlockPoolInner>,
}
struct BlockPoolInner {
    chunks: Vec<Box<[Block; 100]>>,
    free_list: Vec<*mut Block>,
    allocated: usize,
}
impl BlockPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = BlockPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        BlockPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Block {
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
    pub fn free(&self, ptr: *mut Block) {
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
impl BlockPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Block; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for BlockPool {}
unsafe impl Sync for BlockPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct TransactionReceipt {
    pub block_number: u64,
    pub gas_used: u64,
    pub cumulative_gas_used: u64,
    pub transaction_index: u32,
    pub status: u32,
    pub transaction_hash: [u8; 32],
    pub block_hash: [u8; 32],
    pub from_address: [u8; 20],
    pub to_address: [u8; 20],
    pub contract_address: [u8; 20],
}
impl TransactionReceipt {
    pub const SIZE: usize = 160;
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
impl Default for TransactionReceipt {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn transactionreceipt_size() -> usize {
    TransactionReceipt::SIZE
}
#[no_mangle]
pub extern "C" fn transactionreceipt_alignment() -> usize {
    TransactionReceipt::ALIGNMENT
}
pub struct TransactionReceiptPool {
    inner: std::sync::Mutex<TransactionReceiptPoolInner>,
}
struct TransactionReceiptPoolInner {
    chunks: Vec<Box<[TransactionReceipt; 100]>>,
    free_list: Vec<*mut TransactionReceipt>,
    allocated: usize,
}
impl TransactionReceiptPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = TransactionReceiptPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        TransactionReceiptPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut TransactionReceipt {
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
    pub fn free(&self, ptr: *mut TransactionReceipt) {
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
impl TransactionReceiptPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[TransactionReceipt; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for TransactionReceiptPool {}
unsafe impl Sync for TransactionReceiptPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct SmartContract {
    pub balance: u64,
    pub nonce: u64,
    pub created_at_block: u64,
    pub contract_type: u32,
    pub address: [u8; 20],
    pub creator: [u8; 20],
    pub bytecode: [u8; 24576],
}
impl SmartContract {
    pub const SIZE: usize = 24648;
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
impl Default for SmartContract {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn smartcontract_size() -> usize {
    SmartContract::SIZE
}
#[no_mangle]
pub extern "C" fn smartcontract_alignment() -> usize {
    SmartContract::ALIGNMENT
}
pub struct SmartContractPool {
    inner: std::sync::Mutex<SmartContractPoolInner>,
}
struct SmartContractPoolInner {
    chunks: Vec<Box<[SmartContract; 100]>>,
    free_list: Vec<*mut SmartContract>,
    allocated: usize,
}
impl SmartContractPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = SmartContractPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        SmartContractPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut SmartContract {
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
    pub fn free(&self, ptr: *mut SmartContract) {
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
impl SmartContractPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[SmartContract; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for SmartContractPool {}
unsafe impl Sync for SmartContractPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Account {
    pub balance: u64,
    pub nonce: u64,
    pub address: [u8; 20],
    pub code_hash: [u8; 32],
    pub storage_root: [u8; 32],
}
impl Account {
    pub const SIZE: usize = 104;
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
impl Default for Account {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn account_size() -> usize {
    Account::SIZE
}
#[no_mangle]
pub extern "C" fn account_alignment() -> usize {
    Account::ALIGNMENT
}
pub struct AccountPool {
    inner: std::sync::Mutex<AccountPoolInner>,
}
struct AccountPoolInner {
    chunks: Vec<Box<[Account; 100]>>,
    free_list: Vec<*mut Account>,
    allocated: usize,
}
impl AccountPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = AccountPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        AccountPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Account {
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
    pub fn free(&self, ptr: *mut Account) {
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
impl AccountPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Account; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for AccountPool {}
unsafe impl Sync for AccountPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct MerkleProof {
    pub siblings_count: u32,
    pub siblings: [[u8; 1024]; 32],
    pub index: u32,
    pub leaf: [u8; 32],
}
impl MerkleProof {
    pub const SIZE: usize = 32808;
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
    pub fn siblings(&self) -> &[u8] {
        &self.siblings[..self.siblings_count as usize]
    }
    #[inline(always)]
    pub fn siblings_mut(&mut self) -> &mut [u8] {
        let count = self.siblings_count as usize;
        &mut self.siblings[..count]
    }
    pub fn add_sibling(&mut self, item: u8) -> Result<(), &'static str> {
        if self.siblings_count >= 32 as u32 {
            return Err("Array full");
        }
        self.siblings[self.siblings_count as usize] = item;
        self.siblings_count += 1;
        Ok(())
    }
}
impl Default for MerkleProof {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn merkleproof_size() -> usize {
    MerkleProof::SIZE
}
#[no_mangle]
pub extern "C" fn merkleproof_alignment() -> usize {
    MerkleProof::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct StateTransition {
    pub balance_before: u64,
    pub balance_after: u64,
    pub nonce_before: u64,
    pub nonce_after: u64,
    pub account_address: [u8; 20],
    pub storage_key: [u8; 32],
    pub storage_value_before: [u8; 32],
    pub storage_value_after: [u8; 32],
}
impl StateTransition {
    pub const SIZE: usize = 152;
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
impl Default for StateTransition {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn statetransition_size() -> usize {
    StateTransition::SIZE
}
#[no_mangle]
pub extern "C" fn statetransition_alignment() -> usize {
    StateTransition::ALIGNMENT
}
pub struct StateTransitionPool {
    inner: std::sync::Mutex<StateTransitionPoolInner>,
}
struct StateTransitionPoolInner {
    chunks: Vec<Box<[StateTransition; 100]>>,
    free_list: Vec<*mut StateTransition>,
    allocated: usize,
}
impl StateTransitionPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = StateTransitionPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        StateTransitionPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut StateTransition {
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
    pub fn free(&self, ptr: *mut StateTransition) {
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
impl StateTransitionPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[StateTransition; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for StateTransitionPool {}
unsafe impl Sync for StateTransitionPool {}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_balance_before_batch(items: &[StateTransition]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].balance_before;
            let v1 = chunk[1].balance_before;
            let v2 = chunk[2].balance_before;
            let v3 = chunk[3].balance_before;
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
            sum += item.balance_before;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_balance_after_batch(items: &[StateTransition]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].balance_after;
            let v1 = chunk[1].balance_after;
            let v2 = chunk[2].balance_after;
            let v3 = chunk[3].balance_after;
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
            sum += item.balance_after;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_nonce_before_batch(items: &[StateTransition]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].nonce_before;
            let v1 = chunk[1].nonce_before;
            let v2 = chunk[2].nonce_before;
            let v3 = chunk[3].nonce_before;
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
            sum += item.nonce_before;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_nonce_after_batch(items: &[StateTransition]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].nonce_after;
            let v1 = chunk[1].nonce_after;
            let v2 = chunk[2].nonce_after;
            let v3 = chunk[3].nonce_after;
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
            sum += item.nonce_after;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct PendingTransactionPool {
    pub transactions_count: u32,
    pub transactions: [Transaction; 10000],
    pub total_gas: u64,
    pub count: u32,
}
impl PendingTransactionPool {
    pub const SIZE: usize = 42320024;
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
    pub fn transactions(&self) -> &[Transaction] {
        &self.transactions[..self.transactions_count as usize]
    }
    #[inline(always)]
    pub fn transactions_mut(&mut self) -> &mut [Transaction] {
        let count = self.transactions_count as usize;
        &mut self.transactions[..count]
    }
    pub fn add_transaction(&mut self, item: Transaction) -> Result<(), &'static str> {
        if self.transactions_count >= 10000 as u32 {
            return Err("Array full");
        }
        self.transactions[self.transactions_count as usize] = item;
        self.transactions_count += 1;
        Ok(())
    }
}
impl Default for PendingTransactionPool {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn pendingtransactionpool_size() -> usize {
    PendingTransactionPool::SIZE
}
#[no_mangle]
pub extern "C" fn pendingtransactionpool_alignment() -> usize {
    PendingTransactionPool::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct BlockchainState {
    pub latest_block_number: u64,
    pub total_difficulty: u64,
    pub chain_id: u64,
    pub pending_transactions: u64,
    pub latest_block_hash: [u8; 32],
}
impl BlockchainState {
    pub const SIZE: usize = 64;
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
impl Default for BlockchainState {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn blockchainstate_size() -> usize {
    BlockchainState::SIZE
}
#[no_mangle]
pub extern "C" fn blockchainstate_alignment() -> usize {
    BlockchainState::ALIGNMENT
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct ConsensusData {
    pub slot_number: u64,
    pub epoch_number: u64,
    pub validator_signatures_count: u32,
    pub validator_signatures: [[u8; 1024]; 100],
    pub validator_count: u32,
    pub signature_count: u32,
    pub proposer_address: [u8; 20],
    pub is_finalized: u8,
}
impl ConsensusData {
    pub const SIZE: usize = 102456;
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
    pub fn validator_signatures(&self) -> &[u8] {
        &self.validator_signatures[..self.validator_signatures_count as usize]
    }
    #[inline(always)]
    pub fn validator_signatures_mut(&mut self) -> &mut [u8] {
        let count = self.validator_signatures_count as usize;
        &mut self.validator_signatures[..count]
    }
    pub fn add_validator_signature(&mut self, item: u8) -> Result<(), &'static str> {
        if self.validator_signatures_count >= 100 as u32 {
            return Err("Array full");
        }
        self.validator_signatures[self.validator_signatures_count as usize] = item;
        self.validator_signatures_count += 1;
        Ok(())
    }
}
impl Default for ConsensusData {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn consensusdata_size() -> usize {
    ConsensusData::SIZE
}
#[no_mangle]
pub extern "C" fn consensusdata_alignment() -> usize {
    ConsensusData::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_slot_number_batch(items: &[ConsensusData]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].slot_number;
            let v1 = chunk[1].slot_number;
            let v2 = chunk[2].slot_number;
            let v3 = chunk[3].slot_number;
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
            sum += item.slot_number;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_epoch_number_batch(items: &[ConsensusData]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].epoch_number;
            let v1 = chunk[1].epoch_number;
            let v2 = chunk[2].epoch_number;
            let v3 = chunk[3].epoch_number;
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
            sum += item.epoch_number;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_validator_count_batch(items: &[ConsensusData]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].validator_count as i32,
                chunk[6].validator_count as i32,
                chunk[5].validator_count as i32,
                chunk[4].validator_count as i32,
                chunk[3].validator_count as i32,
                chunk[2].validator_count as i32,
                chunk[1].validator_count as i32,
                chunk[0].validator_count as i32,
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
            sum += item.validator_count as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_signature_count_batch(items: &[ConsensusData]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].signature_count as i32,
                chunk[6].signature_count as i32,
                chunk[5].signature_count as i32,
                chunk[4].signature_count as i32,
                chunk[3].signature_count as i32,
                chunk[2].signature_count as i32,
                chunk[1].signature_count as i32,
                chunk[0].signature_count as i32,
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
            sum += item.signature_count as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct TokenBalance {
    pub balance: u64,
    pub last_updated_block: u64,
    pub owner_address: [u8; 20],
    pub token_address: [u8; 20],
}
impl TokenBalance {
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
impl Default for TokenBalance {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn tokenbalance_size() -> usize {
    TokenBalance::SIZE
}
#[no_mangle]
pub extern "C" fn tokenbalance_alignment() -> usize {
    TokenBalance::ALIGNMENT
}
pub struct TokenBalancePool {
    inner: std::sync::Mutex<TokenBalancePoolInner>,
}
struct TokenBalancePoolInner {
    chunks: Vec<Box<[TokenBalance; 100]>>,
    free_list: Vec<*mut TokenBalance>,
    allocated: usize,
}
impl TokenBalancePool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = TokenBalancePoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        TokenBalancePool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut TokenBalance {
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
    pub fn free(&self, ptr: *mut TokenBalance) {
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
impl TokenBalancePoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[TokenBalance; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for TokenBalancePool {}
unsafe impl Sync for TokenBalancePool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct NFT {
    pub token_id: u64,
    pub minted_at_block: u64,
    pub contract_address: [u8; 20],
    pub owner_address: [u8; 20],
    pub metadata_uri: [u8; 256],
}
impl NFT {
    pub const SIZE: usize = 312;
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
impl Default for NFT {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn nft_size() -> usize {
    NFT::SIZE
}
#[no_mangle]
pub extern "C" fn nft_alignment() -> usize {
    NFT::ALIGNMENT
}
pub struct NFTPool {
    inner: std::sync::Mutex<NFTPoolInner>,
}
struct NFTPoolInner {
    chunks: Vec<Box<[NFT; 100]>>,
    free_list: Vec<*mut NFT>,
    allocated: usize,
}
impl NFTPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = NFTPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        NFTPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut NFT {
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
    pub fn free(&self, ptr: *mut NFT) {
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
impl NFTPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[NFT; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for NFTPool {}
unsafe impl Sync for NFTPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct GasEstimate {
    pub base_fee: u64,
    pub priority_fee: u64,
    pub max_fee: u64,
    pub estimated_gas: u64,
    pub confidence: f64,
}
impl GasEstimate {
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
impl Default for GasEstimate {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn gasestimate_size() -> usize {
    GasEstimate::SIZE
}
#[no_mangle]
pub extern "C" fn gasestimate_alignment() -> usize {
    GasEstimate::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_base_fee_batch(items: &[GasEstimate]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].base_fee;
            let v1 = chunk[1].base_fee;
            let v2 = chunk[2].base_fee;
            let v3 = chunk[3].base_fee;
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
            sum += item.base_fee;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_priority_fee_batch(items: &[GasEstimate]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].priority_fee;
            let v1 = chunk[1].priority_fee;
            let v2 = chunk[2].priority_fee;
            let v3 = chunk[3].priority_fee;
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
            sum += item.priority_fee;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_max_fee_batch(items: &[GasEstimate]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].max_fee;
            let v1 = chunk[1].max_fee;
            let v2 = chunk[2].max_fee;
            let v3 = chunk[3].max_fee;
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
            sum += item.max_fee;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_estimated_gas_batch(items: &[GasEstimate]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].estimated_gas;
            let v1 = chunk[1].estimated_gas;
            let v2 = chunk[2].estimated_gas;
            let v3 = chunk[3].estimated_gas;
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
            sum += item.estimated_gas;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct NetworkStats {
    pub tps_current: u64,
    pub tps_average: u64,
    pub tps_peak: u64,
    pub block_time_ms: u64,
    pub pending_tx_count: u64,
    pub network_utilization: f64,
    pub total_accounts: u64,
    pub total_contracts: u64,
}
impl NetworkStats {
    pub const SIZE: usize = 64;
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
impl Default for NetworkStats {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn networkstats_size() -> usize {
    NetworkStats::SIZE
}
#[no_mangle]
pub extern "C" fn networkstats_alignment() -> usize {
    NetworkStats::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_tps_current_batch(items: &[NetworkStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].tps_current;
            let v1 = chunk[1].tps_current;
            let v2 = chunk[2].tps_current;
            let v3 = chunk[3].tps_current;
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
            sum += item.tps_current;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_tps_average_batch(items: &[NetworkStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].tps_average;
            let v1 = chunk[1].tps_average;
            let v2 = chunk[2].tps_average;
            let v3 = chunk[3].tps_average;
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
            sum += item.tps_average;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_tps_peak_batch(items: &[NetworkStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].tps_peak;
            let v1 = chunk[1].tps_peak;
            let v2 = chunk[2].tps_peak;
            let v3 = chunk[3].tps_peak;
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
            sum += item.tps_peak;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_block_time_ms_batch(items: &[NetworkStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].block_time_ms;
            let v1 = chunk[1].block_time_ms;
            let v2 = chunk[2].block_time_ms;
            let v3 = chunk[3].block_time_ms;
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
            sum += item.block_time_ms;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_pending_tx_count_batch(items: &[NetworkStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].pending_tx_count;
            let v1 = chunk[1].pending_tx_count;
            let v2 = chunk[2].pending_tx_count;
            let v3 = chunk[3].pending_tx_count;
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
            sum += item.pending_tx_count;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_total_accounts_batch(items: &[NetworkStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].total_accounts;
            let v1 = chunk[1].total_accounts;
            let v2 = chunk[2].total_accounts;
            let v3 = chunk[3].total_accounts;
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
            sum += item.total_accounts;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_total_contracts_batch(items: &[NetworkStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].total_contracts;
            let v1 = chunk[1].total_contracts;
            let v2 = chunk[2].total_contracts;
            let v3 = chunk[3].total_contracts;
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
            sum += item.total_contracts;
        }
        sum
    }
}
