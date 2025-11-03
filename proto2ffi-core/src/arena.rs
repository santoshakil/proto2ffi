use std::alloc::{alloc, dealloc, Layout};
use std::cell::Cell;
use std::ptr::NonNull;
use std::sync::atomic::{AtomicUsize, Ordering};

pub struct Arena {
    chunks: Vec<Chunk>,
    current: Cell<usize>,
    allocated: AtomicUsize,
}

struct Chunk {
    ptr: NonNull<u8>,
    capacity: usize,
    offset: Cell<usize>,
}

impl Arena {
    pub fn new(chunk_size: usize) -> Self {
        Self {
            chunks: vec![Chunk::new(chunk_size)],
            current: Cell::new(0),
            allocated: AtomicUsize::new(0),
        }
    }

    pub fn with_capacity(chunk_size: usize, num_chunks: usize) -> Self {
        let mut chunks = Vec::with_capacity(num_chunks);
        for _ in 0..num_chunks {
            chunks.push(Chunk::new(chunk_size));
        }

        Self {
            chunks,
            current: Cell::new(0),
            allocated: AtomicUsize::new(0),
        }
    }

    pub fn allocate(&self, size: usize, align: usize) -> Option<NonNull<u8>> {
        let current = self.current.get();

        if let Some(ptr) = self.chunks[current].allocate(size, align) {
            self.allocated.fetch_add(size, Ordering::Relaxed);
            return Some(ptr);
        }

        None
    }

    pub fn allocate_or_grow(&mut self, size: usize, align: usize) -> NonNull<u8> {
        if let Some(ptr) = self.allocate(size, align) {
            return ptr;
        }

        let chunk_size = self.chunks[0].capacity.max(size + align);
        let new_chunk = Chunk::new(chunk_size);
        self.chunks.push(new_chunk);
        self.current.set(self.chunks.len() - 1);

        self.allocate(size, align).expect("allocation failed after growing")
    }

    pub fn allocate_slice<T>(&mut self, len: usize) -> &mut [T] {
        let size = std::mem::size_of::<T>() * len;
        let align = std::mem::align_of::<T>();
        let ptr = self.allocate_or_grow(size, align);

        unsafe {
            std::slice::from_raw_parts_mut(ptr.as_ptr() as *mut T, len)
        }
    }

    pub fn allocate_value<T>(&mut self, value: T) -> &mut T {
        let size = std::mem::size_of::<T>();
        let align = std::mem::align_of::<T>();
        let ptr = self.allocate_or_grow(size, align);

        unsafe {
            let typed_ptr = ptr.as_ptr() as *mut T;
            std::ptr::write(typed_ptr, value);
            &mut *typed_ptr
        }
    }

    pub fn reset(&mut self) {
        for chunk in &self.chunks {
            chunk.reset();
        }
        self.current.set(0);
        self.allocated.store(0, Ordering::Relaxed);
    }

    pub fn clear(&mut self) {
        for chunk in self.chunks.drain(1..) {
            drop(chunk);
        }
        self.chunks[0].reset();
        self.current.set(0);
        self.allocated.store(0, Ordering::Relaxed);
    }

    pub fn allocated_bytes(&self) -> usize {
        self.allocated.load(Ordering::Relaxed)
    }

    pub fn capacity_bytes(&self) -> usize {
        self.chunks.iter().map(|c| c.capacity).sum()
    }

    pub fn chunk_count(&self) -> usize {
        self.chunks.len()
    }

    pub fn utilization(&self) -> f64 {
        let capacity = self.capacity_bytes();
        if capacity == 0 {
            return 0.0;
        }
        self.allocated_bytes() as f64 / capacity as f64
    }
}

impl Chunk {
    fn new(capacity: usize) -> Self {
        let layout = Layout::from_size_align(capacity, 1).expect("invalid layout");
        let ptr = unsafe { alloc(layout) };

        Self {
            ptr: NonNull::new(ptr).expect("allocation failed"),
            capacity,
            offset: Cell::new(0),
        }
    }

    fn allocate(&self, size: usize, align: usize) -> Option<NonNull<u8>> {
        let offset = self.offset.get();
        let aligned_offset = (offset + align - 1) & !(align - 1);
        let new_offset = aligned_offset + size;

        if new_offset > self.capacity {
            return None;
        }

        self.offset.set(new_offset);

        unsafe {
            Some(NonNull::new_unchecked(self.ptr.as_ptr().add(aligned_offset)))
        }
    }

    fn reset(&self) {
        self.offset.set(0);
    }
}

impl Drop for Chunk {
    fn drop(&mut self) {
        let layout = Layout::from_size_align(self.capacity, 1).expect("invalid layout");
        unsafe {
            dealloc(self.ptr.as_ptr(), layout);
        }
    }
}

unsafe impl Send for Arena {}
unsafe impl Sync for Arena {}

pub struct ArenaBox<T> {
    ptr: NonNull<T>,
}

impl<T> ArenaBox<T> {
    pub fn new(arena: &mut Arena, value: T) -> Self {
        let ptr = arena.allocate_value(value);
        Self {
            ptr: NonNull::from(ptr),
        }
    }

    pub fn as_ref(&self) -> &T {
        unsafe { self.ptr.as_ref() }
    }

    pub fn as_mut(&mut self) -> &mut T {
        unsafe { self.ptr.as_mut() }
    }
}

impl<T> std::ops::Deref for ArenaBox<T> {
    type Target = T;

    fn deref(&self) -> &T {
        self.as_ref()
    }
}

impl<T> std::ops::DerefMut for ArenaBox<T> {
    fn deref_mut(&mut self) -> &mut T {
        self.as_mut()
    }
}

pub struct ArenaVec<T> {
    ptr: NonNull<T>,
    len: usize,
}

impl<T> ArenaVec<T> {
    pub fn new(arena: &mut Arena, len: usize) -> Self {
        let slice = arena.allocate_slice::<T>(len);
        Self {
            ptr: NonNull::from(&mut slice[0]),
            len,
        }
    }

    pub fn as_slice(&self) -> &[T] {
        unsafe { std::slice::from_raw_parts(self.ptr.as_ptr(), self.len) }
    }

    pub fn as_mut_slice(&mut self) -> &mut [T] {
        unsafe { std::slice::from_raw_parts_mut(self.ptr.as_ptr(), self.len) }
    }

    pub fn len(&self) -> usize {
        self.len
    }

    pub fn is_empty(&self) -> bool {
        self.len == 0
    }
}

impl<T> std::ops::Deref for ArenaVec<T> {
    type Target = [T];

    fn deref(&self) -> &[T] {
        self.as_slice()
    }
}

impl<T> std::ops::DerefMut for ArenaVec<T> {
    fn deref_mut(&mut self) -> &mut [T] {
        self.as_mut_slice()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_arena_basic() {
        let mut arena = Arena::new(1024);
        let value = arena.allocate_value(42i32);
        assert_eq!(*value, 42);
    }

    #[test]
    fn test_arena_slice() {
        let mut arena = Arena::new(1024);
        let slice = arena.allocate_slice::<i32>(10);
        slice[0] = 1;
        slice[9] = 10;
        assert_eq!(slice[0], 1);
        assert_eq!(slice[9], 10);
    }

    #[test]
    fn test_arena_reset() {
        let mut arena = Arena::new(1024);
        let _v1 = arena.allocate_value(42i32);
        assert!(arena.allocated_bytes() > 0);

        arena.reset();
        assert_eq!(arena.allocated_bytes(), 0);
    }

    #[test]
    fn test_arena_grow() {
        let mut arena = Arena::new(16);
        let _slice = arena.allocate_slice::<i32>(100);
        assert!(arena.chunk_count() > 1);
    }

    #[test]
    fn test_arena_utilization() {
        let mut arena = Arena::new(1024);
        let _v = arena.allocate_value(42i32);
        let util = arena.utilization();
        assert!(util > 0.0 && util < 1.0);
    }

    #[test]
    fn test_arena_box() {
        let mut arena = Arena::new(1024);
        let mut boxed = ArenaBox::new(&mut arena, 42);
        assert_eq!(*boxed, 42);
        *boxed = 100;
        assert_eq!(*boxed, 100);
    }

    #[test]
    fn test_arena_vec() {
        let mut arena = Arena::new(1024);
        let mut vec = ArenaVec::new(&mut arena, 10);
        vec[0] = 1;
        vec[9] = 10;
        assert_eq!(vec.len(), 10);
        assert_eq!(vec[0], 1);
        assert_eq!(vec[9], 10);
    }
}
