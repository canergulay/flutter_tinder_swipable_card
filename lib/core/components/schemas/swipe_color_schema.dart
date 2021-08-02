import 'package:flutter/material.dart';

class SwipeColorSchemas {
  static SwipeColorSchemas? _instace = SwipeColorSchemas._init();
  static SwipeColorSchemas? get instance => _instace;
  SwipeColorSchemas._init();

  static Color photoActive = Colors.white;
  static Color photoInactive = Colors.white38;
}
