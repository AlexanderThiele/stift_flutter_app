

import 'package:flutter/material.dart';
import 'package:pencalendar/models/single_draw.dart';

class SignaturePainter extends CustomPainter {
  List<SingleDraw> drawList;

  SignaturePainter({required this.drawList});

  @override
  void paint(Canvas canvas, Size size) {
    for (SingleDraw draw in drawList) {
      Paint paint = Paint()
        ..color = draw.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = draw.size;

      for (int i = 0; i < draw.pointList.length - 1; i++) {
        canvas.drawLine(draw.pointList[i], draw.pointList[i + 1], paint);
      }
    }

  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => oldDelegate.drawList.length != drawList.length;
}
