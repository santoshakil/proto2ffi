pub trait Calculator {
    fn add(&self, a: i64, b: i64) -> i64;
    fn subtract(&self, a: i64, b: i64) -> i64;
    fn multiply(&self, a: i64, b: i64) -> i64;
    fn divide(&self, a: i64, b: i64) -> Option<i64>;
}

pub struct BasicCalculator;

impl Calculator for BasicCalculator {
    fn add(&self, a: i64, b: i64) -> i64 {
        a.saturating_add(b)
    }

    fn subtract(&self, a: i64, b: i64) -> i64 {
        a.saturating_sub(b)
    }

    fn multiply(&self, a: i64, b: i64) -> i64 {
        a.saturating_mul(b)
    }

    fn divide(&self, a: i64, b: i64) -> Option<i64> {
        if b == 0 {
            None
        } else {
            Some(a / b)
        }
    }
}
