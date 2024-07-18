import 'package:flutter/material.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'dart:math';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // Your error handling logic goes here
    FlutterError.presentError(details);

    stdout.write('Global error caught exception: ${details.exception}');
    stdout.write('Global error caught stack: ${details.stack}');
    //stdout.flush();
    // You can also log the stack trace if needed: details.stack
  };

  // const appt = MyApp();
  // runApp(appt);

  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    // Log or handle the error

    stdout.write('runZonedGuarded error caught error: ${error}');
    stdout.write('runZonedGuarded error caught stack: ${stack}');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Your drawing code here
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0;

    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Return true if you want to repaint when setState is called
    return true;
  }
}

class _MyAppState extends State<MyApp> {
  bool isModelLoading = false;
  bool isSceneLoading = false;
  bool isShapeLoading = false;
  bool showloading = true;
  late Playx3dSceneController controller;

  // orig
  String litMat = "assets/materials/lit.filamat";
  String texturedMat = "assets/materials/textured_pbr.filamat";

  // nonorig
  //String litMat = "assets/materials/lit.filamat";
  //String texturedMat = "assets/materials/lit.filamat";

  @override
  void initState() {
    //log('Allen initstate 1 ');
    logToStdOutAndFlush('InitState');

    super.initState();

    // const oneSec = Duration(seconds: 1);
    // const fiveSec = Duration(seconds: 5);
    // Timer.periodic(
    //   oneSec,
    //   (Timer t) {
    //     logToStdOutAndFlush('Duration Hit');

    //     // will trigger a full rebuild, but doesnt draw
    //     // setState(() {});
    //   },
    // );

    // Timer.periodic(
    //   fiveSec,
    //   (Timer t) {
    //     showloading = false;

    //     // triggers rebuild
    //     // setState(() {});
    //   },
    // );
  }

  void logToStdOutAndFlush(String strOut) {
    DateTime now = DateTime.now();
    stdout.write('ALLEN DART : $strOut: $now\n');
    //stdout.flush();
  }

  @override
  Widget build(BuildContext context) {
    logToStdOutAndFlush('building Widget');

    return MaterialApp(
      home: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Action to perform when the button is pressed
        //     //stdout.write('button pressed');
        //     setState(() {});

        //     //reassemble();

        //     //_updatePlayxScene();
        //     //_updateWidget(null);
        //   },
        //   //tooltip: 'Increment', // Tooltip text when long pressed
        //   child: Icon(Icons.add), // Icon to display
        // ),

        backgroundColor: Colors.black.withOpacity(0.0),

        // body: Stack(
        //   children: [
        //     CustomPaint(
        //       painter: MyCustomPainter(),
        //       child: Container(), // Container to set the size of the canvas
        //     ),
        //     poGetPlayx3dScene(),
        //   ],
        // ),

        // body: Stack(
        //   children: [
        //     showloading
        //         ? const Center(
        //             child: CircularProgressIndicator(
        //               color: Colors.pink,
        //             ),
        //           )
        //         : Container(),
        //     poGetPlayx3dScene(),
        //   ],
        // ),

        body: Stack(
          children: [
            poGetPlayx3dScene(),
          ],
        ),

        //body: poGetPlayx3dScene(),
      ),
    );
  }

  static const String foxAsset = "assets/models/Fox.glb";
  static const String helmetAsset = "assets/models/DamagedHelmet.glb";
  static const String sequoiaAsset = "assets/models/sequoia.glb";
  static const String garageAsset = "assets/models/garagescene.glb";

  GlbModel poGetModel(String szAsset, double _x, double _y, double _z, double _scale) {
    
    return GlbModel.asset(
      szAsset,
      //animation: PlayxAnimation.byIndex(0, autoPlay: false),
      //fallback: GlbModel.asset(helmetAsset),
      centerPosition: PlayxPosition(x: _x, y: _y, z: _z),
      scale: _scale,
    );
  }

  Scene poGetScene() {
    return Scene(
      //skybox: HdrSkybox.asset("assets/envs/courtyard.hdr"),
      //indirectLight: HdrIndirectLight.asset("assets/envs/courtyard.hdr"),
      // skybox: ColoredSkybox(color: Colors.white),
      // indirectLight: DefaultIndirectLight(
      //     intensity: 30000, // indirect light intensity.
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
      light: Light(
          type: LightType.directional,
          colorTemperature: 6500,
          intensity: 15000,
          castShadows: false,
          castLight: true,
          position: PlayxPosition(x: 0, y: 3, z: 0),
          direction: PlayxDirection(x: 0, y: -1, z: 0)),
      //ground: poGetGround(),      
      camera: Camera.freeFlight(
        exposure: Exposure.formAperture(
          aperture: 16.0,
          shutterSpeed: 1 / 60,
          sensitivity: 150,
        ),
        targetPosition: PlayxPosition(x: 0.0, y: 0.0, z: 0.0),
        //orbitHomePosition: PlayxPosition(x: 0.0, y: 1.0, z: 1.0),
        upVector: PlayxPosition(x: 0.0, y: 1.0, z: 0.0),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  Ground poGetGround()
  {
    return Ground(
        width: 30.0,
        height: 30.0,
        isBelowModel: true,
        normal: PlayxDirection.y(1.0),
        material: PlayxMaterial.asset(
          texturedMat,
          parameters: [
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
          ],
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
        MaterialParameter.color(color: colorOveride != null ? colorOveride: Colors.white, name: "baseColor"),
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
        MaterialParameter.color(color: getRandomPresetColor(), name: "baseColor"),
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
  Shape poCreateCube(double _x, double _y, double _z, int idToSet,
  double _extentsX, double _extentsY, double _extentsZ, Color? colorOveride) {
    return Cube(
      id: idToSet,
      size: PlayxSize(x: _extentsX, y: _extentsY, z: _extentsZ),
      centerPosition: PlayxPosition(x: _x, y: _y, z: _z),
      //material: poGetBaseMaterial(),
      material: colorOveride != null ? poGetBaseMaterial(colorOveride) : poGetBaseMaterialWithRandomValues(),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////
  Shape poCreateShere(double _x, double _y, double _z, int idToSet) {
    return Sphere(
      id: idToSet,
      radius: 1,
      centerPosition: PlayxPosition(x: _x, y: _y, z: _z),
      material: poGetBaseMaterial(null),
    );
  }

  List<Shape> poCreateLineGrid() {
    List<Shape> itemsToReturn = [];
    int idIter = 20;
    for (double i = -10; i <= 10; i+=2) {
      for (int j = 0; j < 1; j++) {
        for (double k = -10; k <= 10; k += 2) {
          itemsToReturn.add(poCreateCube( i 
          , 0
          , k 
          , idIter++,
          .1,
          .1,
          .1
          , Colors.red));
        }
      }
    }

    return itemsToReturn;
  }

  ////////////////////////////////////////////////////////////////////////////////
  List<Shape> poGetScenesShapes() {
    //return poCreateLineGrid();

    List<Shape> itemsToReturn = [];
    itemsToReturn.add(poCreateCube(0,0,0,0,0,0,0, null));
    return itemsToReturn;

    // Random random = Random();

    // List<Shape> itemsToReturn = [];
    // const int numMulti = 5;
    // int idIter = 10;
    // for (int i = 0; i < numMulti; i++) {
    //   for (int j = 0; j < numMulti; j++) {
    //     for (int k = 0; k < numMulti; k++) {
    //       itemsToReturn.add(poCreateCube( (i * numMulti) - ((numMulti * numMulti ) / 2)
    //       , k * 5
    //       , (j * numMulti) - ((numMulti * numMulti ) / 2)
    //       , idIter++,
    //       1,
    //       1,
    //       1));
    //     }
    //   }
    // }

    //return itemsToReturn;
  }

  ////////////////////////////////////////////////////////////////////////////////
  List<Model> poGetModelList() {
    List<Model> itemsToReturn = [];
    itemsToReturn.add(poGetModel(sequoiaAsset, 0,0,-14.77, 1));
    itemsToReturn.add(poGetModel(garageAsset, 0,0,-16, 1));
    //itemsToReturn.add(poGetModel(foxAsset, -5,0,0, .01));
    //itemsToReturn.add(poGetModel(helmetAsset, 5,0,0, .1));
    return itemsToReturn;
  }

  ////////////////////////////////////////////////////////////////////////////////
  void vOnEachFrameRender(num? frameTimeNano) {
    //logToStdOutAndFlush('vOnEachFrameRender');
    //stdout.flush();

    if (frameTimeNano != null) {
      // log('Frame time: $frameTimeNano');
    }
  }

  Playx3dScene poGetPlayx3dScene() {
    return Playx3dScene(
      models: poGetModelList(),
      scene: poGetScene(),
      shapes: poGetScenesShapes(),
      // shapes: [
      //           Cube(
      //             id: 1,
      //             length: .5,
      //             centerPosition: PlayxPosition(x: -3, y: 0, z: 0),
      //             material: PlayxMaterial.asset(
      //               "assets/materials/textured_pbr.filamat",
      //               parameters: [
      //                 MaterialParameter.texture(
      //                   value: PlayxTexture.asset(
      //                     "assets/materials/texture/floor_basecolor.png",
      //                     type: TextureType.color,
      //                     sampler: PlayxTextureSampler(anisotropy: 8),
      //                   ),
      //                   name: "baseColor",
      //                 ),
      //                 MaterialParameter.texture(
      //                   value: PlayxTexture.asset(
      //                     "assets/materials/texture/floor_normal.png",
      //                     type: TextureType.normal,
      //                     sampler: PlayxTextureSampler(anisotropy: 8),
      //                   ),
      //                   name: "normal",
      //                 ),
      //                 MaterialParameter.texture(
      //                   value: PlayxTexture.asset(
      //                     "assets/materials/texture/floor_ao_roughness_metallic.png",
      //                     type: TextureType.data,
      //                     sampler: PlayxTextureSampler(anisotropy: 8),
      //                   ),
      //                   name: "aoRoughnessMetallic",
      //                 ),
      //               ],
      //             ),
      //           ),
      //           Sphere(
      //             id: 2,
      //             centerPosition: PlayxPosition(x: 3, y: 0, z: 0),
      //             radius: .5,
      //             material: PlayxMaterial.asset(
      //               "assets/materials/textured_pbr.filamat",
      //               parameters: [
      //                 MaterialParameter.texture(
      //                   value: PlayxTexture.asset(
      //                     "assets/materials/texture/floor_basecolor.png",
      //                     type: TextureType.color,
      //                     sampler: PlayxTextureSampler(anisotropy: 8),
      //                   ),
      //                   name: "baseColor",
      //                 ),
      //                 MaterialParameter.texture(
      //                   value: PlayxTexture.asset(
      //                     "assets/materials/texture/floor_normal.png",
      //                     type: TextureType.normal,
      //                     sampler: PlayxTextureSampler(anisotropy: 8),
      //                   ),
      //                   name: "normal",
      //                 ),
      //                 MaterialParameter.texture(
      //                   value: PlayxTexture.asset(
      //                     "assets/materials/texture/floor_ao_roughness_metallic.png",
      //                     type: TextureType.data,
      //                     sampler: PlayxTextureSampler(anisotropy: 8),
      //                   ),
      //                   name: "aoRoughnessMetallic",
      //                 ),
      //               ],
      //             ),
      //           ),
      // ],
      onCreated: (Playx3dSceneController controller) async {
        logToStdOutAndFlush('poGetPlayx3dScene onCreated');
        //controller.updateScene();
        return;
        Future.delayed(const Duration(seconds: 5), () async {
          Result<int?> result = await controller.changeAnimationByIndex(1);

          logToStdOutAndFlush(
              'poGetPlayx3dScene result: $isModelLoading : $isSceneLoading : $isSceneLoading');

          if (result.isSuccess()) {
            final data = result.data;
            logToStdOutAndFlush("success :$data");
          } else {
            logToStdOutAndFlush('else message :$result.message');
          }
        });
      },
      onModelStateChanged: (state) {
        logToStdOutAndFlush('poGetPlayx3dScene onModelStateChanged: $state');
        setState(() {
          isModelLoading = state == ModelState.loading;
        });
      },
      onSceneStateChanged: (state) {
        logToStdOutAndFlush('poGetPlayx3dScene onSceneStateChanged: $state');

        //print('Playx3dSceneController: onSceneStateChanged: $state');
        setState(() {
          isSceneLoading = state == SceneState.loading;
        });
      },
      onShapeStateChanged: (state) {
        logToStdOutAndFlush('poGetPlayx3dScene onShapeStateChanged: $state');

        //print('Playx3dSceneController: onShapeStateChanged: $state');
        setState(() {
          isShapeLoading = state == ShapeState.loading;
        });
      },
      onEachRender: vOnEachFrameRender,
    );
  } // end  poGetPlayx3dScene
}
