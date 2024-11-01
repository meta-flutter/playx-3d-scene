import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'utils.dart';

const String litMat = "assets/materials/lit.filamat";
const String texturedMat = "assets/materials/textured_pbr.filamat";

////////////////////////////////////////////////////////////////////////
PlayxMaterial poGetLitMaterial(Color? colorOveride) {
  return PlayxMaterial.asset(
    litMat,
    //usually the material file contains values for these properties,
    //but if we want to customize it we can like that.
    parameters: [
      //update base color property with color
      MaterialParameter.color(
          color: colorOveride ?? Colors.white, name: "baseColor"),
      //update roughness property with it's value
      MaterialParameter.float(value: .8, name: "roughness"),
      //update metallicproperty with it's value
      MaterialParameter.float(value: .0, name: "metallic"),
    ],
  );
}

////////////////////////////////////////////////////////////////////////////////
PlayxMaterial poGetLitMaterialWithRandomValues() {
  Random random = Random();

  return PlayxMaterial.asset(
    litMat,
    //usually the material file contains values for these properties,
    //but if we want to customize it we can like that.
    parameters: [
      //update base color property with color
      MaterialParameter.color(color: getRandomPresetColor(), name: "baseColor"),
      //update roughness property with it's value
      MaterialParameter.float(value: random.nextDouble(), name: "roughness"),
      //update metallicproperty with it's value
      MaterialParameter.float(value: random.nextDouble(), name: "metallic"),
    ],
  );
}

////////////////////////////////////////////////////////////////////////////////
MaterialParameter poGetRandomColorMaterialParam() {
  return MaterialParameter.color(
      color: getRandomPresetColor(), name: "baseColor");
}

////////////////////////////////////////////////////////////////////////////////
PlayxMaterial poGetTexturedMaterial() {
  return PlayxMaterial.asset(texturedMat, parameters: [
    MaterialParameter.texture(
      value: PlayxTexture.asset(
        "assets/materials/texture/floor_basecolor.png",
        type: TextureType.color,
        sampler: PlayxTextureSampler(anisotropy: 8),
      ),
      name: "baseColor",
    ),
    MaterialParameter.texture(
      value: PlayxTexture.asset(
        "assets/materials/texture/floor_normal.png",
        type: TextureType.normal,
        sampler: PlayxTextureSampler(anisotropy: 8),
      ),
      name: "normal",
    ),
    MaterialParameter.texture(
      value: PlayxTexture.asset(
        "assets/materials/texture/floor_ao_roughness_metallic.png",
        type: TextureType.data,
        sampler: PlayxTextureSampler(anisotropy: 8),
      ),
      name: "aoRoughnessMetallic",
    ),
  ]);
}
