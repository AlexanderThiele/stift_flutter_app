import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/repo/firestore_repository.dart';

final calendarControllerProvider =
    StateNotifierProvider<CalendarController, List<Calendar>>(
        (ref) => CalendarController(ref.read));

class CalendarController extends StateNotifier<List<Calendar>> {
  final Reader _read;

  StreamSubscription? _streamSubscription;

  CalendarController(this._read) : super(<Calendar>[]) {
    print("listen");
    _streamSubscription = _read(firestoreRepositoryProvider)
        .allCalendar
        .snapshots()
        .listen(onNewCalendarReceived);
  }

  onNewCalendarReceived(QuerySnapshot<Calendar> snapshot) {
    List<Calendar> updatedList = snapshot.docs.map((e) => e.data()).toList();
    updatedList.removeWhere((element) => element.isCrashObject);
    print("New FireStore Data");
    print(updatedList.length);
    state = updatedList;
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
}
