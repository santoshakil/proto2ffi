#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Particle {
    pub x: f64,
    pub y: f64,
    pub z: f64,
    pub vx: f64,
    pub vy: f64,
    pub vz: f64,
    pub mass: f64,
    pub color: u32,
    pub active: u8,
}
impl Particle {
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
impl Default for Particle {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn particle_size() -> usize {
    Particle::SIZE
}
#[no_mangle]
pub extern "C" fn particle_alignment() -> usize {
    Particle::ALIGNMENT
}
pub struct ParticlePool {
    chunks: Vec<Box<[Particle; 100]>>,
    free_list: Vec<*mut Particle>,
    allocated: std::sync::atomic::AtomicUsize,
}
impl ParticlePool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut pool = ParticlePool {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: std::sync::atomic::AtomicUsize::new(0),
        };
        for _ in 0..chunk_count {
            pool.add_chunk();
        }
        pool
    }
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Particle; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
    pub fn allocate(&mut self) -> *mut Particle {
        if self.free_list.is_empty() {
            self.add_chunk();
        }
        let ptr = self
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        self.allocated
            .fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        ptr
    }
    pub fn free(&mut self, ptr: *mut Particle) {
        self.free_list.push(ptr);
        self.allocated
            .fetch_sub(1, std::sync::atomic::Ordering::Relaxed);
    }
    pub fn allocated_count(&self) -> usize {
        self.allocated.load(std::sync::atomic::Ordering::Relaxed)
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        self.chunks.len() * CHUNK_SIZE
    }
}
unsafe impl Send for ParticlePool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct RigidBody {
    pub px: f64,
    pub py: f64,
    pub pz: f64,
    pub qx: f64,
    pub qy: f64,
    pub qz: f64,
    pub qw: f64,
    pub vx: f64,
    pub vy: f64,
    pub vz: f64,
    pub ax: f64,
    pub ay: f64,
    pub az: f64,
    pub mass: f64,
    pub id: u64,
}
impl RigidBody {
    pub const SIZE: usize = 120;
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
impl Default for RigidBody {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn rigidbody_size() -> usize {
    RigidBody::SIZE
}
#[no_mangle]
pub extern "C" fn rigidbody_alignment() -> usize {
    RigidBody::ALIGNMENT
}
pub struct RigidBodyPool {
    chunks: Vec<Box<[RigidBody; 100]>>,
    free_list: Vec<*mut RigidBody>,
    allocated: std::sync::atomic::AtomicUsize,
}
impl RigidBodyPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut pool = RigidBodyPool {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: std::sync::atomic::AtomicUsize::new(0),
        };
        for _ in 0..chunk_count {
            pool.add_chunk();
        }
        pool
    }
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[RigidBody; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
    pub fn allocate(&mut self) -> *mut RigidBody {
        if self.free_list.is_empty() {
            self.add_chunk();
        }
        let ptr = self
            .free_list
            .pop()
            .expect("free_list should not be empty after add_chunk");
        self.allocated
            .fetch_add(1, std::sync::atomic::Ordering::Relaxed);
        ptr
    }
    pub fn free(&mut self, ptr: *mut RigidBody) {
        self.free_list.push(ptr);
        self.allocated
            .fetch_sub(1, std::sync::atomic::Ordering::Relaxed);
    }
    pub fn allocated_count(&self) -> usize {
        self.allocated.load(std::sync::atomic::Ordering::Relaxed)
    }
    pub fn capacity(&self) -> usize {
        const CHUNK_SIZE: usize = 100;
        self.chunks.len() * CHUNK_SIZE
    }
}
unsafe impl Send for RigidBodyPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct PoolStats {
    pub total_allocations: u64,
    pub total_frees: u64,
    pub active_objects: u64,
    pub pool_hits: u64,
    pub pool_misses: u64,
}
impl PoolStats {
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
impl Default for PoolStats {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn poolstats_size() -> usize {
    PoolStats::SIZE
}
#[no_mangle]
pub extern "C" fn poolstats_alignment() -> usize {
    PoolStats::ALIGNMENT
}
