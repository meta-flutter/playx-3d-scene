import 'package:flutter/services.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import 'package:playx_3d_scene/src/utils/utils.dart';

///An object which helps facilitate communication between the [Playx3dScene] Widget
///and android side model viewer based on Filament.
///It provides utility methods to update the viewer, change the animation environment, lightening, etc.
/// Each controller is unique for each widget.
class Playx3dSceneController {
  int id;
  late MethodChannel _channel;

  static const String _channelName = "io.sourcya.playx.3d.scene.channel";

  Playx3dSceneController({required this.id}) {
    _channel = MethodChannel('${_channelName}_$id');
  }

  /// Updates the current 3d scene view with the new [scene], [model], and [shapes].
  /// Returns true if the scene was updated successfully.
  Future<Result<bool>> updatePlayx3dScene(
      {Scene? scene, List<Model>? models, List<Shape>? shapes}) {
    final data = _channel.invokeMethod<bool>(
      _updatePlayx3dScene,
      {
        _updatePlayx3dSceneSceneKey: scene?.toJson(),
        _updatePlayx3dSceneModelKey: models?.map((e) => e.toJson()).toList(),
        _updatePlayx3dSceneShapesKey: shapes?.map((e) => e.toJson()).toList(),
      },
    );
    return _handleError(data);
  }

  /// Updates the current scene with the new [scene].
  /// Returns true if the scene was updated successfully.
  Future<Result<bool>> updateScene({Scene? scene}) {
    final data = _channel.invokeMethod<bool>(
      _updateScene,
      {_updateSceneKey: scene?.toJson()},
    );
    return _handleError(data);
  }

  /// Updates the current scene with the new [model].
  /// Returns true if the models were updated successfully.
  Future<Result<bool>> updateModel({List<Model>? models}) {
    final data = _channel.invokeMethod<bool>(
      _updateModel,
      {_updateModelKey: models?.map((e) => e.toJson()).toList()},
    );
    return _handleError(data);
  }

  /// Updates the current scene with the new [shapes].
  /// Returns true if the shapes were updated successfully.
  Future<Result<bool>> updateShapes({List<Shape>? shapes}) {
    final data = _channel.invokeMethod<bool>(
      _updateShapes,
      {_updateShapesKey: shapes?.map((e) => e.toJson()).toList()},
    );
    return _handleError(data);
  }

  Future<Result<int>> changeMaterialParameterData(
        Map<String, dynamic> ourJson, String entity) {
      final data = _channel.invokeMethod<int>(
      /* const String _changeMaterialParameter = "CHANGE_MATERIAL_PARAMETER";
      const String _changeMaterialParameterData = "CHANGE_MATERIAL_PARAMETER_DATA";
      const String _changeMaterialParameterEntityGuid = "CHANGE_MATERIAL_PARAMETER_ENTITY_GUID"; */
        _changeMaterialParameter,
        {
          _changeMaterialParameterData: ourJson,
          _changeMaterialParameterEntityGuid: entity,
        },
      );
      return _handleError(data);
    }

      Future<Result<int>> changeMaterialDefinitionData(
            Map<String, dynamic> ourJson, String entity) {
          final data = _channel.invokeMethod<int>(
            _changeMaterialDefinition,
            {
              _changeMaterialDefinitionData: ourJson,
              _changeMaterialDefinitionEntityGuid: entity,
            },
          );
          return _handleError(data);
        }

  Future<Result<int>> changeLightValuesByGUID(
      String entityGUID, Color? color, int? intensity) {
    final data = _channel.invokeMethod<int>(
      _changeLightColorByGUID,
      {
        _entityGUID: entityGUID,
        _changeLightColorByGUIDColor: color?.toHex(),
        _changeLightColorByGUIDIntensity: intensity
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> toggleShapesInScene(bool value) {
    final data = _channel.invokeMethod<int>(
      _toggleShapesInScene,
      {
        _toggleShapesInSceneValue: value,
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> toggleCollidableVisualsInScene(bool value) {
    final data = _channel.invokeMethod<int>(
      _toggleCollidableVisualsInScene,
      {
        _toggleCollidableVisualsInSceneValue: value,
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> changeCameraMode(String value) {
    final data = _channel.invokeMethod<int>(
      _changeCameraMode,
      {
        _changeCameraModeValue: value,
      },
    );
    return _handleError(data);
  }

    Future<Result<int>> resetInertiaCameraToDefaultValues() {
      final data = _channel.invokeMethod<int>(
        _resetInertiaCameraToDefaultValues,
        {
        },
      );
      return _handleError(data);
    }

  Future<Result<int>> setCameraRotation(double fValue) {
    final data = _channel.invokeMethod<int>(
      _changeCameraRotation,
      {
        _changeCameraRotationValue: fValue,
      },
    );
    return _handleError(data);
  }
  
    Future<Result<int>> changeQualitySettings() {
      final data = _channel.invokeMethod<int>(
        _ChangeQualitySettings,
      );
      return _handleError(data);
    }

   Future<Result<int>> requestCollisionCheckFromRay(String queryID,
    double originX, double originY, double originZ,
     double directionX, double directionY, double directionZ,
     double length) {
      final data = _channel.invokeMethod<int>(
        _collisionRayRequest,
        {
          _collisionRayRequestGUID: queryID,
          _collisionRayRequestOriginX: originX,
          _collisionRayRequestOriginY: originY,
          _collisionRayRequestOriginZ: originZ,
          _collisionRayRequestDirectionX: directionX,
          _collisionRayRequestDirectionY: directionY,
          _collisionRayRequestDirectionZ: directionZ,
          _collisionRayRequestLength: length,
        },
      );
      return _handleError(data);
    }

  //animation
 Future<Result<int>> enqueueAnimation(String entityGUID, int animationIndex) {
    final data = _channel.invokeMethod<int>(
      _animationEnqueue,
      {
        _entityGUID: entityGUID,
        _animationChangeSpeedValue: animationIndex,
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> clearAnimationQueue(String entityGUID) {
    final data = _channel.invokeMethod<int>(
      _animationClearQueue,
      {
        _entityGUID: entityGUID,
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> playAnimation(String entityGUID, int animationIndex) {
    final data = _channel.invokeMethod<int>(
      _animationPlay,
      {
        _entityGUID: entityGUID,
        _animationChangeSpeedValue: animationIndex,
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> changeAnimationSpeed(String entityGUID, double speed) {
    final data = _channel.invokeMethod<int>(
      _animationChangeSpeed,
      {
        _entityGUID: entityGUID,
        _animationChangeSpeedValue: speed,
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> pauseAnimation(String entityGUID) {
    final data = _channel.invokeMethod<int>(
      _animationPause,
      {
        _entityGUID: entityGUID,
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> resumeAnimation(String entityGUID) {
    final data = _channel.invokeMethod<int>(
      _animationResume,
      {
        _entityGUID: entityGUID,
      },
    );
    return _handleError(data);
  }

  Future<Result<int>> setAnimationLooping(String entityGUID, bool looping) {
    final data = _channel.invokeMethod<int>(
      _animationSetLooping,
      {
        _entityGUID: entityGUID,
        _animationSetLoopingValue: looping,
      },
    );
    return _handleError(data);
  }

  //skybox

  /// Updates skybox by ktx file from the assets.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeSkyboxByKtxAsset(String? path) {
    final data = _channel.invokeMethod<String>(
      _changeSkyboxByAsset,
      {_changeSkyboxByAssetKey: path},
    );
    return _handleError(data);
  }

  /// Updates skybox by ktx file from [url].
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeSkyboxByKtxUrl(String? url) {
    final data = _channel.invokeMethod<String>(
      _changeSkyboxByUrl,
      {_changeSkyboxByUrlKey: url},
    );
    return _handleError(data);
  }

  /// Updates skybox by hdr file from the assets.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeSkyboxByHdrAsset(String? path) {
    final data = _channel.invokeMethod<String>(
      _changeSkyboxByHdrAsset,
      {_changeSkyboxByHdrAssetKey: path},
    );
    return _handleError(data);
  }

  /// Updates skybox by hdr file from [url].
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeSkyboxByHdrUrl(String? url) {
    final data = _channel.invokeMethod<String>(
      _changeSkyboxByHdrUrl,
      {_changeSkyboxByHdrUrlKey: url},
    );
    return _handleError(data);
  }

  /// Updates skybox by given color.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeSkyboxColor(Color? color) {
    final environmentColor = color?.toHex;
    final data = _channel.invokeMethod<String>(
      _changeSkyboxColor,
      {_changeSkyboxColorKey: environmentColor},
    );
    return _handleError(data);
  }

  /// Updates skybox to be transparent.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeToTransparentSkybox() {
    final data = _channel.invokeMethod<String>(
      _changeToTransparentSkybox,
      {},
    );
    return _handleError(data);
  }

  //light

  /// Updates scene indirect light by ktx file from assets.
  /// also update scene indirect light [intensity] if provided.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeIndirectLightByKtxAsset(
      {required String? path, double? intensity}) {
    final data = _channel.invokeMethod<String>(
      _changeLightByKtxAsset,
      {
        _changeLightByKtxAssetKey: path,
        _changeLightByKtxAssetIntensityKey: intensity
      },
    );
    return _handleError(data);
  }

  /// Updates scene indirect light by ktx file from url.
  /// also update scene indirect light [intensity] if provided.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeIndirectLightByKtxUrl(
      {required String? url, double? intensity}) {
    final data = _channel.invokeMethod<String>(
      _changeLightByKtxUrl,
      {
        _changeLightByKtxUrlKey: url,
        _changeLightByKtxUrlIntensityKey: intensity
      },
    );
    return _handleError(data);
  }

  /// Updates scene indirect light by HDR file from assets.
  /// also update scene indirect light [intensity] if provided.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeIndirectLightByHdrAsset(
      {required String? path, double? intensity}) {
    final data = _channel.invokeMethod<String>(
      _changeLightByHdrAsset,
      {
        _changeLightByHdrAssetKey: path,
        _changeLightByHdrAssetIntensityKey: intensity
      },
    );
    return _handleError(data);
  }

  /// Updates scene indirect light by HDR file from assets.
  /// also update scene indirect light [intensity] if provided.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeIndirectLightByHdrUrl(
      {required String? url, double? intensity}) {
    final data = _channel.invokeMethod<String>(
      _changeLightByHdrUrl,
      {
        _changeLightByHdrUrlKey: url,
        _changeLightByHdrUrlIntensityKey: intensity
      },
    );
    return _handleError(data);
  }

  /// Updates scene indirect light by [DefaultIndirectLight].
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeIndirectLightByDefaultIndirectLight(
      DefaultIndirectLight indirectLight) {
    final data = _channel.invokeMethod<String>(
      _changeLightByIndirectLight,
      {_changeLightByIndirectLightKey: indirectLight.toJson()},
    );
    return _handleError(data);
  }

  /// Updates scene indirect light to [DefaultIndirectLight] with default values of :
  /// * intensity which is 40_000.0.
  /// * radiance bands of 1.0,
  /// * radiance sh of [1,1,1]
  /// * irradiance bands of 1.0,
  /// * irradiance sh of [1,1,1]
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeToDefaultIndirectLight() {
    final data = _channel.invokeMethod<String>(
      _changeToDefaultIndirectLight,
      {},
    );
    return _handleError(data);
  }

  /// Updates scene direct light .
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeSceneLight(Light light) {
    final data = _channel.invokeMethod<String>(
      _changeLight,
      {_changeLightKey: light.toJson()},
    );
    return _handleError(data);
  }

  /// Updates scene direct light To the default value.
  /// With intensity value of 100_000.0.
  /// and color temperature bands of 6_500.0,
  /// and direction of [0.0, -1.0, 0.0],
  /// and cast shadows true.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeToDefaultLight() {
    final data = _channel.invokeMethod<String>(
      _changeToDefaultLight,
      {},
    );
    return _handleError(data);
  }

  //load model

  /// Load glb model from assets and replace current model with it.
  /// Returns String message that it's succeeded.
  Future<Result<String>> loadGlbModelFromAssets(String? path) {
    final data = _channel.invokeMethod<String>(
      _loadGlbModelFromAssets,
      {_loadGlbModelFromAssetsPathKey: path},
    );
    return _handleError(data);
  }

  /// Load glb model from url and replace current model with it.
  /// Returns String message that it's succeeded.
  Future<Result> loadGlbModelFromUrl(String? url) {
    final data = _channel.invokeMethod<String>(
      _loadGlbModelFromUrl,
      {_loadGlbModelFromUrlKey: url},
    );
    return _handleError(data);
  }

  /// Load gltf model from assets and replace current model with it.
  /// If the images path that in the gltf file different from the flutter asset path,
  /// consider adding [prefix] to the images path to be before the image.
  /// Or [postfix] to the images path to be after the image.
  /// For example if in the gltf file, the image path is textures/texture
  /// and in assets the image path is assets/models/textures/texture.png
  /// [prefix] must be 'assets/models/' and [postfix] should be '.png'.
  /// Returns String message that it's succeeded.
  Future<Result<String>> loadGltfModelFromAssets(String? path,
      {String? imagePathPrefix, String? imagePathPostfix}) {
    final data = _channel.invokeMethod<String>(
      _loadGltfModelFromAssets,
      {
        _loadGltfModelFromAssetsPathKey: path,
        _loadGltfModelFromAssetsPrefixPathKey: imagePathPrefix,
        _loadGltfModelFromAssetsPostfixPathKey: imagePathPostfix
      },
    );
    return _handleError(data);
  }

  /// Updates current model scale.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeModelScale(double? scale) {
    final data = _channel.invokeMethod<String>(
      _changeModelScale,
      {_changeModelScaleKey: scale},
    );
    return _handleError(data);
  }

  /// Updates current model center position in the world space.
  /// By taking x,y,z coordinates of [centerPosition] in the world space.
  /// Returns String message that it's succeeded.
  Future<Result<String>> changeModelCenterPosition(
      PlayxPosition centerPosition) {
    final data = _channel.invokeMethod<String>(
      _changeModelPosition,
      {_changeModelPositionKey: centerPosition.toJson()},
    );
    return _handleError(data);
  }

  /// Get current model state.
  Future<Result<ModelState>> getCurrentModelState() async {
    try {
      final state = await _channel.invokeMethod<String>(
        _getCurrentModelState,
        {},
      );
      return Result.success(ModelState.from(state));
    } on PlatformException catch (err) {
      return Result.error(err.message);
    } catch (err) {
      return Result.error("Something went wrong");
    }
  }

  ///Replace current camera with a new [camera].
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateCamera(Camera? camera) {
    final data = _channel.invokeMethod<String>(
      _updateCamera,
      {_updateCameraKey: camera?.toJson()},
    );
    return _handleError(data);
  }

  /// Update the current camera exposure.
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateExposure(Exposure? exposure) {
    final data = _channel.invokeMethod<String>(
      _updateExposure,
      {_updateExposureKey: exposure?.toJson()},
    );
    return _handleError(data);
  }

  /// Update the current camera projection.
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateProjection(Projection? projection) {
    final data = _channel.invokeMethod<String>(
      _updateProjection,
      {_updateProjectionKey: projection?.toJson()},
    );
    return _handleError(data);
  }

  /// Update the current camera lens projection.
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateLensProjection(LensProjection? lensProjection) {
    final data = _channel.invokeMethod<String>(
      _updateLensProjection,
      {_updateLensProjectionKey: lensProjection?.toJson()},
    );
    return _handleError(data);
  }

  /// Update the current camera shifting.
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateCameraShift(List<double>? shift) {
    final data = _channel.invokeMethod<String>(
      _updateCameraShift,
      {_updateCameraShiftKey: shift},
    );
    return _handleError(data);
  }

  /// Update the current camera scaling.
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateCameraScaling(List<double>? scaling) {
    final data = _channel.invokeMethod<String>(
      _updateCameraScaling,
      {_updateCameraScalingKey: scaling},
    );
    return _handleError(data);
  }

  /// Update the current camera to it's default settings.
  /// Returns String message that it's succeeded.
  Future<Result<String>> setDefaultCamera() {
    final data = _channel.invokeMethod<String>(
      _setDefaultCamera,
      {},
    );
    return _handleError(data);
  }

  ///Makes the camera looks at its default position.
  /// Returns String message that it's succeeded.
  Future<Result<String>> lookAtDefaultCameraPosition() {
    final data = _channel.invokeMethod<String>(
      _lookAtDefaultPosition,
      {},
    );
    return _handleError(data);
  }

  ///Gets the current positions the camera is looking at.
  /// Returns List of 9 elements.
  /// From [0:2] elements are eye position.
  /// From [3:5] elements are target position.
  /// From [6:8]  elements are upward position
  Future<Result<List<double>>> getCameraLookAtPositions() async {
    try {
      final positions = await _channel.invokeMethod<List<Object?>?>(
        _getLookAt,
        {},
      );
      final result = positions?.map((e) => (e as double)).toList();
      return Result.success(result);
    } on PlatformException catch (err) {
      return Result.error(err.message);
    } catch (err) {
      return Result.error("Something went wrong");
    }
  }

  ///Sets the camera's model matrix.
  ///
  ///[eyePos] consists of 3 elements :
  /// eyeX – x-axis position of the camera in world space
  /// eyeY – y-axis position of the camera in world space
  /// eyeZ – z-axis position of the camera in world space
  ///
  ///[targetPos] consists of 3 elements :
  /// centerX – x-axis position of the point in world space the camera is looking at
  /// centerY – y-axis position of the point in world space the camera is looking at
  /// centerZ – z-axis position of the point in world space the camera is looking at
  ///
  ///[upwardPos] consists of 3 elements :
  /// upX – x-axis coordinate of a unit vector denoting the camera's "up" direction
  /// upY – y-axis coordinate of a unit vector denoting the camera's "up" direction
  /// upZ – z-axis coordinate of a unit vector denoting the camera's "up" direction
  /// Returns String message that it's succeeded.
  Future<Result<String>> lookAtCameraPosition({
    List<double>? eyePos,
    List<double>? targetPos,
    List<double>? upwardPos,
  }) {
    final data = _channel.invokeMethod<String>(
      _lookAtPosition,
      {
        _eyeArrayKey: eyePos,
        _targetArrayKey: targetPos,
        _upwardArrayKey: upwardPos
      },
    );
    return _handleError(data);
  }

  /// In MAP and ORBIT modes, dollys the camera along the viewing direction.
  /// In FREE_FLIGHT mode, adjusts the move speed of the camera.
  ///
  /// [x] X-coordinate for point of interest in viewport space, ignored in FREE_FLIGHT mode
  /// [y] Y-coordinate for point of interest in viewport space, ignored in FREE_FLIGHT mode
  /// [scrolldelta] In MAP and ORBIT modes, negative means "zoom in", positive means "zoom out"
  ///  In FREE_FLIGHT mode, negative means "slower", positive means "faster"
  /// Returns String message that it's succeeded.
  Future<Result<String>> scrollCameraTo({
    num? x,
    num? y,
    double? scrollDelta,
  }) {
    final data = _channel.invokeMethod<String>(
      _cameraScroll,
      {
        _cameraScrollXKey: x,
        _cameraScrollYKey: y,
        _cameraScrollDeltaKey: scrollDelta
      },
    );
    return _handleError(data);
  }

  ///Starts a grabbing session (i.e. the user is dragging around in the viewport).
  /// In MAP mode, this starts a panning session. In ORBIT mode, this starts either rotating or strafing.
  /// In FREE_FLIGHT mode, this starts a nodal panning session.
  /// [x] – X-coordinate for point of interest in viewport space.
  /// [y] – Y-coordinate for point of interest in viewport space.
  /// [strafe] – ORBIT mode only; if true, starts a translation rather than a rotation.
  /// Returns String message that it's succeeded.
  Future<Result<String>> beginCameraGrab({
    num? x,
    num? y,
    bool? strafe,
  }) {
    final data = _channel.invokeMethod<String>(
      _cameraGrabBegin,
      {
        _cameraGrabBeginXKey: x,
        _cameraGrabBeginYKey: y,
        _cameraGrabBeginStrafeKey: strafe
      },
    );
    return _handleError(data);
  }

  ///Updates a grabbing session. This must be called at least once between [beginCameraGrab] / [endCameraGrab] to dirty the camera.
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateCameraGrab({
    num? x,
    num? y,
  }) {
    final data = _channel.invokeMethod<String>(
      _cameraGrabUpdate,
      {
        _cameraGrabUpdateXKey: x,
        _cameraGrabUpdateYKey: y,
      },
    );
    return _handleError(data);
  }

  ///Ends a grabbing session.
  /// Returns String message that it's succeeded.
  Future<Result<String>> endCameraGrab() {
    final data = _channel.invokeMethod<String>(
      _cameraGrabEnd,
      {},
    );
    return _handleError(data);
  }

  ///Given a viewport coordinate, picks a point in the ground plane.
  Future<Result<List<double>>> getCameraRayCast({
    num? x,
    num? y,
  }) {
    final data = _channel.invokeMethod<List<double>?>(
      _cameraRayCast,
      {
        _cameraRayCastXKey: x,
        _cameraRayCastYKey: y,
      },
    );
    return _handleError(data);
  }

  /// Updates current Ground by updating it's width, height, and whether is below model or not without updating material.
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateGround(Ground? ground) {
    final data = _channel.invokeMethod<String>(
      _updateGround,
      {_updateGroundKey: ground?.toJson()},
    );
    return _handleError(data);
  }

  /// Updates current Ground material.
  /// Returns String message that it's succeeded.

  Future<Result<String>> updateGroundMaterial(PlayxMaterial material) {
    final data = _channel.invokeMethod<String>(
      _updateGroundMaterial,
      {_updateGroundMaterialKey: material.toJson()},
    );
    return _handleError(data);
  }

  /// Add a shape to the scene.
  /// Returns String message that it's succeeded.
  Future<Result<String>> addShape(Shape shape) {
    final data = _channel.invokeMethod<String>(
      _addShape,
      {_addShapeKey: shape.toJson()},
    );
    return _handleError(data);
  }

  /// Removes a shape from the scene by given [id].
  /// Returns String message that it's succeeded.
  Future<Result<String>> removeShape(int id) {
    final data = _channel.invokeMethod<String>(
      _removeShape,
      {_removeShapeKey: id},
    );
    return _handleError(data);
  }

  /// Updates a shape with given [id] with new [shape].
  /// if no shape was found with the given [id], new shape will be created.
  /// Returns String message that it's succeeded.
  Future<Result<String>> updateShape(int id, Shape shape) {
    final data = _channel.invokeMethod<String>(
      _updateShape,
      {_updateShapeKey: shape.toJson(), _updateShapeIdKey: id},
    );
    return _handleError(data);
  }

  ///Gets current created shapes ids.
  Future<Result<List<int>>> getCurrentShapesIds() {
    final data = _channel.invokeMethod<List<Object?>?>(
      _getCurrentCreatedShapesIds,
      {},
    ).then((value) {
      final List<int> ids = [];
      value?.forEach((element) {
        final id = element as int?;
        if (id != null) {
          ids.add(id);
        }
      });
      return ids;
    });
    return _handleError(data);
  }
}

Future<Result<T>> _handleError<T>(Future<T?> data) async {
  try {
    final result = await data;
    return Result.success(result);
  } on PlatformException catch (err) {
    return Result.error(err.message);
  } catch (err) {
    return Result.error("Something went wrong");
  }
}

const String _updatePlayx3dScene = "UPDATE_PLAYX_3D_SCENE";
const String _updatePlayx3dSceneSceneKey = "UPDATE_PLAYX_3D_SCENE_SCENE_KEY";
const String _updatePlayx3dSceneModelKey = "UPDATE_PLAYX_3D_SCENE_MODEL_KEY";
const String _updatePlayx3dSceneShapesKey = "UPDATE_PLAYX_3D_SCENE_SHAPES_KEY";

const String _changeLightColorByGUID =
    "CHANGE_LIGHT_COLOR_BY_GUID";
const String _changeLightColorByGUIDColor =
    "CHANGE_LIGHT_COLOR_BY_GUID_COLOR";
const String _changeLightColorByGUIDIntensity =
    "CHANGE_LIGHT_COLOR_BY_GUID_INTENSITY";

const String _changeMaterialParameter = "CHANGE_MATERIAL_PARAMETER";
const String _changeMaterialParameterData = "CHANGE_MATERIAL_PARAMETER_DATA";
const String _changeMaterialParameterEntityGuid = "CHANGE_MATERIAL_PARAMETER_ENTITY_GUID";

const String _changeMaterialDefinition = "CHANGE_MATERIAL_DEFINITION";
const String _changeMaterialDefinitionData = "CHANGE_MATERIAL_DEFINITION_DATA";
const String _changeMaterialDefinitionEntityGuid = "CHANGE_MATERIAL_DEFINITION_ENTITY_GUID";

const String _toggleShapesInScene = "TOGGLE_SHAPES_IN_SCENE";
const String _toggleShapesInSceneValue = "TOGGLE_SHAPES_IN_SCENE_VALUE";

const String _toggleCollidableVisualsInScene = "TOGGLE_COLLIDABLE_VISUALS_IN_SCENE";
const String _toggleCollidableVisualsInSceneValue ="TOGGLE_COLLIDABLE_VISUALS_IN_SCENE_VALUE";

const String _changeCameraMode = "CHANGE_CAMERA_MODE";
const String _changeCameraModeValue = "CHANGE_CAMERA_MODE_VALUE";
const String _resetInertiaCameraToDefaultValues = "RESET_INERTIA_TO_DEFAULTS";

const String _changeCameraRotation = "ROTATE_CAMERA";
const String _changeCameraRotationValue = "ROTATE_CAMERA_VALUE";
const String _ChangeQualitySettings = "CHANGE_QUALITY_SETTINGS";

const String _collisionRayRequest = "COLLISION_RAY_REQUEST";
const String _collisionRayRequestOriginX = "COLLISION_RAY_REQUEST_ORIGIN_X";
const String _collisionRayRequestOriginZ = "COLLISION_RAY_REQUEST_ORIGIN_Z";
const String _collisionRayRequestOriginY = "COLLISION_RAY_REQUEST_ORIGIN_Y";
const String _collisionRayRequestDirectionX = "COLLISION_RAY_REQUEST_DIRECTION_X";
const String _collisionRayRequestDirectionY = "COLLISION_RAY_REQUEST_DIRECTION_Y";
const String _collisionRayRequestDirectionZ = "COLLISION_RAY_REQUEST_DIRECTION_Z";
const String _collisionRayRequestLength = "COLLISION_RAY_REQUEST_LENGTH";
const String _collisionRayRequestGUID = "COLLISION_RAY_REQUEST_GUID";

const String _changeSkyboxByAsset = "CHANGE_SKYBOX_BY_ASSET";
const String _changeSkyboxByAssetKey = "CHANGE_SKYBOX_BY_ASSET_KEY";

const String _changeSkyboxByUrl = "CHANGE_SKYBOX_BY_URL";
const String _changeSkyboxByUrlKey = "CHANGE_SKYBOX_BY_URL_KEY";

const String _changeSkyboxByHdrAsset = "CHANGE_SKYBOX_BY_HDR_ASSET";
const String _changeSkyboxByHdrAssetKey = "CHANGE_SKYBOX_BY_HDR_ASSET_KEY";

const String _changeSkyboxByHdrUrl = "CHANGE_SKYBOX_BY_HDR_URL";
const String _changeSkyboxByHdrUrlKey = "CHANGE_SKYBOX_BY_HDR_URL_KEY";

const String _changeSkyboxColor = "CHANGE_SKYBOX_COLOR";
const String _changeSkyboxColorKey = "CHANGE_SKYBOX_COLOR_KEY";

const String _changeToTransparentSkybox = "CHANGE_TO_TRANSPARENT_SKYBOX";

const String _changeLightByKtxAsset = "CHANGE_LIGHT_BY_ASSET";
const String _changeLightByKtxAssetKey = "CHANGE_LIGHT_BY_ASSET_KEY";
const String _changeLightByKtxAssetIntensityKey =
    "CHANGE_LIGHT_BY_ASSET_INTENSITY_KEY";

const String _changeLightByKtxUrl = "CHANGE_LIGHT_BY_KTX_URL";
const String _changeLightByKtxUrlKey = "CHANGE_LIGHT_BY_KTX_URL_KEY";
const String _changeLightByKtxUrlIntensityKey =
    "CHANGE_LIGHT_BY_KTX_URL_INTENSITY_KEY";

const String _changeLightByHdrAsset = "CHANGE_LIGHT_BY_HDR_ASSET";
const String _changeLightByHdrAssetKey = "CHANGE_LIGHT_BY_HDR_ASSET_KEY";
const String _changeLightByHdrAssetIntensityKey =
    "CHANGE_LIGHT_BY_HDR_ASSET_INTENSITY_KEY";

const String _changeLightByHdrUrl = "CHANGE_LIGHT_BY_HDR_URL";
const String _changeLightByHdrUrlKey = "CHANGE_LIGHT_BY_HDR_URL_KEY";
const String _changeLightByHdrUrlIntensityKey =
    "CHANGE_LIGHT_BY_HDR_URL_INTENSITY_KEY";

const String _changeLightByIndirectLight = "CHANGE_LIGHT_BY_INDIRECT_LIGHT";
const String _changeLightByIndirectLightKey =
    "CHANGE_LIGHT_BY_INDIRECT_LIGHT_KEY";

const String _changeToDefaultIndirectLight =
    "CHANGE_TO_DEFAULT_LIGHT_INTENSITY";

const String _changeLight = "CHANGE_LIGHT";
const String _changeLightKey = "CHANGE_LIGHT_KEY";
const String _changeToDefaultLight = "CHANGE_TO_DEFAULT_LIGHT";

const String _loadGlbModelFromAssets = "LOAD_GLB_MODEL_FROM_ASSETS";
const String _loadGlbModelFromAssetsPathKey =
    "LOAD_GLB_MODEL_FROM_ASSETS_PATH_KEY";

const String _loadGlbModelFromUrl = "LOAD_GLB_MODEL_FROM_URL";
const String _loadGlbModelFromUrlKey = "LOAD_GLB_MODEL_FROM_URL_KEY";

const String _loadGltfModelFromAssets = "LOAD_GLTF_MODEL_FROM_ASSETS";
const String _loadGltfModelFromAssetsPathKey =
    "LOAD_GLTF_MODEL_FROM_ASSETS_PATH_KEY";
const String _loadGltfModelFromAssetsPrefixPathKey =
    "LOAD_GLTF_MODEL_FROM_ASSETS_PREFIX_PATH_KEY";
const String _loadGltfModelFromAssetsPostfixPathKey =
    "LOAD_GLTF_MODEL_FROM_ASSETS_POSTFIX_PATH_KEY";

const String _updateScene = "UPDATE_SCENE";
const String _updateSceneKey = "UPDATE_SCENE_KEY";
const String _updateModel = "UPDATE_MODEL";
const String _updateModelKey = "UPDATE_MODELS_KEY";
const String _updateShapes = "UPDATE_SHAPES";
const String _updateShapesKey = "UPDATE_SHAPES_KEY";
const String _getCurrentModelState = "GET_CURRENT_MODEL_STATE";
const String _changeModelScale = "CHANGE_MODEL_SCALE";
const String _changeModelScaleKey = "CHANGE_MODEL_SCALE_KEY";
const String _changeModelPosition = "CHANGE_MODEL_POSITION";
const String _changeModelPositionKey = "CHANGE_MODEL_POSITION_KEY";
const String _updateCamera = "UPDATE_CAMERA";
const String _updateCameraKey = "UPDATE_CAMERA_KEY";

const String _updateExposure = "UPDATE_EXPOSURE";
const String _updateExposureKey = "UPDATE_EXPOSURE_KEY";

const String _updateProjection = "UPDATE_PROJECTION";
const String _updateProjectionKey = "UPDATE_PROJECTION_KEY";

const String _updateLensProjection = "UPDATE_LENS_PROJECTION";
const String _updateLensProjectionKey = "UPDATE_LENS_PROJECTION_KEY";

const String _updateCameraShift = "UPDATE_CAMERA_SHIFT";
const String _updateCameraShiftKey = "UPDATE_CAMERA_SHIFT_KEY";

const String _updateCameraScaling = "UPDATE_CAMERA_SCALING";
const String _updateCameraScalingKey = "UPDATE_CAMERA_SCALING_KEY";

const String _setDefaultCamera = "SET_DEFAULT_CAMERA";
const String _lookAtDefaultPosition = "LOOK_AT_DEFAULT_POSITION";

const String _lookAtPosition = "LOOK_AT_POSITION";
const String _eyeArrayKey = "EYE_ARRAY_KEY";
const String _targetArrayKey = "TARGET_ARRAY_KEY";
const String _upwardArrayKey = "UPWARD_ARRAY_KEY";

const String _getLookAt = "GET_LOOK_AT";
const String _cameraScroll = "CAMERA_SCROLL";

const String _cameraScrollXKey = "CAMERA_SCROLL_X_KEY";
const String _cameraScrollYKey = "CAMERA_SCROLL_Y_KEY";
const String _cameraScrollDeltaKey = "CAMERA_SCROLL_DELTA_KEY";

const String _cameraRayCast = "CAMERA_RAYCAST";
const String _cameraRayCastXKey = "CAMERA_RAYCAST_X_KEY";
const String _cameraRayCastYKey = "CAMERA_RAYCAST_Y_KEY";

const String _cameraGrabBegin = "CAMERA_GRAB_BEGIN";
const String _cameraGrabBeginXKey = "CAMERA_GRAB_BEGIN_X_KEY";
const String _cameraGrabBeginYKey = "CAMERA_GRAB_BEGIN_Y_KEY";
const String _cameraGrabBeginStrafeKey = "CAMERA_GRAB_BEGIN_STRAFE_KEY";

const String _cameraGrabUpdate = "CAMERA_GRAB_UPDATE";
const String _cameraGrabUpdateXKey = "CAMERA_GRAB_UPDATE_X_KEY";
const String _cameraGrabUpdateYKey = "CAMERA_GRAB_UPDATE_Y_KEY";
const String _cameraGrabEnd = "CAMERA_GRAB_END";

const String _updateGround = "UPDATE_GROUND";
const String _updateGroundKey = "UPDATE_GROUND_KEY";

const String _updateGroundMaterial = "UPDATE_GROUND_MATERIAL";
const String _updateGroundMaterialKey = "UPDATE_GROUND_MATERIAL_KEY";

const String _addShape = "ADD_SHAPE";
const String _addShapeKey = "ADD_SHAPE_KEY";
const String _removeShape = "REMOVE_SHAPE";
const String _removeShapeKey = "REMOVE_SHAPE_KEY";
const String _updateShape = "UPDATE_SHAPE";
const String _updateShapeKey = "UPDATE_SHAPE_KEY";
const String _updateShapeIdKey = "UPDATE_SHAPE_ID_KEY";
const String _getCurrentCreatedShapesIds = "CREATED_SHAPES_IDS";

const String _animationEnqueue = "ANIMATION_ENQUEUE";
const String _animationClearQueue = "ANIMATION_CLEAR_QUEUE";
const String _animationPlay = "ANIMATION_PLAY";
const String _animationChangeSpeed = "ANIMATION_CHANGE_SPEED";
const String _animationChangeSpeedValue = "ANIMATION_CHANGE_SPEED_VALUE";
const String _animationPause = "ANIMATION_PAUSE";
const String _animationResume = "ANIMATION_RESUME";
const String _animationSetLooping = "ANIMATION_SET_LOOPING";
const String _animationSetLoopingValue = "ANIMATION_LOOPING_VALUE";
const String _entityGUID = "ENTITY_GUID";