import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/repository/drawings/drawings_repository.dart';

const drawingsRepositoryBoxName = "drawings";

Future<Box> openDrawingsBox() => Hive.openBox<String>(drawingsRepositoryBoxName);

class HiveDrawingsRepository extends DrawingsRepository {
  final ProviderRef _ref;
  late final box = Hive.box<String>(drawingsRepositoryBoxName);

  HiveDrawingsRepository(this._ref);

  @override
  List<SingleDraw> loadDrawings(int year) {
    return box.keys
        .map((key) {
          return SingleDraw.fromHive(key, jsonDecode(box.get(key)!));
        })
        .where((element) => element.year == year)
        .map((e) => e.parsePointList())
        .toList();
  }

  @override
  Future<void> createSingleCalendarDrawings(Calendar? calendar, SingleDraw singleDraw, String id) async {
    singleDraw.localKey = await box.add(singleDraw.toHive);
  }

  @override
  Future<void> deleteSingleCalendarDrawings(Calendar? calendar, SingleDraw singleDraw) async {
    await box.delete(singleDraw.localKey);
  }

  @override
  Future<void> deleteSingleCalendarDrawingList(Calendar? calendar, List<SingleDraw> singleDraw) async {
    for (final drawing in singleDraw) {
      await deleteSingleCalendarDrawings(calendar, drawing);
    }
  }
}
