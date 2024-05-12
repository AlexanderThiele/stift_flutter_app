import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/controller/country_controller.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:pencalendar/repository/repository_provider.dart';
import 'package:pencalendar/utils/app_logger.dart';

final publicHolidayControllerProvider =
    StateNotifierProvider<PublicHolidayController, List<PublicHoliday>?>(
        (ref) => PublicHolidayController(ref));

class PublicHolidayController extends StateNotifier<List<PublicHoliday>?> {
  final StateNotifierProviderRef _ref;

  PublicHolidayController(this._ref) : super(null);

  onNewYearOrNewCountry() async {
    Locale? locale = _ref.read(countryControllerProvider);
    if (locale == null) {
      AppLogger.d("Locale null");
      return;
    }
    final sharedPref = _ref.read(sharedPrefProvider);
    final year = _ref.read(activeCalendarYearProvider);
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
}
