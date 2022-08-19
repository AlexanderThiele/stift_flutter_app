import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:pencalendar/utils/douglas_peucker_algorithmus.dart';

class PaintView extends StatefulWidget {
  final Function enableZoom;
  final Function disableZoom;
  final Color color;

  const PaintView(
      {required this.enableZoom,
      required this.disableZoom,
      required this.color,
      Key? key})
      : super(key: key);

  @override
  State createState() => _PaintViewState();
}

class _PaintViewState extends State<PaintView> {
  final List<CompletedPaint> _points = [];
  List<Offset> _currentDrawing = [];
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        return XGestureDetector(
          onMoveStart: (MoveEvent event) {
            widget.disableZoom();
            print("move start");
            setState(() {
              _currentDrawing.add(event.localPos);
            });
          },
          onMoveUpdate: (MoveEvent event) {
            setState(() {
              _currentDrawing.add(checkPos(event.localPos));
            });
          },
          onMoveEnd: (MoveEvent event) {
            widget.enableZoom();
            print("move end");
            setState(() {
              _points.add(CompletedPaint(_currentDrawing, widget.color));
              _currentDrawing = [];
            });
          },
          onScaleStart: (event) {
            widget.enableZoom();
            print("scale start");
          },
          onScaleUpdate: (event) {},
          onScaleEnd: () {
            widget.disableZoom();
            _currentDrawing.clear();
            print("scale end");
          },
          child: Stack(
            children: [
              ..._points.map((completedPaint) => CustomPaint(
                    painter: completedPaint.signature,
                    size: Size.infinite,
                  )),
              CustomPaint(
                painter:
                    Signature(points: _currentDrawing, color: widget.color),
                size: Size.infinite,
              )
            ],
          ),
        );
      },
    );
  }
}

class CompletedPaint {
  late List<Offset> pointList;
  Color color;

  CompletedPaint(List<Offset> completePointList, this.color){
    pointList = simplifyDouglasPeucker(completePointList, 0.2);
    print("from ${completePointList.length} to ${pointList.length}");
  }

  get signature => Signature(points: pointList, color: color);
}

class Signature extends CustomPainter {
  List<Offset> points;
  Color color;

  Signature({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.5;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
