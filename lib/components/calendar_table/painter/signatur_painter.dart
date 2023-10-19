import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pencalendar/components/calendar_table/interactive_paint_view.dart';
import 'package:pencalendar/models/single_draw.dart';

class SignaturePainter extends CustomPainter {
  List<TouchData> points;
  Color color;
  double strokeWidth;
  List<SingleDraw> drawingList;

  SignaturePainter({required this.points, required this.color, required this.strokeWidth, required this.drawingList});

  @override
  void paint(Canvas canvas, Size size) {
    // EXISTING DRAWINGS
    //print("paaaaint");
    for (SingleDraw draw in drawingList) {
      Paint paint = Paint()
        ..color = draw.color
        ..strokeJoin = StrokeJoin.round
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
  bool shouldRepaint(SignaturePainter oldDelegate) {
    // if we don't return true here, the signatures will somehow disappear
    return true;
    /*print("should repaint");
    if (points != oldDelegate.points) {
      return true;
    }
    if (drawingList.length != oldDelegate.drawingList.length) {
      return true;
    }
    return false;*/
  }
}
