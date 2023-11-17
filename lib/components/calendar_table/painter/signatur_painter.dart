import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/components/calendar_table/interactive_paint_view.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:pencalendar/utils/const/cal_size.dart';

class SignaturePainerWrapper extends ConsumerWidget {
  final List<TouchData> currentDrawings;

  const SignaturePainerWrapper(this.currentDrawings, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CalendarWithDrawings? activeCalendar = ref.watch(activeCalendarControllerProvider);
    final Color activeColor = ref.watch(activeColorProvider);
    final double activeWidth = ref.watch(activeWidthProvider);
    if (activeCalendar == null) {
      return const SizedBox();
    }
    return CustomPaint(
        painter: SignaturePainter(
            points: currentDrawings,
            drawingList: activeCalendar.drawingList,
            color: activeColor,
            strokeWidth: activeWidth),
        size: const Size(calWidth, calHeight));
  }
}

class SignaturePainter extends CustomPainter {
  final List<TouchData> points;
  Color color;
  double strokeWidth;
  List<SingleDraw> drawingList;

  /// this is to optimize the paint method
  int drawingListLastLength = 0;

  SignaturePainter({required this.points, required this.color, required this.strokeWidth, required this.drawingList});

  @override
  void paint(Canvas canvas, Size size) {
    // EXISTING DRAWINGS
    for (SingleDraw draw in drawingList) {
      Paint paint = Paint()
        ..color = draw.color
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = draw.size;
      canvas.drawPath(draw.path, paint);
    }

    if (points.isEmpty) {
      return;
    }

    // CURRENT DRAWING
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;
    canvas.drawPoints(PointMode.polygon, [for (int i = 0; i < points.length; i++) points[i].offset].toList(), paint);
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    if (drawingList.length != oldDelegate.drawingListLastLength) {
      // we have to set the drawingNumber of the oldDelegate somehow. idk why tbh.
      oldDelegate.drawingListLastLength = drawingList.length;
      return true;
    }
    drawingListLastLength = drawingList.length;

    if (points.isNotEmpty) {
      // always repaint when points are not empty
      // points == current drawings
      return true;
    }
    return false;
  }
}
