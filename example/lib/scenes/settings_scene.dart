
import 'dart:math';

import 'package:flutter/material.dart' hide Material;
import 'package:my_fox_example/assets.dart';
import 'package:my_fox_example/demo_widgets.dart';
import 'package:my_fox_example/material_helpers.dart';
import 'package:my_fox_example/messages.g.dart';
import 'package:my_fox_example/scenes/scene_view.dart';
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
  });

  @override
  _SettingsSceneViewState createState() => _SettingsSceneViewState();

  static final Map<String, String> objectGuids = {
    'car': uuid.v4(),
  };

  static List<Model> getSceneModels() {
    final List<Model> models = [];

    models.add(GlbModel.asset(
      sequoiaAsset,
      centerPosition: Vector3.only(x: 72, y: 0, z: 68),
      scale: Vector3.only(x: 1, y: 1, z: 1),
      rotation: Vector4(x: 0, y: 0, z: 0, w: 1),
      collidable: Collidable(isStatic: false, shouldMatchAttachedObject: true),
      animation: null,
      receiveShadows: true,
      castShadows: true,
      guid: objectGuids['car']!,
      keepInMemory: true,
      isInstancePrimary: false,
    ));

    return models;
  }

  static List<Shape> getSceneShapes() {
    final List<Shape> shapes = [];

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
    widget.filament.changeCameraOrbitHomePosition(64,4,64);
    widget.filament.changeCameraTargetPosition(72,0,68);
    widget.filament.changeCameraFlightStartPosition(64, 4, 68);

    _animationController = BottomSheet.createAnimationController(
      this,
    );
  }

  @override
  void onUpdateFrame(FilamentViewApi filament, double dt) {

  }

  @override
  void onTriggerEvent(String eventName) {

  }

  @override
  void onDestroy() {

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

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    // If settings hidden, show large invisible button to show settings
    if(!_showSettings) {
      widget.filament.changeCameraMode("AUTO_ORBIT");
    } else {
      widget.filament.changeCameraMode("INERTIA_AND_GESTURES");
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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                ),
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
}