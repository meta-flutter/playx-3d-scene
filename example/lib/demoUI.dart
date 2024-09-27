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
import 'shapeAndObjectCreators.dart';
import 'main.dart';

////////////////////////////////////////////////////////////////////////
TextStyle getTextStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    shadows: [
      Shadow(
        offset: Offset(-1.5, -1.5),
        color: Colors.white,
      ),
      Shadow(
        offset: Offset(1.5, -1.5),
        color: Colors.white,
      ),
      Shadow(
        offset: Offset(1.5, 1.5),
        color: Colors.white,
      ),
      Shadow(
        offset: Offset(-1.5, 1.5),
        color: Colors.white,
      ),
    ],
  );
}
