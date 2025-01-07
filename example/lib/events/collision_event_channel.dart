import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:io';
import 'dart:math' as math;
import '../shape_and_object_creators.dart';
import '../material_helpers.dart';
import '../messages.g.dart';

class CollisionEventChannel {
  static const EventChannel _eventChannel =
      EventChannel('plugin.filament_view.collision_info');

  bool bWriteEventsToLog = false;

  late FilamentViewApi filamentViewApi;

  void setController(FilamentViewApi api) {
    filamentViewApi = api;
  }

  double randomInRange(double min, double max) {
    final random = math.Random();
    return random.nextDouble() * (max - min) + min;
  }

  /// Generates a uniformly distributed random unit quaternion.
  Quaternion randomQuaternion() {
    final random = math.Random();

    // Generate three random values in [0,1).
    final double u1 = random.nextDouble();
    final double u2 = random.nextDouble();
    final double u3 = random.nextDouble();

    // Convert them to quaternion components
    final double sqrt1MinusU1 = math.sqrt(1.0 - u1);
    final double sqrtU1 = math.sqrt(u1);
    final double twoPiU2 = 2.0 * math.pi * u2;
    final double twoPiU3 = 2.0 * math.pi * u3;

    final double x = sqrt1MinusU1 * math.sin(twoPiU2);
    final double y = sqrt1MinusU1 * math.cos(twoPiU2);
    final double z = sqrtU1 * math.sin(twoPiU3);
    final double w = sqrtU1 * math.cos(twoPiU3);

    return Quaternion(x, y, z, w);
  }

  void initEventChannel() {
    try {
      // Listen for events from the native side
      _eventChannel.receiveBroadcastStream().listen(
        (event) {
          // Handle incoming event
          if (bWriteEventsToLog) stdout.write('Received event: $event\n');

          //Received event: {collision_event_hit_count: 1, collision_event_hit_result_0: {guid: 73bcc636-16b2-41d0-813e-f4d95f52d67a, hitPosition: [-1.4180145263671875, 1.1819745302200317, -0.35870814323425293], name: assets/models/sequoia_ngp.glb}, collision_event_source: vOnTouch, collision_event_type: 1}

          if (event.containsKey("collision_event_hit_result_0")) {
            Map<String, dynamic> hitResult = Map<String, dynamic>.from(
                event["collision_event_hit_result_0"]);
            String guid = hitResult["guid"];
            if (thingsWeCanChangeParamsOn.contains(guid)) {
              Map<String, dynamic> ourJson =
                  poGetRandomColorMaterialParam().toJson();
              filamentViewApi.changeMaterialParameter(ourJson, guid);
            } else {
              Map<String, dynamic> ourJson =
                  poGetLitMaterialWithRandomValues().toJson();
              thingsWeCanChangeParamsOn.add(guid);
              filamentViewApi.changeMaterialDefinition(ourJson, guid);
            }

            filamentViewApi.changeTranslationByGUID(guid, randomInRange(-5, 5),
                randomInRange(0, 2), randomInRange(-5, 5));

            final quat = randomQuaternion();
            filamentViewApi.changeRotationByGUID(
                guid, quat.x, quat.y, quat.z, quat.w);

            filamentViewApi.changeScaleByGUID(guid, randomInRange(0.4, 1.5),
                randomInRange(0.4, 1.5), randomInRange(0.4, 1.5));
          }
        },
        onError: (error) {
          // Handle specific errors
          if (error is MissingPluginException) {
            stdout.write(
                'MissingPluginException: Make sure the plugin is registered on the native side.\nDetails: $error\n');
          } else {
            stdout.write('Other Error: $error\n');
          }
        },
      );
    } catch (e, stackTrace) {
      // Catch any synchronous exceptions
      if (e is MissingPluginException) {
        stdout.write(
            'Caught MissingPluginException during EventChannel initialization.\nDetails: $e\nStack Trace:\n$stackTrace\n');
      } else {
        stdout.write('Unexpected Error: $e\nStack Trace:\n$stackTrace\n');
      }
    }
  }
}
