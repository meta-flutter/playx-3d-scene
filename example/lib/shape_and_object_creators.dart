import 'package:flutter/material.dart' hide Animation;
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'package:uuid/uuid.dart';
import 'material_helpers.dart';

const String sequoiaAsset = "assets/models/sequoia_ngp.glb";
const String garageAsset = "assets/models/garagescene.glb";

const String radarConeAsset = "assets/models/radar_cone.glb";
const String radarSegmentAsset = "assets/models/half_torus.glb";
//const String radarSegmentAsset = "assets/models/half_torus_parent_mat.glb";
//const String radarSegmentAsset = "assets/models/2-Candle.glb";
const String roadAsset = "assets/models/road_segment.glb";

// fox has animation
const String foxAsset = "assets/models/Fox.glb";
//const String dmgHelmAsset = "assets/models/DamagedHelmet.glb";

////////////////////////////////////////////////////////////////////////
GlbModel poGetModel(
    String szAsset,
    Vector3 position,
    Vector3 scale,
    Vector4 rotation,
    Collidable? collidable,
    Animation? animationInfo,
    bool bReceiveShadows,
    bool bCastShadows,
    String overrideGUID,
    bool bKeepInMemory,
    bool bWhenInstanceableIsPrimary) {
  return GlbModel.asset(szAsset,
      should_keep_asset_in_memory: bKeepInMemory,
      is_primary_to_instance_from: bWhenInstanceableIsPrimary,
      animation: animationInfo,
      collidable: collidable,
      centerPosition: position,
      scale: scale,
      rotation: rotation,
      name: szAsset,
      receiveShadows: bReceiveShadows,
      castShadows: bCastShadows,
      // ignore: prefer_const_constructors
      global_guid: overrideGUID);
}

////////////////////////////////////////////////////////////////////////////////
List<String> thingsWeCanChangeParamsOn = [];
Shape poCreateCube(Vector3 pos, Vector3 scale, Vector3 sizeExtents,
    Color? colorOveride) {
  String uniqueGuid = const Uuid().v4();
  // Just to show off changing material params during runtime.
  thingsWeCanChangeParamsOn.add(uniqueGuid);

  return Cube(
      size: sizeExtents,
      centerPosition: pos,
      scale: scale,
      castShadows: true,
      receiveShadows: true,
      material: poGetLitMaterialWithRandomValues(),
      collidable: Collidable(isStatic: false, shouldMatchAttachedObject: true),
      // ignore: prefer_const_constructors
      global_guid: uniqueGuid
      //material: colorOveride != null
      //    ? poGetLitMaterial(colorOveride)
      //    : poGetLitMaterialWithRandomValues(),
      );
}

////////////////////////////////////////////////////////////////////////////////
Shape poCreateSphere(Vector3 pos, Vector3 scale, Vector3 sizeExtents,
    int stacks, int slices, Color? colorOveride) {
  return Sphere(
      centerPosition: pos,
      material: poGetTexturedMaterial(),
      //material: poGetLitMaterial(null),
      stacks: stacks,
      collidable: Collidable(isStatic: false, shouldMatchAttachedObject: true),
      slices: slices,
      cullingEnabled: false,
      castShadows: true,
      receiveShadows: true,
      scale: scale,
      size: sizeExtents);
}

////////////////////////////////////////////////////////////////////////////////
Shape poCreatePlane(Vector3 pos, Vector3 scale, Vector3 sizeExtents) {
  return Plane(
      doubleSided: true,
      size: sizeExtents,
      scale: scale,
      castShadows: true,
      receiveShadows: true,
      centerPosition: pos,
      collidable: Collidable(isStatic: false, shouldMatchAttachedObject: true),

      // facing UP
      rotation: Vector4(x: 0, y: .7071, z: .7071, w: 0),
      // identity
      // rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      material: poGetTexturedMaterial());
  //material: poGetLitMaterialWithRandomValues());
}

////////////////////////////////////////////////////////////////////////////////
List<Shape> poCreateLineGrid() {
  List<Shape> itemsToReturn = [];
  double countExtents = 6;
  for (double i = -countExtents; i <= countExtents; i += 2) {
    for (int j = 0; j < 1; j++) {
      for (double k = -countExtents; k <= countExtents; k += 2) {
        itemsToReturn.add(poCreateCube(
          Vector3.only(x: i, y: 0, z: k),
          Vector3.only(x: 1, y: 1, z: 1),
          Vector3.only(x: 1, y: 1, z: 1),
          null
        ));
      }
    }
  }

  return itemsToReturn;
}

////////////////////////////////////////////////////////////////////////////////
List<Shape> poGetScenesShapes() {
  //return poCreateLineGrid();

  List<Shape> itemsToReturn = [];

  itemsToReturn.add(poCreateCube(
    Vector3.only(x: 3, y: 1, z: 3),
    Vector3.only(x: 2, y: 2, z: 2),
    Vector3.only(x: 2, y: 2, z: 2),
    null,
  ));

  itemsToReturn.add(poCreateCube(
    Vector3.only(x: 0, y: 1, z: 3),
    Vector3.only(x: .1, y: 1, z: .1),
    Vector3.only(x: 1, y: 1, z: 1), 
    null,
  ));

  itemsToReturn.add(poCreateCube(
    Vector3.only(x: -3, y: 1, z: 3),
    Vector3.only(x: .5, y: .5, z: .5),
    Vector3.only(x: 1, y: 1, z: 1),
    null,
  ));

  itemsToReturn.add(poCreateSphere(
    Vector3.only(x: 3, y: 1, z: -3),
    Vector3.only(x: 1, y: 1, z: 1),
    Vector3.only(x: 1, y: 1, z: 1),
    11, 5, null,
  ));

  itemsToReturn.add(poCreateSphere(
    Vector3.only(x: 0, y: 1, z: -3),
    Vector3.only(x: 1, y: 1, z: 1),
    Vector3.only(x: 1, y: 1, z: 1),
    20, 20, null,
  ));

  itemsToReturn.add(poCreateSphere(
    Vector3.only(x: -3, y: 1, z: -3),
    Vector3.only(x: 1, y: .5, z: 1),
    Vector3.only(x: 1, y: 1, z: 1),
    20, 20, null,
  ));

  itemsToReturn.add(poCreatePlane(
    Vector3.only(x: -5, y: 1, z: 0),
    Vector3.only(x: 1, y: 1, z: 1),
    Vector3.only(x: 2, y: 1, z: 2),
  ));

  itemsToReturn.add(poCreatePlane(
    Vector3.only(x: 5, y: 1, z: 0),
    Vector3.only(x: 4, y: 1, z: 4),
    Vector3.only(x: 4, y: 1, z: 4)
  ));

  return itemsToReturn;
}

////////////////////////////////////////////////////////////////////////////////
class MovingDemoLight {
  String guid;
  Vector3 origin;
  Vector3 direction;

  String phase = "moving"; // 'toCenter' or 'toOpposite'
  double startX = 0, startZ = 0;
  double oppositeX = 0, oppositeZ = 0;
  double t = 0;

  MovingDemoLight(this.guid, this.origin,this.direction) {
    startX = origin.x;
    startZ = origin.z;

    // Compute opposite positions using the formula
    oppositeX = -startX;
    oppositeZ = -startZ;
  }

  @override
  String toString() {
    return 'Light(guid: $guid, origin: $origin, direction: $direction)';
  }
}

List<MovingDemoLight> lightsWeCanChangeParamsOn = [];
String centerPointLightGUID = const Uuid().v4();
List<Light> poGetSceneLightsList() {
  List<Light> itemsToReturn = [];

  itemsToReturn.add(poGetDefaultPointLight(Colors.white, 10000000));

  double yDirection = -1;
  double fallOffRadius = 10;
  double spotLightConeInnter = 0.1;
  double spotLightConeOuter = 0.3;
  //LightType lType = LightType.spot;
  LightType lType = LightType.point;

  String guid = const Uuid().v4();

  lightsWeCanChangeParamsOn
      .add(MovingDemoLight(guid, Position(-15.0, 5.0, -15.0), Direction(0.0, yDirection, 0.0)));

  itemsToReturn.add(Light(
      global_guid: guid,
      type: lType,
      colorTemperature: 36500,
      color: Colors.red,
      intensity: 100000000,
      castShadows: true,
      castLight: true,
      spotLightConeInner: spotLightConeInnter,
      spotLightConeOuter: spotLightConeOuter,
      falloffRadius: fallOffRadius,
      position: Vector3.only(x: -15, y: 5, z: -15),
      // should be a unit vector
      direction: Vector3.only(x: 0, y: yDirection, z: 0)));

  guid = const Uuid().v4();

  lightsWeCanChangeParamsOn
      .add(MovingDemoLight(guid, Position(15.0, 5.0, 15.0), Direction(0.0, yDirection, 0.0)));

  itemsToReturn.add(Light(
      global_guid: guid,
      type: lType,
      colorTemperature: 36500,
      color: Colors.blue,
      intensity: 100000000,
      castShadows: true,
      castLight: true,
      spotLightConeInner: spotLightConeInnter,
      spotLightConeOuter: spotLightConeOuter,
      falloffRadius: fallOffRadius,
      position: Vector3.only(x: 15, y: 5, z: 15),
      // should be a unit vector
      direction: Vector3.only(x: 0, y: yDirection, z: 0)));

  guid = const Uuid().v4();

  lightsWeCanChangeParamsOn
      .add(MovingDemoLight(guid, Position(-15.0, 5.0, 15.0), Direction(0.0, yDirection, 0.0)));

  itemsToReturn.add(Light(
      global_guid: guid,
      type: lType,
      colorTemperature: 36500,
      color: Colors.green,
      intensity: 100000000,
      castShadows: true,
      castLight: true,
      spotLightConeInner: spotLightConeInnter,
      spotLightConeOuter: spotLightConeOuter,
      falloffRadius: fallOffRadius,
      position: Vector3.only(x: -15, y: 5, z: 15),
      // should be a unit vector
      direction: Vector3.only(x: 0, y: yDirection, z: 0)));

  guid = const Uuid().v4();

  lightsWeCanChangeParamsOn
      .add(MovingDemoLight(guid, Position(15.0, 5.0, -15.0), Direction(0.0, yDirection, 0.0)));

  itemsToReturn.add(Light(
      global_guid: guid,
      type: lType,
      colorTemperature: 36500,
      color: Colors.orange,
      intensity: 100000000,
      castShadows: true,
      castLight: true,
      spotLightConeInner: spotLightConeInnter,
      spotLightConeOuter: spotLightConeOuter,
      falloffRadius: fallOffRadius,
      position: Vector3.only(x: 15, y: 5, z: -15),
      // should be a unit vector
      direction: Vector3.only(x: 0, y: yDirection, z: 0)));

  return itemsToReturn;
}

////////////////////////////////////////////////////////////////////////////////
List<String> radarConePieceGUID = [];
List<String> radarSegmentPiecesGUIDS = [];

List<Model> poGetModelList() {
  List<Model> itemsToReturn = [];

  // scene 0

  // 'primary object'
  itemsToReturn.add(poGetModel(
      sequoiaAsset,
      Vector3.only(x: 0, y: 0, z: 0),
      Vector3.only(x: 1, y: 1, z: 1),
      Vector4(x: 0, y: 0, z: 0, w: 1),
      null,
      null,
      true,
      true,
      const Uuid().v4(),
      true,
      true));

  itemsToReturn.add(poGetModel(
      sequoiaAsset,
      Vector3.only(x: 0, y: 0, z: 0),
      Vector3.only(x: 1, y: 1, z: 1),
      Vector4(x: 0, y: 0, z: 0, w: 1),
      Collidable(isStatic: false, shouldMatchAttachedObject: true),
      null,
      true,
      true,
      const Uuid().v4(),
      true,
      false));

  itemsToReturn.add(poGetModel(
      garageAsset,
      Vector3.only(x: 0, y: 0, z: -16),
      Vector3.only(x: 1, y: 1, z: 1),
      Vector4(x: 0, y: 0, z: 0, w: 1),
      null,
      null,
      false,
      true,
      const Uuid().v4(),
      false,
      false));

  itemsToReturn.add(poGetModel(
      foxAsset,
      Vector3.only(x: 0, y: 0, z: 0),
      Vector3.only(x: 1, y: 1, z: 1),
      Vector4(x: 0, y: 0, z: 0, w: 1),
      null,
      Animation.byIndex(0, autoPlay: true),
      true,
      true,
      const Uuid().v4(),
      true,
      true));

  itemsToReturn.add(poGetModel(
      foxAsset,
      Vector3.only(x: 1, y: 0, z: 4),
      Vector3.only(x: 0.04, y: 0.04, z: 0.04),
      Vector4(x: 0, y: 0, z: 0, w: 1),
      null,
      Animation.byIndex(0, autoPlay: true),
      true,
      true,
      const Uuid().v4(),
      true,
      false));

  itemsToReturn.add(poGetModel(
      foxAsset,
      Vector3.only(x: -1, y: 0, z: 4),
      Vector3.only(x: 0.04, y: 0.04, z: 0.04),
      Vector4(x: 0, y: 0, z: 0, w: 1),
      null,
      Animation.byIndex(1, autoPlay: true, notifyOfAnimationEvents: true),
      true,
      true,
      const Uuid().v4(),
      true,
      false));

  // scene 1
  for (int i = 0; i < 10; i++) {
    itemsToReturn.add(poGetModel(
        sequoiaAsset,
        Vector3.only(x: -40, y: 0, z: i * 5 - 25),
        Vector3.only(x: 1, y: 1, z: 1),
        Vector4(x: 0, y: 0, z: 0, w: 1),
        null,
        null,
        true,
        true,
        const Uuid().v4(),
        true,
        false));
  }

  itemsToReturn.add(poGetModel(
      roadAsset,
      Vector3.only(x: -40, y: 0, z: 0),
      Vector3.only(x: .4, y: .1, z: .2),
      Vector4(x: 0, y: 0, z: 0, w: 1),
      null,
      null,
      true,
      false,
      const Uuid().v4(),
      false,
      false));

  String guid = const Uuid().v4();
  radarConePieceGUID.add(guid);

  itemsToReturn.add(poGetModel(
      radarConeAsset,
      Vector3.only(x: -42.1, y: 1, z: 0),
      Vector3.only(x: 4, y: 1, z: 3),
      Vector4(x: 0, y: 0, z: 0, w: 1),
      null,
      null,
      false,
      false,
      guid,
      false,
      false));

  itemsToReturn.add(poGetModel(
      radarSegmentAsset,
      Vector3.only(x: 0, y: 0, z: 0),
      Vector3.only(x: 1, y: 1, z: 1),
      Vector4(x: 0.0, y: 0, z: 0, w: 1),
      null,
      null,
      true,
      true,
      const Uuid().v4(),
      true,
      true));

  for (int i = 0; i < 20; i++) {
    String guidForSegment = const Uuid().v4();

    itemsToReturn.add(poGetModel(
        radarSegmentAsset,
        Vector3.only(x: -42.2, y: 0, z: 0),
        Vector3.only(x: 0, y: 0, z: 0),
        Vector4(x: 0.7071, y: 0, z: 0.7071, w: 0),
        null,
        null,
        true,
        true,
        guidForSegment,
        true,
        false));

    radarSegmentPiecesGUIDS.add(guidForSegment);
  }

  return itemsToReturn;
}

////////////////////////////////////////////////////////////////////////////////
DefaultIndirectLight poGetDefaultIndirectLight() {
  return DefaultIndirectLight(
      intensity: 1000000, // indirect light intensity.
      radianceBands: 1, // Number of spherical harmonics bands.
      radianceSh: [
        1,
        1,
        1
      ], // Array containing the spherical harmonics coefficients.
      irradianceBands: 1, // Number of spherical harmonics bands.
      irradianceSh: [
        1,
        1,
        1
      ] // Array containing the spherical harmonics coefficients.
      );
}

////////////////////////////////////////////////////////////////////////////////
// Note point lights seem to only value intensity at a high
// range 30000000, for a 3 meter diameter of a circle, not caring about
// falloffradius
//
// Note for Spot lights you must specify a direction != 0,0,0
////////////////////////////////////////////////////////////////////////////////
Light poGetDefaultPointLight(Color directLightColor, double intensity) {
  return Light(
      global_guid: centerPointLightGUID,
      type: LightType.point,
      colorTemperature: 36500,
      color: directLightColor,
      intensity: intensity,
      castShadows: true,
      castLight: true,
      spotLightConeInner: 1,
      spotLightConeOuter: 10,
      falloffRadius: 300.1, // what base is this in? meters?
      position: Vector3.only(x: 0, y: 5, z: 1),
      // should be a unit vector
      direction: Vector3.only(x: 0, y: 1, z: 0));
}
