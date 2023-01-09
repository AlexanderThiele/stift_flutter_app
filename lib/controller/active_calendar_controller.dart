import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/repo/firestore_repository.dart';
import 'package:pencalendar/utils/app_logger.dart';

final activeCalendarControllerProvider =
    StateNotifierProvider<ActiveCalendarController, CalendarWithDrawings?>(
        (ref) => ActiveCalendarController(ref.read));

class ActiveCalendarController extends StateNotifier<CalendarWithDrawings?> {
  final Reader _read;

  StreamSubscription? _streamSubscription;

  ActiveCalendarController(this._read) : super(null);

  onNewCalendarReceived(List<Calendar> updatedList) {
    if (state == null && updatedList.isNotEmpty) {
      // select the first calendar as the current active
      selectCalendar(updatedList.first);
    }
  }

  selectCalendar(Calendar calendar) async {
    var year = _read(activeCalendarYearProvider);
    await _streamSubscription?.cancel();
    state = CalendarWithDrawings(calendar, drawingList: []);
    _streamSubscription = _read(firestoreRepositoryProvider)
        .getSingleCalendarDrawings(calendar, year)
        .snapshots()
        .listen(onNewDrawingReceived);
  }

  changeYear(int year) {
    _read(activeCalendarYearProvider.notifier).changeYear(year);
    if (state != null) {
      selectCalendar(state!.calendar);
    } else {
      AppLogger.e("Change year but the calendar is null");
    }
  }

  onNewDrawingReceived(QuerySnapshot<SingleDraw> snapshot) {
    print("new drawing");
    print("size ${snapshot.size}");
    for (var singleDraw in snapshot.docChanges) {
      switch (singleDraw.type) {
        case DocumentChangeType.added:
          state?.drawingList.add(singleDraw.doc.data()!);
          break;
        case DocumentChangeType.removed:
          {
            print("delete");
            state?.drawingList
                .removeWhere((element) => element.id == singleDraw.doc.id);
          }
      }
    }
    state = state;
    // state = state!..drawingList = snapshot.docs.map((e) => e.data()).toList();
  }

  void saveSignatur(List<Offset> pointList, Color color, double size) {
    print("save");
    final year = _read(activeCalendarYearProvider);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final singleDraw = SingleDraw(id, pointList, color, size, year);
    state = state!..drawingList.add(singleDraw);
    _read(firestoreRepositoryProvider)
        .createSingleCalendarDrawings(state!.calendar, singleDraw, id);
  }


  void deleteLast() {
    if(state == null || state!.drawingList.isEmpty){
      AppLogger.d("nothing to delete, list is empty");
      return;
    }
    final tobeDeleted = state!.drawingList.last;
    _read(firestoreRepositoryProvider)
        .deleteSingleCalendarDrawings(state!.calendar, tobeDeleted);
    state = state!..drawingList.remove(tobeDeleted);
  }

  void deleteAll() {
    final year = _read(activeCalendarYearProvider);
    _read(firestoreRepositoryProvider)
        .deleteAllCalendarDrawings(state!.calendar, year);
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
        if (path.contains(offset) ||
            _checkNearbyPoints(offset, drawing.pointList)) {
          print("GEFUNDEN ${drawing}");
          print("GEFUNDEN ${drawing.id}");
          toBeRemoved.add(drawing);
        }
      }
      for (var drawing in toBeRemoved) {
        _read(firestoreRepositoryProvider)
            .deleteSingleCalendarDrawings(state!.calendar, drawing);
        state = state!..drawingList.remove(drawing);
      }
    }
  }

  bool _checkNearbyPoints(Offset offset, List<Offset> pointList) {
    for (Offset point in pointList) {
      var pointDistance =
          sqrt(pow(point.dx - offset.dx, 2) + pow(point.dy - offset.dy, 2));
      if (pointDistance < 5) {
        return true;
      }
    }
    return false;
  }

  @override
  bool updateShouldNotify(
      CalendarWithDrawings? old, CalendarWithDrawings? current) {
    return true;
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
