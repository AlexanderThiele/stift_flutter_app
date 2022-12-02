import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_color_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/single_draw.dart';
import 'package:pencalendar/utils/douglas_peucker_algorithmus.dart';

class PaintView extends ConsumerWidget {
  final Function enableZoom;
  final Function disableZoom;

  PaintView({required this.enableZoom, required this.disableZoom, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color activeColor = ref.watch(activeColorProvider);
    final double activeWidth = ref.watch(activeWidthProvider);
    final Brush activeBrush = ref.watch(activeBrushProvider);
    final CalendarWithDrawings? activeCalendar =
        ref.watch(activeCalendarControllerProvider);

    return TestState(
        ref.read(activeCalendarControllerProvider.notifier),
        enableZoom,
        disableZoom,
        activeColor,
        activeWidth,
        activeBrush,
        activeCalendar);
  }
}

class TestState extends StatefulWidget {
  final ActiveCalendarController activeCalendarController;
  final Function enableZoom;
  final Function disableZoom;
  final Color activeColor;
  final double activeWidth;
  final Brush activeBrush;
  final CalendarWithDrawings? activeCalendar;

  TestState(
      this.activeCalendarController,
      this.enableZoom,
      this.disableZoom,
      this.activeColor,
      this.activeWidth,
      this.activeBrush,
      this.activeCalendar);

  @override
  State<TestState> createState() => _TestStateState();
}

class _TestStateState extends State<TestState> {
  late double width;
  late double height;
  List<Offset> currentDrawings = [];

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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        return XGestureDetector(
            onMoveStart: (MoveEvent event) {
              widget.disableZoom();
              if (widget.activeBrush == Brush.eraser) {
                return;
              }
              print("move start");
              setState(() {
                currentDrawings.add(checkPos(event.localPos));
              });
            },
            onMoveUpdate: (MoveEvent event) {
              if (widget.activeBrush == Brush.eraser) {
                // check points
                widget.activeCalendarController
                    .onDeleteCalculation(event.localPos);
                return;
              } else {
                setState(() {
                  currentDrawings.add(checkPos(event.localPos));
                });
              }
            },
            onMoveEnd: (MoveEvent event) {
              widget.enableZoom();
              if (widget.activeBrush == Brush.eraser) {
                return;
              }
              widget.activeCalendarController.saveSignatur(
                  simplifyDouglasPeucker(currentDrawings, 0.1),
                  widget.activeColor,
                  widget.activeWidth);
              /*
              onPaintEnd.call(simplifyDouglasPeucker(currentDrawing, 0.2),
                  activeColor, activeWidth);*/
              setState(() {
                currentDrawings = [];
              });
            },
            onScaleStart: (event) {
              widget.enableZoom();
            },
            onScaleUpdate: (event) {},
            onScaleEnd: () {
              widget.disableZoom();
              setState(() {
                currentDrawings = [];
              });
            },
            child: CustomPaint(
              painter: Signature(
                  points: currentDrawings,
                  drawingList: widget.activeCalendar?.drawingList,
                  color: widget.activeColor,
                  strokeWidth: widget.activeWidth),
              size: Size.infinite,
            ));
      },
    );
  }
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
