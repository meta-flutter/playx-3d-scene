import 'dart:ui';

export './loading_state.dart';
export './result.dart';

///convert color to hex string
extension ColorsExt on Color {
  String toHex() {
    return "#${value.toRadixString(16)}";
  }
}
