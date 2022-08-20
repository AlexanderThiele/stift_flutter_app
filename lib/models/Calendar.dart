import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pencalendar/utils/app_logger.dart';

class Calendar {
  String id;
  String name;
  String user_id;

  Calendar.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        name = snapshot.data()?["name"],
        user_id  = snapshot.data()?["user_id"];

  Calendar.crashObject()
      : id = "crash",
        name = "crash",
        user_id = "crash";

  static Calendar fromFirestoreWrapped(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    try {
      return Calendar.fromFirestore(snapshot, options);
    } on Exception catch (e) {
      AppLogger.e(e, e: e);
    }
    return Calendar.crashObject();
  }


  Map<String, dynamic> get toFirestore {
    return {
      if (name != null) "name": name
    };
  }

  bool get isCrashObject => id == "crash";
}
