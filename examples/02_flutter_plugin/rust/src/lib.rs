// Example Flutter plugin implementation
// Generated code will be placed in src/generated/

// Placeholder - actual implementation would use generated code

#[no_mangle]
pub extern "C" fn example_add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(example_add(2, 3), 5);
    }
}
