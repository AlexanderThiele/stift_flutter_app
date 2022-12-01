import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_color_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/utils/douglas_peucker_algorithmus.dart';

class PaintView extends ConsumerWidget {
  final Function enableZoom;
  final Function disableZoom;
  final Function(List<Offset>, Color, double) onPaintEnd;
  final Function(Offset) checkDelete;

  final currentDrawingProvider = StateProvider<List<Offset>>((ref) => []);

  PaintView(
      {required this.enableZoom,
      required this.disableZoom,
      required this.onPaintEnd,
      required this.checkDelete,
      Key? key})
      : super(key: key);

  // final List<CompletedPaint> _points = [];
  late double width;
  late double height;

  Offset checkPos(Offset offset) {
    double dx = offset.dx;
    double dy = offset.dy;
    if (dx < 0) {
      dx = 0;
    }
    if (dy < 0) {
      dy = 0;
    }
    if (dx > width) {
      dx = width;
    }
    if (dy > height) {
      dy = height;
    }
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color activeColor = ref.watch(activeColorProvider);
    final activeWidth = ref.watch(activeWidthProvider);
    final activeBrush = ref.watch(activeBrushProvider);
    final currentDrawing = ref.watch(currentDrawingProvider);
    final activeCalendar = ref.watch(activeCalendarControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        return XGestureDetector(
            onMoveStart: (MoveEvent event) {
              disableZoom();
              if (activeBrush == Brush.eraser) {
                return;
              }
              print("move start");
              ref.read(currentDrawingProvider.notifier).state = [
                ...currentDrawing,
                event.localPos
              ];
            },
            onMoveUpdate: (MoveEvent event) {
              if (activeBrush == Brush.eraser) {
                // check points
                ref
                    .read(activeCalendarControllerProvider.notifier)
                    .onDeleteCalculation(event.localPos);
                return;
              } else {
                ref.read(currentDrawingProvider.notifier).state = [
                  ...currentDrawing,
                  event.localPos
                ];
              }
            },
            onMoveEnd: (MoveEvent event) {
              enableZoom();
              if (activeBrush == Brush.eraser) {
                return;
              }
              print("move end");
              onPaintEnd.call(simplifyDouglasPeucker(currentDrawing, 0.2),
                  activeColor, activeWidth);

              ref.read(currentDrawingProvider.notifier).state = [];
            },
            onScaleStart: (event) {
              enableZoom();
            },
            onScaleUpdate: (event) {},
            onScaleEnd: () {
              disableZoom();
              ref.read(currentDrawingProvider.notifier).state = [];
            },
            child: CustomPaint(
              painter: Signature(
                  points: currentDrawing,
                  drawingList: activeCalendar?.drawingList,
                  color: activeColor,
                  strokeWidth: activeWidth),
              size: Size.infinite,
            ));
      },
    );
  }

  _checkDelete() {}
}

class Signature extends CustomPainter {
  List<Offset> points;
  Color color;
  double strokeWidth;
  List<SingleDraw>? drawingList;

  Signature(
      {required this.points,
      required this.color,
      required this.strokeWidth,
      required this.drawingList});

  @override
  void paint(Canvas canvas, Size size) {
    // EXISTING DRAWINGS
    if (drawingList != null) {
      for (SingleDraw draw in drawingList!) {
        Paint paint = Paint()
          ..color = draw.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = draw.size;

        for (int i = 0; i < draw.pointList.length - 1; i++) {
          canvas.drawLine(draw.pointList[i], draw.pointList[i + 1], paint);
        }
      }
    }

    // CURRENT DRAWING
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    if (points != oldDelegate.points) {
      return true;
    }
    if (drawingList?.length != oldDelegate.drawingList?.length) {
      return true;
    }
    return false;
  }
}
