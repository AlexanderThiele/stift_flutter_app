import 'package:design_system/atoms/ds_calendar_color_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarColorProvider =
    NotifierProvider<CalendarColorNotifier, DsCalendarColorOption>(() => CalendarColorNotifier());

class CalendarColorNotifier extends Notifier<DsCalendarColorOption> {
  void changeColorOption(DsCalendarColorOption option) {
    state = option;
  }

  @override
  DsCalendarColorOption build() {
    return DsCalendarColorOption.standard;
  }
}
