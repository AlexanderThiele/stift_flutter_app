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
    state = CalendarWithDrawings(calendar);
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
    state = state!..drawingList = snapshot.docs.map((e) => e.data()).toList();
  }

  void saveSignatur(List<Offset> pointList, Color color, double size) {
    print("save");
    var year = _read(activeCalendarYearProvider);
    final singleDraw = SingleDraw("", pointList, color, size, year);
    state = state!..drawingList.add(singleDraw);
    _read(firestoreRepositoryProvider)
        .createSingleCalendarDrawings(state!.calendar, singleDraw);
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
