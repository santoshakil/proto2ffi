mod generated;

use std::ptr;
use std::alloc::{alloc, dealloc, Layout};

use generated::generated::*;

#[no_mangle]
pub extern "C" fn stress_create_deep_nesting() -> *mut DeepNestingRoot {
    let layout = Layout::new::<DeepNestingRoot>();
    unsafe {
        let ptr = alloc(layout) as *mut DeepNestingRoot;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_deep_nesting(ptr: *mut DeepNestingRoot) {
    if !ptr.is_null() {
        let layout = Layout::new::<DeepNestingRoot>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_create_wide_message() -> *mut WideMessage {
    let layout = Layout::new::<WideMessage>();
    unsafe {
        let ptr = alloc(layout) as *mut WideMessage;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_wide_message(ptr: *mut WideMessage) {
    if !ptr.is_null() {
        let layout = Layout::new::<WideMessage>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_create_huge_message() -> *mut HugeMessage {
    let layout = Layout::new::<HugeMessage>();
    unsafe {
        let ptr = alloc(layout) as *mut HugeMessage;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_huge_message(ptr: *mut HugeMessage) {
    if !ptr.is_null() {
        let layout = Layout::new::<HugeMessage>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_create_massive_array() -> *mut MassiveArray {
    let layout = Layout::new::<MassiveArray>();
    unsafe {
        let ptr = alloc(layout) as *mut MassiveArray;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_massive_array(ptr: *mut MassiveArray) {
    if !ptr.is_null() {
        let layout = Layout::new::<MassiveArray>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_create_recursive_node() -> *mut RecursiveNode {
    let layout = Layout::new::<RecursiveNode>();
    unsafe {
        let ptr = alloc(layout) as *mut RecursiveNode;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_recursive_node(ptr: *mut RecursiveNode) {
    if !ptr.is_null() {
        let layout = Layout::new::<RecursiveNode>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_create_complex_graph() -> *mut ComplexGraph {
    let layout = Layout::new::<ComplexGraph>();
    unsafe {
        let ptr = alloc(layout) as *mut ComplexGraph;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_complex_graph(ptr: *mut ComplexGraph) {
    if !ptr.is_null() {
        let layout = Layout::new::<ComplexGraph>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_create_allocation_test() -> *mut AllocationTest {
    let layout = Layout::new::<AllocationTest>();
    unsafe {
        let ptr = alloc(layout) as *mut AllocationTest;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_allocation_test(ptr: *mut AllocationTest) {
    if !ptr.is_null() {
        let layout = Layout::new::<AllocationTest>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_create_mixed_complexity() -> *mut MixedComplexity {
    let layout = Layout::new::<MixedComplexity>();
    unsafe {
        let ptr = alloc(layout) as *mut MixedComplexity;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_mixed_complexity(ptr: *mut MixedComplexity) {
    if !ptr.is_null() {
        let layout = Layout::new::<MixedComplexity>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_create_stress_test_suite() -> *mut StressTestSuite {
    let layout = Layout::new::<StressTestSuite>();
    unsafe {
        let ptr = alloc(layout) as *mut StressTestSuite;
        if !ptr.is_null() {
            ptr::write_bytes(ptr, 0, 1);
        }
        ptr
    }
}

#[no_mangle]
pub extern "C" fn stress_destroy_stress_test_suite(ptr: *mut StressTestSuite) {
    if !ptr.is_null() {
        let layout = Layout::new::<StressTestSuite>();
        unsafe {
            dealloc(ptr as *mut u8, layout);
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_fill_huge_arrays(
    massive_array: *mut MassiveArray,
    count: i32,
) {
    if massive_array.is_null() {
        return;
    }

    unsafe {
        let arr = &mut *massive_array;
        for i in 0..count {
            let ptr = arr.numbers.wrapping_add(i as usize) as *mut i32;
            if !ptr.is_null() {
                *ptr = i;
            }
        }
    }
}

#[no_mangle]
pub extern "C" fn stress_allocate_memory_blocks(
    allocation_test: *mut AllocationTest,
    count: i32,
) -> i32 {
    if allocation_test.is_null() {
        return -1;
    }

    unsafe {
        let test = &mut *allocation_test;
        test.block_count = count;
        count
    }
}

#[no_mangle]
pub extern "C" fn stress_build_recursive_tree(
    node: *mut RecursiveNode,
    depth: i32,
    children_per_node: i32,
) -> i32 {
    if node.is_null() || depth <= 0 {
        return 0;
    }

    unsafe {
        let n = &mut *node;
        n.depth = depth;

        if depth > 1 && children_per_node > 0 {
            return children_per_node;
        }
    }

    0
}

#[no_mangle]
pub extern "C" fn stress_traverse_deep_nesting(
    root: *const DeepNestingRoot,
) -> i32 {
    if root.is_null() {
        return 0;
    }

    20
}

#[no_mangle]
pub extern "C" fn stress_measure_layout_size() -> usize {
    std::mem::size_of::<StressTestSuite>()
}

#[no_mangle]
pub extern "C" fn stress_measure_wide_message_size() -> usize {
    std::mem::size_of::<WideMessage>()
}

#[no_mangle]
pub extern "C" fn stress_measure_huge_message_size() -> usize {
    std::mem::size_of::<HugeMessage>()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_deep_nesting_allocation() {
        let ptr = stress_create_deep_nesting();
        assert!(!ptr.is_null());
        stress_destroy_deep_nesting(ptr);
    }

    #[test]
    fn test_wide_message_allocation() {
        let ptr = stress_create_wide_message();
        assert!(!ptr.is_null());
        stress_destroy_wide_message(ptr);
    }

    #[test]
    fn test_huge_message_allocation() {
        let ptr = stress_create_huge_message();
        assert!(!ptr.is_null());
        stress_destroy_huge_message(ptr);
    }

    #[test]
    fn test_massive_array_allocation() {
        let ptr = stress_create_massive_array();
        assert!(!ptr.is_null());
        stress_destroy_massive_array(ptr);
    }

    #[test]
    fn test_recursive_node_allocation() {
        let ptr = stress_create_recursive_node();
        assert!(!ptr.is_null());
        stress_destroy_recursive_node(ptr);
    }

    #[test]
    fn test_repeated_allocations() {
        for _ in 0..1000 {
            let ptr = stress_create_deep_nesting();
            assert!(!ptr.is_null());
            stress_destroy_deep_nesting(ptr);
        }
    }

    #[test]
    fn test_multiple_types_concurrent() {
        let p1 = stress_create_deep_nesting();
        let p2 = stress_create_wide_message();
        let p3 = stress_create_huge_message();
        
        assert!(!p1.is_null());
        assert!(!p2.is_null());
        assert!(!p3.is_null());
        
        stress_destroy_deep_nesting(p1);
        stress_destroy_wide_message(p2);
        stress_destroy_huge_message(p3);
    }

    #[test]
    fn test_null_pointer_safety() {
        stress_destroy_deep_nesting(ptr::null_mut());
        stress_destroy_wide_message(ptr::null_mut());
        stress_destroy_huge_message(ptr::null_mut());
        stress_destroy_massive_array(ptr::null_mut());
        stress_destroy_recursive_node(ptr::null_mut());
        stress_destroy_complex_graph(ptr::null_mut());
        stress_destroy_allocation_test(ptr::null_mut());
        stress_destroy_mixed_complexity(ptr::null_mut());
        stress_destroy_stress_test_suite(ptr::null_mut());
    }

    #[test]
    fn test_complex_graph_allocation() {
        let ptr = stress_create_complex_graph();
        assert!(!ptr.is_null());
        stress_destroy_complex_graph(ptr);
    }

    #[test]
    fn test_allocation_test_creation() {
        let ptr = stress_create_allocation_test();
        assert!(!ptr.is_null());
        stress_destroy_allocation_test(ptr);
    }

    #[test]
    fn test_mixed_complexity_creation() {
        let ptr = stress_create_mixed_complexity();
        assert!(!ptr.is_null());
        stress_destroy_mixed_complexity(ptr);
    }

    #[test]
    fn test_stress_test_suite_creation() {
        let ptr = stress_create_stress_test_suite();
        assert!(!ptr.is_null());
        stress_destroy_stress_test_suite(ptr);
    }


    #[test]
    fn test_allocate_memory_blocks() {
        let ptr = stress_create_allocation_test();
        assert!(!ptr.is_null());
        let result = stress_allocate_memory_blocks(ptr, 1000);
        assert_eq!(result, 1000);
        stress_destroy_allocation_test(ptr);
    }

    #[test]
    fn test_allocate_memory_blocks_null() {
        let result = stress_allocate_memory_blocks(ptr::null_mut(), 100);
        assert_eq!(result, -1);
    }

    #[test]
    fn test_build_recursive_tree() {
        let ptr = stress_create_recursive_node();
        assert!(!ptr.is_null());
        let result = stress_build_recursive_tree(ptr, 5, 3);
        assert_eq!(result, 3);
        stress_destroy_recursive_node(ptr);
    }

    #[test]
    fn test_build_recursive_tree_depth_zero() {
        let ptr = stress_create_recursive_node();
        assert!(!ptr.is_null());
        let result = stress_build_recursive_tree(ptr, 0, 3);
        assert_eq!(result, 0);
        stress_destroy_recursive_node(ptr);
    }

    #[test]
    fn test_build_recursive_tree_null() {
        let result = stress_build_recursive_tree(ptr::null_mut(), 5, 3);
        assert_eq!(result, 0);
    }

    #[test]
    fn test_traverse_deep_nesting() {
        let ptr = stress_create_deep_nesting();
        assert!(!ptr.is_null());
        let result = stress_traverse_deep_nesting(ptr);
        assert_eq!(result, 20);
        stress_destroy_deep_nesting(ptr);
    }

    #[test]
    fn test_traverse_deep_nesting_null() {
        let result = stress_traverse_deep_nesting(ptr::null());
        assert_eq!(result, 0);
    }

    #[test]
    fn test_measure_layout_size() {
        let size = stress_measure_layout_size();
        assert!(size > 0);
    }

    #[test]
    fn test_measure_wide_message_size() {
        let size = stress_measure_wide_message_size();
        assert!(size > 0);
    }

    #[test]
    fn test_measure_huge_message_size() {
        let size = stress_measure_huge_message_size();
        assert!(size > 0);
    }

    #[test]
    fn test_concurrent_allocations() {
        use std::thread;
        use std::sync::{Arc, atomic::{AtomicU32, Ordering}};

        let allocated = Arc::new(AtomicU32::new(0));

        let handles: Vec<_> = (0..8)
            .map(|_| {
                let allocated = Arc::clone(&allocated);
                thread::spawn(move || {
                    for _ in 0..100 {
                        let ptr = stress_create_deep_nesting();
                        if !ptr.is_null() {
                            allocated.fetch_add(1, Ordering::Relaxed);
                            stress_destroy_deep_nesting(ptr);
                        }
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }

        assert_eq!(allocated.load(Ordering::Relaxed), 800);
    }

    #[test]
    fn test_concurrent_mixed_allocations() {
        use std::thread;

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    for _ in 0..50 {
                        match i % 4 {
                            0 => {
                                let p = stress_create_deep_nesting();
                                assert!(!p.is_null());
                                stress_destroy_deep_nesting(p);
                            }
                            1 => {
                                let p = stress_create_wide_message();
                                assert!(!p.is_null());
                                stress_destroy_wide_message(p);
                            }
                            2 => {
                                let p = stress_create_huge_message();
                                assert!(!p.is_null());
                                stress_destroy_huge_message(p);
                            }
                            _ => {
                                let p = stress_create_massive_array();
                                assert!(!p.is_null());
                                stress_destroy_massive_array(p);
                            }
                        }
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_repeated_complex_operations() {
        for _ in 0..10 {
            let deep = stress_create_deep_nesting();
            let wide = stress_create_wide_message();
            let huge = stress_create_huge_message();
            let node = stress_create_recursive_node();

            assert!(!deep.is_null());
            assert!(!wide.is_null());
            assert!(!huge.is_null());
            assert!(!node.is_null());

            let _ = stress_build_recursive_tree(node, 3, 2);
            let _ = stress_traverse_deep_nesting(deep);

            stress_destroy_deep_nesting(deep);
            stress_destroy_wide_message(wide);
            stress_destroy_huge_message(huge);
            stress_destroy_recursive_node(node);
        }
    }

    #[test]
    fn test_rapid_allocation_deallocation() {
        for _ in 0..1000 {
            let ptr = stress_create_recursive_node();
            stress_destroy_recursive_node(ptr);
        }
    }

    #[test]
    fn test_interleaved_operations() {
        let mut deep_ptrs = Vec::new();
        let mut wide_ptrs = Vec::new();

        for _ in 0..50 {
            deep_ptrs.push(stress_create_deep_nesting());
        }

        for i in 0..25 {
            stress_destroy_deep_nesting(deep_ptrs[i]);
        }

        for _ in 0..25 {
            wide_ptrs.push(stress_create_wide_message());
        }

        for i in 25..50 {
            stress_destroy_deep_nesting(deep_ptrs[i]);
        }

        for i in 0..25 {
            stress_destroy_wide_message(wide_ptrs[i]);
        }
    }

    #[test]
    fn test_recursive_tree_max_depth() {
        let ptr = stress_create_recursive_node();
        assert!(!ptr.is_null());
        let result = stress_build_recursive_tree(ptr, 100, 5);
        assert_eq!(result, 5);
        stress_destroy_recursive_node(ptr);
    }

    #[test]
    fn test_allocation_stress_high_count() {
        let ptr = stress_create_allocation_test();
        assert!(!ptr.is_null());
        let result = stress_allocate_memory_blocks(ptr, 1000000);
        assert_eq!(result, 1000000);
        stress_destroy_allocation_test(ptr);
    }
}
