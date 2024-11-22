import 'package:flutter/services.dart';
import 'dart:io';

class AnimationEventChannel {
  static const EventChannel _eventChannel =
  EventChannel('plugin.filament_view.animation_info');

  void initEventChannel() {
    try {
      // Listen for events from the native side
      _eventChannel.receiveBroadcastStream().listen(
            (event) {
          // Handle incoming event
          stdout.write('Received event: $event\n');
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
