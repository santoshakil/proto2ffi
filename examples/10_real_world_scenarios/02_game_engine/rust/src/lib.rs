mod generated;

use generated::*;
use std::sync::{Arc, Mutex};

static TRANSFORM_POOL: once_cell::sync::Lazy<TransformPool> =
    once_cell::sync::Lazy::new(|| TransformPool::new(10000));

static RIGIDBODY_POOL: once_cell::sync::Lazy<RigidBodyPool> =
    once_cell::sync::Lazy::new(|| RigidBodyPool::new(5000));

static ENTITY_POOL: once_cell::sync::Lazy<EntityPool> =
    once_cell::sync::Lazy::new(|| EntityPool::new(10000));

static FRAME_STATS: once_cell::sync::Lazy<Arc<Mutex<FrameStats>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(FrameStats::default())));

#[no_mangle]
pub extern "C" fn game_create_entity(
    entity_id: u32,
    name_ptr: *const u8,
    name_len: u32,
) -> *mut Entity {
    let ptr = ENTITY_POOL.allocate();
    unsafe {
        (*ptr).entity_id = entity_id;
        (*ptr).component_count = 0;
        (*ptr).active = 1;
        (*ptr).layer = 0;
        (*ptr).tag = 0;

        if !name_ptr.is_null() && name_len > 0 {
            let len = std::cmp::min(name_len as usize, 63);
            let _name_slice = std::slice::from_raw_parts(name_ptr, len);
            std::ptr::copy_nonoverlapping(name_ptr, (*ptr).name.as_mut_ptr(), len);
            (*ptr).name[len] = 0;
        }
    }
    ptr
}

#[no_mangle]
pub extern "C" fn game_free_entity(ptr: *mut Entity) {
    if !ptr.is_null() {
        ENTITY_POOL.free(ptr);
    }
}

#[no_mangle]
pub extern "C" fn game_create_transform(
    x: f32,
    y: f32,
    z: f32,
) -> *mut Transform {
    let ptr = TRANSFORM_POOL.allocate();
    unsafe {
        (*ptr).position.x = x;
        (*ptr).position.y = y;
        (*ptr).position.z = z;
        (*ptr).rotation.x = 0.0;
        (*ptr).rotation.y = 0.0;
        (*ptr).rotation.z = 0.0;
        (*ptr).rotation.w = 1.0;
        (*ptr).scale.x = 1.0;
        (*ptr).scale.y = 1.0;
        (*ptr).scale.z = 1.0;
        (*ptr).parent_entity = 0;
        (*ptr).children_count = 0;
    }
    ptr
}

#[no_mangle]
pub extern "C" fn game_free_transform(ptr: *mut Transform) {
    if !ptr.is_null() {
        TRANSFORM_POOL.free(ptr);
    }
}

#[no_mangle]
pub extern "C" fn game_set_rotation(
    transform: *mut Transform,
    x: f32,
    y: f32,
    z: f32,
) {
    if transform.is_null() {
        return;
    }

    unsafe {
        let (sx, cx) = (x * 0.5).sin_cos();
        let (sy, cy) = (y * 0.5).sin_cos();
        let (sz, cz) = (z * 0.5).sin_cos();

        (*transform).rotation.w = cx * cy * cz + sx * sy * sz;
        (*transform).rotation.x = sx * cy * cz - cx * sy * sz;
        (*transform).rotation.y = cx * sy * cz + sx * cy * sz;
        (*transform).rotation.z = cx * cy * sz - sx * sy * cz;
    }
}

#[no_mangle]
pub extern "C" fn game_create_rigidbody(
    mass: f32,
    use_gravity: bool,
) -> *mut RigidBody {
    let ptr = RIGIDBODY_POOL.allocate();
    unsafe {
        (*ptr).velocity.x = 0.0;
        (*ptr).velocity.y = 0.0;
        (*ptr).velocity.z = 0.0;
        (*ptr).angular_velocity.x = 0.0;
        (*ptr).angular_velocity.y = 0.0;
        (*ptr).angular_velocity.z = 0.0;
        (*ptr).mass = mass;
        (*ptr).drag = 0.0;
        (*ptr).angular_drag = 0.05;
        (*ptr).use_gravity = if use_gravity { 1 } else { 0 };
        (*ptr).is_kinematic = 0;
    }
    ptr
}

#[no_mangle]
pub extern "C" fn game_free_rigidbody(ptr: *mut RigidBody) {
    if !ptr.is_null() {
        RIGIDBODY_POOL.free(ptr);
    }
}

#[no_mangle]
pub extern "C" fn game_physics_step(
    bodies: *mut RigidBody,
    count: u32,
    delta_time: f32,
) {
    if bodies.is_null() || count == 0 {
        return;
    }

    unsafe {
        let bodies_slice = std::slice::from_raw_parts_mut(bodies, count as usize);

        for body in bodies_slice.iter_mut() {
            if body.use_gravity == 1 && body.is_kinematic == 0 {
                body.velocity.y -= 9.81 * delta_time;
            }

            let drag_factor = 1.0 - body.drag * delta_time;
            body.velocity.x *= drag_factor;
            body.velocity.y *= drag_factor;
            body.velocity.z *= drag_factor;

            let angular_drag_factor = 1.0 - body.angular_drag * delta_time;
            body.angular_velocity.x *= angular_drag_factor;
            body.angular_velocity.y *= angular_drag_factor;
            body.angular_velocity.z *= angular_drag_factor;
        }
    }
}

#[no_mangle]
pub extern "C" fn game_apply_force(
    body: *mut RigidBody,
    force_x: f32,
    force_y: f32,
    force_z: f32,
) {
    if body.is_null() {
        return;
    }

    unsafe {
        if (*body).mass > 0.0 {
            let inv_mass = 1.0 / (*body).mass;
            (*body).velocity.x += force_x * inv_mass;
            (*body).velocity.y += force_y * inv_mass;
            (*body).velocity.z += force_z * inv_mass;
        }
    }
}

#[no_mangle]
pub extern "C" fn game_update_transform(
    transform: *mut Transform,
    body: *const RigidBody,
    delta_time: f32,
) {
    if transform.is_null() || body.is_null() {
        return;
    }

    unsafe {
        (*transform).position.x += (*body).velocity.x * delta_time;
        (*transform).position.y += (*body).velocity.y * delta_time;
        (*transform).position.z += (*body).velocity.z * delta_time;
    }
}

#[no_mangle]
pub extern "C" fn game_vector_length(v: Vector3) -> f32 {
    (v.x * v.x + v.y * v.y + v.z * v.z).sqrt()
}

#[no_mangle]
pub extern "C" fn game_vector_normalize(v: *mut Vector3) {
    if v.is_null() {
        return;
    }

    unsafe {
        let len = ((*v).x * (*v).x + (*v).y * (*v).y + (*v).z * (*v).z).sqrt();
        if len > 0.0001 {
            let inv_len = 1.0 / len;
            (*v).x *= inv_len;
            (*v).y *= inv_len;
            (*v).z *= inv_len;
        }
    }
}

#[no_mangle]
pub extern "C" fn game_update_frame_stats(
    frame_number: u64,
    frame_time_us: u64,
    draw_calls: u32,
    active_entities: u32,
) {
    let mut stats = FRAME_STATS.lock().unwrap();
    stats.frame_number = frame_number;
    stats.frame_time_us = frame_time_us;
    stats.draw_calls = draw_calls;
    stats.active_entities = active_entities;

    if frame_time_us > 0 {
        stats.fps = 1_000_000.0 / frame_time_us as f32;
    }
}

#[no_mangle]
pub extern "C" fn game_get_frame_stats() -> FrameStats {
    *FRAME_STATS.lock().unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_game_create_entity() {
        let name = b"Player\0";
        let ptr = game_create_entity(1, name.as_ptr(), name.len() as u32 - 1);
        assert!(!ptr.is_null());

        unsafe {
            assert_eq!((*ptr).entity_id, 1);
            assert_eq!((*ptr).active, 1);
            assert_eq!((*ptr).component_count, 0);
        }

        game_free_entity(ptr);
    }

    #[test]
    fn test_game_create_transform() {
        let ptr = game_create_transform(10.0, 20.0, 30.0);
        assert!(!ptr.is_null());

        unsafe {
            assert_eq!((*ptr).position.x, 10.0);
            assert_eq!((*ptr).position.y, 20.0);
            assert_eq!((*ptr).position.z, 30.0);
            assert_eq!((*ptr).scale.x, 1.0);
            assert_eq!((*ptr).rotation.w, 1.0);
        }

        game_free_transform(ptr);
    }

    #[test]
    fn test_game_set_rotation() {
        let ptr = game_create_transform(0.0, 0.0, 0.0);
        game_set_rotation(ptr, 0.0, 0.0, 0.0);

        unsafe {
            assert!(((*ptr).rotation.w - 1.0).abs() < 0.001);
        }

        game_free_transform(ptr);
    }

    #[test]
    fn test_game_create_rigidbody() {
        let ptr = game_create_rigidbody(10.0, true);
        assert!(!ptr.is_null());

        unsafe {
            assert_eq!((*ptr).mass, 10.0);
            assert_eq!((*ptr).use_gravity, 1);
            assert_eq!((*ptr).velocity.x, 0.0);
        }

        game_free_rigidbody(ptr);
    }

    #[test]
    fn test_game_apply_force() {
        let ptr = game_create_rigidbody(2.0, false);
        game_apply_force(ptr, 10.0, 0.0, 0.0);

        unsafe {
            assert_eq!((*ptr).velocity.x, 5.0);
        }

        game_free_rigidbody(ptr);
    }

    #[test]
    fn test_game_apply_force_zero_mass() {
        let ptr = game_create_rigidbody(0.0, false);
        game_apply_force(ptr, 10.0, 0.0, 0.0);

        unsafe {
            assert_eq!((*ptr).velocity.x, 0.0);
        }

        game_free_rigidbody(ptr);
    }

    #[test]
    fn test_game_physics_step() {
        let ptr = game_create_rigidbody(1.0, true);
        unsafe {
            (*ptr).velocity.x = 10.0;
        }

        game_physics_step(ptr, 1, 0.016);

        unsafe {
            assert!((*ptr).velocity.y < 0.0);
        }

        game_free_rigidbody(ptr);
    }

    #[test]
    fn test_game_update_transform() {
        let transform = game_create_transform(0.0, 0.0, 0.0);
        let body = game_create_rigidbody(1.0, false);

        unsafe {
            (*body).velocity.x = 10.0;
            (*body).velocity.y = 5.0;
        }

        game_update_transform(transform, body, 1.0);

        unsafe {
            assert_eq!((*transform).position.x, 10.0);
            assert_eq!((*transform).position.y, 5.0);
        }

        game_free_transform(transform);
        game_free_rigidbody(body);
    }

    #[test]
    fn test_game_vector_length() {
        let v = Vector3 { x: 3.0, y: 4.0, z: 0.0 };
        let len = game_vector_length(v);
        assert_eq!(len, 5.0);
    }

    #[test]
    fn test_game_vector_normalize() {
        let mut v = Vector3 { x: 3.0, y: 4.0, z: 0.0 };
        game_vector_normalize(&mut v);
        let len = game_vector_length(v);
        assert!((len - 1.0).abs() < 0.001);
    }

    #[test]
    fn test_game_update_frame_stats() {
        game_update_frame_stats(100, 16666, 50, 200);
        let stats = game_get_frame_stats();
        assert_eq!(stats.frame_number, 100);
        assert_eq!(stats.frame_time_us, 16666);
        assert_eq!(stats.draw_calls, 50);
        assert_eq!(stats.active_entities, 200);
        assert!(stats.fps > 59.0 && stats.fps < 61.0);
    }

    #[test]
    fn test_game_free_null_pointers() {
        game_free_entity(std::ptr::null_mut());
        game_free_transform(std::ptr::null_mut());
        game_free_rigidbody(std::ptr::null_mut());
    }

    #[test]
    fn test_game_vector_normalize_zero() {
        let mut v = Vector3 { x: 0.0, y: 0.0, z: 0.0 };
        game_vector_normalize(&mut v);
        assert_eq!(v.x, 0.0);
        assert_eq!(v.y, 0.0);
        assert_eq!(v.z, 0.0);
    }

    #[test]
    fn test_game_set_rotation_null() {
        game_set_rotation(std::ptr::null_mut(), 0.0, 0.0, 0.0);
    }

    #[test]
    fn test_game_apply_force_null() {
        game_apply_force(std::ptr::null_mut(), 10.0, 0.0, 0.0);
    }

    #[test]
    fn test_game_update_transform_null() {
        let transform = game_create_transform(0.0, 0.0, 0.0);
        game_update_transform(transform, std::ptr::null(), 1.0);
        game_free_transform(transform);
    }

    #[test]
    fn test_game_physics_step_null() {
        game_physics_step(std::ptr::null_mut(), 0, 0.016);
    }

    #[test]
    fn test_game_multiple_entities() {
        let ptr1 = game_create_entity(1, std::ptr::null(), 0);
        let ptr2 = game_create_entity(2, std::ptr::null(), 0);

        assert!(!ptr1.is_null());
        assert!(!ptr2.is_null());
        assert_ne!(ptr1, ptr2);

        game_free_entity(ptr1);
        game_free_entity(ptr2);
    }

    #[test]
    fn test_game_concurrent_entity_creation() {
        use std::thread;

        let handles: Vec<_> = (0..8)
            .map(|i| {
                thread::spawn(move || {
                    let mut entities = Vec::new();
                    for j in 0..25 {
                        let name = format!("Entity_{}", i * 100 + j);
                        let ptr = game_create_entity(
                            (i * 100 + j) as u32,
                            name.as_ptr(),
                            name.len() as u32,
                        );
                        assert!(!ptr.is_null());
                        entities.push(ptr);
                    }
                    for ptr in entities {
                        game_free_entity(ptr);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_game_concurrent_transform_operations() {
        use std::thread;

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    let mut transforms = Vec::new();
                    for j in 0..50 {
                        let ptr = game_create_transform(
                            (i * 10 + j) as f32,
                            (i * 20 + j) as f32,
                            (i * 30 + j) as f32,
                        );
                        assert!(!ptr.is_null());

                        game_set_rotation(
                            ptr,
                            (j as f32) * 0.1,
                            (j as f32) * 0.2,
                            (j as f32) * 0.3,
                        );

                        transforms.push(ptr);
                    }

                    for ptr in transforms {
                        game_free_transform(ptr);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_game_concurrent_rigidbody_updates() {
        use std::thread;

        let handles: Vec<_> = (0..8)
            .map(|i| {
                thread::spawn(move || {
                    let mut bodies = Vec::new();
                    for j in 0..25 {
                        let ptr = game_create_rigidbody((i + j + 1) as f32, j % 2 == 0);
                        assert!(!ptr.is_null());

                        game_apply_force(
                            ptr,
                            (i * 10 + j) as f32,
                            (i * 5 + j) as f32,
                            (i * 2 + j) as f32,
                        );

                        bodies.push(ptr);
                    }

                    for ptr in bodies {
                        game_free_rigidbody(ptr);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_game_concurrent_physics_simulation() {
        use std::thread;

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    let body = game_create_rigidbody(1.0, true);
                    let transform = game_create_transform(0.0, 0.0, 0.0);

                    for _ in 0..100 {
                        game_apply_force(body, 10.0, 5.0, 2.0);
                        game_physics_step(body, 1, 0.016);
                        game_update_transform(transform, body, 0.016);
                    }

                    game_free_rigidbody(body);
                    game_free_transform(transform);
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_game_concurrent_vector_operations() {
        use std::thread;

        let handles: Vec<_> = (0..8)
            .map(|i| {
                thread::spawn(move || {
                    for j in 1..101 {
                        let mut v = Vector3 {
                            x: (i * 10 + j) as f32,
                            y: (i * 5 + j) as f32,
                            z: (i * 2 + j) as f32,
                        };

                        let len = game_vector_length(v);
                        assert!(len > 0.0);

                        game_vector_normalize(&mut v);
                        let normalized_len = game_vector_length(v);
                        if normalized_len > 0.0 {
                            assert!((normalized_len - 1.0).abs() < 0.01);
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
    fn test_game_concurrent_frame_stats_updates() {
        use std::thread;

        let handles: Vec<_> = (0..8)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..50 {
                        game_update_frame_stats(
                            (i * 1000 + j) as u64,
                            16666,
                            (i * 10 + j) as u32,
                            (i * 100 + j) as u32,
                        );
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }

        let stats = game_get_frame_stats();
        assert!(stats.frame_number > 0);
    }

    #[test]
    fn test_game_mixed_concurrent_operations() {
        use std::thread;

        let handles: Vec<_> = (0..4)
            .map(|i| {
                thread::spawn(move || {
                    for j in 0..20 {
                        let entity = game_create_entity((i * 100 + j) as u32, std::ptr::null(), 0);
                        let transform = game_create_transform(
                            (i + j) as f32,
                            (i * 2 + j) as f32,
                            (i * 3 + j) as f32,
                        );
                        let body = game_create_rigidbody((j + 1) as f32, true);

                        game_set_rotation(transform, 0.0, 0.0, (j as f32) * 0.1);
                        game_apply_force(body, 10.0, 0.0, 0.0);
                        game_physics_step(body, 1, 0.016);
                        game_update_transform(transform, body, 0.016);

                        let mut v = Vector3 {
                            x: (i + j) as f32,
                            y: (i * 2 + j) as f32,
                            z: (i * 3 + j) as f32,
                        };
                        game_vector_normalize(&mut v);

                        game_free_entity(entity);
                        game_free_transform(transform);
                        game_free_rigidbody(body);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }

    #[test]
    fn test_game_extreme_concurrent_load() {
        use std::thread;

        let handles: Vec<_> = (0..16)
            .map(|i| {
                thread::spawn(move || {
                    let mut entities = Vec::new();
                    let mut transforms = Vec::new();
                    let mut bodies = Vec::new();

                    for j in 0..10 {
                        let entity = game_create_entity((i * 100 + j) as u32, std::ptr::null(), 0);
                        let transform = game_create_transform(
                            (i + j) as f32,
                            (i * 2 + j) as f32,
                            (i * 3 + j) as f32,
                        );
                        let body = game_create_rigidbody((j + 1) as f32, true);

                        if !entity.is_null() {
                            entities.push(entity);
                        }
                        if !transform.is_null() {
                            transforms.push(transform);
                        }
                        if !body.is_null() {
                            bodies.push(body);
                        }
                    }

                    for entity in entities {
                        game_free_entity(entity);
                    }
                    for transform in transforms {
                        game_free_transform(transform);
                    }
                    for body in bodies {
                        game_free_rigidbody(body);
                    }
                })
            })
            .collect();

        for handle in handles {
            handle.join().unwrap();
        }
    }
}
