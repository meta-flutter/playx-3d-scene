import 'package:flutter/services.dart';
import 'dart:io';
import 'package:playx_3d_scene/playx_3d_scene.dart';
import '../shape_and_object_creators.dart';
import '../material_helpers.dart';

class CollisionEventChannel {
  static const EventChannel _eventChannel =
      EventChannel('plugin.filament_view.collision_info');

  bool bWriteEventsToLog = false;

  late Playx3dSceneController poController; // Declare the controller

  void setController(Playx3dSceneController controller) {
    poController = controller;
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
              poController.changeMaterialParameterData(ourJson, guid);
            } else {
              Map<String, dynamic> ourJson =
                  poGetLitMaterialWithRandomValues().toJson();
              thingsWeCanChangeParamsOn.add(guid);
              poController.changeMaterialDefinitionData(ourJson, guid);
            }
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
