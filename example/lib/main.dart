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
import 'demoUI.dart';

// Rebuilding materials to match filament versions.
// playx-3d-scene/example/assets/materials$
// /home/tcna/dev/workspace-automation/app/filament/cmake-build-release/staging/release/bin/matc -a vulkan -o lit.filamat raw/lit.mat
// playx-3d-scene/example/assets/materials$
// /home/tcna/dev/workspace-automation/app/filament/cmake-build-release/staging/release/bin/matc -a vulkan -o textured_pbr.filamat raw/textured_pbr.mat

////////////////////////////////////////////////////////////////////////
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);

    // If debugging and curious uncomment.
    // stdout.write('Global error caught exception: ${details.exception}');
    // stdout.write('Global error caught stack: ${details.stack}');
  };

  runZonedGuarded<Future<void>>(() async {
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    stdout.write('runZonedGuarded error caught error: $error');
    stdout.write('runZonedGuarded error caught stack: $stack');
  });
}

////////////////////////////////////////////////////////////////////////
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ////////////////////////////////////////////////////////////////////////
  bool isModelLoading = false;
  bool isSceneLoading = false;
  bool isShapeLoading = false;
  late Playx3dSceneController poController;
  Color _directLightColor = Colors.purple;
  double _directIntensity = 300000000;
  final double _minIntensity = 10000000;
  final double _maxIntensity = 300000000;
  double _cameraRotation = 0;
  bool _autoRotate = false;
  bool _toggleShapes = true;
  bool _toggleCollidableVisuals = true;

  static const String viewerChannelName = "plugin.filament_view.frame_view";
  static const String collisionChannelName =
      "plugin.filament_view.collision_info";
  static const String animationChannelName =
      "plugin.filament_view.animation_info";

  ////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
  }

  ////////////////////////////////////////////////////////////////////////
  void logToStdOut(String strOut) {
    DateTime now = DateTime.now();
    stdout.write('DART : $strOut: $now\n');
  }

  ////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.0),
        body: Stack(
          children: [
            poGetPlayx3dScene(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Direct Light',
                      style: getTextStyle(),
                    ),
                    SizedBox(
                      width: 100,
                      child: ColorPicker(
                        colorPickerWidth: 100,
                        pickerColor: _directLightColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            _directLightColor = color;
                            poController.changeDirectLightValuesByIndex(
                                0, _directLightColor, _directIntensity.toInt());
                          });
                        },
                        //showLabel: false,
                        pickerAreaHeightPercent: 1.0,
                        enableAlpha: false,
                        displayThumbColor: false,
                        portraitOnly: true,
                        paletteType: PaletteType.hueWheel,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 150,
                      child: Column(
                        children: [
                          Text('Intensity', style: getTextStyle()),
                          Slider(
                            value: _directIntensity,
                            min: _minIntensity,
                            max: _maxIntensity,
                            onChanged: (double value) {
                              setState(() {
                                _directIntensity = value;
                                poController.changeDirectLightValuesByIndex(
                                    0,
                                    _directLightColor,
                                    _directIntensity.toInt());
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Camera Rotation',
                    style: getTextStyle(),
                  ),
                  Slider(
                    value: _cameraRotation,
                    min: 0,
                    max: 600,
                    onChanged: (double value) {
                      setState(() {
                        _cameraRotation = value;
                        poController.setCameraRotation(_cameraRotation / 100);
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _autoRotate = !_autoRotate;
                            //static constexpr char kModeAutoOrbit[] = "AUTO_ORBIT";
                            //static constexpr char kModeInertiaAndGestures[] = "INERTIA_AND_GESTURES";

                            if (_autoRotate)
                              poController.changeCameraMode("AUTO_ORBIT");
                            else
                              poController
                                  .changeCameraMode("INERTIA_AND_GESTURES");
                          });
                        },
                        child: Text(_autoRotate
                            ? 'Auto Orbit On'
                            : 'Inertia & Gestures On'),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            poController.resetInertiaCameraToDefaultValues();
                          });
                        },
                        child: Text('Reset'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _toggleShapes = !_toggleShapes;
                            poController.toggleShapesInScene(_toggleShapes);
                          });
                        },
                        child: Text(_toggleShapes
                            ? 'Toggle Shapes: On'
                            : 'Toggle Shapes: Off'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            poController.toggleCollidableVisualsInScene(
                                _toggleCollidableVisuals);
                            _toggleCollidableVisuals =
                                !_toggleCollidableVisuals;
                          });
                        },
                        child: Text(_toggleCollidableVisuals
                            ? 'Toggle Collidables: On'
                            : 'Toggle Collidables: Off'),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            poController.changeQualitySettings();
                          });
                        },
                        child: Text('Qual'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  Scene poGetScene() {
    return Scene(
      skybox: ColoredSkybox(color: Colors.black),
      //skybox: HdrSkybox.asset("assets/envs/courtyard.hdr"),
      //indirectLight: HdrIndirectLight.asset("assets/envs/courtyard.hdr"),
      indirectLight: poGetDefaultIndirectLight(),
      light: poGetDefaultPointLight(_directLightColor, _directIntensity),
      camera: Camera.inertiaAndGestures(
          exposure: Exposure.formAperture(
            aperture: 24.0,
            shutterSpeed: 1 / 60,
            sensitivity: 150,
          ),
          targetPosition: PlayxPosition(x: 0.0, y: 0.0, z: 0.0),
          upVector: PlayxPosition(x: 0.0, y: 1.0, z: 0.0),
          // This is used as your extents when orbiting around an object
          // when the camera is set to inertiaAndGestures
          flightStartPosition: PlayxPosition(x: 8.0, y: 3.0, z: 8.0),
          // how much ongoing rotation velocity effects, default 0.05
          inertia_rotationSpeed: 0.05,
          // 0-1 how much of a flick distance / delta gets multiplied, default 0.2
          inertia_velocityFactor: 0.2,
          // 0-1 larger number means it takes longer for it to decay, default 0.86
          inertia_decayFactor: 0.86,
          pan_angleCapX: 15,
          pan_angleCapY: 20,
          // how close can you zoom in.
          zoom_minCap: 3,
          // max that you're able to zoom out.
          zoom_maxCap: 10),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////
  void vOnEachFrameRender(num? frameTimeNano) {
    if (frameTimeNano != null) {}
  }

  ////////////////////////////////////////////////////////////////////////////////
  Playx3dScene poGetPlayx3dScene() {
    return Playx3dScene(
      models: poGetModelList(),
      scene: poGetScene(),
      shapes: poGetScenesShapes(),
      onCreated: (Playx3dSceneController controller) async {
        // we'll save the controller so we can send messages
        // from the UI / 'gameplay' in the future.
        poController = controller;

        // Frames from Native to here, currently run in order of
        // - updateFrame - Called regardless if a frame is going to be drawn or not
        // - preRenderFrame - Called before native <features>, but we know we're going to draw a frame
        // - renderFrame - Called after native <features>, right before drawing a frame
        // - postRenderFrame - Called after we've drawn natively, right after drawing a frame.

        const MethodChannel methodChannel = MethodChannel(viewerChannelName);
        methodChannel.setMethodCallHandler((call) async {
          if (call.method == "renderFrame") {
            // Map<String, dynamic> arguments = call.arguments;

            // double timeSinceLastRenderedSec = arguments['timeSinceLastRenderedSec'];
            // double fps = arguments['fps'];
            // vOnEachFrameRender();
          }
        });

        const MethodChannel methodChannelAnimation =
            MethodChannel(animationChannelName);
        methodChannelAnimation.setMethodCallHandler((call) async {
          // Example:
          /*
            Key: animation_event_data, Value: 1 // m_nCurrentPlayingIndex
            Key: animation_event_type, Value: 1 // AnimationEventType
            // what you would use to call functionality from the controller
            Key: global_guid, Value: 184ee0b0-a280-4976-8eae-0a33083b315b
            Key: animation_event_data, Value: 1 // m_nCurrentPlayingIndex
            Key: animation_event_type, Value: 0 // AnimationEventType
            // what you would use to call functionality from the controller
            Key: global_guid, Value: 184ee0b0-a280-4976-8eae-0a33083b315b
          */

          /* Map<String, dynamic> arguments =
              Map<String, dynamic>.from(call.arguments);

          arguments.forEach((key, value) {
              // Check if the value is a nested map
              if (value is Map<String, dynamic>) {
                print("Key: $key has nested data:");
                value.forEach((nestedKey, nestedValue) {
                  print("    $nestedKey: $nestedValue");
                });
              } else {
                print("Key: $key, Value: $value");
              }
            });*/
        });

        // kCollisionEvent = "collision_event";
        // kCollisionEventType = "collision_event_type";
        // enum CollisionEventType { eFromNonNative, eNativeOnTouchBegin
        // , eNativeOnTouchHeld, eNativeOnTouchEnd };
        const MethodChannel methodChannelCollision =
            MethodChannel(collisionChannelName);
        methodChannelCollision.setMethodCallHandler((call) async {
          Map<String, dynamic> arguments =
              Map<String, dynamic>.from(call.arguments);

          /* arguments.forEach((key, value) {
              // Check if the value is a nested map
              if (value is Map<String, dynamic>) {
                print("Key: $key has nested data:");
                value.forEach((nestedKey, nestedValue) {
                  print("    $nestedKey: $nestedValue");
                });
              } else {
                print("Key: $key, Value: $value");
              }
            }); */

          // only works on first hit, go through all results if you want.
          if (arguments.containsKey("collision_event_hit_result_0")) {
            Map<String, dynamic> hitResult = Map<String, dynamic>.from(
                arguments["collision_event_hit_result_0"]);
            String guid = hitResult["guid"];
            if (thingsWeCanChangeParamsOn.contains(guid)) {
              Map<String, dynamic> ourJson =
                  poGetRandomColorMaterialParam().toJson();
              poController.changeMaterialParameterData(ourJson, guid);
            } else {
              logToStdOut(
                  "Didnt find guid, changing material definition: $guid");
              Map<String, dynamic> ourJson =
                  poGetLitMaterialWithRandomValues().toJson();
              thingsWeCanChangeParamsOn.add(guid);
              poController.changeMaterialDefinitionData(ourJson, guid);
            }
          } else {
            logToStdOut("No hit result found in arguments.");
          }
        });

        logToStdOut('poGetPlayx3dScene onCreated');
        return;
      },
      onModelStateChanged: (state) {
        logToStdOut('poGetPlayx3dScene onModelStateChanged: $state');
        setState(() {
          isModelLoading = state == ModelState.loading;
        });
      },
      onSceneStateChanged: (state) {
        logToStdOut('poGetPlayx3dScene onSceneStateChanged: $state');
        setState(() {
          isSceneLoading = state == SceneState.loading;
        });
      },
      onShapeStateChanged: (state) {
        logToStdOut('poGetPlayx3dScene onShapeStateChanged: $state');
        setState(() {
          isShapeLoading = state == ShapeState.loading;
        });
      },
      onEachRender: vOnEachFrameRender,
    );
  } // end  poGetPlayx3dScene
}
