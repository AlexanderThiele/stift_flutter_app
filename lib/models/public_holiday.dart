import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pencalendar/utils/app_logger.dart';

class PublicHoliday {
  DateTime date; // "2023-01-02"
  String localName; // "New Year's Day"
  String name; // "New Year's Day"
  String countryCode; // "US"
  bool fixed; // false
  bool global; // true
  List<String>? counties; // ["DE-BW","DE-BY","DE-ST"]
  int? launchYear; // 1967
  List<String> types; // ["Public"] , ["Optional"]

  PublicHoliday(this.date, this.localName, this.name, this.countryCode,
      this.fixed, this.global, this.counties, this.launchYear, this.types);

  static PublicHoliday fromJson(Map<String, dynamic> json) {
    List<String>? counties;
    if (json["counties"] != null) {
      counties = (json["counties"] as List<dynamic>).map((e) => e.toString()).toList();
    }
    return PublicHoliday(
        DateTime.parse(json["date"]),
        json["localName"],
        json["name"],
        json["countryCode"],
        json["fixed"],
        json["global"],
        counties,
        json["launchYear"],
        (json["types"] as List<dynamic>).map((e) => e.toString()).toList());
  }

  String get parsedCounties {
    String name = "";
    if(counties != null){
      name += counties!.map((e) => e.split("-").last).join(", ").toLowerCase();
    }
    return name;
  }

  @override
  String toString() {
    return 'PublicHoliday{date: $date, localName: $localName, name: $name, countryCode: $countryCode, fixed: $fixed, global: $global, counties: $counties, launchYear: $launchYear, types: $types}';
  }
}
