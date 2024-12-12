import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'dart:async';
import 'dart:io';
import 'shape_and_object_creators.dart';
import 'demo_user_interface.dart';
import 'events/animation_event_channel.dart';
import 'events/frame_event_channel.dart';
import 'events/collision_event_channel.dart';
import 'events/native_readiness.dart';
import 'messages.g.dart';

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
  final AnimationEventChannel _animEventChannel = AnimationEventChannel();
  final CollisionEventChannel _collisionEventChannel = CollisionEventChannel();
  final FrameEventChannel _frameEventChannel = FrameEventChannel();

  late Playx3dSceneController poController;
  // actually a point light
  Color _directLightColor = Colors.white;
  double _directIntensity = 300000000;
  final double _minIntensity = 500000;
  final double _maxIntensity = 300000000;
  double _cameraRotation = 0;
  bool _autoRotate = false;
  bool _toggleShapes = true;
  bool _toggleCollidableVisuals = true;

  final NativeReadiness _nativeReadiness = NativeReadiness();
  bool isReady = false;

  final filamentViewApi = FilamentViewApi();

  ////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    initializeReadiness();
  }

  Future<void> initializeReadiness() async {
    const int maxRetries = 30; // Maximum number of retries
    const Duration retryInterval =
        Duration(seconds: 1); // Interval between retries

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        logToStdOut('Checking native readiness, attempt $attempt...');
        final bool nativeReady = await _nativeReadiness.isNativeReady();

        if (nativeReady) {
          logToStdOut('Native is ready. Proceeding...');
          startListeningForEvents(); // Start listening for readiness events

          return; // Exit the function if ready
        } else {
          logToStdOut('Native is not ready. Retrying...');
        }
      } catch (e) {
        logToStdOut('Error checking readiness: $e');
      }

      // Wait before the next retry
      await Future.delayed(retryInterval);
    }

    // If we exhaust retries, log a message or take fallback action
    logToStdOut(
        'Failed to confirm native readiness after $maxRetries attempts.');
  }

  void startListeningForEvents() {
    _nativeReadiness.readinessStream.listen(
      (event) {
        if (event == "ready") {
          logToStdOut('Received ready event from native side.');
          setState(() {
            logToStdOut('Creating Event Channels');
            _animEventChannel.initEventChannel();
            _collisionEventChannel.initEventChannel();
            _frameEventChannel.initEventChannel();
            logToStdOut('Event Channels created.');

            isReady = true;
          });
        }
      },
      onError: (error) {
        logToStdOut('Error listening for readiness events: $error');
      },
    );
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
                            final String colorString =
                                '#${_directLightColor.value.toRadixString(16).padLeft(8, '0')}';

                            filamentViewApi.changeLightColorByGUID(
                                centerPointLightGUID,
                                colorString,
                                _directIntensity.toInt());
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

                                final String colorString =
                                    '#${_directLightColor.value.toRadixString(16).padLeft(8, '0')}';

                                filamentViewApi.changeLightColorByGUID(
                                    centerPointLightGUID,
                                    colorString,
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
                        filamentViewApi
                            .setCameraRotation(_cameraRotation / 100);
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

                            if (_autoRotate) {
                              filamentViewApi.changeCameraMode("AUTO_ORBIT");
                            } else {
                              filamentViewApi
                                  .changeCameraMode("INERTIA_AND_GESTURES");
                            }
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
                            filamentViewApi.resetInertiaCameraToDefaultValues();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _toggleShapes = !_toggleShapes;
                            filamentViewApi.toggleShapesInScene(_toggleShapes);
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
                            filamentViewApi.toggleDebugCollidableViewsInScene(
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
                            filamentViewApi.changeViewQualitySettings();
                          });
                        },
                        child: const Text('Qual'),
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
      lights: poGetSceneLightsList(),
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
  //bool hasInit = false;
  Playx3dScene poGetPlayx3dScene() {
    return Playx3dScene(
        models: poGetModelList(),
        scene: poGetScene(),
        shapes: poGetScenesShapes(),
        onCreated: (Playx3dSceneController controller) async {
          logToStdOut('poGetPlayx3dScene onCreated');

          // we'll save the controller so we can send messages
          // from the UI / 'gameplay' in the future.
          poController = controller;

          _frameEventChannel.setController(filamentViewApi);
          _collisionEventChannel.setController(filamentViewApi);

          logToStdOut('poGetPlayx3dScene onCreated completed');
          return;
        });
  } // end  poGetPlayx3dScene
}
