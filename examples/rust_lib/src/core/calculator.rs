pub trait Calculator {
    fn add(&self, a: i64, b: i64) -> i64;
    fn subtract(&self, a: i64, b: i64) -> i64;
    fn multiply(&self, a: i64, b: i64) -> i64;
    fn divide(&self, a: i64, b: i64) -> Option<i64>;
}

pub struct BasicCalculator;

impl Calculator for BasicCalculator {
    #[inline(always)]
    fn add(&self, a: i64, b: i64) -> i64 {
        a.saturating_add(b)
    }

    #[inline(always)]
    fn subtract(&self, a: i64, b: i64) -> i64 {
        a.saturating_sub(b)
    }

    #[inline(always)]
    fn multiply(&self, a: i64, b: i64) -> i64 {
        a.saturating_mul(b)
    }

    #[inline(always)]
    fn divide(&self, a: i64, b: i64) -> Option<i64> {
        if b == 0 {
            None
        } else {
            Some(a / b)
        }
    }
}
