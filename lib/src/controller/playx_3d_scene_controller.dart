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

const String _changeLightTransformByGUID = "CHANGE_LIGHT_TRANSFORM_BY_GUID";
const String _changeLightTransformByGUIDPosx = "CHANGE_LIGHT_TRANSFORM_BY_GUID_POSX";
const String _changeLightTransformByGUIDPosy = "CHANGE_LIGHT_TRANSFORM_BY_GUID_POSY";
const String _changeLightTransformByGUIDPosz = "CHANGE_LIGHT_TRANSFORM_BY_GUID_POSZ";
const String _changeLightTransformByGUIDDirx = "CHANGE_LIGHT_TRANSFORM_BY_GUID_DIRX";
const String _changeLightTransformByGUIDDiry = "CHANGE_LIGHT_TRANSFORM_BY_GUID_DIRY";
const String _changeLightTransformByGUIDDirz = "CHANGE_LIGHT_TRANSFORM_BY_GUID_DIRZ";

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