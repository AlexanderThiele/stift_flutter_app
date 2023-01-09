import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/public_holiday_controller.dart';

final activeCalendarYearProvider =
    StateNotifierProvider<ActiveCalendarYearController, int>(
        (ref) => ActiveCalendarYearController(ref.read));

class ActiveCalendarYearController extends StateNotifier<int> {
  final Reader _read;

  ActiveCalendarYearController(this._read) : super(DateTime.now().year);

  changeYear(int year) {
    state = year;
    // notify public holiday
    _read(publicHolidayControllerProvider.notifier).onNewYearOrNewCountry();
  }
}
