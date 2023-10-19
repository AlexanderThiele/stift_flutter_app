import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/controller/public_holiday_controller.dart';

final countryControllerProvider =
    StateNotifierProvider<CountryController, Locale?>(
        (ref) => CountryController(ref));

class CountryController extends StateNotifier<Locale?> {
  final StateNotifierProviderRef _ref;

  CountryController(this._ref) : super(null) {
    _loadCountry();
  }

  _loadCountry() async {
    await CountryCodes.init();
    state = CountryCodes.getDeviceLocale();
    _ref.read(publicHolidayControllerProvider.notifier).onNewYearOrNewCountry();
  }

  @override
  bool updateShouldNotify(Locale? old, Locale? current) {
    return true;
  }
}
