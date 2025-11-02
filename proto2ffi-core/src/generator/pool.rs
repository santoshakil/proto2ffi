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
            inner: std::sync::Mutex<#pool_inner_name>,
        }

        struct #pool_inner_name {
            chunks: Vec<Box<[#name; 100]>>,
            free_list: Vec<*mut #name>,
            allocated: usize,
        }

        impl #pool_name {
            pub fn new(capacity: usize) -> Self {
                const CHUNK_SIZE: usize = 100;
                let chunk_count = (capacity + CHUNK_SIZE - 1) / CHUNK_SIZE;
                let mut inner = #pool_inner_name {
                    chunks: Vec::with_capacity(chunk_count),
                    free_list: Vec::with_capacity(capacity),
                    allocated: 0,
                };

                for _ in 0..chunk_count {
                    inner.add_chunk();
                }

                #pool_name {
                    inner: std::sync::Mutex::new(inner),
                }
            }

            pub fn allocate(&self) -> *mut #name {
                let mut inner = self.inner.lock().unwrap();
                if inner.free_list.is_empty() {
                    inner.add_chunk();
                }

                let ptr = inner.free_list.pop()
                    .expect("free_list should not be empty after add_chunk");
                inner.allocated += 1;
                ptr
            }

            pub fn free(&self, ptr: *mut #name) {
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

        impl #pool_inner_name {
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
        }

        unsafe impl Send for #pool_name {}
        unsafe impl Sync for #pool_name {}
    }
}
