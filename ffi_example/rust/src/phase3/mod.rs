pub mod generated;

use generated::*;
use std::sync::Mutex;
use std::time::Instant;

static PARTICLE_POOL: Mutex<Option<ParticlePool>> = Mutex::new(None);
static RIGIDBODY_POOL: Mutex<Option<RigidBodyPool>> = Mutex::new(None);
static POOL_STATS: Mutex<PoolStats> = Mutex::new(PoolStats {
    total_allocations: 0,
    total_frees: 0,
    active_objects: 0,
    pool_hits: 0,
    pool_misses: 0,
});

#[no_mangle]
pub extern "C" fn particle_pool_init(capacity: usize) {
    let mut pool_guard = PARTICLE_POOL.lock().unwrap();
    *pool_guard = Some(ParticlePool::new(capacity));
}

#[no_mangle]
pub extern "C" fn particle_pool_allocate() -> *mut Particle {
    let mut pool_guard = PARTICLE_POOL.lock().unwrap();
    let mut stats = POOL_STATS.lock().unwrap();

    stats.total_allocations += 1;
    stats.active_objects += 1;

    if let Some(pool) = pool_guard.as_mut() {
        stats.pool_hits += 1;
        pool.allocate()
    } else {
        stats.pool_misses += 1;
        let particle = Box::into_raw(Box::new(Particle::default()));
        particle
    }
}

#[no_mangle]
pub extern "C" fn particle_pool_free(ptr: *mut Particle) {
    if ptr.is_null() {
        return;
    }

    let mut pool_guard = PARTICLE_POOL.lock().unwrap();
    let mut stats = POOL_STATS.lock().unwrap();

    stats.total_frees += 1;
    stats.active_objects = stats.active_objects.saturating_sub(1);

    if let Some(pool) = pool_guard.as_mut() {
        pool.free(ptr);
    } else {
        unsafe {
            let _ = Box::from_raw(ptr);
        }
    }
}

#[no_mangle]
pub extern "C" fn rigidbody_pool_init(capacity: usize) {
    let mut pool_guard = RIGIDBODY_POOL.lock().unwrap();
    *pool_guard = Some(RigidBodyPool::new(capacity));
}

#[no_mangle]
pub extern "C" fn rigidbody_pool_allocate() -> *mut RigidBody {
    let mut pool_guard = RIGIDBODY_POOL.lock().unwrap();
    let mut stats = POOL_STATS.lock().unwrap();

    stats.total_allocations += 1;
    stats.active_objects += 1;

    if let Some(pool) = pool_guard.as_mut() {
        stats.pool_hits += 1;
        pool.allocate()
    } else {
        stats.pool_misses += 1;
        let body = Box::into_raw(Box::new(RigidBody::default()));
        body
    }
}

#[no_mangle]
pub extern "C" fn rigidbody_pool_free(ptr: *mut RigidBody) {
    if ptr.is_null() {
        return;
    }

    let mut pool_guard = RIGIDBODY_POOL.lock().unwrap();
    let mut stats = POOL_STATS.lock().unwrap();

    stats.total_frees += 1;
    stats.active_objects = stats.active_objects.saturating_sub(1);

    if let Some(pool) = pool_guard.as_mut() {
        pool.free(ptr);
    } else {
        unsafe {
            let _ = Box::from_raw(ptr);
        }
    }
}

#[no_mangle]
pub extern "C" fn pool_get_stats(stats: *mut PoolStats) {
    if !stats.is_null() {
        unsafe {
            let stats_guard = POOL_STATS.lock().unwrap();
            *stats = *stats_guard;
        }
    }
}

#[no_mangle]
pub extern "C" fn pool_reset_stats() {
    let mut stats = POOL_STATS.lock().unwrap();
    *stats = PoolStats::default();
}

#[no_mangle]
pub extern "C" fn particle_update(p: *mut Particle, dt: f64) {
    unsafe {
        if p.is_null() || (*p).active == 0 {
            return;
        }
        let particle = &mut *p;
        particle.x += particle.vx * dt;
        particle.y += particle.vy * dt;
        particle.z += particle.vz * dt;
    }
}

#[no_mangle]
pub extern "C" fn rigidbody_update(rb: *mut RigidBody, dt: f64) {
    unsafe {
        if rb.is_null() {
            return;
        }
        let body = &mut *rb;

        body.vx += body.ax * dt;
        body.vy += body.ay * dt;
        body.vz += body.az * dt;

        body.px += body.vx * dt;
        body.py += body.vy * dt;
        body.pz += body.vz * dt;
    }
}

#[no_mangle]
pub extern "C" fn benchmark_pool_vs_malloc(
    count: usize,
    iterations: usize,
    pool_time_us: *mut u64,
    malloc_time_us: *mut u64,
) {
    particle_pool_init(count);

    let start = Instant::now();
    for _ in 0..iterations {
        let mut particles = Vec::with_capacity(count);
        for _ in 0..count {
            let p = particle_pool_allocate();
            particles.push(p);
        }
        for p in particles {
            particle_pool_free(p);
        }
    }
    let pool_elapsed = start.elapsed().as_micros() as u64;

    let start = Instant::now();
    for _ in 0..iterations {
        let mut particles = Vec::with_capacity(count);
        for _ in 0..count {
            let p = Box::into_raw(Box::new(Particle::default()));
            particles.push(p);
        }
        for p in particles {
            unsafe {
                let _ = Box::from_raw(p);
            }
        }
    }
    let malloc_elapsed = start.elapsed().as_micros() as u64;

    unsafe {
        if !pool_time_us.is_null() {
            *pool_time_us = pool_elapsed;
        }
        if !malloc_time_us.is_null() {
            *malloc_time_us = malloc_elapsed;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_particle_pool() {
        particle_pool_init(100);

        let p1 = particle_pool_allocate();
        let p2 = particle_pool_allocate();

        assert!(!p1.is_null());
        assert!(!p2.is_null());
        assert_ne!(p1, p2);

        particle_pool_free(p1);
        particle_pool_free(p2);

        let stats = PoolStats::default();
        pool_get_stats(&stats as *const PoolStats as *mut PoolStats);
    }

    #[test]
    fn test_rigidbody_pool() {
        rigidbody_pool_init(100);

        let rb1 = rigidbody_pool_allocate();
        let rb2 = rigidbody_pool_allocate();

        assert!(!rb1.is_null());
        assert!(!rb2.is_null());
        assert_ne!(rb1, rb2);

        rigidbody_pool_free(rb1);
        rigidbody_pool_free(rb2);
    }

    #[test]
    fn test_particle_update() {
        let mut p = Particle::default();
        p.active = 1;
        p.x = 0.0;
        p.vx = 10.0;

        particle_update(&mut p, 1.0);

        assert_eq!(p.x, 10.0);
    }

    #[test]
    fn test_benchmark() {
        let mut pool_time = 0u64;
        let mut malloc_time = 0u64;

        benchmark_pool_vs_malloc(1000, 10, &mut pool_time, &mut malloc_time);

        assert!(pool_time > 0);
        assert!(malloc_time > 0);
        println!("Pool: {}μs, Malloc: {}μs", pool_time, malloc_time);
    }
}
