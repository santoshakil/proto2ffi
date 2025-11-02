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
