import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/controller/public_holiday_controller.dart';

final activeCalendarYearProvider =
    StateNotifierProvider<ActiveCalendarYearController, int>(
        (ref) => ActiveCalendarYearController(ref));

class ActiveCalendarYearController extends StateNotifier<int> {
  final StateNotifierProviderRef _ref;

  ActiveCalendarYearController(this._ref) : super(DateTime.now().year);

  changeYear(int year) {
    state = year;
    // notify public holiday
    _ref.read(publicHolidayControllerProvider.notifier).onNewYearOrNewCountry();
  }
}
