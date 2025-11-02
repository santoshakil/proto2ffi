use crate::layout::MessageLayout;
use quote::{quote, format_ident};
use proc_macro2::TokenStream;

pub fn generate_pool_allocator(message: &MessageLayout) -> TokenStream {
    let name = format_ident!("{}", message.name);
    let pool_name = format_ident!("{}Pool", message.name);

    let _pool_size = message.options
        .get("proto2ffi.pool_size")
        .and_then(|s| s.parse::<usize>().ok())
        .unwrap_or(1000);

    const CHUNK_SIZE: usize = 100;

    quote! {
        pub struct #pool_name {
            chunks: Vec<Box<[#name; 100]>>,
            free_list: Vec<*mut #name>,
            allocated: std::sync::atomic::AtomicUsize,
        }

        impl #pool_name {
            pub fn new(capacity: usize) -> Self {
                const CHUNK_SIZE: usize = 100;
                let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
                let mut pool = #pool_name {
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
                let mut chunk: Box<[#name; 100]> = Box::new(unsafe { mem::zeroed() });
                let ptr = chunk.as_mut_ptr();

                for i in 0..CHUNK_SIZE {
                    unsafe {
                        self.free_list.push(ptr.add(i));
                    }
                }

                self.chunks.push(chunk);
            }

            pub fn allocate(&mut self) -> *mut #name {
                if self.free_list.is_empty() {
                    self.add_chunk();
                }

                let ptr = self.free_list.pop()
                    .expect("free_list should not be empty after add_chunk");
                self.allocated.fetch_add(1, std::sync::atomic::Ordering::Relaxed);
                ptr
            }

            pub fn free(&mut self, ptr: *mut #name) {
                self.free_list.push(ptr);
                self.allocated.fetch_sub(1, std::sync::atomic::Ordering::Relaxed);
            }

            pub fn allocated_count(&self) -> usize {
                self.allocated.load(std::sync::atomic::Ordering::Relaxed)
            }

            pub fn capacity(&self) -> usize {
                const CHUNK_SIZE: usize = 100;
                self.chunks.len() * CHUNK_SIZE
            }
        }

        unsafe impl Send for #pool_name {}
    }
}
