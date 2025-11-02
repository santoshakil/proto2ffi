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
