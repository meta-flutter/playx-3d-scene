import 'package:flutter/services.dart';
import 'dart:io';
import '../utils.dart';
import 'package:playx_3d_scene/playx_3d_scene.dart';

class FrameEventChannel {
  static const EventChannel _eventChannel =
      EventChannel('plugin.filament_view.frame_view');

  bool bWriteEventsToLog = false;

  late Playx3dSceneController poController; // Declare the controller

  void setController(Playx3dSceneController controller) {
    poController = controller;
  }

  // Frames from Native to here, currently run in order of
  // - updateFrame - Called regardless if a frame is going to be drawn or not
  // - preRenderFrame - Called before native <features>, but we know we're going to draw a frame
  // - renderFrame - Called after native <features>, right before drawing a frame
  // - postRenderFrame - Called after we've drawn natively, right after drawing a frame.
  void initEventChannel() {
    try {
      // Listen for events from the native side
      _eventChannel.receiveBroadcastStream().listen(
        (event) {
          // Handle incoming event
          if (bWriteEventsToLog) stdout.write('Received event: $event\n');

          if (event is Map) {
            //final elapsedFrameTime = event['elapsedFrameTime'];
            final method = event['method'];

            // Log extracted values
            if (method == 'preRenderFrame') {
              vRunLightLoops(poController);
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
