import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/public_holiday_controller.dart';

final countryControllerProvider =
    StateNotifierProvider<CountryController, Locale?>(
        (ref) => CountryController(ref.read));

class CountryController extends StateNotifier<Locale?> {
  final Reader _read;

  CountryController(this._read) : super(null) {
    _loadCountry();
  }

  _loadCountry() async {
    await CountryCodes.init();
    state = CountryCodes.getDeviceLocale();
    _read(publicHolidayControllerProvider.notifier).onNewYearOrNewCountry();
  }

  @override
  bool updateShouldNotify(Locale? old, Locale? current) {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
