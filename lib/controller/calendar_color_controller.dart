import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarColorProvider =
    NotifierProvider<CalendarColorNotifier, CalendarColorOption>(() => CalendarColorNotifier());

class CalendarColorNotifier extends Notifier<CalendarColorOption> {
  void changeColorOption(CalendarColorOption option) {
    print("changed");
    state = option;
  }

  @override
  CalendarColorOption build() {
    print("build");
    return CalendarColorOption.blackWhite;
  }
}

enum CalendarColorOption {
  standard,
  blackWhite;

  List<Color> get calendarColors {
    switch (this) {
      case CalendarColorOption.standard:
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
      case CalendarColorOption.blackWhite:
        // return 12 white color list
        return List.generate(12, (index) => Colors.grey.shade200);
    }
  }
}
