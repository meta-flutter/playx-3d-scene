import 'package:my_fox_example/shape_and_object_creators.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'package:uuid/uuid.dart';

const String sequoiaAsset = "assets/models/sequoia_ngp.glb";
const String garageAsset = "assets/models/garagescene.glb";

const String checkerboardFloor = "assets/models/checkerboard_v2.glb";

const String radarConeAsset = "assets/models/radar_cone.glb";
const String radarSegmentAsset = "assets/models/half_torus.glb";
//const String radarSegmentAsset = "assets/models/half_torus_parent_mat.glb";
//const String radarSegmentAsset = "assets/models/2-Candle.glb";
const String roadAsset = "assets/models/road_segment.glb";

// fox has animation
const String foxAsset = "assets/models/Fox.glb";
//const String dmgHelmAsset = "assets/models/DamagedHelmet.glb";

/// Returns a list of base models (instance templates) to be used in the scene(s)
List<Model> getBaseModels() {
  final List<Model> models = [];

  // Car
  models.add(GlbModel.asset(
    sequoiaAsset,
    centerPosition: Vector3.only(x: 0, y: 0, z: 0),
    scale: Vector3.only(x: 1, y: 1, z: 1),
    rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
    collidable: null,
    animation: null,
    receiveShadows: true,
    castShadows: true,
    name: sequoiaAsset,
    guid: const Uuid().v4(),
    keepInMemory: true,
    isInstancePrimary: true,
  ));

  // Fox
  models.add(GlbModel.asset(
    foxAsset,
    centerPosition: Vector3.only(x: 0, y: 0, z: 0),
    scale: Vector3.only(x: 1, y: 1, z: 1),
    rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
    collidable: null,
    animation: null,
    receiveShadows: true,
    castShadows: true,
    guid: const Uuid().v4(),
    keepInMemory: true,
    isInstancePrimary: true,
  ));

  // Radar cone
  models.add(GlbModel.asset(
    radarConeAsset,
    centerPosition: Vector3.only(x: 0, y: 0, z: 0),
    scale: Vector3.only(x: 1, y: 1, z: 1),
    rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
    collidable: null,
    animation: null,
    receiveShadows: false,
    castShadows: false,
    name: radarConeAsset,
    guid: const Uuid().v4(),
    keepInMemory: true,
    isInstancePrimary: true,
  ));

  // Radar segment
  models.add(GlbModel.asset(
    radarSegmentAsset,
    centerPosition: Vector3.only(x: 0, y: 0, z: 0),
    scale: Vector3.only(x: 1, y: 1, z: 1),
    rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
    collidable: null,
    animation: null,
    receiveShadows: true,
    castShadows: true,
    name: radarSegmentAsset,
    guid: const Uuid().v4(),
    keepInMemory: true,
    isInstancePrimary: true,
  ));

  // Floor
  models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: Vector3.only(x: 0, y: -0.1, z: 0),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: checkerboardFloor,
      guid: const Uuid().v4(),
      keepInMemory: true,
      isInstancePrimary: true,
    ));

  return models;
}