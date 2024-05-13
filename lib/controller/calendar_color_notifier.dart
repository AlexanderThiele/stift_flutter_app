import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:design_system/atoms/ds_calendar_color_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/repository/repository_provider.dart';

final calendarColorProvider =
    NotifierProvider<CalendarColorNotifier, DsCalendarColorOption>(() => CalendarColorNotifier());

class CalendarColorNotifier extends Notifier<DsCalendarColorOption> {
  void changeColorOption(DsCalendarColorOption option) {
    ref.read(sharedPrefProvider).setCalendarColor(jsonEncode({"calendarColorOptionName": option.name}));
    state = option;
  }

  @override
  DsCalendarColorOption build() {
    final savedCalendarColor = ref.read(sharedPrefProvider).getCalendarColor();
    if (savedCalendarColor != null) {
      final parsedCalendarColor = jsonDecode(savedCalendarColor);
      final calendarColorOptionName = parsedCalendarColor["calendarColorOptionName"];
      if (calendarColorOptionName != null) {
        final savedColor =
            DsCalendarColorOption.values.firstWhereOrNull((element) => element.name == calendarColorOptionName);
        if (savedColor != null) {
          return savedColor;
        }
      }
    }
    return DsCalendarColorOption.standard;
  }
}
