import 'package:flutter/material.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'package:uuid/uuid.dart';
import 'material_helpers.dart';

const String sequoiaAsset = "assets/models/sequoia_ngp.glb";
const String garageAsset = "assets/models/garagescene.glb";
// fox has animation
const String foxAsset = "assets/models/Fox.glb";
//const String dmgHelmAsset = "assets/models/DamagedHelmet.glb";

////////////////////////////////////////////////////////////////////////
GlbModel poGetModel(
    String szAsset,
    PlayxPosition position,
    PlayxSize scale,
    PlayxRotation rotation,
    Collidable? collidable,
    PlayxAnimation? animationInfo) {
  return GlbModel.asset(szAsset,
      animation: animationInfo,
      //fallback: GlbModel.asset(helmetAsset),
      collidable: collidable,
      centerPosition: position,
      scale: scale,
      rotation: rotation,
      name: szAsset,
      receiveShadows: true,
      castShadows: true,
      // ignore: prefer_const_constructors
      global_guid: Uuid().v4());
}

////////////////////////////////////////////////////////////////////////////////
List<String> thingsWeCanChangeParamsOn = [];
Shape poCreateCube(PlayxPosition pos, PlayxSize scale, PlayxSize sizeExtents,
    int idToSet, Color? colorOveride) {
  String uniqueGuid = const Uuid().v4();
  // Just to show off changing material params during runtime.
  thingsWeCanChangeParamsOn.add(uniqueGuid);

  return Cube(
      id: idToSet,
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
Shape poCreateSphere(PlayxPosition pos, PlayxSize scale, PlayxSize sizeExtents,
    int idToSet, int stacks, int slices, Color? colorOveride) {
  return Sphere(
      id: idToSet,
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
Shape poCreatePlane(
    PlayxPosition pos, PlayxSize scale, PlayxSize sizeExtents, int idToSet) {
  return Plane(
      id: idToSet,
      doubleSided: true,
      size: sizeExtents,
      scale: scale,
      castShadows: true,
      receiveShadows: true,
      centerPosition: pos,
      collidable: Collidable(isStatic: false, shouldMatchAttachedObject: true),

      // facing UP
      rotation: PlayxRotation(x: 0, y: .7071, z: .7071, w: 0),
      // identity
      // rotation: PlayxRotation(x: 0, y: 0, z: 0, w: 1),
      material: poGetTexturedMaterial());
  //material: poGetLitMaterialWithRandomValues());
}

////////////////////////////////////////////////////////////////////////////////
List<Shape> poCreateLineGrid() {
  List<Shape> itemsToReturn = [];
  int idIter = 40;
  double countExtents = 6;
  for (double i = -countExtents; i <= countExtents; i += 2) {
    for (int j = 0; j < 1; j++) {
      for (double k = -countExtents; k <= countExtents; k += 2) {
        itemsToReturn.add(poCreateCube(
            PlayxPosition(x: i, y: 0, z: k),
            PlayxSize(x: 1, y: 1, z: 1),
            PlayxSize(x: 1, y: 1, z: 1),
            idIter++,
            null));
      }
    }
  }

  return itemsToReturn;
}

////////////////////////////////////////////////////////////////////////////////
List<Shape> poGetScenesShapes() {
  //return poCreateLineGrid();

  List<Shape> itemsToReturn = [];
  int idToSet = 10;

  itemsToReturn.add(poCreateCube(
      PlayxPosition(x: 3, y: 1, z: 3),
      PlayxSize(x: 2, y: 2, z: 2),
      PlayxSize(x: 2, y: 2, z: 2),
      idToSet++,
      null));

  itemsToReturn.add(poCreateCube(
      PlayxPosition(x: 0, y: 1, z: 3),
      PlayxSize(x: .1, y: 1, z: .1),
      PlayxSize(x: 1, y: 1, z: 1),
      idToSet++,
      null));

  itemsToReturn.add(poCreateCube(
      PlayxPosition(x: -3, y: 1, z: 3),
      PlayxSize(x: .5, y: .5, z: .5),
      PlayxSize(x: 1, y: 1, z: 1),
      idToSet++,
      null));

  itemsToReturn.add(poCreateSphere(
      PlayxPosition(x: 3, y: 1, z: -3),
      PlayxSize(x: 1, y: 1, z: 1),
      PlayxSize(x: 1, y: 1, z: 1),
      idToSet++,
      11,
      5,
      null));

  itemsToReturn.add(poCreateSphere(
      PlayxPosition(x: 0, y: 1, z: -3),
      PlayxSize(x: 1, y: 1, z: 1),
      PlayxSize(x: 1, y: 1, z: 1),
      idToSet++,
      20,
      20,
      null));

  itemsToReturn.add(poCreateSphere(
      PlayxPosition(x: -3, y: 1, z: -3),
      PlayxSize(x: 1, y: .5, z: 1),
      PlayxSize(x: 1, y: 1, z: 1),
      idToSet++,
      20,
      20,
      null));

  itemsToReturn.add(poCreatePlane(PlayxPosition(x: -5, y: 1, z: 0),
      PlayxSize(x: 1, y: 1, z: 1), PlayxSize(x: 2, y: 1, z: 2), idToSet++));

  itemsToReturn.add(poCreatePlane(PlayxPosition(x: 5, y: 1, z: 0),
      PlayxSize(x: 4, y: 1, z: 4), PlayxSize(x: 4, y: 1, z: 4), idToSet++));

  return itemsToReturn;
}

////////////////////////////////////////////////////////////////////////////////
class MovingDemoLight {
  String guid;
  double originX, originY, originZ;
  double directionX, directionY, directionZ;

  String phase = "moving"; // 'toCenter' or 'toOpposite'
  double startX = 0, startZ = 0;
  double oppositeX = 0, oppositeZ = 0;
  double t = 0;

  MovingDemoLight(this.guid, this.originX, this.originY, this.originZ,
      this.directionX, this.directionY, this.directionZ) {
    startX = originX;
    startZ = originZ;

    // Compute opposite positions using the formula
    oppositeX = -startX;
    oppositeZ = -startZ;
  }

  @override
  String toString() {
    return 'Light(guid: $guid, origin: ($originX, $originY, $originZ), direction: ($directionX, $directionY, $directionZ))';
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
      .add(MovingDemoLight(guid, -15.0, 5.0, -15.0, 0.0, yDirection, 0.0));

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
      position: PlayxPosition(x: -15, y: 5, z: -15),
      // should be a unit vector
      direction: PlayxDirection(x: 0, y: yDirection, z: 0)));

  guid = const Uuid().v4();

  lightsWeCanChangeParamsOn
      .add(MovingDemoLight(guid, 15.0, 5.0, 15.0, 0.0, yDirection, 0.0));

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
      position: PlayxPosition(x: 15, y: 5, z: 15),
      // should be a unit vector
      direction: PlayxDirection(x: 0, y: yDirection, z: 0)));

  guid = const Uuid().v4();

  lightsWeCanChangeParamsOn
      .add(MovingDemoLight(guid, -15.0, 5.0, 15.0, 0.0, yDirection, 0.0));

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
      position: PlayxPosition(x: -15, y: 5, z: 15),
      // should be a unit vector
      direction: PlayxDirection(x: 0, y: yDirection, z: 0)));

  guid = const Uuid().v4();

  lightsWeCanChangeParamsOn
      .add(MovingDemoLight(guid, 15.0, 5.0, -15.0, 0.0, yDirection, 0.0));

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
      position: PlayxPosition(x: 15, y: 5, z: -15),
      // should be a unit vector
      direction: PlayxDirection(x: 0, y: yDirection, z: 0)));

  return itemsToReturn;
}

////////////////////////////////////////////////////////////////////////////////
List<Model> poGetModelList() {
  List<Model> itemsToReturn = [];
  itemsToReturn.add(poGetModel(
      sequoiaAsset,
      PlayxPosition(x: 0, y: 0, z: 0),
      PlayxSize(x: 1, y: 1, z: 1),
      PlayxRotation(x: 0, y: 0, z: 0, w: 1),
      Collidable(isStatic: false, shouldMatchAttachedObject: true),
      null));

  itemsToReturn.add(poGetModel(
      garageAsset,
      PlayxPosition(x: 0, y: 0, z: -16),
      PlayxSize(x: 1, y: 1, z: 1),
      PlayxRotation(x: 0, y: 0, z: 0, w: 1),
      null,
      null));

  itemsToReturn.add(poGetModel(
      foxAsset,
      PlayxPosition(x: 1, y: 0, z: 4),
      PlayxSize(x: .04, y: .04, z: .04),
      PlayxRotation(x: 0, y: 0, z: 0, w: 1),
      null,
      PlayxAnimation.byIndex(0, autoPlay: true)));

  itemsToReturn.add(poGetModel(
      foxAsset,
      PlayxPosition(x: -1, y: 0, z: 4),
      PlayxSize(x: .04, y: .04, z: .04),
      PlayxRotation(x: 0, y: 0, z: 0, w: 1),
      null,
      PlayxAnimation.byIndex(1,
          autoPlay: true, notifyOfAnimationEvents: true)));

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
      position: PlayxPosition(x: 0, y: 5, z: 1),
      // should be a unit vector
      direction: PlayxDirection(x: 0, y: 1, z: 0));
}
