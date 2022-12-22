import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/cal/interactive_paint_view.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_color_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/utils/douglas_peucker_algorithmus.dart';

class Signature extends CustomPainter {
  List<TouchData> points;
  Color color;
  double strokeWidth;
  List<SingleDraw> drawingList;

  Signature(
      {required this.points,
      required this.color,
      required this.strokeWidth,
      required this.drawingList});

  @override
  void paint(Canvas canvas, Size size) {
    // EXISTING DRAWINGS
    //print("paaaaint");
    for (SingleDraw draw in drawingList) {
      Paint paint = Paint()
        ..color = draw.color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = draw.size;
      canvas.drawPath(draw.path, paint);
    }

    // CURRENT DRAWING
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i].offset, points[i + 1].offset, paint);
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    return true;
    print("should repaint");
    if (points != oldDelegate.points) {
      return true;
    }
    if (drawingList.length != oldDelegate.drawingList.length) {
      return true;
    }
    return false;
  }
}
