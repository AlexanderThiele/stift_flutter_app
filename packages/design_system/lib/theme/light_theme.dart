import 'package:flutter/material.dart';

// https://coolors.co/palette/264653-2a9d8f-e9c46a-f4a261-e76f51
final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2C304D),
      brightness: Brightness.light,
      primary: const Color(0xFF2C304D),
      onPrimary: const Color(0xFFFFFFFF),
      secondary: const Color(0xFF3AADB4),
      onSecondary: const Color(0xFFFFFFFF),
      tertiary: const Color(0xFFE9C46A),
      onTertiary: const Color(0xFFFFFFFF),
      error: const Color(0xFFE76F51),
      onError: Colors.white,
      background: const Color(0xFFFCF9F0),
      onBackground: const Color(0xFF2C304D),
      surface: const Color(0xFFFCF9F0),
      onSurface: const Color(0xFF2C304D),
      surfaceTint: const Color(0xFF3AADB4),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFCF9F0),
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xFF2C304D)),
        foregroundColor: MaterialStatePropertyAll(Color(0xFFFFFFFF)),
      ),
    ),
    cardTheme: const CardTheme(),
    popupMenuTheme: const PopupMenuThemeData(surfaceTintColor: Color(0xFF3AADB4)),
    appBarTheme: const AppBarTheme(surfaceTintColor: Color(0xFF3AADB4)),
    progressIndicatorTheme: const ProgressIndicatorThemeData(circularTrackColor: Color(0xFFFFFFFF)));
