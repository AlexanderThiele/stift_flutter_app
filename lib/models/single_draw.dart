import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pencalendar/utils/app_logger.dart';
import 'package:pencalendar/utils/extensions/hex_color.dart';

class SingleDraw {
  String id;
  List<Offset> pointList;
  Color color;
  double size;
  int year;
  Path path = Path();

  SingleDraw(this.id, this.pointList, this.color, this.size, this.year) {
    parsePointList();
  }

  SingleDraw.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        pointList = (snapshot.data()?["point_list"] as List<dynamic>)
            .map((e) => Offset(e["dx"]!, e["dy"]!))
            .toList(),
        color = HexColor.fromHex(snapshot.data()?["color"]),
        size = snapshot.data()?["size"],
        year = snapshot.data()?["year"] {
    parsePointList();
  }

  SingleDraw.crashObject()
      : id = "crash",
        pointList = [],
        color = Colors.white,
        size = 1.0,
        year = 1999;

  void parsePointList() {
    for (int i = 0; i < pointList.length; i++) {
      if (i == 0) {
        path.moveTo(pointList[i].dx, pointList[i].dy);
      } else {
        path.lineTo(pointList[i].dx, pointList[i].dy);
      }
    }
  }

  static SingleDraw fromFirestoreWrapped(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    try {
      return SingleDraw.fromFirestore(snapshot, options);
    } on Exception catch (e) {
      AppLogger.e(e, e: e);
    }
    return SingleDraw.crashObject();
  }

  Map<String, dynamic> get toFirestore {
    AppLogger.d("to Firestore: ${toString()}");
    return {
      "point_list": pointList.map((e) => {"dx": e.dx, "dy": e.dy}).toList(),
      "color": color.toHex(),
      "size": size,
      "year": year
    };
  }
}
