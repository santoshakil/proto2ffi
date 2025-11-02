pub mod generated;

use generated::*;
use std::time::{SystemTime, UNIX_EPOCH};

#[no_mangle]
pub extern "C" fn mesh_create_cube(mesh: *mut Mesh, size: f64) {
    unsafe {
        let m = &mut *mesh;
        m.triangles_count = 0;
        m.triangle_count = 0;

        let half = size / 2.0;

        let verts = [
            Vec3 { x: -half, y: -half, z: -half },
            Vec3 { x: half, y: -half, z: -half },
            Vec3 { x: half, y: half, z: -half },
            Vec3 { x: -half, y: half, z: -half },
            Vec3 { x: -half, y: -half, z: half },
            Vec3 { x: half, y: -half, z: half },
            Vec3 { x: half, y: half, z: half },
            Vec3 { x: -half, y: half, z: half },
        ];

        let white = Color { r: 255, g: 255, b: 255, a: 255 };

        let faces = [
            ([0, 1, 2], Vec3 { x: 0.0, y: 0.0, z: -1.0 }),
            ([0, 2, 3], Vec3 { x: 0.0, y: 0.0, z: -1.0 }),
            ([4, 6, 5], Vec3 { x: 0.0, y: 0.0, z: 1.0 }),
            ([4, 7, 6], Vec3 { x: 0.0, y: 0.0, z: 1.0 }),
            ([0, 4, 5], Vec3 { x: 0.0, y: -1.0, z: 0.0 }),
            ([0, 5, 1], Vec3 { x: 0.0, y: -1.0, z: 0.0 }),
            ([2, 6, 7], Vec3 { x: 0.0, y: 1.0, z: 0.0 }),
            ([2, 7, 3], Vec3 { x: 0.0, y: 1.0, z: 0.0 }),
            ([0, 3, 7], Vec3 { x: -1.0, y: 0.0, z: 0.0 }),
            ([0, 7, 4], Vec3 { x: -1.0, y: 0.0, z: 0.0 }),
            ([1, 5, 6], Vec3 { x: 1.0, y: 0.0, z: 0.0 }),
            ([1, 6, 2], Vec3 { x: 1.0, y: 0.0, z: 0.0 }),
        ];

        for (indices, normal) in &faces {
            let mut tri = Triangle::default();
            tri.normal = *normal;

            for &idx in indices {
                let v = Vertex {
                    position: verts[idx],
                    normal: *normal,
                    color: white,
                };
                let _ = tri.add_vertice(v);
            }

            let _ = m.add_triangle(tri);
        }

        m.triangle_count = m.triangles_count;
    }
}

#[no_mangle]
pub extern "C" fn mesh_calculate_bounds(mesh: *const Mesh, bounds: *mut BoundingBox) {
    unsafe {
        let m = &*mesh;
        let b = &mut *bounds;

        if m.triangles_count == 0 {
            *b = BoundingBox::default();
            return;
        }

        let mut min = Vec3 { x: f64::INFINITY, y: f64::INFINITY, z: f64::INFINITY };
        let mut max = Vec3 { x: f64::NEG_INFINITY, y: f64::NEG_INFINITY, z: f64::NEG_INFINITY };

        for i in 0..m.triangles_count as usize {
            let tri = &m.triangles[i];
            for j in 0..tri.vertices_count as usize {
                let v = &tri.vertices[j];
                let p = &v.position;

                if p.x < min.x { min.x = p.x; }
                if p.y < min.y { min.y = p.y; }
                if p.z < min.z { min.z = p.z; }
                if p.x > max.x { max.x = p.x; }
                if p.y > max.y { max.y = p.y; }
                if p.z > max.z { max.z = p.z; }
            }
        }

        b.min = min;
        b.max = max;
    }
}

#[no_mangle]
pub extern "C" fn mesh_vertex_count(mesh: *const Mesh) -> u32 {
    unsafe {
        let m = &*mesh;
        let mut count = 0u32;
        for i in 0..m.triangles_count as usize {
            count += m.triangles[i].vertices_count;
        }
        count
    }
}

#[no_mangle]
pub extern "C" fn mesh_transform(mesh: *mut Mesh, scale: f64, offset: *const Vec3) {
    unsafe {
        let m = &mut *mesh;
        let off = &*offset;

        for i in 0..m.triangles_count as usize {
            let tri = &mut m.triangles[i];
            for j in 0..tri.vertices_count as usize {
                let v = &mut tri.vertices[j];
                v.position.x = v.position.x * scale + off.x;
                v.position.y = v.position.y * scale + off.y;
                v.position.z = v.position.z * scale + off.z;
            }
        }
    }
}

#[no_mangle]
pub extern "C" fn model_create(model: *mut Model, name: *const u8, name_len: usize) {
    unsafe {
        let m = &mut *model;
        *m = Model::default();

        let name_slice = std::slice::from_raw_parts(name, name_len.min(63));
        let copy_len = name_slice.len().min(63);
        m.mesh.name[..copy_len].copy_from_slice(&name_slice[..copy_len]);
        m.mesh.name[copy_len] = 0;

        let timestamp = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs();
        m.id = timestamp;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_mesh_create_cube() {
        let mut mesh = Mesh::default();
        mesh_create_cube(&mut mesh, 2.0);

        assert_eq!(mesh.triangles_count, 12);
        assert_eq!(mesh.triangle_count, 12);

        let vertex_count = mesh_vertex_count(&mesh);
        assert_eq!(vertex_count, 36);
    }

    #[test]
    fn test_mesh_bounds() {
        let mut mesh = Mesh::default();
        mesh_create_cube(&mut mesh, 2.0);

        let mut bounds = BoundingBox::default();
        mesh_calculate_bounds(&mesh, &mut bounds);

        assert_eq!(bounds.min.x, -1.0);
        assert_eq!(bounds.min.y, -1.0);
        assert_eq!(bounds.min.z, -1.0);
        assert_eq!(bounds.max.x, 1.0);
        assert_eq!(bounds.max.y, 1.0);
        assert_eq!(bounds.max.z, 1.0);
    }

    #[test]
    fn test_mesh_transform() {
        let mut mesh = Mesh::default();
        mesh_create_cube(&mut mesh, 2.0);

        let offset = Vec3 { x: 10.0, y: 20.0, z: 30.0 };
        mesh_transform(&mut mesh, 2.0, &offset);

        let mut bounds = BoundingBox::default();
        mesh_calculate_bounds(&mesh, &mut bounds);

        assert_eq!(bounds.min.x, 8.0);
        assert_eq!(bounds.min.y, 18.0);
        assert_eq!(bounds.min.z, 28.0);
        assert_eq!(bounds.max.x, 12.0);
        assert_eq!(bounds.max.y, 22.0);
        assert_eq!(bounds.max.z, 32.0);
    }

    #[test]
    fn test_model_create() {
        let mut model = Model::default();
        let name = b"TestCube";
        model_create(&mut model, name.as_ptr(), name.len());

        assert!(model.id > 0);
    }
}
