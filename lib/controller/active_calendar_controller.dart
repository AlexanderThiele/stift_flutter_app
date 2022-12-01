import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/repo/firestore_repository.dart';
import 'package:pencalendar/utils/app_logger.dart';

final activeCalendarControllerProvider =
    StateNotifierProvider<ActiveCalendarController, CalendarWithDrawings?>(
        (ref) => ActiveCalendarController(ref.read));

final activeCalendarYearProvider = StateProvider((ref) => DateTime.now().year);

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
    _read(activeCalendarYearProvider.notifier).state = year;
    if (state != null) {
      selectCalendar(state!.calendar);
    } else {
      AppLogger.e("Change year but the calendar is null");
    }
  }

  onNewDrawingReceived(QuerySnapshot<SingleDraw> snapshot) {
    print("new drawing");
    print("size ${snapshot.size}");
    final List<SingleDraw> drawList = [];
    for (var singleDraw in snapshot.docChanges) {
      print(singleDraw.type);
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
    print("save");
    var year = _read(activeCalendarYearProvider);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final singleDraw = SingleDraw(id, pointList, color, size, year);
    state = state!..drawingList.add(singleDraw);
    _read(firestoreRepositoryProvider)
        .createSingleCalendarDrawings(state!.calendar, singleDraw, id).then((value) => print("value")).timeout(Duration(seconds: 4));
  }

  onDeleteCalculation(Offset offset) {
    if (state != null) {
      for (var drawing in state!.drawingList) {
        final path = Path();

        for (int i = 0; i < drawing.pointList.length; i++) {
          if (i == 0) {
            path.moveTo(drawing.pointList[i].dx, drawing.pointList[i].dy);
          } else {
            path.lineTo(drawing.pointList[i].dx, drawing.pointList[i].dy);
          }
        }
        if (path.contains(offset)) {
          print("GEFUNDEN ${drawing}");
          print("GEFUNDEN ${drawing.id}");
          _read(firestoreRepositoryProvider)
              .deleteSingleCalendarDrawings(state!.calendar, drawing);
          state = state!..drawingList.remove(drawing);
        }
      }
    }
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
