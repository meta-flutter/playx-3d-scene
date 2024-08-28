import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'package:playx_3d_scene/src/models/scene/geometry/rotation.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

////////////////////////////////////////////////////////////////////////
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);

    // If debugging and curious uncomment.
    // stdout.write('Global error caught exception: ${details.exception}');
    // stdout.write('Global error caught stack: ${details.stack}');
  };

  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    stdout.write('runZonedGuarded error caught error: ${error}');
    stdout.write('runZonedGuarded error caught stack: ${stack}');
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
  bool showloading = true;
  late Playx3dSceneController m_poController;
  Color _DirectLightColor = Colors.purple;
  double _directIntensity = 300000000;
  final double _minIntensity = 10000000;
  final double _maxIntensity = 300000000;
  double _cameraRotation = 0;
  bool _autoRotate = true;
  bool _toggleShapes = true;

  static const String litMat = "assets/materials/lit.filamat";
  static const String texturedMat = "assets/materials/textured_pbr.filamat";
  //static const String foxAsset = "assets/models/Fox.glb";
  //static const String helmetAsset = "assets/models/DamagedHelmet.glb";
  static const String sequoiaAsset = "assets/models/sequoia.glb";
  static const String garageAsset = "assets/models/garagescene.glb";

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
  void _updateIntensityFromText(String text, bool isDirectLight) {
    try {
      int intensity = int.parse(text);
      setState(() {
        if (isDirectLight) {
          m_poController.changeDirectLightValuesByIndex(
              0, _DirectLightColor, intensity);
        } else {
          //m_poController.changeIndirectLightValuesByIndex(1, _IndirectLightColor, intensity);
        }
      });
    } catch (e) {
      // Handle invalid intensity value
    }
  }

  ////////////////////////////////////////////////////////////////////////
  TextStyle getTextStyle() {
    return TextStyle(
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
                    Container(
                      width: 100,
                      child: ColorPicker(
                        colorPickerWidth: 100,
                        pickerColor: _DirectLightColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            _DirectLightColor = color;
                            m_poController.changeDirectLightValuesByIndex(
                                0, _DirectLightColor, _directIntensity.toInt());
                          });
                        },
                        showLabel: false,
                        pickerAreaHeightPercent: 1.0,
                        enableAlpha: false,
                        displayThumbColor: false,
                        portraitOnly: true,
                        paletteType: PaletteType.hueWheel,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
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
                                m_poController.changeDirectLightValuesByIndex(
                                    0,
                                    _DirectLightColor,
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
                        m_poController.setCameraRotation(_cameraRotation / 100);
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _autoRotate = !_autoRotate;
                            m_poController.toggleCameraAutoRotate(_autoRotate);
                          });
                        },
                        child: Text(_autoRotate
                            ? 'Toggle Rotate: On'
                            : 'Toggle Rotate: Off'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _toggleShapes = !_toggleShapes;
                            m_poController.toggleShapesInScene(_toggleShapes);
                          });
                        },
                        child: Text(_toggleShapes
                            ? 'Toggle Shapes: On'
                            : 'Toggle Shapes: Off'),
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
  GlbModel poGetModel(
      String szAsset, double _x, double _y, double _z, double _scale) {
    return GlbModel.asset(
      szAsset,
      //animation: PlayxAnimation.byIndex(0, autoPlay: false),
      //fallback: GlbModel.asset(helmetAsset),
      centerPosition: PlayxPosition(x: _x, y: _y, z: _z),
      scale: _scale,
    );
  }

  ////////////////////////////////////////////////////////////////////////
  Scene poGetScene() {
    return Scene(
      skybox: ColoredSkybox(color: Colors.black),
      //skybox: HdrSkybox.asset("assets/envs/courtyard.hdr"),
      indirectLight: HdrIndirectLight.asset("assets/envs/courtyard.hdr"),
      //skybox: ColoredSkybox(color: Colors.red),
      // indirectLight: DefaultIndirectLight(
      //     intensity: 1000000, // indirect light intensity.
      //     radianceBands: 1, // Number of spherical harmonics bands.
      //     radianceSh: [
      //       1,
      //       1,
      //       1
      //     ], // Array containing the spherical harmonics coefficients.
      //     irradianceBands: 1, // Number of spherical harmonics bands.
      //     irradianceSh: [
      //       1,
      //       1,
      //       1
      //     ] // Array containing the spherical harmonics coefficients.
      //     ),

      // Note point lights seem to only value intensity at a high
      // range 30000000, for a 3 meter diameter of a circle, not caring about
      // falloffradius
      //
      // Note for Spot lights you must specify a direction != 0,0,0
      light: Light(
          type: LightType.point,
          colorTemperature: 36500,
          color: _DirectLightColor,
          intensity: _directIntensity,
          castShadows: false,
          castLight: true,
          spotLightConeInner: 1,
          spotLightConeOuter: 10,
          falloffRadius: 300.1, // what base is this in? meters?
          position: PlayxPosition(x: 0, y: 3, z: 0),
          // should be a unit vector
          direction: PlayxDirection(x: 0, y: 1, z: 0)),
      camera: Camera.freeFlight(
        exposure: Exposure.formAperture(
          aperture: 24.0,
          shutterSpeed: 1 / 60,
          sensitivity: 150,
        ),
        targetPosition: PlayxPosition(x: 0.0, y: 0.0, z: 0.0),
        upVector: PlayxPosition(x: 0.0, y: 1.0, z: 0.0),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  PlayxMaterial poGetBaseMaterial(Color? colorOveride) {
    return PlayxMaterial.asset(
      litMat,
      //usually the material file contains values for these properties,
      //but if we want to customize it we can like that.
      parameters: [
        //update base color property with color
        MaterialParameter.color(
            color: colorOveride != null ? colorOveride : Colors.white,
            name: "baseColor"),
        //update roughness property with it's value
        MaterialParameter.float(value: .8, name: "roughness"),
        //update metallicproperty with it's value
        MaterialParameter.float(value: .0, name: "metallic"),
      ],
    );
  }

  ////////////////////////////////////////////////////////////////////////
  Color getTrueRandomColor() {
    Random random = Random();

    // Generate random values for red, green, and blue channels
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    // Create and return a Color object
    return Color.fromARGB(255, red, green, blue);
  }

  ////////////////////////////////////////////////////////////////////////////////
  Color getRandomPresetColor() {
    // List of preset colors from the Flutter Material color palette
    List<Color> presetColors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    // Create a random instance
    Random random = Random();

    // Select a random color from the list
    return presetColors[random.nextInt(presetColors.length)];
  }

  ////////////////////////////////////////////////////////////////////////////////
  PlayxMaterial poGetBaseMaterialWithRandomValues() {
    Random random = Random();

    return PlayxMaterial.asset(
      litMat,
      //usually the material file contains values for these properties,
      //but if we want to customize it we can like that.
      parameters: [
        //update base color property with color
        MaterialParameter.color(
            color: getRandomPresetColor(), name: "baseColor"),
        //update roughness property with it's value
        MaterialParameter.float(value: random.nextDouble(), name: "roughness"),
        //update metallicproperty with it's value
        MaterialParameter.float(value: random.nextDouble(), name: "metallic"),
      ],
    );
  }

  //   return PlayxMaterial.asset(texturedMat,
  //       parameters: [
  //         MaterialParameter.texture(
  //           value: PlayxTexture.asset(
  //             "assets/materials/texture/floor_basecolor.png",
  //             type: TextureType.color,
  //             sampler: PlayxTextureSampler(anisotropy: 8),
  //           ),
  //           name: "baseColor",
  //         ),
  //         MaterialParameter.texture(
  //           value: PlayxTexture.asset(
  //             "assets/materials/texture/floor_normal.png",
  //             type: TextureType.normal,
  //             sampler: PlayxTextureSampler(anisotropy: 8),
  //           ),
  //           name: "normal",
  //         ),
  //         MaterialParameter.texture(
  //           value: PlayxTexture.asset(
  //             "assets/materials/texture/floor_ao_roughness_metallic.png",
  //             type: TextureType.data,
  //             sampler: PlayxTextureSampler(anisotropy: 8),
  //           ),
  //           name: "aoRoughnessMetallic",
  //         ),
  //       ]);
  // }

  ////////////////////////////////////////////////////////////////////////////////
  Shape poCreateCube(PlayxPosition pos, PlayxSize scale, PlayxSize sizeExtents,
      int idToSet, Color? colorOveride) {
    return Cube(
      id: idToSet,
      size: sizeExtents,
      centerPosition: pos,
      scale: scale,
      //material: poGetBaseMaterial(),
      material: colorOveride != null
          ? poGetBaseMaterial(colorOveride)
          : poGetBaseMaterialWithRandomValues(),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////
  Shape poCreateSphere(
      PlayxPosition pos,
      PlayxSize scale,
      PlayxSize sizeExtents,
      int idToSet,
      int stacks,
      int slices,
      Color? colorOveride) {
    return Sphere(
        id: idToSet,
        centerPosition: pos,
        material: poGetBaseMaterial(null),
        stacks: stacks,
        slices: slices,
        cullingEnabled: false,
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
        centerPosition: pos,
        rotation: PlayxRotation(x: .7071, y: .7071, z: 0, w: 0),
        material: poGetBaseMaterialWithRandomValues());
  }

  ////////////////////////////////////////////////////////////////////////////////
  List<Shape> poCreateLineGrid() {
    List<Shape> itemsToReturn = [];
    int idIter = 40;
    for (double i = -10; i <= 10; i += 2) {
      for (int j = 0; j < 1; j++) {
        for (double k = -10; k <= 10; k += 2) {
          itemsToReturn.add(poCreateCube(
              PlayxPosition(x: i, y: 0, z: k),
              PlayxSize(x: 1, y: 1, z: 1),
              PlayxSize(x: 1, y: 1, z: 1),
              idIter++,
              Colors.red));
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
        PlayxSize(x: 1, y: 1, z: 1),
        PlayxSize(x: 1, y: 1, z: 1),
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
        PlayxSize(x: 1, y: 1, z: 1),
        PlayxSize(x: 2, y: 1, z: 2),
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
    //itemsToReturn.add(poGetModel(foxAsset, 0,0,-14.77, .1));
    //itemsToReturn.add(poGetModel(sequoiaAsset, 0, 0, -14.77, 1));
    itemsToReturn.add(poGetModel(garageAsset, 0, 0, -16, 1));
    //itemsToReturn.add(poGetModel(helmetAsset, 5,0,0, .1));
    return itemsToReturn;
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
        m_poController = controller;

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
