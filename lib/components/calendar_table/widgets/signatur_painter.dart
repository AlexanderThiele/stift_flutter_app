

import 'package:flutter/material.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/utils/app_logger.dart';

class SignaturePainter extends CustomPainter {
  List<SingleDraw> drawList;

  SignaturePainter({required this.drawList});

  @override
  void paint(Canvas canvas, Size size) {
    AppLogger.d("do paint ${drawList.length}");
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
  bool shouldRepaint(SignaturePainter oldDelegate) {
    AppLogger.d("should repaint ${oldDelegate.drawList.length != drawList.length}");
    return oldDelegate.drawList.length != drawList.length;
  }
}