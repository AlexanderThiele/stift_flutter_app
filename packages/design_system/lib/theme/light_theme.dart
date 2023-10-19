import 'package:flutter/material.dart';

// https://coolors.co/palette/264653-2a9d8f-e9c46a-f4a261-e76f51
final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF2C304D),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF3AADB4),
        onSecondary: Color(0xFFFFFFFF),
        error: Color(0xFFE76F51),
        onError: Colors.white,
        background: Color(0xFFE6DACC),
        onBackground: Color(0xFF2C304D),
        surface: Color(0xFFE6DACC),
        onSurface: Color(0xFF2C304D)),
    scaffoldBackgroundColor: const Color(0xFFFAFEF2),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFCDF77E), foregroundColor: Colors.black, focusColor: Colors.red),
    brightness: Brightness.light,
    textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.black)));
