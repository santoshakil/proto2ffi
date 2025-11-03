mod generated;

pub use generated::*;

#[no_mangle]
pub extern "C" fn point_distance(p1: *const Point, p2: *const Point) -> f64 {
    unsafe {
        let p1 = &*p1;
        let p2 = &*p2;
        let dx = p2.x - p1.x;
        let dy = p2.y - p1.y;
        (dx * dx + dy * dy).sqrt()
    }
}

#[no_mangle]
pub extern "C" fn point_midpoint(p1: *const Point, p2: *const Point, result: *mut Point) {
    unsafe {
        let p1 = &*p1;
        let p2 = &*p2;
        let result = &mut *result;
        result.x = (p1.x + p2.x) / 2.0;
        result.y = (p1.y + p2.y) / 2.0;
    }
}

#[no_mangle]
pub extern "C" fn counter_increment(counter: *mut Counter) -> i64 {
    unsafe {
        let counter = &mut *counter;
        counter.value += 1;
        counter.timestamp = get_timestamp_micros();
        counter.value
    }
}

#[no_mangle]
pub extern "C" fn counter_add(counter: *mut Counter, amount: i64) -> i64 {
    unsafe {
        let counter = &mut *counter;
        counter.value += amount;
        counter.timestamp = get_timestamp_micros();
        counter.value
    }
}

#[no_mangle]
pub extern "C" fn stats_update(stats: *mut Stats, value: f64) {
    unsafe {
        let stats = &mut *stats;
        stats.count += 1;
        stats.sum += value;

        if stats.count == 1 {
            stats.min = value;
            stats.max = value;
        } else {
            if value < stats.min {
                stats.min = value;
            }
            if value > stats.max {
                stats.max = value;
            }
        }

        stats.avg = stats.sum / stats.count as f64;
    }
}

#[no_mangle]
pub extern "C" fn stats_reset(stats: *mut Stats) {
    unsafe {
        let stats = &mut *stats;
        *stats = Stats::default();
    }
}

fn get_timestamp_micros() -> i64 {
    use std::time::{SystemTime, UNIX_EPOCH};
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_micros() as i64
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_point_distance() {
        let p1 = Point { x: 0.0, y: 0.0 };
        let p2 = Point { x: 3.0, y: 4.0 };

        let dist = point_distance(&p1 as *const Point, &p2 as *const Point);
        assert_eq!(dist, 5.0);
    }

    #[test]
    fn test_counter_increment() {
        let mut counter = Counter::default();

        counter_increment(&mut counter as *mut Counter);
        assert_eq!(counter.value, 1);

        counter_increment(&mut counter as *mut Counter);
        assert_eq!(counter.value, 2);
    }

    #[test]
    fn test_stats() {
        let mut stats = Stats::default();

        stats_update(&mut stats as *mut Stats, 10.0);
        stats_update(&mut stats as *mut Stats, 20.0);
        stats_update(&mut stats as *mut Stats, 30.0);

        assert_eq!(stats.count, 3);
        assert_eq!(stats.sum, 60.0);
        assert_eq!(stats.min, 10.0);
        assert_eq!(stats.max, 30.0);
        assert_eq!(stats.avg, 20.0);
    }
}
#[cfg(test)]
mod additional_tests {
    use super::*;

    #[test]
    fn test_point_midpoint() {
        let p1 = Point { x: 0.0, y: 0.0 };
        let p2 = Point { x: 10.0, y: 10.0 };
        let mut result = Point::default();
        
        point_midpoint(&p1, &p2, &mut result);
        assert_eq!(result.x, 5.0);
        assert_eq!(result.y, 5.0);
    }

    #[test]
    fn test_counter_add() {
        let mut counter = Counter::default();
        
        let val1 = counter_add(&mut counter, 10);
        assert_eq!(val1, 10);
        
        let val2 = counter_add(&mut counter, 25);
        assert_eq!(val2, 35);
        
        let val3 = counter_add(&mut counter, -5);
        assert_eq!(val3, 30);
    }

    #[test]
    fn test_stats_reset() {
        let mut stats = Stats::default();
        
        stats_update(&mut stats, 100.0);
        stats_update(&mut stats, 200.0);
        assert_eq!(stats.count, 2);
        
        stats_reset(&mut stats);
        assert_eq!(stats.count, 0);
        assert_eq!(stats.sum, 0.0);
    }

    #[test]
    fn test_point_distance_zero() {
        let p1 = Point { x: 5.0, y: 5.0 };
        let p2 = Point { x: 5.0, y: 5.0 };
        
        let dist = point_distance(&p1, &p2);
        assert_eq!(dist, 0.0);
    }

    #[test]
    fn test_point_distance_negative() {
        let p1 = Point { x: -3.0, y: -4.0 };
        let p2 = Point { x: 0.0, y: 0.0 };
        
        let dist = point_distance(&p1, &p2);
        assert_eq!(dist, 5.0);
    }

    #[test]
    fn test_counter_overflow() {
        let mut counter = Counter { value: i64::MAX - 1, timestamp: 0 };
        
        counter_increment(&mut counter);
        assert_eq!(counter.value, i64::MAX);
    }

    #[test]
    fn test_stats_single_value() {
        let mut stats = Stats::default();
        
        stats_update(&mut stats, 42.0);
        assert_eq!(stats.min, 42.0);
        assert_eq!(stats.max, 42.0);
        assert_eq!(stats.avg, 42.0);
    }

    #[test]
    fn test_stats_negative_values() {
        let mut stats = Stats::default();
        
        stats_update(&mut stats, -10.0);
        stats_update(&mut stats, -20.0);
        stats_update(&mut stats, -5.0);
        
        assert_eq!(stats.min, -20.0);
        assert_eq!(stats.max, -5.0);
        assert_eq!(stats.avg, -11.666666666666666);
    }

    #[test]
    fn test_point_midpoint_negative() {
        let p1 = Point { x: -10.0, y: -10.0 };
        let p2 = Point { x: 10.0, y: 10.0 };
        let mut result = Point::default();
        
        point_midpoint(&p1, &p2, &mut result);
        assert_eq!(result.x, 0.0);
        assert_eq!(result.y, 0.0);
    }

    #[test]
    fn test_counter_negative_add() {
        let mut counter = Counter::default();
        
        counter_add(&mut counter, -100);
        assert_eq!(counter.value, -100);
    }
}
