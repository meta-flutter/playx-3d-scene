import 'package:flutter/services.dart';

class NativeReadiness {
  static const MethodChannel _readinessChecker =
      MethodChannel('plugin.filament_view.readiness_checker');
  static const EventChannel _readinessChannel =
      EventChannel('plugin.filament_view.readiness');

  Future<bool> isNativeReady() async {
    try {
      final bool ready =
          await _readinessChecker.invokeMethod<bool>('isReady') ?? false;
      return ready;
    } catch (e) {
      //print('Error checking native readiness: $e');
      return false;
    }
  }

  Stream<String> get readinessStream => _readinessChannel
      .receiveBroadcastStream()
      .map((event) => event as String);
}
