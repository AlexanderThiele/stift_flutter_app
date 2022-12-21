import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/auth_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/riverpod/rp_firebase.dart';
import 'package:pencalendar/utils/app_logger.dart';

final firestoreRepositoryProvider =
    Provider<FirestoreRepository>((ref) => FirestoreRepository(ref.read));

class FirestoreRepository {
  final Reader _read;

  FirestoreRepository(this._read);

  Query<Calendar> get allCalendar {
    User? currentUser = _read(authControllerProvider);

    if (currentUser == null) {
      AppLogger.e("NO USER EXCEPTION");
      throw Exception("No user");
    }

    return _read(firebaseFirestoreProvider)
        .collection("calendar")
        .where("user_id", isEqualTo: currentUser.uid)
        .withConverter<Calendar>(
            fromFirestore: Calendar.fromFirestoreWrapped,
            toFirestore: (Calendar cal, _) => cal.toFirestore);
  }

  Future createCalendar(String name) {
    User? currentUser = _read(authControllerProvider);

    if (currentUser == null) {
      AppLogger.e("NO USER EXCEPTION");
      throw Exception("No user");
    }

    AppLogger.d("Create Calendar");

    return _read(firebaseFirestoreProvider)
        .collection("calendar")
        .add(Calendar.create(user_id: currentUser.uid, name: name).toFirestore);
  }

  Query<SingleDraw> getSingleCalendarDrawings(Calendar calendar, int year) {
    return _read(firebaseFirestoreProvider)
        .collection("calendar")
        .doc(calendar.id)
        .collection("drawings")
        .where("year", isEqualTo: year)
        .withConverter(
            fromFirestore: SingleDraw.fromFirestoreWrapped,
            toFirestore: (SingleDraw sdraw, _) => sdraw.toFirestore);
  }

  Future createSingleCalendarDrawings(
      Calendar calendar, SingleDraw singleDraw, String id) {
    return _read(firebaseFirestoreProvider)
        .collection("calendar")
        .doc(calendar.id)
        .collection("drawings")
        .doc(id)
        .set(singleDraw.toFirestore);
  }

  Future deleteSingleCalendarDrawings(
      Calendar calendar, SingleDraw singleDraw) {
    return _read(firebaseFirestoreProvider)
        .collection("calendar")
        .doc(calendar.id)
        .collection("drawings")
        .doc(singleDraw.id)
        .delete();
  }

  Future deleteAllCalendarDrawings(Calendar calendar, year) async {
    final snapshots = await _read(firebaseFirestoreProvider)
        .collection("calendar")
        .doc(calendar.id)
        .collection("drawings")
        .where("year", isEqualTo: year)
        .get();
    final batch = FirebaseFirestore.instance.batch();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
