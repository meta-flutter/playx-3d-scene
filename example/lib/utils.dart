import 'package:flutter/material.dart';
import 'dart:math';

////////////////////////////////////////////////////////////////////////
Color getTrueRandomColor() {
  Random random = Random();

  // Generate random values for red, green, and blue channels
  int red = random.nextInt(256);
  int green = random.nextInt(256);
  int blue = random.nextInt(256);

  // Create and return a Color object
  return Color.fromARGB(255, red, green, blue);
}

////////////////////////////////////////////////////////////////////////////////
Color getRandomPresetColor() {
  // List of preset colors from the Flutter Material color palette
  List<Color> presetColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  // Create a random instance
  Random random = Random();

  // Select a random color from the list
  return presetColors[random.nextInt(presetColors.length)];
}
