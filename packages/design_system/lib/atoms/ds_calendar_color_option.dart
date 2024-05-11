import 'package:flutter/material.dart';

enum DsCalendarColorOption {
  standard,
  blackWhite;

  List<Color> get calendarColors {
    switch (this) {
      case DsCalendarColorOption.standard:
        return [
          Colors.blue.shade300,
          Colors.blue.shade100,
          Colors.teal.shade500,
          Colors.teal.shade300,
          Colors.green.shade400,
          Colors.green.shade200,
          Colors.yellow.shade300,
          Colors.orange.shade200,
          Colors.orange.shade500,
          Colors.red.shade200,
          Colors.red.shade400,
          Colors.purple.shade300,
          Colors.blue.shade300
        ];
      case DsCalendarColorOption.blackWhite:
        return List.generate(12, (index) => Colors.grey.shade200);
    }
  }

  List<Color> get calendarColorsForButton {
    switch (this) {
      case DsCalendarColorOption.standard:
        return calendarColors;
      case DsCalendarColorOption.blackWhite:
        return [Colors.black, Colors.white];
    }
  }
}
