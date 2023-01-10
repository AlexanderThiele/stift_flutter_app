import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/controller/country_controller.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:pencalendar/repository/shared_pref_repository.dart';
import 'package:pencalendar/utils/app_logger.dart';

final publicHolidayControllerProvider =
    StateNotifierProvider<PublicHolidayController, List<PublicHoliday>?>(
        (ref) => PublicHolidayController(ref.read));

class PublicHolidayController extends StateNotifier<List<PublicHoliday>?> {
  final Reader _read;

  PublicHolidayController(this._read) : super(null);

  onNewYearOrNewCountry() async {
    Locale? locale = _read(countryControllerProvider);
    if (locale == null) {
      AppLogger.d("Locale null");
      return;
    }
    final sharedPref = _read(sharedPrefUtilityProvider);
    final year = _read(activeCalendarYearProvider);
    final countryCode = locale.countryCode;
    if (countryCode != null) {
      state = await sharedPref.loadPublicHoliday(year, countryCode);
    }
  }

  @override
  bool updateShouldNotify(
      List<PublicHoliday>? old, List<PublicHoliday>? current) {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
