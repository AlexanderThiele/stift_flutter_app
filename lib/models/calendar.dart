// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pencalendar/utils/app_logger.dart';

class Calendar {
  /// firebase ID
  String id;
  String name;
  String user_id;

  Calendar.create({
    required this.user_id,
    required this.name,
  }) : id = "";

  Calendar.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        name = snapshot.data()?["name"],
        user_id = snapshot.data()?["user_id"];

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
    AppLogger.d("to Firestore: ${toString()}");
    return {
      if (name != null) "name": name,
      if (user_id != null) "user_id": user_id,
    };
  }

  bool get isCrashObject => id == "crash";

  @override
  String toString() {
    return "$id, $name, $user_id";
  }
}
