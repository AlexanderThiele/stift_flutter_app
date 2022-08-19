import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';
import 'package:pencalendar/utils/douglas_peucker_algorithmus.dart';

class PaintView extends StatefulWidget {
  final Function enableZoom;
  final Function disableZoom;

  const PaintView(this.enableZoom, this.disableZoom, {Key? key}) : super(key: key);

  @override
  State createState() => _PaintViewState();
}

class _PaintViewState extends State<PaintView> {
  final List<List<Offset>> _points = [];
  List<Offset> _currentDrawing = [];
  late double width;
  late double height;

  Offset checkPos(Offset offset) {
    double dx = offset.dx;
    double dy = offset.dy;
    if(dx < 0){
      dx = 0;
    }
    if(dy < 0){
      dy = 0;
    }
    if(dx > width){
      dx = width;
    }
    if(dy > height){
      dy = height;
    }
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
          print("${event.delta} ${event.localDelta} ${event.pointer} ${event.localPos} ${event.position}");
          setState(() {
            _currentDrawing.add(checkPos(event.localPos));
          });
        },
        onMoveEnd: (MoveEvent event) {
          widget.enableZoom();
          print("move end");
          List<Offset> simplifiedPoints =
          simplifyDouglasPeucker(_currentDrawing, 0.1);
          setState(() {
            _points.add(simplifiedPoints);
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
            ..._points.map((drawing) =>
                CustomPaint(
                  painter: Signature(points: drawing),
                  size: Size.infinite,
                )),
            CustomPaint(
              painter: Signature(points: _currentDrawing),
              size: Size.infinite,
            )
          ],
        ),
      );
    },);
  }
}

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
