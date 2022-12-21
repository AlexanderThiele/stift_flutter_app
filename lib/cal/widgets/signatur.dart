import 'package:flutter/material.dart';
import 'package:pencalendar/models/single_draw.dart';

class Signature extends CustomPaint {
  List<Offset> points;
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
    for (SingleDraw draw in drawingList) {
      Paint paint = Paint()
        ..color = color
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
      canvas.drawLine(points[i], points[i + 1], paint);
    }
    canvas.save();
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    if (points != oldDelegate.points) {
      return true;
    }
    if (drawingList.length != oldDelegate.drawingList.length) {
      return true;
    }
    return false;
  }
}