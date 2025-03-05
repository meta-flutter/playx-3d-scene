
import 'dart:math';

import 'package:flutter/material.dart' hide Material;
import 'package:my_fox_example/assets.dart';
import 'package:my_fox_example/demo_widgets.dart';
import 'package:my_fox_example/events/collision_event_channel.dart';
import 'package:my_fox_example/main.dart';
import 'package:my_fox_example/material_helpers.dart';
import 'package:my_fox_example/messages.g.dart';
import 'package:my_fox_example/scenes/scene_view.dart';
import 'package:my_fox_example/shape_and_object_creators.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();
final Random random = Random();

class SettingsSceneView extends StatefulSceneView {
  SettingsSceneView({
    super.key,
    required super.filament,
    required super.frameController,
    required super.collisionController,
    required super.readinessController,
  });

  @override
  _SettingsSceneViewState createState() => _SettingsSceneViewState();

  static final Vector3 carOrigin = Vector3.only(x: 72, y: 0, z: 68);

  static final Map<String, String> objectGuids = {
    'car': uuid.v4(),
    'floor1': uuid.v4(),
    'floor2': uuid.v4(),
    'floor3': uuid.v4(),
    'floor4': uuid.v4(),
    'floor5': uuid.v4(),
    'floor6': uuid.v4(),
    'floor7': uuid.v4(),
    'floor8': uuid.v4(),
    'floor9': uuid.v4(),
    'wall1': uuid.v4(),
    'wall2': uuid.v4(),
    'wall3': uuid.v4(),
    'wall4': uuid.v4(),
    'cube': uuid.v4(),
    'wiper1': uuid.v4(),
    'wiper2': uuid.v4(),
    's_wheel_F1': uuid.v4(),
    's_wheel_F2': uuid.v4(),
    's_wheel_B1': uuid.v4(),
    's_wheel_B2': uuid.v4(),
    'light1': uuid.v4(),
    'light2': uuid.v4(),
    'l_light_B1': uuid.v4(),
    'l_light_B2': uuid.v4(),
    'l_light_F1': uuid.v4(),
    'l_light_F2': uuid.v4(),
    //turning lights, front and back
    'l_light_tB1': uuid.v4(),
    'l_light_tB2': uuid.v4(),
    'l_light_tF1': uuid.v4(),
    'l_light_tF2': uuid.v4(),
  };

  static List<Model> getSceneModels() {
    final List<Model> models = [];


    models.add(GlbModel.asset(
      sequoiaAsset,
      centerPosition: carOrigin,
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: Collidable(isStatic: false, shouldMatchAttachedObject: true),
      animation: null,
      receiveShadows: true,
      castShadows: true,
      name: sequoiaAsset,
      guid: objectGuids['car']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));

    final Vector3 lightOffset = Vector3.only(x: -2.5, y: 1, z: -0.9);

    // use 'radar_cone' asset for lights
    models.add(GlbModel.asset(
      radarConeAsset,
      centerPosition: carOrigin + lightOffset - Vector3.only(z: lightOffset.z * 2),
      scale: lightSize,
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: false,
      castShadows: false,
      name: radarConeAsset,
      guid: objectGuids['light1']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));


    models.add(GlbModel.asset(
      radarConeAsset,
      // centerPosition: Vector3.only(z: lightOffset.z * 10),
      centerPosition: carOrigin + lightOffset - Vector3.only(z: lightOffset.z * 0),
      scale: lightSize,
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: false,
      castShadows: false,
      name: radarConeAsset,
      guid: objectGuids['light2']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));

    // 16x16 floor, 3x3 tiles
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: 0, y: 0, z: 0),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_1",
      guid: objectGuids['floor1']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: -16, y: 0, z: 16),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_2",
      guid: objectGuids['floor2']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: -16, y: 0, z: 0),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_3",
      guid: objectGuids['floor3']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: -16, y: 0, z: -16),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_4",
      guid: objectGuids['floor4']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: 0, y: 0, z: -16),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_5",
      guid: objectGuids['floor5']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: 16, y: 0, z: -16),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_6",
      guid: objectGuids['floor6']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: 16, y: 0, z: 0),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_7",
      guid: objectGuids['floor7']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: 16, y: 0, z: 16),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_8",
      guid: objectGuids['floor8']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));
    models.add(GlbModel.asset(
      checkerboardFloor,
      centerPosition: carOrigin - Vector3.only(x: 0, y: 0, z: 16),
      scale: Vector3.all(1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: null,
      animation: null,
      receiveShadows: true,
      castShadows: false,
      name: "${checkerboardFloor}_9",
      guid: objectGuids['floor9']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));

    return models;
  }

  static final Vector3 wiperSize = Vector3.only(x: 0.05, y: 0.75, z: 0.05);
  static final Vector3 lightSize = Vector3.only(x: 0.2, y: 0.2, z: 0.2);

  static final Vector3 wheelOffset = Vector3.only(x: 1.75, y: 0.5, z: 0.9);
  static final double wheelBackOffset = 0.4;
  static final Vector3 wheelSize = Vector3(0.5, 0.5, 0.2);
  static final int wheelSegments = 8;
  static final Map<String, Vector3> wheelPositions = {
    's_wheel_F1': carOrigin + Vector3.only(x: -wheelOffset.x,                   y: wheelOffset.y, z: wheelOffset.z),
    's_wheel_F2': carOrigin + Vector3.only(x: -wheelOffset.x,                   y: wheelOffset.y, z: -wheelOffset.z),
    's_wheel_B1': carOrigin + Vector3.only(x: wheelOffset.x - wheelBackOffset,  y: wheelOffset.y, z: wheelOffset.z),
    's_wheel_B2': carOrigin + Vector3.only(x: wheelOffset.x - wheelBackOffset,  y: wheelOffset.y, z: -wheelOffset.z),
  };

  static List<Shape> getSceneShapes() {
    final List<Shape> shapes = [];

    // shapes.add(poCreateCube(
    //   Vector3.only(x: 72, y: 4, z: 68),
    //   Vector3.only(x: 2, y: 2, z: 2),
    //   Vector3.only(x: 2, y: 2, z: 2),
    //   null,
    //   objectGuids['cube']!,
    // ));

    // Wall (use cube as wall), floor is 48x48 
    // shapes.add(poCreateCube(
    //   carOrigin - Vector3.only(x: 0, y: -8 + 0.1, z: 24),
    //   Vector3.only(x: 48, y: 16, z: 0.1),
    //   Vector3.only(x: 48, y: 16, z: 0.1),
    //   null,
    //   objectGuids['wall1']!,
    // ));
    // shapes.add(poCreateCube(
    //   carOrigin - Vector3.only(x: 0, y: -8 + 0.1, z: -24),
    //   Vector3.only(x: 48, y: 16, z: 0.1),
    //   Vector3.only(x: 48, y: 16, z: 0.1),
    //   null,
    //   objectGuids['wall2']!,
    // ));
    // shapes.add(poCreateCube(
    //   carOrigin - Vector3.only(x: 24, y: -8 + 0.1, z: 0),
    //   Vector3.only(x: 0.1, y: 16, z: 48),
    //   Vector3.only(x: 0.1, y: 16, z: 48),
    //   null,
    //   objectGuids['wall3']!,
    // ));
    // shapes.add(poCreateCube(
    //   carOrigin - Vector3.only(x: -24, y: -8 + 0.1, z: -0),
    //   Vector3.only(x: 0.1, y: 16, z: 48),
    //   Vector3.only(x: 0.1, y: 16, z: 48),
    //   null,
    //   objectGuids['wall4']!,
    // ));

    // use cube as wipers
    Vector3 wiperOffset = Vector3.only(x: -1.3, y: 1.45, z: -0.45);

    shapes.add(poCreateCube(
      Vector3.only(x: 72, y: 0, z: 68) + wiperOffset,
      wiperSize,
      wiperSize,
      null,
      objectGuids['wiper1']!,
    ));

    shapes.add(poCreateCube(
      Vector3.only(x: 72, y: 0, z: 68) + wiperOffset - Vector3.only(z: wiperOffset.z * 2),
      wiperSize,
      wiperSize,
      null,
      objectGuids['wiper2']!,
    ));

    // Use spheres as wheels
    for(final entry in wheelPositions.entries) {
      shapes.add(poCreateSphere(
        entry.value,
        wheelSize,
        wheelSize,
        wheelSegments, wheelSegments,
        null,
        objectGuids[entry.key]!,
      ));
    }

    return shapes;
  }

  static List<Light> getSceneLights() {
    final List<Light> lights = [];

    return lights;
  }
}

class _SettingsSceneViewState extends StatefulSceneViewState<SettingsSceneView> with SingleTickerProviderStateMixin {
  /*
   *  Game logic
   */
  @override
  void onCreate() {
    _resetCamera();

    _animationController = BottomSheet.createAnimationController(
      this,
    );

    // Set up listeners for wheel clicks
    widget.collisionController.addListener(_onObjectTouch);
    // Set tire meshes to invisible
    for(String name in SettingsSceneView.wheelPositions.keys) {
      widget.filament.turnOffVisualForEntity(SettingsSceneView.objectGuids[name]!);
    }
  }

  void _resetCamera({ bool autoOrbit = false}) {
    if(autoOrbit) {
      widget.filament.changeCameraMode("AUTO_ORBIT");
    } else {
      widget.filament.changeCameraMode("INERTIA_AND_GESTURES");
    }


    widget.filament.changeCameraOrbitHomePosition(64,4,64);
    widget.filament.changeCameraTargetPosition(72,1,68);
    widget.filament.changeCameraFlightStartPosition(64, 4, 64);


  }

  void _onObjectTouch(CollisionEvent event) {
    print("Scene received touch!");
    onTriggerEvent("touchObject", event);
  }

  double _timer = 0;
  final ValueNotifier<bool> _showWipers = ValueNotifier<bool>(true);
  final ValueNotifier<double> _wiperSpeed = ValueNotifier<double>(8);

  final ValueNotifier<bool> _showLights = ValueNotifier<bool>(true);
  final ValueNotifier<double> _lightLength = ValueNotifier<double>(1);
  final ValueNotifier<double> _lightWidth = ValueNotifier<double>(1);
  final ValueNotifier<double> _lightAngleX = ValueNotifier<double>(0);
  final ValueNotifier<double> _lightAngleY = ValueNotifier<double>(0);
  final ValueNotifier<double> _lightIntensity = ValueNotifier<double>(1);

  final ValueNotifier<bool> _activateTurningLights = ValueNotifier<bool>(false);

  @override
  void onUpdateFrame(FilamentViewApi filament, double dt) {
    _timer += dt;

    // Wipers
    final double wiperSpeed = _wiperSpeed.value;
    final double wiperAngle = sin(_timer * wiperSpeed) * 0.66;
    final Vector4 wiperRotation = Vector4.fromEulerAngles(wiperAngle, 0, -0.8);
    filament.changeRotationByGUID(
      SettingsSceneView.objectGuids['wiper1']!,
      wiperRotation.x,
      wiperRotation.y,
      wiperRotation.z,
      wiperRotation.w,
    );
    filament.changeRotationByGUID(
      SettingsSceneView.objectGuids['wiper2']!,
      wiperRotation.x,
      wiperRotation.y,
      wiperRotation.z,
      wiperRotation.w,
    );

    // show/hide wipers
    filament.changeScaleByGUID(
      SettingsSceneView.objectGuids['wiper1']!,
      SettingsSceneView.wiperSize.x * (_showWipers.value ? 1 : 0),
      SettingsSceneView.wiperSize.y * (_showWipers.value ? 1 : 0),
      SettingsSceneView.wiperSize.z * (_showWipers.value ? 1 : 0),
    );
    filament.changeScaleByGUID(
      SettingsSceneView.objectGuids['wiper2']!,
      SettingsSceneView.wiperSize.x * (_showWipers.value ? 1 : 0),
      SettingsSceneView.wiperSize.y * (_showWipers.value ? 1 : 0),
      SettingsSceneView.wiperSize.z * (_showWipers.value ? 1 : 0),
    );

    // Lights
    Vector3 lightScale = SettingsSceneView.lightSize * Vector3(
      _lightLength.value,
      1,
      _lightWidth.value,
    ) * Vector3.all(
      _showLights.value ? 1 : 0,
    );

    filament.changeScaleByGUID(
      SettingsSceneView.objectGuids['light1']!,
      lightScale.x,
      lightScale.y,
      lightScale.z,
    );
    filament.changeScaleByGUID(
      SettingsSceneView.objectGuids['light2']!,
      lightScale.x,
      lightScale.y,
      lightScale.z,
    );
    Vector4 lightRotation = Vector4.fromEulerAngles(0, _lightAngleX.value, _lightAngleY.value);
    filament.changeRotationByGUID(
      SettingsSceneView.objectGuids['light1']!,
      lightRotation.x,
      lightRotation.y,
      lightRotation.z,
      lightRotation.w,
    );
    filament.changeRotationByGUID(
      SettingsSceneView.objectGuids['light2']!,
      lightRotation.x,
      lightRotation.y,
      lightRotation.z,
      lightRotation.w,
    );

    // show/hide lights
    if(_showLights.value) {
      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_B1']!,
        Colors.red.toHex(),
        (5000000 * _lightIntensity.value).round(),
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_B2']!,
        Colors.red.toHex(),
        (5000000 * _lightIntensity.value).round(),
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_F1']!,
        Colors.yellow.toHex(),
        (5000000 * _lightIntensity.value).round()
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_F2']!,
        Colors.yellow.toHex(),
        (5000000 * _lightIntensity.value).round()
      );
    } else {
      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_B1']!,
        Colors.black.toHex(),
        0,
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_B2']!,
        Colors.black.toHex(),
        0,
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_F1']!,
        Colors.black.toHex(),
        0,
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_F2']!,
        Colors.black.toHex(),
        0,
      );
    }

    // blink turning lights
    if((_timer * 2).floor() % 2 == 1 && _activateTurningLights.value == true) {
      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_tB1']!,
        Colors.orange.toHex(),
        (5000000 * _lightIntensity.value).round(),
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_tB2']!,
        Colors.orange.toHex(),
        (5000000 * _lightIntensity.value).round(),
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_tF1']!,
        Colors.orange.toHex(),
        (5000000 * _lightIntensity.value).round(),
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_tF2']!,
        Colors.orange.toHex(),
        (5000000 * _lightIntensity.value).round(),
      );
    } else {
      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_tB1']!,
        Colors.black.toHex(),
        0,
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_tB2']!,
        Colors.black.toHex(),
        0,
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_tF1']!,
        Colors.black.toHex(),
        0,
      );

      filament.changeLightColorByGUID(
        SettingsSceneView.objectGuids['l_light_tF2']!,
        Colors.black.toHex(),
        0,
      );
    }
  }

  static const double _wheelCameraDistanceZ = 1;
  static const double _wheelCameraDistanceY = 0;
  static final Map<String, Vector3> _wheelCameraPositions = SettingsSceneView.wheelPositions.map((key, value) => MapEntry(
    key,
    value
      + Vector3.only(y: _wheelCameraDistanceY)
      + (
        value.z > 0
          ? Vector3.only(x: _wheelCameraDistanceZ)
          : Vector3.only(x: -_wheelCameraDistanceZ)
        )
  ));

  @override
  void onTriggerEvent(final String eventName, [ final dynamic? eventData ]) {
    if(eventName != "touchObject") return;

    final CollisionEvent event = eventData as CollisionEvent;
    final String guid = event.results[0].guid;

    print('Touched object with guid: ${guid}');

    // If touched any of the wheels...
    if(
      guid == SettingsSceneView.objectGuids['s_wheel_F1'] ||
      guid == SettingsSceneView.objectGuids['s_wheel_F2'] ||
      guid == SettingsSceneView.objectGuids['s_wheel_B1'] ||
      guid == SettingsSceneView.objectGuids['s_wheel_B2']
    ) {
      final String name = SettingsSceneView.objectGuids.entries.firstWhere((entry) => entry.value == guid).key;
      print('Touched wheel ${name}');

      // Change camera position to wheel
      _cameraFocusOnTire(name);

      // Set menu setting
      _menuSelected.value = 4;

      // Increase tire pressure
      _tirePressures[name]!.value = (_tirePressures[name]!.value + 0.025).clamp(0, 1);
    }
  }

  void _cameraFocusOnTire(String name) {
    final Vector3 cameraLookAt = SettingsSceneView.wheelPositions[name]!;
    final Vector3 cameraLookFrom = _wheelCameraPositions[name]!;


    widget.filament.changeCameraFlightStartPosition(
      cameraLookFrom.x,
      cameraLookFrom.y,
      cameraLookFrom.z,
    );

    // widget.filament.changeCameraOrbitHomePosition(
    //   cameraLookFrom.x,
    //   cameraLookFrom.y,
    //   cameraLookFrom.z,
    // );

    widget.filament.changeCameraTargetPosition(
      cameraLookAt.x,
      cameraLookAt.y,
      cameraLookAt.z,
    );


    // If last character is 1, it's left - set camera angle
    if(name.endsWith('1')) {  
      widget.filament.setCameraRotation(pi * 0.5);
    } else {
      widget.filament.setCameraRotation(pi * -0.5);
    }

    print("Set camera to tire ${name}, look from ${cameraLookFrom} at ${cameraLookAt}");


    // widget.filament.resetInertiaCameraToDefaultValues();
  }

  @override
  void onDestroy() {
    widget.collisionController.removeListener(_onObjectTouch);
  }

  /*
   *  UI
   */
  double _screenHeight = 0;
  bool _showSettings = false;
  late AnimationController _animationController;

  ValueNotifier<double> _setting1 = ValueNotifier<double>(0.5);
  ValueNotifier<double> _setting2 = ValueNotifier<double>(0.5);
  ValueNotifier<double> _setting3 = ValueNotifier<double>(0.5);

  ValueNotifier<int> _menuSelected = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    // If settings hidden, show large invisible button to show settings
    if(!_showSettings) {
      // TODO(kerberjg): add viewport adjustment to filament view
      _resetCamera(autoOrbit: true);
    } else {
      _resetCamera(autoOrbit: false);
    }

    return Stack(
      children: [
        // GestureDetector to show/hide
        if(!_showSettings) GestureDetector(
          onTap: () {
            setState(() {
              _showSettings = !_showSettings;
              if (_showSettings) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),

        // Settings bottom sheet on the left (use AnimatedBuilder to animate)
        AnimatedPositioned(
          left: 0,
          bottom: _showSettings ? 0 : -_screenHeight,
          duration: const Duration(milliseconds: 300),
          child: _buildSettingsBottomSheet(context),
        )
      ]
    );
  }

  Widget _buildSettingsBottomSheet(BuildContext context) {
    return Container(
        height: _screenHeight,
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.66),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        //
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Row 1: title, close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      setState(() {
                        _showSettings = false;
                      });
                    },
                  ),
                ],
              ),
              // Row 2: settings (3 sliders)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ListenableBuilder(
                  listenable: _menuSelected,
                  builder:(context, child) => switch(_menuSelected.value) {
                    0 => child!,
                    1 => _buildMaterialSettings(context),
                    2 => _buildLightSettings(context),
                    3 => _buildWiperSettings(context),
                    4 => _buildTireSettings(context),
                    _ => Text("Unknown menu item"),
                  },

                  // Menu selector (buttons with icon and text)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: <Widget>[
                      // Material settings
                      ElevatedButton.icon(
                        onPressed: () {
                          _menuSelected.value = 1;
                        },
                        icon: const Icon(Icons.color_lens),
                        label: const Text('Material'),
                      ),
                      // Light settings
                      ElevatedButton.icon(
                        onPressed: () {
                          _menuSelected.value = 2;
                        },
                        icon: const Icon(Icons.lightbulb),
                        label: const Text('Light'),
                      ),
                      // Wiper settings
                      ElevatedButton.icon(
                        onPressed: () {
                          _menuSelected.value = 3;
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text('Wiper'),
                      ),
                      // Tire settings
                      ElevatedButton.icon(
                        onPressed: () {
                          _menuSelected.value = 4;
                        },
                        icon: const Icon(Icons.car_repair),
                        label: const Text('Tire'),
                      ),
                    ],
                  ),

                )
              ),
            ],
        ),
      );
  }

  Material _customizedMaterial = poGetLitMaterialWithRandomValues();
  MaterialParameter _paramColor = MaterialParameter.baseColor(color: Colors.white);
  MaterialParameter _paramRoughness = MaterialParameter.roughness(value: 0.8);
  MaterialParameter _paramMetalness = MaterialParameter.metallic(value: 0.0);
  HSVColor _customColor = HSVColor.fromColor(Color(0xffff00ff));

  void _onSettingChanged() {
    // Update hue
    _customColor = _customColor.withHue(_setting1.value * 360);
    _paramColor = MaterialParameter.baseColor(color: _customColor.toColor());

    // Update roughness
    _paramRoughness = MaterialParameter.roughness(value: _setting2.value);

    // Update metalness
    _paramMetalness = MaterialParameter.metallic(value: _setting3.value);

    // Set material
    _customizedMaterial = Material.asset(
      litMat,
      parameters: [
        _paramColor,
        _paramRoughness,
        _paramMetalness,
      ],
    );
    widget.filament.changeMaterialDefinition(_customizedMaterial.toJson(), SettingsSceneView.objectGuids['car']!);
  }

  Widget _buildMaterialSettings(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // back button
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _resetCamera();
          _menuSelected.value = 0;
        },
      ),
      SizedBox(height: 16),
      // Slider 1: Ambient light
      Text("Color"),
      ListenableBuilder(
        listenable: _setting1,
        builder: (BuildContext context, Widget? child) => Slider(
          min: 0,
          max: 1,
          value: _setting1.value,
          onChanged: (double value) {
            _setting1.value = value;
            _onSettingChanged();
          },
        )
      ),
      // Slider 2: Direct light
      Text("Roughness"),
      ListenableBuilder(
        listenable: _setting2,
        builder: (BuildContext context, Widget? child) => Slider(
          min: 0,
          max: 1,
          value: _setting2.value,
          onChanged: (double value) {
            _setting2.value = value;
            _onSettingChanged();
          },
        )
      ),
      // Slider 3: Indirect light
      Text("Metallic"),
      ListenableBuilder(
        listenable: _setting3,
        builder: (BuildContext context, Widget? child) => Slider(
          min: 0,
          max: 1,
          value: _setting3.value,
          onChanged: (double value) {
            _setting3.value = value;
            _onSettingChanged();
          },
        )
      ),
      // Button: Randomize
      ElevatedButton(
        onPressed: () {
          _setting1.value = random.nextDouble();
          _setting2.value = random.nextDouble();
          _setting3.value = random.nextDouble();
          _onSettingChanged();
        },
        child: const Text('Randomize'),
      ),
    ],
  );


  // Wiper settings
  Widget _buildWiperSettings(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // back button
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _resetCamera();
          _menuSelected.value = 0;
        },
      ),
      SizedBox(height: 16),
      // Switch 1: Show wipers
      Row(
        children: <Widget>[
          Text("Show wipers"),
          ListenableBuilder(
            listenable: _showWipers,
            builder: (BuildContext context, Widget? child) => Switch(
              value: _showWipers.value,
              onChanged: (bool value) {
                _showWipers.value = value;
              },
            ),
          ),
        ],
      ),
      // Slider 1: Wiper speed
      Text("Wiper speed"),
      ListenableBuilder(
        listenable: _wiperSpeed,
        builder: (BuildContext context, Widget? child) => Slider(
          min: 0,
          max: 20,
          value: _wiperSpeed.value,
          onChanged: (double value) {
            _wiperSpeed.value = value;
          },
        )
      ),
    ],
  );

  // Light settings
  Widget _buildLightSettings(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // back button
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _resetCamera();
          _menuSelected.value = 0;
        },
      ),
      SizedBox(height: 16),
      // Switch 1: Show lights
      Row(
        children: <Widget>[
          Text("Show lights"),
          ListenableBuilder(
            listenable: _showLights,
            builder: (BuildContext context, Widget? child) => Switch(
              value: _showLights.value,
              onChanged: (bool value) {
                _showLights.value = value;
              },
            ),
          ),
        ],
      ),
      // Switch 2: Activate turning lights
      Row(
        children: <Widget>[
          Text("Activate turning lights"),
          ListenableBuilder(
            listenable: _activateTurningLights,
            builder: (BuildContext context, Widget? child) => Switch(
              value: _activateTurningLights.value,
              onChanged: (bool value) {
                _activateTurningLights.value = value;
              },
            ),
          ),
        ],
      ),
      // Slider 1: Light length
      Text("Light length"),
      ListenableBuilder(
        listenable: _lightLength,
        builder: (BuildContext context, Widget? child) => Slider(
          min: 0.1,
          max: 5,
          value: _lightLength.value,
          onChanged: (double value) {
            _lightLength.value = value;
          },
        )
      ),
      // Slider 2: Light width
      Text("Light width"),
      ListenableBuilder(
        listenable: _lightWidth,
        builder: (BuildContext context, Widget? child) => Slider(
          min: 0.1,
          max: 5,
          value: _lightWidth.value,
          onChanged: (double value) {
            _lightWidth.value = value;
          },
        )
      ),
      // Slider 3: Light angle X
      Text("Light turning"),
      ListenableBuilder(
        listenable: _lightAngleX,
        builder: (BuildContext context, Widget? child) => Slider(
          min: -pi / 4,
          max: pi / 4,
          value: _lightAngleX.value,
          onChanged: (double value) {
            _lightAngleX.value = value;
          },
        )
      ),
      // Slider 4: Light angle Y
      Text("Light height"),
      ListenableBuilder(
        listenable: _lightAngleY,
        builder: (BuildContext context, Widget? child) => Slider(
          min: -pi / 4,
          max: pi / 4,
          value: _lightAngleY.value,
          onChanged: (double value) {
            _lightAngleY.value = value;
          },
        )
      ),
      // Slider 5: Light intensity
      Text("Light intensity"),
      ListenableBuilder(
        listenable: _lightIntensity,
        builder: (BuildContext context, Widget? child) => Slider(
          min: 0,
          max: 2,
          value: _lightIntensity.value,
          onChanged: (double value) {
            _lightIntensity.value = value;
          },
        )
      ),

    ],
  );

  final Map<String, ValueNotifier<double>> _tirePressures = {
    's_wheel_F1': ValueNotifier<double>(0.5),
    's_wheel_F2': ValueNotifier<double>(0.5),
    's_wheel_B1': ValueNotifier<double>(0.5),
    's_wheel_B2': ValueNotifier<double>(0.5),
  };

  static const Map<String, String> _tireNames = {
    's_wheel_F1': 'Front-left',
    's_wheel_F2': 'Front-right',
    's_wheel_B1': 'Back-left',
    's_wheel_B2': 'Back-right',
  };

  Widget _buildTireSettings(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // back button
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _resetCamera();
          _menuSelected.value = 0;
        },
      ),
      SizedBox(height: 16),
      
      // All tire pressure sliders
      for(final entry in _tirePressures.entries) ...[
        Text(_tireNames[entry.key]!),
        ListenableBuilder(
          listenable: entry.value,
          builder: (BuildContext context, Widget? child) => Slider(
            min: 0,
            max: 1,
            value: entry.value.value,
            onChangeStart: (double value) {
              // focus camera on tire
              _cameraFocusOnTire(entry.key);
            },
            onChanged: (double value) {
              // set value
              entry.value.value = value;
            },
          )
        ),
      ],
    ],
  );

}