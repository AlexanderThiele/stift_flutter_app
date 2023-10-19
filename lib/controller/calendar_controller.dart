import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/repository/firestore_repository.dart';

final calendarControllerProvider =
    StateNotifierProvider<CalendarController, List<Calendar>>(
        (ref) => CalendarController(ref));

class CalendarController extends StateNotifier<List<Calendar>> {
  final StateNotifierProviderRef _ref;

  StreamSubscription? _streamSubscription;

  CalendarController(this._ref) : super(<Calendar>[]) {
    _streamSubscription = _ref.read(firestoreRepositoryProvider)
        .allCalendar
        .snapshots()
        .listen(onNewCalendarReceived);
  }

  initCalendar() async {
    // hmm nothing to init?
  }

  onNewCalendarReceived(QuerySnapshot<Calendar> snapshot) {
    List<Calendar> updatedList = snapshot.docs.map((e) => e.data()).toList();
    updatedList.removeWhere((element) => element.isCrashObject);
    state = updatedList;

    if (snapshot.size == 0) {
      _createDefaultCalendar();
    } else {
      _ref.read(activeCalendarControllerProvider.notifier).onNewCalendarReceived(updatedList);
    }
  }

  @override
  bool updateShouldNotify(List old, List current) {
    return true;
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  _createDefaultCalendar() {
    _ref.read(firestoreRepositoryProvider).createCalendar("default");
  }
}
