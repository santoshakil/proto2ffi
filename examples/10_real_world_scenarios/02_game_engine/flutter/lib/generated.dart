// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

enum ComponentType {
  TRANSFORM(0), // Value: 0
  RIGIDBODY(1), // Value: 1
  COLLIDER(2), // Value: 2
  RENDERER(3), // Value: 3
  LIGHT(4), // Value: 4
  CAMERA(5), // Value: 5
  AUDIO_SOURCE(6), // Value: 6
  PARTICLE_SYSTEM(7); // Value: 7

  const ComponentType(this.value);
  final int value;
}

enum ColliderShape {
  BOX(0), // Value: 0
  SPHERE(1), // Value: 1
  CAPSULE(2), // Value: 2
  MESH(3); // Value: 3

  const ColliderShape(this.value);
  final int value;
}

enum LightType {
  DIRECTIONAL(0), // Value: 0
  POINT(1), // Value: 1
  SPOT(2); // Value: 2

  const LightType(this.value);
  final int value;
}

const int VECTOR3_SIZE = 16;
const int VECTOR3_ALIGNMENT = 8;

final class Vector3 extends ffi.Struct {
  @ffi.Float()
  external double x;

  @ffi.Float()
  external double y;

  @ffi.Float()
  external double z;

  static ffi.Pointer<Vector3> allocate() {
    return calloc<Vector3>();
  }
}

const int QUATERNION_SIZE = 16;
const int QUATERNION_ALIGNMENT = 8;

final class Quaternion extends ffi.Struct {
  @ffi.Float()
  external double x;

  @ffi.Float()
  external double y;

  @ffi.Float()
  external double z;

  @ffi.Float()
  external double w;

  static ffi.Pointer<Quaternion> allocate() {
    return calloc<Quaternion>();
  }
}

const int TRANSFORM_SIZE = 312;
const int TRANSFORM_ALIGNMENT = 8;

final class Transform extends ffi.Struct {
  external Vector3 position;

  external Quaternion rotation;

  external Vector3 scale;

  @ffi.Uint32()
  external int children_count;

  @ffi.Array<ffi.Uint32>(64)
  external ffi.Array<ffi.Uint32> children;

  @ffi.Uint32()
  external int parent_entity;

  List<int> get children_list {
    return List.generate(
      children_count,
      (i) => children[i],
      growable: false,
    );
  }

  void add_children(int item) {
    if (children_count >= 64) {
      throw Exception('children array full');
    }
    children[children_count] = item;
    children_count++;
  }

  static ffi.Pointer<Transform> allocate() {
    return calloc<Transform>();
  }
}

const int RIGIDBODY_SIZE = 48;
const int RIGIDBODY_ALIGNMENT = 8;

final class RigidBody extends ffi.Struct {
  external Vector3 velocity;

  external Vector3 angular_velocity;

  @ffi.Float()
  external double mass;

  @ffi.Float()
  external double drag;

  @ffi.Float()
  external double angular_drag;

  @ffi.Uint8()
  external int use_gravity;

  @ffi.Uint8()
  external int is_kinematic;

  static ffi.Pointer<RigidBody> allocate() {
    return calloc<RigidBody>();
  }
}

const int COLLIDER_SIZE = 48;
const int COLLIDER_ALIGNMENT = 8;

final class Collider extends ffi.Struct {
  external Vector3 center;

  external Vector3 size;

  @ffi.Uint32()
  external int shape;

  @ffi.Float()
  external double radius;

  @ffi.Float()
  external double height;

  @ffi.Uint8()
  external int is_trigger;

  static ffi.Pointer<Collider> allocate() {
    return calloc<Collider>();
  }
}

const int PHYSICSSTATE_SIZE = 53280;
const int PHYSICSSTATE_ALIGNMENT = 8;

final class PhysicsState extends ffi.Struct {
  @ffi.Uint32()
  external int entity_ids_count;

  @ffi.Array<ffi.Uint32>(1024)
  external ffi.Array<ffi.Uint32> entity_ids;

  @ffi.Uint32()
  external int bodies_count;

  @ffi.Array<RigidBody>(1024)
  external ffi.Array<RigidBody> bodies;

  @ffi.Uint64()
  external int simulation_time_us;

  @ffi.Uint32()
  external int body_count;

  @ffi.Uint32()
  external int collision_count;

  List<int> get entity_ids_list {
    return List.generate(
      entity_ids_count,
      (i) => entity_ids[i],
      growable: false,
    );
  }

  void add_entity_id(int item) {
    if (entity_ids_count >= 1024) {
      throw Exception('entity_ids array full');
    }
    entity_ids[entity_ids_count] = item;
    entity_ids_count++;
  }

  List<RigidBody> get bodies_list {
    return List.generate(
      bodies_count,
      (i) => bodies[i],
      growable: false,
    );
  }

  RigidBody get_next_bodie() {
    if (bodies_count >= 1024) {
      throw Exception('bodies array full');
    }
    final idx = bodies_count;
    bodies_count++;
    return bodies[idx];
  }

  static ffi.Pointer<PhysicsState> allocate() {
    return calloc<PhysicsState>();
  }
}

const int PARTICLE_SIZE = 48;
const int PARTICLE_ALIGNMENT = 8;

final class Particle extends ffi.Struct {
  external Vector3 position;

  external Vector3 velocity;

  @ffi.Float()
  external double lifetime;

  @ffi.Float()
  external double size;

  @ffi.Uint32()
  external int color;

  static ffi.Pointer<Particle> allocate() {
    return calloc<Particle>();
  }
}

const int PARTICLESYSTEM_SIZE = 480056;
const int PARTICLESYSTEM_ALIGNMENT = 8;

final class ParticleSystem extends ffi.Struct {
  external Vector3 emitter_position;

  @ffi.Uint32()
  external int particles_count;

  @ffi.Array<Particle>(10000)
  external ffi.Array<Particle> particles;

  external Vector3 gravity;

  @ffi.Uint32()
  external int particle_count;

  @ffi.Float()
  external double emission_rate;

  @ffi.Float()
  external double particle_lifetime;

  @ffi.Uint8()
  external int is_playing;

  List<Particle> get particles_list {
    return List.generate(
      particles_count,
      (i) => particles[i],
      growable: false,
    );
  }

  Particle get_next_particle() {
    if (particles_count >= 10000) {
      throw Exception('particles array full');
    }
    final idx = particles_count;
    particles_count++;
    return particles[idx];
  }

  static ffi.Pointer<ParticleSystem> allocate() {
    return calloc<ParticleSystem>();
  }
}

const int ENTITY_SIZE = 152;
const int ENTITY_ALIGNMENT = 8;

final class Entity extends ffi.Struct {
  @ffi.Uint32()
  external int components_count;

  @ffi.Array<ffi.Uint32>(16)
  external ffi.Array<ffi.Uint32> components;

  @ffi.Uint32()
  external int entity_id;

  @ffi.Uint32()
  external int component_count;

  @ffi.Uint32()
  external int layer;

  @ffi.Uint32()
  external int tag;

  @ffi.Array<ffi.Uint8>(64)
  external ffi.Array<ffi.Uint8> name;

  @ffi.Uint8()
  external int active;

  List<int> get components_list {
    return List.generate(
      components_count,
      (i) => components[i],
      growable: false,
    );
  }

  void add_component(int item) {
    if (components_count >= 16) {
      throw Exception('components array full');
    }
    components[components_count] = item;
    components_count++;
  }

  String get name_str {
    final bytes = <int>[];
    for (int i = 0; i < 64; i++) {
      if (name[i] == 0) break;
      bytes.add(name[i]);
    }
    return String.fromCharCodes(bytes);
  }

  set name_str(String value) {
    final bytes = utf8.encode(value);
    final len = bytes.length < 63 ? bytes.length : 63;
    for (int i = 0; i < len; i++) {
      name[i] = bytes[i];
    }
    if (len < 64) {
      name[len] = 0;
    }
  }

  static ffi.Pointer<Entity> allocate() {
    return calloc<Entity>();
  }
}

const int SCENEGRAPH_SIZE = 1048;
const int SCENEGRAPH_ALIGNMENT = 8;

final class SceneGraph extends ffi.Struct {
  @ffi.Uint32()
  external int root_entities_count;

  @ffi.Array<ffi.Uint32>(256)
  external ffi.Array<ffi.Uint32> root_entities;

  @ffi.Uint64()
  external int frame_number;

  @ffi.Uint32()
  external int root_count;

  @ffi.Uint32()
  external int total_entities;

  List<int> get root_entities_list {
    return List.generate(
      root_entities_count,
      (i) => root_entities[i],
      growable: false,
    );
  }

  void add_root_entitie(int item) {
    if (root_entities_count >= 256) {
      throw Exception('root_entities array full');
    }
    root_entities[root_entities_count] = item;
    root_entities_count++;
  }

  static ffi.Pointer<SceneGraph> allocate() {
    return calloc<SceneGraph>();
  }
}

const int RENDERCOMMAND_SIZE = 336;
const int RENDERCOMMAND_ALIGNMENT = 8;

final class RenderCommand extends ffi.Struct {
  external Transform transform;

  @ffi.Uint32()
  external int entity_id;

  @ffi.Uint32()
  external int mesh_id;

  @ffi.Uint32()
  external int material_id;

  @ffi.Uint32()
  external int render_order;

  @ffi.Uint8()
  external int cast_shadows;

  static ffi.Pointer<RenderCommand> allocate() {
    return calloc<RenderCommand>();
  }
}

const int LIGHT_SIZE = 56;
const int LIGHT_ALIGNMENT = 8;

final class Light extends ffi.Struct {
  external Vector3 position;

  external Vector3 direction;

  @ffi.Uint32()
  external int light_type;

  @ffi.Uint32()
  external int color;

  @ffi.Float()
  external double intensity;

  @ffi.Float()
  external double range;

  @ffi.Float()
  external double spot_angle;

  static ffi.Pointer<Light> allocate() {
    return calloc<Light>();
  }
}

const int CAMERA_SIZE = 64;
const int CAMERA_ALIGNMENT = 8;

final class Camera extends ffi.Struct {
  external Vector3 position;

  external Vector3 forward;

  external Vector3 up;

  @ffi.Float()
  external double fov;

  @ffi.Float()
  external double near_clip;

  @ffi.Float()
  external double far_clip;

  @ffi.Float()
  external double aspect_ratio;

  static ffi.Pointer<Camera> allocate() {
    return calloc<Camera>();
  }
}

const int FRAMESTATS_SIZE = 40;
const int FRAMESTATS_ALIGNMENT = 8;

final class FrameStats extends ffi.Struct {
  @ffi.Uint64()
  external int frame_number;

  @ffi.Uint64()
  external int frame_time_us;

  @ffi.Uint32()
  external int draw_calls;

  @ffi.Uint32()
  external int vertices;

  @ffi.Uint32()
  external int triangles;

  @ffi.Uint32()
  external int active_entities;

  @ffi.Uint32()
  external int visible_entities;

  @ffi.Float()
  external double fps;

  static ffi.Pointer<FrameStats> allocate() {
    return calloc<FrameStats>();
  }
}

class FFIBindings {
  static final _dylib = _loadLibrary();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libgenerated.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libgenerated.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('generated.dll');
    } else {
      return ffi.DynamicLibrary.open('libgenerated.so');
    }
  }

  late final vector3_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector3_size');

  late final vector3_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('vector3_alignment');

  late final quaternion_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('quaternion_size');

  late final quaternion_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('quaternion_alignment');

  late final transform_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transform_size');

  late final transform_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('transform_alignment');

  late final rigidbody_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rigidbody_size');

  late final rigidbody_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rigidbody_alignment');

  late final collider_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('collider_size');

  late final collider_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('collider_alignment');

  late final physicsstate_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('physicsstate_size');

  late final physicsstate_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('physicsstate_alignment');

  late final particle_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('particle_size');

  late final particle_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('particle_alignment');

  late final particlesystem_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('particlesystem_size');

  late final particlesystem_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('particlesystem_alignment');

  late final entity_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('entity_size');

  late final entity_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('entity_alignment');

  late final scenegraph_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('scenegraph_size');

  late final scenegraph_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('scenegraph_alignment');

  late final rendercommand_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rendercommand_size');

  late final rendercommand_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('rendercommand_alignment');

  late final light_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('light_size');

  late final light_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('light_alignment');

  late final camera_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('camera_size');

  late final camera_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('camera_alignment');

  late final framestats_size = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('framestats_size');

  late final framestats_alignment = _dylib.lookupFunction<
    ffi.Size Function(),
    int Function()
  >('framestats_alignment');
}
