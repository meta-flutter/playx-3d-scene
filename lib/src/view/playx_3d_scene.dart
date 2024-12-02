import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:playx_3d_scene/src/controller/playx_3d_scene_controller.dart';
import 'package:playx_3d_scene/src/models/model/model.dart';
import 'package:playx_3d_scene/src/models/scene/camera/camera.dart';
import 'package:playx_3d_scene/src/models/scene/ground.dart';
import 'package:playx_3d_scene/src/models/scene/indirect_light/indirect_light.dart';
import 'package:playx_3d_scene/src/models/scene/light/light.dart';
import 'package:playx_3d_scene/src/models/scene/scene.dart';
import 'package:playx_3d_scene/src/models/scene/skybox/skybox.dart';
import 'package:playx_3d_scene/src/models/shapes/cube.dart';
import 'package:playx_3d_scene/src/models/shapes/plane.dart';
import 'package:playx_3d_scene/src/models/shapes/shape.dart';
import 'package:playx_3d_scene/src/models/shapes/sphere.dart';
import 'package:playx_3d_scene/src/models/state/model_state.dart';
import 'package:playx_3d_scene/src/models/state/scene_state.dart';
import 'package:playx_3d_scene/src/models/state/shape_state.dart';

typedef Playx3dSceneCreatedCallback = void Function(
    Playx3dSceneController controller);
const String _channelName = "io.sourcya.playx.3d.scene.channel";
const String _viewType = "${_channelName}_3d_scene";

class Playx3dScene extends StatefulWidget {
  /// Model to be rendered.
  /// provide details about the model to be rendered.
  /// like asset path, url, animation, etc.
  final List<Model>? models;

  /// Scene to be rendered.
  /// provide details about the scene to be rendered.
  /// like skybox, light, camera, etc.
  /// Default scene is a transparent [Skybox] with default [Light] and default [IndirectLight]
  /// with default [Camera] and no [Ground]
  final Scene? scene;

  /// List of shapes to be rendered.
  /// could be plane cube or sphere.
  /// each shape will be rendered with its own position size and material.
  /// See also:
  /// [Shape]
  /// [Cube]
  /// [Sphere]
  /// [Plane]
  final List<Shape>? shapes;

  /// onCreated callback provides an object of [Playx3dSceneController] when the native view is created.
  /// This controller provides utility methods to update the viewer, change the animation environment, lightening, etc.
  /// The onCreated callback is called once when the native view is created and provide unique controller to each widget.
  /// See also:
  /// [Playx3dSceneController]
  final Playx3dSceneCreatedCallback? onCreated;

  /// Which gestures should be consumed by the view.
  ///
  /// When the view is put inside other view like [ListView],
  /// it might claim gestures that are recognized by any of the recognizers on this list.
  /// as the [ListView] will handle vertical drags gestures.
  ///
  /// To get the [Playx3dScene] to claim the vertical drag gestures we can pass a vertical drag
  /// gesture recognizer factory in [gestureRecognizers] e.g:
  ///
  /// ```dart
  /// GestureDetector(
  ///   onVerticalDragStart: (DragStartDetails details) {},
  ///   child: SizedBox(
  ///     width: 200.0,
  ///     height: 100.0,
  ///     child: Playx3dScene(
  ///       gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
  ///         Factory<OneSequenceGestureRecognizer>(
  ///           () => EagerGestureRecognizer(),
  ///         ),
  ///       },
  ///     ),
  ///   ),
  /// )
  /// ```
  ///
  /// When this set is empty, the view will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  const Playx3dScene(
      {super.key,
      this.models,
      this.scene,
      this.shapes,
      this.onCreated,
      this.gestureRecognizers =
          const <Factory<OneSequenceGestureRecognizer>>{}});

  @override
  State<StatefulWidget> createState() {
    return PlayxModelViewerState();
  }
}

class PlayxModelViewerState extends State<Playx3dScene> {
  final Map<String, dynamic> _creationParams = <String, dynamic>{};
  final Completer<Playx3dSceneController> _controller =
      Completer<Playx3dSceneController>();

  PlayxModelViewerState();

  @override
  void initState() {
    _setupCreationParams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return AndroidView(
        viewType: _viewType,
        creationParams: _creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
      );
    }
    return Text('$defaultTargetPlatform is not yet supported by the plugin');
  }

  void _setupCreationParams() {
    //final model = widget.models?.toJson();
    final scene = widget.scene?.toJson();
    _creationParams["models"] =
        widget.models?.map((param) => param.toJson()).toList();
    _creationParams["scene"] = scene;
    _creationParams["shapes"] =
        widget.shapes?.map((param) => param.toJson()).toList();
  }

  void _onPlatformViewCreated(int id) {
    final controller = Playx3dSceneController(id: id);

    _controller.complete(controller);
    if (widget.onCreated != null) {
      widget.onCreated!(controller);
    }
  }

  @override
  void didUpdateWidget(Playx3dScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateWidget(oldWidget);
  }

  void _updateWidget(Playx3dScene? oldWidget) {
    _setupCreationParams();
    if (!listEquals(oldWidget?.models, widget.models) ||
        oldWidget?.scene != widget.scene ||
        !listEquals(oldWidget?.shapes, widget.shapes)) {
      _updatePlayxScene();
    }
  }

  Future<void> _updatePlayxScene() async {
    final controller = (await _controller.future);
    await controller.updatePlayx3dScene(
      models: widget.models,
      scene: widget.scene,
      shapes: widget.shapes,
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    // Update scene on hot reload for better debugging
    _updateWidget(null);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
