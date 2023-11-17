import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/components/calendar_table/interactive_paint_view.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:pencalendar/repository/repository_provider.dart';
import 'package:pencalendar/utils/app_logger.dart';

final activeCalendarControllerProvider = StateNotifierProvider<ActiveCalendarController, CalendarWithDrawings?>(
    (ref) => ActiveCalendarController(ref)..selectCalendar(null));

class ActiveCalendarController extends StateNotifier<CalendarWithDrawings?> {
  final StateNotifierProviderRef _ref;

  ActiveCalendarController(this._ref) : super(null);

  void selectCalendar(Calendar? calendar) async {
    var year = _ref.read(activeCalendarYearProvider);
    state = CalendarWithDrawings(calendar, drawingList: _ref.read(drawingsRepositoryProvider).loadDrawings(year));
  }

  void changeYear(int year) {
    assert(state != null);
    _ref.read(activeCalendarYearProvider.notifier).changeYear(year);
    selectCalendar(state!.calendar);
  }

  void saveSignatur(List<TouchData> pointList) {
    final color = _ref.read(activeColorProvider);
    final size = _ref.read(activeWidthProvider);
    AppLogger.d("save");
    final year = _ref.read(activeCalendarYearProvider);
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final List<SinglePoint> convertedPoints = [];
    for (final point in pointList) {
      convertedPoints.add(SinglePoint(point.offset.dx, point.offset.dy, point.pressure));
    }

    final singleDraw = SingleDraw(id, -1, convertedPoints, color, size, year);
    state = state!..drawingList.add(singleDraw);

    _ref.read(drawingsRepositoryProvider).createSingleCalendarDrawings(state!.calendar, singleDraw, id);
  }

  void deleteLast() {
    if (state == null || state!.drawingList.isEmpty) {
      AppLogger.d("nothing to delete, list is empty");
      return;
    }
    final tobeDeleted = state!.drawingList.last;
    _ref.read(drawingsRepositoryProvider).deleteSingleCalendarDrawings(state!.calendar, tobeDeleted);
    state = state!..drawingList.remove(tobeDeleted);
  }

  void deleteAll() {
    for (final drawing in state!.drawingList) {
      _ref.read(drawingsRepositoryProvider).deleteSingleCalendarDrawings(state!.calendar, drawing);
    }
    state = state!..drawingList.clear();
  }

  void onDeleteCalculation(Offset offset) {
    if (state != null) {
      final List<SingleDraw> toBeRemoved = [];
      for (var drawing in state!.drawingList) {
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
        }
      }
      for (var drawing in toBeRemoved) {
        _ref.read(drawingsRepositoryProvider).deleteSingleCalendarDrawings(state!.calendar, drawing);
        state = state!..drawingList.remove(drawing);
      }
    }
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
