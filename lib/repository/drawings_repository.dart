import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/single_draw.dart';

final drawingsRepositoryProvider = Provider<DrawingsRepository>((ref) => DrawingsRepository(ref));

const drawingsRepositoryBoxName = "drawings";

Future<Box> openDrawingsBox() => Hive.openBox<String>(drawingsRepositoryBoxName);

class DrawingsRepository {
  final ProviderRef _ref;
  late final box = Hive.box<String>(drawingsRepositoryBoxName);

  DrawingsRepository(this._ref);

  List<SingleDraw> loadDrawings(int year) {
    return box.keys
        .map((key) {
          return SingleDraw.fromHive(key, jsonDecode(box.get(key)!));
        })
        .where((element) => element.year == year)
        .map((e) => e.parsePointList())
        .toList();
  }

  createSingleCalendarDrawings(Calendar calendar, SingleDraw singleDraw, String id) async {
    singleDraw.localKey = await box.add(singleDraw.toHive);
  }

  deleteSingleCalendarDrawings(Calendar calendar, SingleDraw singleDraw) {
    box.delete(singleDraw.localKey);
  }

  Future deleteSingleCalendarDrawingList(Calendar calendar, List<SingleDraw> singleDraw) async {
    for (final drawing in singleDraw) {
      deleteSingleCalendarDrawings(calendar, drawing);
    }
  }
}
