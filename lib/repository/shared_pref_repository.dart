import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:pencalendar/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// will be overwritten by main
final sharedPrefInstanceProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final sharedPrefUtilityProvider = Provider<SharedPrefRepository>(
    (ref) => SharedPrefRepository(ref.watch(sharedPrefInstanceProvider)));

class SharedPrefRepository {
  final SharedPreferences _sharedPreferences;

  final String publicHolidayKey = "public.holiday.{{country_code}}.{{year}}";

  SharedPrefRepository(this._sharedPreferences);

  /// either load local or from remote
  Future<List<PublicHoliday>> loadPublicHoliday(
      int year, String countryCode) async {
    final key = publicHolidayKey
        .replaceAll("{{country_code}}", countryCode.toLowerCase())
        .replaceAll("{{year}}", year.toString());
    String? localSaved = _sharedPreferences.getString(key);
    if (localSaved == null) {
      // load online
      AppLogger.d(
          "got Locale $countryCode and year $year. Fetching public holidays now");
      http.Response response = await http.get(Uri.parse(
          "https://date.nager.at/api/v3/PublicHolidays/$year/$countryCode"));
      if (response.statusCode == 200) {
        AppLogger.d("Saving fetched public holidays to sharedPref");
        await _sharedPreferences.setString(key, response.body);
      }
    } else {
      AppLogger.d("Found public holidays locally");
    }

    // load again
    localSaved = _sharedPreferences.getString(key);

    if (localSaved == null) {
      AppLogger.d("found no public holidays for $countryCode in $year");
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(localSaved);
    return jsonList
        .map((json) => PublicHoliday.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
