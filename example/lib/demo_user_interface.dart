import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////////////////
TextStyle getTextStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    shadows: [
      Shadow(
        offset: Offset(-1.5, -1.5),
        color: Colors.white,
      ),
      Shadow(
        offset: Offset(1.5, -1.5),
        color: Colors.white,
      ),
      Shadow(
        offset: Offset(1.5, 1.5),
        color: Colors.white,
      ),
      Shadow(
        offset: Offset(-1.5, 1.5),
        color: Colors.white,
      ),
    ],
  );
}
