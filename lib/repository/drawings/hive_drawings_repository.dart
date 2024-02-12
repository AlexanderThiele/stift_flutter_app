import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_layer.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/repository/drawings/drawings_repository.dart';

class HiveDrawingsRepository extends DrawingsRepository {
  final hiveDrawingsYearBox = "drawings";
  final hiveLayerDataBox = "layer.data";
  final hiveLayerSettingsBox = "layer.settings";

  final ProviderRef _ref;

  HiveDrawingsRepository(this._ref);

  @override
  Future<void> createSingleCalendarDrawings(
    Calendar? calendar,
    CalendarLayer calendarLayer,
    SingleDraw singleDraw,
  ) async {
    final box = await _getDrawingsBox(calendarLayer);
    singleDraw.localKey = await box.add(singleDraw.toHive);
  }

  @override
  Future<void> deleteSingleCalendarDrawings(
      Calendar? calendar, CalendarLayer calendarLayer, SingleDraw singleDraw) async {
    final box = await _getDrawingsBox(calendarLayer);
    await box.delete(singleDraw.localKey);
  }

  @override
  Future<void> deleteCalendarDrawings(
      Calendar? calendar, CalendarLayer calendarLayer, List<SingleDraw> singleDrawList) async {
    final box = await _getDrawingsBox(calendarLayer);
    for (final singleDraw in singleDrawList) {
      await box.delete(singleDraw.localKey);
    }
  }

  @override
  Future<void> deleteSingleCalendarDrawingList(
      Calendar? calendar, CalendarLayer calendarLayer, List<SingleDraw> singleDraw) async {
    for (final drawing in singleDraw) {
      await deleteSingleCalendarDrawings(calendar, calendarLayer, drawing);
    }
  }

  @override
  Future<List<CalendarLayer>> loadAllCalendarLayer(int year) async {
    final box = await _getLayerBox();
    // default layer
    List<CalendarLayer> layerList = [];

    layerList.addAll(
      box.keys.map(
        (boxKey) => CalendarLayer.fromHive(
          boxKey,
          jsonDecode(box.get(boxKey)!),
        ),
      ),
    );
    if (layerList.isEmpty) {
      final defaultLayer = CalendarLayer(name: "", isWriteActive: true, isVisible: true);
      await _saveCalendarLayer(defaultLayer);
      layerList.add(defaultLayer);
      await saveAllCalendarLayer(layerList);
      await migrateDefaultCalendar(defaultLayer);
    }

    for (final calendarLayer in layerList) {
      calendarLayer.drawingList = await _loadDrawings(year, calendarLayer);
    }

    return layerList;
  }

  @override
  Future<int> createNewCalendarLayer(CalendarLayer calendarLayer) async {
    final box = await _getLayerBox();
    int localKey = await box.add(calendarLayer.toHive);
    calendarLayer.localKey = localKey;
    return localKey;
  }

  @override
  Future<void> deleteCalendarLayer(CalendarLayer calendarLayer) async {
    await clearCalendarLayer(calendarLayer);
    final layerBox = await _getLayerBox();
    layerBox.delete(calendarLayer.localKey);
  }

  @override
  Future<void> saveAllCalendarLayer(List<CalendarLayer> calendarLayer) async {
    final box = await _getLayerBox();
    for (final layer in calendarLayer) {
      if (layer.localKey >= 0) {
        await box.put(layer.localKey, layer.toHive);
      }
    }
  }

  /// Deletes all drawings in a calendar Layer
  @override
  Future<void> clearCalendarLayer(CalendarLayer calendarLayer) async {
    final box = await _getDrawingsBox(calendarLayer);
    await box.deleteAll(calendarLayer.drawingList.map((e) => e.localKey));
  }

  Future<List<SingleDraw>> _loadDrawings(int year, CalendarLayer calendarLayer) async {
    final box = await _getDrawingsBox(calendarLayer);
    return box.keys
        .map((key) {
          return SingleDraw.fromHive(key, jsonDecode(box.get(key)!));
        })
        .where((element) => element.year == year)
        .map((e) => e.parsePointList())
        .toList();
  }

  Future<void> _saveCalendarLayer(CalendarLayer calendarLayer) async {
    final box = await _getLayerBox();
    calendarLayer.localKey = await box.add(calendarLayer.toHive);
  }

  Future<Box> _getDrawingsBox(CalendarLayer calendarLayer) async {
    final layerName = calendarLayer.localKey.toString();
    return await Hive.openBox<String>("$hiveDrawingsYearBox$layerName");
  }

  Future<void> migrateDefaultCalendar(CalendarLayer defaultLayer) async {
    final defaultBox = await Hive.openBox<String>("drawings");
    final toNewBox = await _getDrawingsBox(defaultLayer);
    await toNewBox.addAll(defaultBox.values);
    await defaultBox.clear();
  }

  Future<Box> _getLayerBox() => Hive.openBox<String>(hiveLayerDataBox);
}
