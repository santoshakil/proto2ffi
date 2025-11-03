use crate::layout::{MessageLayout, FieldLayout};
use quote::{quote, format_ident};
use proc_macro2::TokenStream;

pub fn generate_simd_operations(message: &MessageLayout) -> Option<TokenStream> {
    if message.options.get("proto2ffi.simd") != Some(&"true".to_string()) {
        return None;
    }

    let name = format_ident!("{}", message.name);

    let sum_operations = generate_sum_operations(message, &name);
    let min_max_operations = generate_min_max_operations(message, &name);
    let multiply_operations = generate_multiply_operations(message, &name);
    let average_operations = generate_average_operations(message, &name);
    let count_operations = generate_count_operations(message, &name);
    let dot_product_operations = generate_dot_product_operations(message, &name);

    Some(quote! {
        #[cfg(target_arch = "x86_64")]
        pub mod simd {
            use super::*;
            use std::arch::x86_64::*;

            #sum_operations
            #min_max_operations
            #multiply_operations
            #average_operations
            #count_operations
            #dot_product_operations
        }
    })
}

fn generate_sum_operations(message: &MessageLayout, name: &proc_macro2::Ident) -> TokenStream {
    let mut ops = Vec::new();

    for field in &message.fields {
        if is_summable_type(field) && !field.repeated {
            let field_name = format_ident!("{}", field.name);
            let fn_name = format_ident!("sum_{}_batch", field.name);

            ops.push(match field.size {
                8 => {
                    quote! {
                        #[target_feature(enable = "avx2")]
                        pub unsafe fn #fn_name(items: &[#name]) -> i64 {
                            let mut total = _mm256_setzero_si256();

                            for chunk in items.chunks_exact(4) {
                                let v0 = chunk[0].#field_name;
                                let v1 = chunk[1].#field_name;
                                let v2 = chunk[2].#field_name;
                                let v3 = chunk[3].#field_name;

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
                                sum += item.#field_name;
                            }

                            sum
                        }
                    }
                }
                4 => {
                    quote! {
                        #[target_feature(enable = "avx2")]
                        pub unsafe fn #fn_name(items: &[#name]) -> i64 {
                            let mut total = _mm256_setzero_si256();

                            for chunk in items.chunks_exact(8) {
                                let values = _mm256_set_epi32(
                                    chunk[7].#field_name as i32,
                                    chunk[6].#field_name as i32,
                                    chunk[5].#field_name as i32,
                                    chunk[4].#field_name as i32,
                                    chunk[3].#field_name as i32,
                                    chunk[2].#field_name as i32,
                                    chunk[1].#field_name as i32,
                                    chunk[0].#field_name as i32,
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
                                sum += item.#field_name as i64;
                            }

                            sum
                        }
                    }
                }
                _ => continue,
            });
        }
    }

    quote! {
        #(#ops)*
    }
}

fn is_summable_type(field: &FieldLayout) -> bool {
    field.rust_type == "i32"
        || field.rust_type == "i64"
        || field.rust_type == "u32"
        || field.rust_type == "u64"
}

fn generate_min_max_operations(message: &MessageLayout, name: &proc_macro2::Ident) -> TokenStream {
    let mut ops = Vec::new();

    for field in &message.fields {
        if is_summable_type(field) && !field.repeated && field.size == 4 {
            let field_name = format_ident!("{}", field.name);
            let fn_name = format_ident!("min_max_{}_batch", field.name);

            ops.push(quote! {
                #[target_feature(enable = "avx2")]
                pub unsafe fn #fn_name(items: &[#name]) -> (i32, i32) {
                    if items.is_empty() {
                        return (i32::MAX, i32::MIN);
                    }

                    let mut min_vec = _mm256_set1_epi32(i32::MAX);
                    let mut max_vec = _mm256_set1_epi32(i32::MIN);

                    for chunk in items.chunks_exact(8) {
                        let values = _mm256_set_epi32(
                            chunk[7].#field_name as i32,
                            chunk[6].#field_name as i32,
                            chunk[5].#field_name as i32,
                            chunk[4].#field_name as i32,
                            chunk[3].#field_name as i32,
                            chunk[2].#field_name as i32,
                            chunk[1].#field_name as i32,
                            chunk[0].#field_name as i32,
                        );
                        min_vec = _mm256_min_epi32(min_vec, values);
                        max_vec = _mm256_max_epi32(max_vec, values);
                    }

                    let min_array: [i32; 8] = std::mem::transmute(min_vec);
                    let max_array: [i32; 8] = std::mem::transmute(max_vec);

                    let mut min_val = *min_array.iter().min().unwrap();
                    let mut max_val = *max_array.iter().max().unwrap();

                    let remainder = &items[items.len() & !7..];
                    for item in remainder {
                        let val = item.#field_name as i32;
                        min_val = min_val.min(val);
                        max_val = max_val.max(val);
                    }

                    (min_val, max_val)
                }
            });
        }
    }

    quote! {
        #(#ops)*
    }
}

fn generate_multiply_operations(message: &MessageLayout, name: &proc_macro2::Ident) -> TokenStream {
    let mut ops = Vec::new();

    for field in &message.fields {
        if is_summable_type(field) && !field.repeated && field.size == 4 {
            let field_name = format_ident!("{}", field.name);
            let fn_name = format_ident!("multiply_{}_batch", field.name);

            ops.push(quote! {
                #[target_feature(enable = "avx2")]
                pub unsafe fn #fn_name(items: &[#name], scalar: i32) -> Vec<i32> {
                    let mut result = Vec::with_capacity(items.len());
                    let scalar_vec = _mm256_set1_epi32(scalar);

                    for chunk in items.chunks_exact(8) {
                        let values = _mm256_set_epi32(
                            chunk[7].#field_name as i32,
                            chunk[6].#field_name as i32,
                            chunk[5].#field_name as i32,
                            chunk[4].#field_name as i32,
                            chunk[3].#field_name as i32,
                            chunk[2].#field_name as i32,
                            chunk[1].#field_name as i32,
                            chunk[0].#field_name as i32,
                        );
                        let multiplied = _mm256_mullo_epi32(values, scalar_vec);
                        let output: [i32; 8] = std::mem::transmute(multiplied);
                        result.extend_from_slice(&output);
                    }

                    let remainder = &items[items.len() & !7..];
                    for item in remainder {
                        result.push((item.#field_name as i32).wrapping_mul(scalar));
                    }

                    result
                }
            });
        }
    }

    quote! {
        #(#ops)*
    }
}

fn generate_average_operations(message: &MessageLayout, name: &proc_macro2::Ident) -> TokenStream {
    let mut ops = Vec::new();

    for field in &message.fields {
        if is_summable_type(field) && !field.repeated {
            let field_name = format_ident!("{}", field.name);
            let fn_name = format_ident!("average_{}_batch", field.name);

            if field.size == 4 {
                ops.push(quote! {
                    #[target_feature(enable = "avx2")]
                    pub unsafe fn #fn_name(items: &[#name]) -> f64 {
                        if items.is_empty() {
                            return 0.0;
                        }

                        let mut total = _mm256_setzero_si256();

                        for chunk in items.chunks_exact(8) {
                            let values = _mm256_set_epi32(
                                chunk[7].#field_name as i32,
                                chunk[6].#field_name as i32,
                                chunk[5].#field_name as i32,
                                chunk[4].#field_name as i32,
                                chunk[3].#field_name as i32,
                                chunk[2].#field_name as i32,
                                chunk[1].#field_name as i32,
                                chunk[0].#field_name as i32,
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
                            sum += item.#field_name as i64;
                        }

                        sum as f64 / items.len() as f64
                    }
                });
            }
        }
    }

    quote! {
        #(#ops)*
    }
}
fn generate_count_operations(message: &MessageLayout, name: &proc_macro2::Ident) -> TokenStream {
    let mut ops = Vec::new();

    for field in &message.fields {
        if is_summable_type(field) && !field.repeated && field.size == 4 {
            let field_name = format_ident!("{}", field.name);
            let fn_name = format_ident!("count_{}_gt", field.name);

            ops.push(quote! {
                #[target_feature(enable = "avx2")]
                pub unsafe fn #fn_name(items: &[#name], threshold: i32) -> usize {
                    let threshold_vec = _mm256_set1_epi32(threshold);
                    let mut count = 0usize;

                    for chunk in items.chunks_exact(8) {
                        let values = _mm256_set_epi32(
                            chunk[7].#field_name as i32,
                            chunk[6].#field_name as i32,
                            chunk[5].#field_name as i32,
                            chunk[4].#field_name as i32,
                            chunk[3].#field_name as i32,
                            chunk[2].#field_name as i32,
                            chunk[1].#field_name as i32,
                            chunk[0].#field_name as i32,
                        );
                        let cmp = _mm256_cmpgt_epi32(values, threshold_vec);
                        let mask = _mm256_movemask_epi8(cmp);
                        count += mask.count_ones() as usize / 4;
                    }

                    let remainder = &items[items.len() & !7..];
                    for item in remainder {
                        if item.#field_name as i32 > threshold {
                            count += 1;
                        }
                    }

                    count
                }
            });
        }
    }

    quote! {
        #(#ops)*
    }
}

fn generate_dot_product_operations(message: &MessageLayout, name: &proc_macro2::Ident) -> TokenStream {
    let mut ops = Vec::new();

    for field in &message.fields {
        if is_summable_type(field) && !field.repeated && field.size == 4 {
            let field_name = format_ident!("{}", field.name);
            let fn_name = format_ident!("dot_product_{}", field.name);

            ops.push(quote! {
                #[target_feature(enable = "avx2")]
                pub unsafe fn #fn_name(items_a: &[#name], items_b: &[#name]) -> i64 {
                    let len = items_a.len().min(items_b.len());
                    let mut total = _mm256_setzero_si256();

                    let chunks = len / 8;
                    for i in 0..chunks {
                        let base = i * 8;
                        let values_a = _mm256_set_epi32(
                            items_a[base + 7].#field_name as i32,
                            items_a[base + 6].#field_name as i32,
                            items_a[base + 5].#field_name as i32,
                            items_a[base + 4].#field_name as i32,
                            items_a[base + 3].#field_name as i32,
                            items_a[base + 2].#field_name as i32,
                            items_a[base + 1].#field_name as i32,
                            items_a[base + 0].#field_name as i32,
                        );
                        let values_b = _mm256_set_epi32(
                            items_b[base + 7].#field_name as i32,
                            items_b[base + 6].#field_name as i32,
                            items_b[base + 5].#field_name as i32,
                            items_b[base + 4].#field_name as i32,
                            items_b[base + 3].#field_name as i32,
                            items_b[base + 2].#field_name as i32,
                            items_b[base + 1].#field_name as i32,
                            items_b[base + 0].#field_name as i32,
                        );
                        let product = _mm256_mullo_epi32(values_a, values_b);
                        total = _mm256_add_epi32(total, product);
                    }

                    let mut sum = 0i64;
                    let result: [i32; 8] = std::mem::transmute(total);
                    for val in &result {
                        sum += *val as i64;
                    }

                    let remainder_start = chunks * 8;
                    for i in remainder_start..len {
                        sum += (items_a[i].#field_name as i64) * (items_b[i].#field_name as i64);
                    }

                    sum
                }
            });
        }
    }

    quote! {
        #(#ops)*
    }
}
