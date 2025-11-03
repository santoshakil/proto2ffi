use crate::layout::MessageLayout;
use quote::{quote, format_ident};
use proc_macro2::TokenStream;

pub fn generate_pool_allocator(message: &MessageLayout) -> TokenStream {
    let name = format_ident!("{}", message.name);
    let pool_name = format_ident!("{}Pool", message.name);
    let pool_inner_name = format_ident!("{}PoolInner", message.name);

    let _pool_size = message.options
        .get("proto2ffi.pool_size")
        .and_then(|s| s.parse::<usize>().ok())
        .unwrap_or(1000);

    quote! {
        pub struct #pool_name {
            inner: std::sync::RwLock<#pool_inner_name>,
            allocated: std::sync::atomic::AtomicUsize,
        }

        struct #pool_inner_name {
            chunks: Vec<Box<[#name; 100]>>,
            free_list: Vec<*mut #name>,
            freed_set: std::collections::HashSet<*mut #name>,
        }

        impl #pool_name {
            pub fn new(capacity: usize) -> Self {
                const CHUNK_SIZE: usize = 100;
                let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
                let mut inner = #pool_inner_name {
                    chunks: Vec::with_capacity(chunk_count),
                    free_list: Vec::with_capacity(capacity),
                    freed_set: std::collections::HashSet::with_capacity(capacity),
                };

                for _ in 0..chunk_count {
                    inner.add_chunk();
                }

                #pool_name {
                    inner: std::sync::RwLock::new(inner),
                    allocated: std::sync::atomic::AtomicUsize::new(0),
                }
            }

            pub fn allocate(&self) -> *mut #name {
                let mut inner = match self.inner.write() {
                    Ok(guard) => guard,
                    Err(_) => return std::ptr::null_mut(),
                };

                if inner.free_list.is_empty() {
                    inner.add_chunk();
                }

                match inner.free_list.pop() {
                    Some(ptr) => {
                        inner.freed_set.remove(&ptr);
                        self.allocated.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                        ptr
                    }
                    None => std::ptr::null_mut(),
                }
            }

            pub fn free(&self, ptr: *mut #name) -> bool {
                if ptr.is_null() {
                    return false;
                }

                let mut inner = match self.inner.write() {
                    Ok(guard) => guard,
                    Err(_) => return false,
                };

                if inner.freed_set.contains(&ptr) {
                    eprintln!("Warning: Double free detected for pointer {:?}", ptr);
                    return false;
                }

                inner.free_list.push(ptr);
                inner.freed_set.insert(ptr);
                self.allocated.fetch_sub(1, std::sync::atomic::Ordering::Relaxed);
                true
            }

            pub fn allocated_count(&self) -> usize {
                self.allocated.load(std::sync::atomic::Ordering::Relaxed)
            }

            pub fn capacity(&self) -> usize {
                const CHUNK_SIZE: usize = 100;
                match self.inner.read() {
                    Ok(inner) => inner.chunks.len() * CHUNK_SIZE,
                    Err(_) => 0,
                }
            }

            pub fn reset(&self) {
                let mut inner = match self.inner.write() {
                    Ok(guard) => guard,
                    Err(_) => return,
                };

                const CHUNK_SIZE: usize = 100;
                inner.free_list.clear();
                inner.freed_set.clear();

                for chunk in &inner.chunks {
                    let ptr = chunk.as_ptr() as *mut #name;
                    for i in 0..CHUNK_SIZE {
                        unsafe {
                            let item_ptr = ptr.add(i);
                            inner.free_list.push(item_ptr);
                            inner.freed_set.insert(item_ptr);
                        }
                    }
                }

                self.allocated.store(0, std::sync::atomic::Ordering::Relaxed);
            }

            pub fn fragmentation_ratio(&self) -> f64 {
                match self.inner.read() {
                    Ok(inner) => {
                        let capacity = inner.chunks.len() * 100;
                        let free = inner.free_list.len();
                        if capacity == 0 {
                            return 0.0;
                        }
                        let allocated = capacity - free;
                        if allocated == 0 {
                            return 0.0;
                        }
                        (capacity - allocated - free) as f64 / capacity as f64
                    }
                    Err(_) => 0.0,
                }
            }
        }

        impl #pool_inner_name {
            fn add_chunk(&mut self) {
                const CHUNK_SIZE: usize = 100;
                let mut chunk: Box<[#name; 100]> = Box::new(unsafe { mem::zeroed() });
                let ptr = chunk.as_mut_ptr();

                for i in 0..CHUNK_SIZE {
                    unsafe {
                        let item_ptr = ptr.add(i);
                        self.free_list.push(item_ptr);
                        self.freed_set.insert(item_ptr);
                    }
                }

                self.chunks.push(chunk);
            }
        }

        unsafe impl Send for #pool_name {}
        unsafe impl Sync for #pool_name {}
    }
}
