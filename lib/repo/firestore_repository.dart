import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/auth_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
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
      AppLogger.d("NO USER EXCEPTION");
      throw Exception("No user");
    }
    return _read(firebaseFirestoreProvider)
        .collection("calendar")
        .where("user_id", isEqualTo: currentUser.uid)
        .withConverter<Calendar>(
            fromFirestore: Calendar.fromFirestoreWrapped,
            toFirestore: (Calendar cal, _) => cal.toFirestore);
  }
}
