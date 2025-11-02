#![allow(dead_code)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(unused_imports)]
use std::marker::PhantomData;
use std::mem;
use std::slice;
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum ComponentType {
    TRANSFORM = 0,
    RIGIDBODY = 1,
    COLLIDER = 2,
    RENDERER = 3,
    LIGHT = 4,
    CAMERA = 5,
    AUDIO_SOURCE = 6,
    PARTICLE_SYSTEM = 7,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum ColliderShape {
    BOX = 0,
    SPHERE = 1,
    CAPSULE = 2,
    MESH = 3,
}
#[repr(u32)]
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub enum LightType {
    DIRECTIONAL = 0,
    POINT = 1,
    SPOT = 2,
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Vector3 {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}
impl Vector3 {
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
impl Default for Vector3 {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn vector3_size() -> usize {
    Vector3::SIZE
}
#[no_mangle]
pub extern "C" fn vector3_alignment() -> usize {
    Vector3::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Quaternion {
    pub x: f32,
    pub y: f32,
    pub z: f32,
    pub w: f32,
}
impl Quaternion {
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
impl Default for Quaternion {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn quaternion_size() -> usize {
    Quaternion::SIZE
}
#[no_mangle]
pub extern "C" fn quaternion_alignment() -> usize {
    Quaternion::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Transform {
    pub position: Vector3,
    pub rotation: Quaternion,
    pub scale: Vector3,
    pub children_count: u32,
    pub children: [u32; 64],
    pub parent_entity: u32,
}
impl Transform {
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
    #[inline(always)]
    pub fn children(&self) -> &[u32] {
        &self.children[..self.children_count as usize]
    }
    #[inline(always)]
    pub fn children_mut(&mut self) -> &mut [u32] {
        let count = self.children_count as usize;
        &mut self.children[..count]
    }
    pub fn add_children(&mut self, item: u32) -> Result<(), &'static str> {
        if self.children_count >= 64 as u32 {
            return Err("Array full");
        }
        self.children[self.children_count as usize] = item;
        self.children_count += 1;
        Ok(())
    }
}
impl Default for Transform {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn transform_size() -> usize {
    Transform::SIZE
}
#[no_mangle]
pub extern "C" fn transform_alignment() -> usize {
    Transform::ALIGNMENT
}
pub struct TransformPool {
    inner: std::sync::Mutex<TransformPoolInner>,
}
struct TransformPoolInner {
    chunks: Vec<Box<[Transform; 100]>>,
    free_list: Vec<*mut Transform>,
    allocated: usize,
}
impl TransformPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = TransformPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        TransformPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Transform {
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
    pub fn free(&self, ptr: *mut Transform) {
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
impl TransformPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Transform; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for TransformPool {}
unsafe impl Sync for TransformPool {}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_parent_entity_batch(items: &[Transform]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].parent_entity as i32,
                chunk[6].parent_entity as i32,
                chunk[5].parent_entity as i32,
                chunk[4].parent_entity as i32,
                chunk[3].parent_entity as i32,
                chunk[2].parent_entity as i32,
                chunk[1].parent_entity as i32,
                chunk[0].parent_entity as i32,
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
            sum += item.parent_entity as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct RigidBody {
    pub velocity: Vector3,
    pub angular_velocity: Vector3,
    pub mass: f32,
    pub drag: f32,
    pub angular_drag: f32,
    pub use_gravity: u8,
    pub is_kinematic: u8,
}
impl RigidBody {
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
    inner: std::sync::Mutex<RigidBodyPoolInner>,
}
struct RigidBodyPoolInner {
    chunks: Vec<Box<[RigidBody; 100]>>,
    free_list: Vec<*mut RigidBody>,
    allocated: usize,
}
impl RigidBodyPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = RigidBodyPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        RigidBodyPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut RigidBody {
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
    pub fn free(&self, ptr: *mut RigidBody) {
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
impl RigidBodyPoolInner {
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
}
unsafe impl Send for RigidBodyPool {}
unsafe impl Sync for RigidBodyPool {}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Collider {
    pub center: Vector3,
    pub size: Vector3,
    pub shape: u32,
    pub radius: f32,
    pub height: f32,
    pub is_trigger: u8,
}
impl Collider {
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
impl Default for Collider {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn collider_size() -> usize {
    Collider::SIZE
}
#[no_mangle]
pub extern "C" fn collider_alignment() -> usize {
    Collider::ALIGNMENT
}
pub struct ColliderPool {
    inner: std::sync::Mutex<ColliderPoolInner>,
}
struct ColliderPoolInner {
    chunks: Vec<Box<[Collider; 100]>>,
    free_list: Vec<*mut Collider>,
    allocated: usize,
}
impl ColliderPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = ColliderPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        ColliderPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Collider {
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
    pub fn free(&self, ptr: *mut Collider) {
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
impl ColliderPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Collider; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for ColliderPool {}
unsafe impl Sync for ColliderPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct PhysicsState {
    pub entity_ids_count: u32,
    pub entity_ids: [u32; 1024],
    pub bodies_count: u32,
    pub bodies: [RigidBody; 1024],
    pub simulation_time_us: u64,
    pub body_count: u32,
    pub collision_count: u32,
}
impl PhysicsState {
    pub const SIZE: usize = 53280;
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
    pub fn entity_ids(&self) -> &[u32] {
        &self.entity_ids[..self.entity_ids_count as usize]
    }
    #[inline(always)]
    pub fn entity_ids_mut(&mut self) -> &mut [u32] {
        let count = self.entity_ids_count as usize;
        &mut self.entity_ids[..count]
    }
    pub fn add_entity_id(&mut self, item: u32) -> Result<(), &'static str> {
        if self.entity_ids_count >= 1024 as u32 {
            return Err("Array full");
        }
        self.entity_ids[self.entity_ids_count as usize] = item;
        self.entity_ids_count += 1;
        Ok(())
    }
    #[inline(always)]
    pub fn bodies(&self) -> &[RigidBody] {
        &self.bodies[..self.bodies_count as usize]
    }
    #[inline(always)]
    pub fn bodies_mut(&mut self) -> &mut [RigidBody] {
        let count = self.bodies_count as usize;
        &mut self.bodies[..count]
    }
    pub fn add_bodie(&mut self, item: RigidBody) -> Result<(), &'static str> {
        if self.bodies_count >= 1024 as u32 {
            return Err("Array full");
        }
        self.bodies[self.bodies_count as usize] = item;
        self.bodies_count += 1;
        Ok(())
    }
}
impl Default for PhysicsState {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn physicsstate_size() -> usize {
    PhysicsState::SIZE
}
#[no_mangle]
pub extern "C" fn physicsstate_alignment() -> usize {
    PhysicsState::ALIGNMENT
}
pub struct PhysicsStatePool {
    inner: std::sync::Mutex<PhysicsStatePoolInner>,
}
struct PhysicsStatePoolInner {
    chunks: Vec<Box<[PhysicsState; 100]>>,
    free_list: Vec<*mut PhysicsState>,
    allocated: usize,
}
impl PhysicsStatePool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = PhysicsStatePoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        PhysicsStatePool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut PhysicsState {
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
    pub fn free(&self, ptr: *mut PhysicsState) {
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
impl PhysicsStatePoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[PhysicsState; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for PhysicsStatePool {}
unsafe impl Sync for PhysicsStatePool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Particle {
    pub position: Vector3,
    pub velocity: Vector3,
    pub lifetime: f32,
    pub size: f32,
    pub color: u32,
}
impl Particle {
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
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_color_batch(items: &[Particle]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].color as i32,
                chunk[6].color as i32,
                chunk[5].color as i32,
                chunk[4].color as i32,
                chunk[3].color as i32,
                chunk[2].color as i32,
                chunk[1].color as i32,
                chunk[0].color as i32,
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
            sum += item.color as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct ParticleSystem {
    pub emitter_position: Vector3,
    pub particles_count: u32,
    pub particles: [Particle; 10000],
    pub gravity: Vector3,
    pub particle_count: u32,
    pub emission_rate: f32,
    pub particle_lifetime: f32,
    pub is_playing: u8,
}
impl ParticleSystem {
    pub const SIZE: usize = 480056;
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
    pub fn particles(&self) -> &[Particle] {
        &self.particles[..self.particles_count as usize]
    }
    #[inline(always)]
    pub fn particles_mut(&mut self) -> &mut [Particle] {
        let count = self.particles_count as usize;
        &mut self.particles[..count]
    }
    pub fn add_particle(&mut self, item: Particle) -> Result<(), &'static str> {
        if self.particles_count >= 10000 as u32 {
            return Err("Array full");
        }
        self.particles[self.particles_count as usize] = item;
        self.particles_count += 1;
        Ok(())
    }
}
impl Default for ParticleSystem {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn particlesystem_size() -> usize {
    ParticleSystem::SIZE
}
#[no_mangle]
pub extern "C" fn particlesystem_alignment() -> usize {
    ParticleSystem::ALIGNMENT
}
pub struct ParticleSystemPool {
    inner: std::sync::Mutex<ParticleSystemPoolInner>,
}
struct ParticleSystemPoolInner {
    chunks: Vec<Box<[ParticleSystem; 100]>>,
    free_list: Vec<*mut ParticleSystem>,
    allocated: usize,
}
impl ParticleSystemPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = ParticleSystemPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        ParticleSystemPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut ParticleSystem {
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
    pub fn free(&self, ptr: *mut ParticleSystem) {
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
impl ParticleSystemPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[ParticleSystem; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for ParticleSystemPool {}
unsafe impl Sync for ParticleSystemPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Entity {
    pub components_count: u32,
    pub components: [u32; 16],
    pub entity_id: u32,
    pub component_count: u32,
    pub layer: u32,
    pub tag: u32,
    pub name: [u8; 64],
    pub active: u8,
}
impl Entity {
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
    #[inline(always)]
    pub fn components(&self) -> &[u32] {
        &self.components[..self.components_count as usize]
    }
    #[inline(always)]
    pub fn components_mut(&mut self) -> &mut [u32] {
        let count = self.components_count as usize;
        &mut self.components[..count]
    }
    pub fn add_component(&mut self, item: u32) -> Result<(), &'static str> {
        if self.components_count >= 16 as u32 {
            return Err("Array full");
        }
        self.components[self.components_count as usize] = item;
        self.components_count += 1;
        Ok(())
    }
}
impl Default for Entity {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn entity_size() -> usize {
    Entity::SIZE
}
#[no_mangle]
pub extern "C" fn entity_alignment() -> usize {
    Entity::ALIGNMENT
}
pub struct EntityPool {
    inner: std::sync::Mutex<EntityPoolInner>,
}
struct EntityPoolInner {
    chunks: Vec<Box<[Entity; 100]>>,
    free_list: Vec<*mut Entity>,
    allocated: usize,
}
impl EntityPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = EntityPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        EntityPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut Entity {
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
    pub fn free(&self, ptr: *mut Entity) {
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
impl EntityPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[Entity; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for EntityPool {}
unsafe impl Sync for EntityPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct SceneGraph {
    pub root_entities_count: u32,
    pub root_entities: [u32; 256],
    pub frame_number: u64,
    pub root_count: u32,
    pub total_entities: u32,
}
impl SceneGraph {
    pub const SIZE: usize = 1048;
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
    pub fn root_entities(&self) -> &[u32] {
        &self.root_entities[..self.root_entities_count as usize]
    }
    #[inline(always)]
    pub fn root_entities_mut(&mut self) -> &mut [u32] {
        let count = self.root_entities_count as usize;
        &mut self.root_entities[..count]
    }
    pub fn add_root_entitie(&mut self, item: u32) -> Result<(), &'static str> {
        if self.root_entities_count >= 256 as u32 {
            return Err("Array full");
        }
        self.root_entities[self.root_entities_count as usize] = item;
        self.root_entities_count += 1;
        Ok(())
    }
}
impl Default for SceneGraph {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn scenegraph_size() -> usize {
    SceneGraph::SIZE
}
#[no_mangle]
pub extern "C" fn scenegraph_alignment() -> usize {
    SceneGraph::ALIGNMENT
}
pub struct SceneGraphPool {
    inner: std::sync::Mutex<SceneGraphPoolInner>,
}
struct SceneGraphPoolInner {
    chunks: Vec<Box<[SceneGraph; 100]>>,
    free_list: Vec<*mut SceneGraph>,
    allocated: usize,
}
impl SceneGraphPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = SceneGraphPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        SceneGraphPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut SceneGraph {
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
    pub fn free(&self, ptr: *mut SceneGraph) {
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
impl SceneGraphPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[SceneGraph; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for SceneGraphPool {}
unsafe impl Sync for SceneGraphPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct RenderCommand {
    pub transform: Transform,
    pub entity_id: u32,
    pub mesh_id: u32,
    pub material_id: u32,
    pub render_order: u32,
    pub cast_shadows: u8,
}
impl RenderCommand {
    pub const SIZE: usize = 336;
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
impl Default for RenderCommand {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn rendercommand_size() -> usize {
    RenderCommand::SIZE
}
#[no_mangle]
pub extern "C" fn rendercommand_alignment() -> usize {
    RenderCommand::ALIGNMENT
}
pub struct RenderCommandPool {
    inner: std::sync::Mutex<RenderCommandPoolInner>,
}
struct RenderCommandPoolInner {
    chunks: Vec<Box<[RenderCommand; 100]>>,
    free_list: Vec<*mut RenderCommand>,
    allocated: usize,
}
impl RenderCommandPool {
    pub fn new(capacity: usize) -> Self {
        const CHUNK_SIZE: usize = 100;
        let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
        let mut inner = RenderCommandPoolInner {
            chunks: Vec::with_capacity(chunk_count),
            free_list: Vec::with_capacity(capacity),
            allocated: 0,
        };
        for _ in 0..chunk_count {
            inner.add_chunk();
        }
        RenderCommandPool {
            inner: std::sync::Mutex::new(inner),
        }
    }
    pub fn allocate(&self) -> *mut RenderCommand {
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
    pub fn free(&self, ptr: *mut RenderCommand) {
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
impl RenderCommandPoolInner {
    fn add_chunk(&mut self) {
        const CHUNK_SIZE: usize = 100;
        let mut chunk: Box<[RenderCommand; 100]> = Box::new(unsafe { mem::zeroed() });
        let ptr = chunk.as_mut_ptr();
        for i in 0..CHUNK_SIZE {
            unsafe {
                self.free_list.push(ptr.add(i));
            }
        }
        self.chunks.push(chunk);
    }
}
unsafe impl Send for RenderCommandPool {}
unsafe impl Sync for RenderCommandPool {}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Light {
    pub position: Vector3,
    pub direction: Vector3,
    pub light_type: u32,
    pub color: u32,
    pub intensity: f32,
    pub range: f32,
    pub spot_angle: f32,
}
impl Light {
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
impl Default for Light {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn light_size() -> usize {
    Light::SIZE
}
#[no_mangle]
pub extern "C" fn light_alignment() -> usize {
    Light::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_light_type_batch(items: &[Light]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].light_type as i32,
                chunk[6].light_type as i32,
                chunk[5].light_type as i32,
                chunk[4].light_type as i32,
                chunk[3].light_type as i32,
                chunk[2].light_type as i32,
                chunk[1].light_type as i32,
                chunk[0].light_type as i32,
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
            sum += item.light_type as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_color_batch(items: &[Light]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].color as i32,
                chunk[6].color as i32,
                chunk[5].color as i32,
                chunk[4].color as i32,
                chunk[3].color as i32,
                chunk[2].color as i32,
                chunk[1].color as i32,
                chunk[0].color as i32,
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
            sum += item.color as i64;
        }
        sum
    }
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct Camera {
    pub position: Vector3,
    pub forward: Vector3,
    pub up: Vector3,
    pub fov: f32,
    pub near_clip: f32,
    pub far_clip: f32,
    pub aspect_ratio: f32,
}
impl Camera {
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
impl Default for Camera {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn camera_size() -> usize {
    Camera::SIZE
}
#[no_mangle]
pub extern "C" fn camera_alignment() -> usize {
    Camera::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
}
#[repr(C, align(8))]
#[derive(Copy, Clone, Debug)]
pub struct FrameStats {
    pub frame_number: u64,
    pub frame_time_us: u64,
    pub draw_calls: u32,
    pub vertices: u32,
    pub triangles: u32,
    pub active_entities: u32,
    pub visible_entities: u32,
    pub fps: f32,
}
impl FrameStats {
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
impl Default for FrameStats {
    fn default() -> Self {
        unsafe { mem::zeroed() }
    }
}
#[no_mangle]
pub extern "C" fn framestats_size() -> usize {
    FrameStats::SIZE
}
#[no_mangle]
pub extern "C" fn framestats_alignment() -> usize {
    FrameStats::ALIGNMENT
}
#[cfg(target_arch = "x86_64")]
pub mod simd {
    use super::*;
    use std::arch::x86_64::*;
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_frame_number_batch(items: &[FrameStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].frame_number;
            let v1 = chunk[1].frame_number;
            let v2 = chunk[2].frame_number;
            let v3 = chunk[3].frame_number;
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
            sum += item.frame_number;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_frame_time_us_batch(items: &[FrameStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(4) {
            let v0 = chunk[0].frame_time_us;
            let v1 = chunk[1].frame_time_us;
            let v2 = chunk[2].frame_time_us;
            let v3 = chunk[3].frame_time_us;
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
            sum += item.frame_time_us;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_draw_calls_batch(items: &[FrameStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].draw_calls as i32,
                chunk[6].draw_calls as i32,
                chunk[5].draw_calls as i32,
                chunk[4].draw_calls as i32,
                chunk[3].draw_calls as i32,
                chunk[2].draw_calls as i32,
                chunk[1].draw_calls as i32,
                chunk[0].draw_calls as i32,
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
            sum += item.draw_calls as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_vertices_batch(items: &[FrameStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].vertices as i32,
                chunk[6].vertices as i32,
                chunk[5].vertices as i32,
                chunk[4].vertices as i32,
                chunk[3].vertices as i32,
                chunk[2].vertices as i32,
                chunk[1].vertices as i32,
                chunk[0].vertices as i32,
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
            sum += item.vertices as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_triangles_batch(items: &[FrameStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].triangles as i32,
                chunk[6].triangles as i32,
                chunk[5].triangles as i32,
                chunk[4].triangles as i32,
                chunk[3].triangles as i32,
                chunk[2].triangles as i32,
                chunk[1].triangles as i32,
                chunk[0].triangles as i32,
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
            sum += item.triangles as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_active_entities_batch(items: &[FrameStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].active_entities as i32,
                chunk[6].active_entities as i32,
                chunk[5].active_entities as i32,
                chunk[4].active_entities as i32,
                chunk[3].active_entities as i32,
                chunk[2].active_entities as i32,
                chunk[1].active_entities as i32,
                chunk[0].active_entities as i32,
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
            sum += item.active_entities as i64;
        }
        sum
    }
    #[target_feature(enable = "avx2")]
    pub unsafe fn sum_visible_entities_batch(items: &[FrameStats]) -> i64 {
        let mut total = _mm256_setzero_si256();
        for chunk in items.chunks_exact(8) {
            let values = _mm256_set_epi32(
                chunk[7].visible_entities as i32,
                chunk[6].visible_entities as i32,
                chunk[5].visible_entities as i32,
                chunk[4].visible_entities as i32,
                chunk[3].visible_entities as i32,
                chunk[2].visible_entities as i32,
                chunk[1].visible_entities as i32,
                chunk[0].visible_entities as i32,
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
            sum += item.visible_entities as i64;
        }
        sum
    }
}
