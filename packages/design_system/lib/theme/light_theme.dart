import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFCDF77E),
        onPrimary: Color(0xFFF77E65),
        secondary: Color(0xFF88966A),
        onSecondary: Color(0xFFFFFFFF),
        error: Colors.red,
        onError: Colors.white,
        background: Color(0xFFFAFEF2),
        onBackground: Colors.black,
        surface: Color(0xFFFAFEF2),
        onSurface: Colors.black),
    scaffoldBackgroundColor: const Color(0xFFFAFEF2),
    backgroundColor: const Color(0xFFFAFEF2),
    toggleableActiveColor: const Color(0xFFF77E65),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFCDF77E),
        foregroundColor: Colors.black,
        focusColor: Colors.red),
    brightness: Brightness.light,
    textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.black)));
