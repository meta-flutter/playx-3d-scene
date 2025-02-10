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
import 'gameplay.dart';

// Rebuilding materials to match filament versions.
// playx-3d-scene/example/assets/materials$
// /home/tcna/dev/workspace-automation/app/filament/cmake-build-release/staging/release/bin/matc -a vulkan -o lit.filamat raw/lit.mat
// playx-3d-scene/example/assets/materials$
// /home/tcna/dev/workspace-automation/app/filament/cmake-build-release/staging/release/bin/matc -a vulkan -o textured_pbr.filamat raw/textured_pbr.mat

////////////////////////////////////////////////////////////////////////
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded<Future<void>>(() async {
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    stdout.write('runZonedGuarded error caught error: $error\n$stack');
  });
}

////////////////////////////////////////////////////////////////////////
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

////////////////////////////////////////////////////////////////////////
class _MyAppState extends State<MyApp> {
  ////////////////////////////////////////////////////////////////////////
  // Event channels
  final AnimationEventChannel _animEventChannel = AnimationEventChannel();
  final CollisionEventChannel _collisionEventChannel = CollisionEventChannel();
  final FrameEventChannel _frameEventChannel = FrameEventChannel();

  late SceneController poController;

  // Point light controls
  Color _directLightColor = Colors.white;
  double _directIntensity = 300000000;
  final double _minIntensity = 500000;
  final double _maxIntensity = 300000000;

  // Camera controls
  double _cameraRotation = 0;
  bool _autoRotate = false;
  bool _toggleShapes = true;
  bool _toggleCollidableVisuals = true;

  final NativeReadiness _nativeReadiness = NativeReadiness();
  bool isReady = false;

  final filamentViewApi = FilamentViewApi();

  // 0 = original UI scene, 1 = alternate UI scene
  int _currentScene = 0;

  // ------------------------------------------------------------------------
  //  field to store the scene widget so it's created only once
  late final SceneView _sceneWidget;
  // ------------------------------------------------------------------------

  ////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------------------
    _sceneWidget = poGetPlayx3dScene();
    // ------------------------------------------------------------------------

    initializeReadiness();
  }

  ////////////////////////////////////////////////////////////////////////
  Future<void> initializeReadiness() async {
    const int maxRetries = 30;
    const Duration retryInterval = Duration(seconds: 1);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('Checking native readiness, attempt $attempt...');
        final bool nativeReady = await _nativeReadiness.isNativeReady();

        if (nativeReady) {
          print('Native is ready. Proceeding...');
          startListeningForEvents();
          return;
        } else {
          print('Native is not ready. Retrying...');
        }
      } catch (e) {
        print('Error checking readiness: $e');
      }

      await Future.delayed(retryInterval);
    }

    print(
        'Failed to confirm native readiness after $maxRetries attempts.');
  }

  ////////////////////////////////////////////////////////////////////////
  void startListeningForEvents() {
    _nativeReadiness.readinessStream.listen(
      (event) {
        if (event == "ready") {
          print('Received ready event from native side.');
          setState(() {
            print('Creating Event Channels');
            _animEventChannel.initEventChannel();
            _collisionEventChannel.initEventChannel();
            _frameEventChannel.initEventChannel();
            print('Event Channels created.');
            isReady = true;
          });
        }
      },
      onError: (error) {
        print('Error listening for readiness events: $error');
      },
    );
  }
  
  ////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.0),
        body: Stack(
          children: [
            _sceneWidget,

            // A button at the top-right to switch scenes
            Positioned(
              top: 50,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Toggle between scene 0 and scene 1
                    _currentScene = (_currentScene + 1) % 2;
                  });
                },
                child: Text(
                  _currentScene == 0
                      ? 'Show Radar Scene'
                      : 'Show Original Scene',
                ),
              ),
            ),

            // Bottom-left: build whichever UI belongs to the current scene
            Positioned(
              bottom: 50,
              left: 20,
              // Right is not strictly needed, but you can set right: 20 if desired
              child: _buildUIForScene(_currentScene),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  Widget _buildUIForScene(int sceneIndex) {
    switch (sceneIndex) {
      case 0:
        filamentViewApi.changeCameraOrbitHomePosition(8, 3, 0);
        filamentViewApi.changeCameraTargetPosition(0, 0, 0);
        filamentViewApi.changeCameraFlightStartPosition(8, 3, 8);

        return _buildSceneZeroUI();
      case 1:
        filamentViewApi.changeCameraOrbitHomePosition(-40, 5, 0);
        filamentViewApi.changeCameraTargetPosition(-45, 0, 0);
        filamentViewApi.changeCameraFlightStartPosition(-25, 15, 0);

        return _buildSceneOneUI();
      default:
        return const SizedBox.shrink();
    }
  }

  ////////////////////////////////////////////////////////////////////////
  Widget _buildSceneZeroUI() {
    return Column(
      // Force left justification in the column
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // -- DIRECT LIGHT CONTROLS --
        Text('Direct Light', style: getTextStyle()),
        const SizedBox(height: 8),
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
                  _directIntensity.toInt(),
                );
              });
            },
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      _directIntensity.toInt(),
                    );
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // -- CAMERA ROTATION SLIDER --
        Text('Camera Rotation', style: getTextStyle()),
        Slider(
          value: _cameraRotation,
          min: 0,
          max: 600,
          onChanged: (double value) {
            setState(() {
              _cameraRotation = value;
              filamentViewApi.setCameraRotation(_cameraRotation / 100);
            });
          },
        ),

        const SizedBox(height: 20),

        // -- ORIGINAL BUTTONS ROW --
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _buildSceneZeroUIButtons(),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////////////////
  Widget _buildSceneOneUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildSceneOneUIButtons(),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  List<Widget> _buildSceneZeroUIButtons() {
    return [
      ElevatedButton(
        onPressed: () {
          setState(() {
            _autoRotate = !_autoRotate;
            if (_autoRotate) {
              filamentViewApi.changeCameraMode("AUTO_ORBIT");
            } else {
              filamentViewApi.changeCameraMode("INERTIA_AND_GESTURES");
            }
          });
        },
        child: Text(
          _autoRotate ? 'Auto Orbit On' : 'Inertia & Gestures On',
        ),
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
        child: Text(
          _toggleShapes ? 'Toggle Shapes: On' : 'Toggle Shapes: Off',
        ),
      ),
      const SizedBox(width: 20),
      ElevatedButton(
        onPressed: () {
          setState(() {
            filamentViewApi.toggleDebugCollidableViewsInScene(
              _toggleCollidableVisuals,
            );
            _toggleCollidableVisuals = !_toggleCollidableVisuals;
          });
        },
        child: Text(
          _toggleCollidableVisuals
              ? 'Toggle Collidables: On'
              : 'Toggle Collidables: Off',
        ),
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
    ];
  }

  ////////////////////////////////////////////////////////////////////////
  List<Widget> _buildSceneOneUIButtons() {
    return [
      ElevatedButton(
        onPressed: () {
          setState(() {
            vDoOneWaveSegment(filamentViewApi);
          });
        },
        child: const Text('Send Single Line out'),
      ),
      const SizedBox(width: 5),
      ElevatedButton(
        onPressed: () {
          setState(() {
            vDo3RadarWaveSegments(filamentViewApi);
          });
        },
        child: const Text('Send Wave Out'),
      ),
      // Add more alternate buttons if needed
    ];
  }

  ////////////////////////////////////////////////////////////////////////
  Scene poGetScene() {
    return Scene(
      skybox: ColoredSkybox(color: Colors.black),
      //skybox: HdrSkybox.asset("assets/envs/courtyard.hdr"),
      indirectLight: HdrIndirectLight.asset("assets/envs/courtyard.hdr"),
      //indirectLight: poGetDefaultIndirectLight(),
      lights: poGetSceneLightsList(),

      camera: Camera.inertiaAndGestures(
          exposure: Exposure.formAperture(
            aperture: 24.0,
            shutterSpeed: 1 / 60,
            sensitivity: 150,
          ),

          /*orbitHomePosition: Position.only(x: -40, y: 5, z: 0),
          targetPosition: Position.only(x: -50.0, y: 0.0, z: 0.0),
          // This is used as your extents when orbiting around an object
          // when the camera is set to inertiaAndGestures
          flightStartPosition: Position.only(x: -25.0, y: 15.0, z: 0),
*/
          orbitHomePosition: Position.only(x: 0, y: 3.0, z: 0),
          targetPosition: Position.only(x: 0.0, y: 0.0, z: 0.0),
          // This is used as your extents when orbiting around an object
          // when the camera is set to inertiaAndGestures
          flightStartPosition: Position.only(x: 8.0, y: 3.0, z: 8.0),
          upVector: Position.only(x: 0.0, y: 1.0, z: 0.0),
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

  ////////////////////////////////////////////////////////////////////////
  SceneView poGetPlayx3dScene() {
    return SceneView(
      models: poGetModelList(),
      scene: poGetScene(),
      shapes: poGetScenesShapes(),
      onCreated: (SceneController controller) async {
        print('poGetPlayx3dScene onCreated');

        poController = controller;

        _frameEventChannel.setController(filamentViewApi);
        _collisionEventChannel.setController(filamentViewApi);

        print('poGetPlayx3dScene onCreated completed');
      },
    );
  }
}
