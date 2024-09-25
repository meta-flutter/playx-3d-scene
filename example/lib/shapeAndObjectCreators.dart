import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'utils.dart';
import 'materialHelpers.dart';

const String sequoiaAsset = "assets/models/sequoia.glb";
const String garageAsset = "assets/models/garagescene.glb";

////////////////////////////////////////////////////////////////////////
GlbModel poGetModel(String szAsset, PlayxPosition position, PlayxSize scale,
    PlayxRotation rotation, Collidable? collidable) {
  return GlbModel.asset(szAsset,
      //animation: PlayxAnimation.byIndex(0, autoPlay: false),
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
Shape poCreateCube(PlayxPosition pos, PlayxSize scale, PlayxSize sizeExtents,
    int idToSet, Color? colorOveride) {
  return Cube(
      id: idToSet,
      size: sizeExtents,
      centerPosition: pos,
      scale: scale,
      castShadows: true,
      receiveShadows: true,
      material: poGetTexturedMaterial(),
      collidable: Collidable(isStatic: false, shouldMatchAttachedObject: true),
      // ignore: prefer_const_constructors
      global_guid: Uuid().v4()
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
List<Model> poGetModelList() {
  List<Model> itemsToReturn = [];
  itemsToReturn.add(poGetModel(
      sequoiaAsset,
      PlayxPosition(x: 0, y: 0, z: -14.77),
      PlayxSize(x: .5, y: 1, z: 1),
      PlayxRotation(x: 0, y: 0, z: 0, w: 1),
      Collidable(isStatic: false, shouldMatchAttachedObject: true)));

  itemsToReturn.add(poGetModel(
      garageAsset,
      PlayxPosition(x: 0, y: 0, z: -16),
      PlayxSize(x: 1, y: 1, z: 1),
      PlayxRotation(x: 0, y: 0, z: 0, w: 1),
      null));
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
      type: LightType.point,
      colorTemperature: 36500,
      color: directLightColor,
      intensity: intensity,
      castShadows: true,
      castLight: true,
      spotLightConeInner: 1,
      spotLightConeOuter: 10,
      falloffRadius: 300.1, // what base is this in? meters?
      position: PlayxPosition(x: 0, y: 3, z: 0),
      // should be a unit vector
      direction: PlayxDirection(x: 0, y: 1, z: 0));
}
