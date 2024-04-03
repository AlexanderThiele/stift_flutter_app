import 'package:design_system/atoms/ds_colors.dart';
import 'package:flutter/material.dart';

// https://coolors.co/palette/264653-2a9d8f-e9c46a-f4a261-e76f51
final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: color10,
      brightness: Brightness.light,
      primary: color10,
      onPrimary: color1000,
      secondary: color20,
      onSecondary: color1000,
      tertiary: color30,
      onTertiary: color1000,
      error: color40,
      onError: color1000,
      background: color900,
      onBackground: color10,
      surface: color900,
      onSurface: color10,
      surfaceTint: color20,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: color900,
      foregroundColor: color0,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color10),
        foregroundColor: MaterialStatePropertyAll(color1000),
      ),
    ),
    cardTheme: const CardTheme(),
    popupMenuTheme: const PopupMenuThemeData(surfaceTintColor: color20),
    appBarTheme: const AppBarTheme(surfaceTintColor: color20),
    progressIndicatorTheme: const ProgressIndicatorThemeData(circularTrackColor: color1000));
