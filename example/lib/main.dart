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
  bool _autoRotate = true;
  bool _toggleShapes = true;
  bool _toggleCollidableVisuals = true;

  static const String viewerChannelName = "plugin.filament_view.frame_view";
  static const String collisionChannelName =
      "plugin.filament_view.collision_info";

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
                            poController.toggleCameraAutoRotate(_autoRotate);
                          });
                        },
                        child: Text(_autoRotate
                            ? 'Toggle Rotate: On'
                            : 'Toggle Rotate: Off'),
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
        flightStartPosition: PlayxPosition(x: 0.0, y: 1.0, z: 5.0),
      ),
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

        // kCollisionEvent = "collision_event";
        // kCollisionEventType = "collision_event_type";
        // enum CollisionEventType { eFromNonNative, eNativeOnTouchBegin
        // , eNativeOnTouchHeld, eNativeOnTouchEnd };
        const MethodChannel methodChannelCollision =
            MethodChannel(collisionChannelName);
        methodChannelCollision.setMethodCallHandler((call) async {
          if (call.method == "collision_event") {
            // Map<String, dynamic> arguments = call.arguments;
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
