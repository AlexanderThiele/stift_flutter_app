import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/repository/drawings_repository.dart';
import 'package:pencalendar/repository/firestore_repository.dart';
import 'package:pencalendar/utils/app_logger.dart';

final activeCalendarControllerProvider =
    StateNotifierProvider<ActiveCalendarController, CalendarWithDrawings?>((ref) => ActiveCalendarController(ref));

class ActiveCalendarController extends StateNotifier<CalendarWithDrawings?> {
  final StateNotifierProviderRef _ref;

  StreamSubscription? _streamSubscription;

  ActiveCalendarController(this._ref) : super(null);

  onNewCalendarReceived(List<Calendar> updatedList) {
    if (state == null && updatedList.isNotEmpty) {
      // select the first calendar as the current active
      selectCalendar(updatedList.first);
    }
  }

  void selectCalendar(Calendar calendar) async {
    var year = _ref.read(activeCalendarYearProvider);
    await _streamSubscription?.cancel();
    state = CalendarWithDrawings(calendar, drawingList: _ref.read(drawingsRepositoryProvider).loadDrawings(year));
    _streamSubscription = _ref
        .read(firestoreRepositoryProvider)
        .getSingleCalendarDrawings(calendar, year)
        .snapshots()
        .listen(onNewDrawingReceived);
  }

  changeYear(int year) {
    _ref.read(activeCalendarYearProvider.notifier).changeYear(year);
    if (state != null) {
      selectCalendar(state!.calendar);
    } else {
      AppLogger.e("Change year but the calendar is null");
    }
  }

  onNewDrawingReceived(QuerySnapshot<SingleDraw> snapshot) {
    AppLogger.d("new drawing");
    AppLogger.d("size ${snapshot.size}");
    for (var singleDraw in snapshot.docChanges) {
      switch (singleDraw.type) {
        case DocumentChangeType.added:
          final singleDrawObj = singleDraw.doc.data()!;
          state?.drawingList.add(singleDrawObj);
          // we're switching from online storage to offline storage
          _ref
              .read(drawingsRepositoryProvider)
              .createSingleCalendarDrawings(state!.calendar, singleDrawObj, singleDrawObj.id);
          _ref.read(firestoreRepositoryProvider).deleteSingleCalendarDrawings(state!.calendar, singleDrawObj);
          break;
        case DocumentChangeType.removed:
          {
            AppLogger.d("delete");
            // turn off for now
            // state?.drawingList.removeWhere((element) => element.id == singleDraw.doc.id);
          }
          break;
        case DocumentChangeType.modified:
          // TODO: Handle this case.
          break;
      }
    }
    state = state;
    // state = state!..drawingList = snapshot.docs.map((e) => e.data()).toList();
  }

  void saveSignatur(List<Offset> pointList, Color color, double size) {
    AppLogger.d("save");
    final year = _ref.read(activeCalendarYearProvider);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final singleDraw = SingleDraw(id, -1, pointList, color, size, year);
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

  onDeleteCalculation(Offset offset) {
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

  bool _checkNearbyPoints(Offset offset, List<Offset> pointList) {
    for (Offset point in pointList) {
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

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
