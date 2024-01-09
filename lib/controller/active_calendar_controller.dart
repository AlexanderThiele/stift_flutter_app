import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/components/calendar_table/interactive_paint_view.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_layer.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:pencalendar/repository/analytics/analytics_repository.dart';
import 'package:pencalendar/repository/repository_provider.dart';
import 'package:pencalendar/utils/app_logger.dart';
import 'package:pencalendar/utils/emoji.dart';

final activeCalendarControllerProvider = StateNotifierProvider<ActiveCalendarController, CalendarWithDrawings?>(
    (ref) => ActiveCalendarController(ref)..selectCalendar(null));

class ActiveCalendarController extends StateNotifier<CalendarWithDrawings?> {
  final StateNotifierProviderRef _ref;

  ActiveCalendarController(this._ref) : super(null);

  void selectCalendar(Calendar? calendar) async {
    var year = _ref.read(activeCalendarYearProvider);
    state = CalendarWithDrawings(calendar,
        layerList: await _ref.read(drawingsRepositoryProvider).loadAllCalendarLayer(year));
  }

  void changeYear(int year) {
    assert(state != null);
    _ref.read(activeCalendarYearProvider.notifier).changeYear(year);
    selectCalendar(state!.calendar);
    _ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.changeYear, parameters: {"year": year});
  }

  void saveSignatur(List<TouchData> pointList, {required bool isStylusDrawing}) {
    assert(state != null);
    final color = _ref.read(activeColorProvider);
    final size = _ref.read(activeWidthProvider);
    final year = _ref.read(activeCalendarYearProvider);
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final singleDraw = SingleDraw(
      id: id,
      localKey: -1,
      pointList: pointList.map((point) => SinglePoint(point.offset.dx, point.offset.dy, point.pressure)).toList(),
      color: color,
      size: size,
      year: year,
      isDeletable: true,
    );
    // update all listeners
    state = state!..addDrawingToWritable(singleDraw);

    _ref
        .read(drawingsRepositoryProvider)
        .createSingleCalendarDrawings(state!.calendar, state!.currentWritableCalendarLayer, singleDraw);
    _ref
        .read(analyticsRepositoryProvider)
        .trackEvent(AnalyticEvent.addDrawing, parameters: {"stylus": isStylusDrawing, "year": year});
  }

  void deleteLast() {
    assert(state != null);
    final (calendarLayer, deletedSingleDraw) = state!.deleteLast();
    if (calendarLayer == null || deletedSingleDraw == null) {
      AppLogger.d("nothing to delete, list is empty");
      return;
    }
    state = state;
    _ref
        .read(drawingsRepositoryProvider)
        .deleteSingleCalendarDrawings(state!.calendar, calendarLayer, deletedSingleDraw);
    _ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.revertDrawing);
  }

  /// This really deletes all Drawings for the current year
  void deleteAll() async {
    for (final calendarLayer in state!.layerList) {
      await _ref.read(drawingsRepositoryProvider).clearCalendarLayer(calendarLayer);
    }

    state = state!..clearAllLayer();
    final year = _ref.read(activeCalendarYearProvider);
    _ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.clearYearDrawing, parameters: {"year": year});
  }

  void onDeleteCalculation(Offset offset) {
    assert(state != null);

    final List<SingleDraw> toBeRemoved = [];
    for (var drawing in state!.currentWritableCalendarLayer.drawingList) {
      final path = Path();

      for (int i = 0; i < drawing.pointList.length; i++) {
        if (i == 0) {
          path.moveTo(drawing.pointList[i].dx, drawing.pointList[i].dy);
        } else {
          path.lineTo(drawing.pointList[i].dx, drawing.pointList[i].dy);
        }
      }
      if (path.contains(offset) || _checkNearbyPoints(offset, drawing.pointList)) {
        AppLogger.d("found intersection: ${drawing.id}");
        toBeRemoved.add(drawing);
        _ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.eraseDrawing);
      }
    }
    state = state!..deleteSingleDrawingsFromWritable(toBeRemoved);
    _ref
        .read(drawingsRepositoryProvider)
        .deleteCalendarDrawings(state!.calendar, state!.currentWritableCalendarLayer, toBeRemoved);
  }

  Future<void> createLayer(String name) async {
    assert(state != null);
    String clearedName = switch (name) {
      "" => randomEmoji,
      _ => name,
    };
    final calendarLayer = CalendarLayer.fromUserCreation(-1, clearedName);
    await _ref.read(drawingsRepositoryProvider).createNewCalendarLayer(calendarLayer);
    _ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.addLayer);
    state!.addLayer(calendarLayer);
    state = state;
  }

  Future<void> deleteLayer(CalendarLayer calendarLayer) async {
    assert(state != null);
    await _ref.read(drawingsRepositoryProvider).deleteCalendarLayer(calendarLayer);
    _ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.deleteLayer);
    state!.layerList.remove(calendarLayer);
    state = state;

    if (calendarLayer.isWriteActive) {
      // if user deleted the active write calendar, then switch again
      switchWritableLayer(state!.layerList.first);
    }
  }

  Future<void> switchVisibility(bool isVisible, CalendarLayer calendarLayer) async {
    assert(state != null);
    if (calendarLayer.isWriteActive) {
      return;
    }
    calendarLayer.isVisible = isVisible;
    _ref.read(drawingsRepositoryProvider).saveAllCalendarLayer(state!.layerList);
    state = state;
  }

  Future<void> switchWritableLayer(CalendarLayer calendarLayer) async {
    assert(state != null);
    for (final layer in state!.layerList) {
      layer.isWriteActive = false;
    }
    calendarLayer.isWriteActive = true;
    calendarLayer.isVisible = true;
    state!.currentWritableCalendarLayer = calendarLayer;
    _ref.read(drawingsRepositoryProvider).saveAllCalendarLayer(state!.layerList);
    state = state;
  }

  bool _checkNearbyPoints(Offset offset, List<SinglePoint> pointList) {
    for (SinglePoint point in pointList) {
      var pointDistance = sqrt(pow(point.dx - offset.dx, 2) + pow(point.dy - offset.dy, 2));
      if (pointDistance < 5) {
        return true;
      }
    }
    return false;
  }

  @override
  bool updateShouldNotify(CalendarWithDrawings? old, CalendarWithDrawings? current) {
    return true;
  }
}
