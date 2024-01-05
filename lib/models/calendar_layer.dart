import 'dart:convert';

import 'package:pencalendar/models/single_draw.dart';

class CalendarLayer {
  final String name;
  bool isWriteActive;
  bool isVisible;

  /// will be set from another hive box
  List<SingleDraw> drawingList;

  /// will be set by hive
  int localKey;

  CalendarLayer({
    required this.name,
    this.drawingList = const [],
    this.localKey = -1,
    this.isWriteActive = false,
    this.isVisible = false,
  });

  CalendarLayer.fromHive(int key, Map<String, dynamic> data)
      : this(
          name: data["name"],
          isWriteActive: data["isWriteActive"],
          isVisible: data["isVisible"],
          localKey: key,
        );

  CalendarLayer.fromUserCreation(int key, String name)
      : this(
          name: name,
          localKey: key,
          drawingList: [],
          isVisible: true,
          isWriteActive: false,
        );

  String get toHive {
    return jsonEncode({
      "name": name,
      "isWriteActive": isWriteActive,
      "isVisible": isVisible,
    });
  }
}
