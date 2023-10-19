import 'package:flutter/material.dart';

// https://coolors.co/palette/264653-2a9d8f-e9c46a-f4a261-e76f51
final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF264653),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF2A9D8F),
        onSecondary: Color(0xFFFFFFFF),
        error: Color(0xFFE76F51),
        onError: Colors.white,
        background: Color(0xFFE9ECED),
        onBackground: Color(0xFF264653),
        surface: Color(0xFFE9F5F3),
        onSurface: Color(0xFF264653)),
    scaffoldBackgroundColor: const Color(0xFFFAFEF2),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFCDF77E), foregroundColor: Colors.black, focusColor: Colors.red),
    brightness: Brightness.light,
    textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.black)));
