/*
 * Copyright 2024 Toyota Connected North America
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'generated/src/dart/messages.g.dart',
  dartTestOut: 'generated/src/dart/test/test_api.g.dart',
  cppHeaderOut: 'generated/src/cpp/messages.g.h',
  cppSourceOut: 'generated/src/cpp/messages.g.cc',
  cppOptions: CppOptions(
    namespace: 'plugin_filament_view',
  ),
  copyrightHeader: 'pigeons/copyright.txt',
))
@HostApi()
abstract class FilamentViewApi {
  /// Change material parameters for the given entity.
  void changeMaterialParameter(Map<String?, Object?> params, String guid);

  /// Change material definition for the given entity.
  void changeMaterialDefinition(Map<String?, Object?> params, String guid);

  /// Toggle shapes visibility in the scene.
  void toggleShapesInScene(bool value);

  /// Toggle debug collidable visuals in the scene.
  void toggleDebugCollidableViewsInScene(bool value);

  /// Change the camera mode by name.
  void changeCameraMode(String mode);

  /// Reset inertia camera to default values.
  void resetInertiaCameraToDefaultValues();

  /// Change view quality settings.
  void changeViewQualitySettings();

  /// Set camera rotation by a float value.
  void setCameraRotation(double value);

  // Light
  void changeLightTransformByGUID(String guid, double posx, double posy,
      double posz, double dirx, double diry, double dirz);
  void changeLightColorByGUID(String guid, String color, int intensity);

  // Animation
  void enqueueAnimation(String guid, int animationIndex);
  void clearAnimationQueue(String guid);
  void playAnimation(String guid, int animationIndex);
  void changeAnimationSpeed(String guid, double speed);
  void pauseAnimation(String guid);
  void resumeAnimation(String guid);
  void setAnimationLooping(String guid, bool looping);

  // Collision
  void requestCollisionCheckFromRay(
      String queryID,
      double originX,
      double originY,
      double originZ,
      double directionX,
      double directionY,
      double directionZ,
      double length);

  // transform
  void changeScaleByGUID(String guid, double x, double y, double z);
  void changeTranslationByGUID(String guid, double x, double y, double z);
  void changeRotationByGUID(
      String guid, double x, double y, double z, double w);
}
