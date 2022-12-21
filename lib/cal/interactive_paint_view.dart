import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/cal/cal_table.dart';
import 'package:pencalendar/cal/paint_view_light.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_color_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/utils/const/cal_size.dart';
import 'package:pencalendar/utils/douglas_peucker_algorithmus.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3, Matrix4;

class InteractivePaintView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color activeColor = ref.watch(activeColorProvider);
    final double activeWidth = ref.watch(activeWidthProvider);
    final Brush activeBrush = ref.watch(activeBrushProvider);
    final int selectedYear = ref.watch(activeCalendarYearProvider);
    final CalendarWithDrawings? activeCalendar =
        ref.watch(activeCalendarControllerProvider);
    final activeCalendarController =
        ref.read(activeCalendarControllerProvider.notifier);

    return _InteractivePaintView(selectedYear, activeColor, activeWidth,
        activeBrush, activeCalendar, activeCalendarController);
  }
}

class _InteractivePaintView extends StatefulWidget {
  final int selectedYear;
  final Color activeColor;
  final double activeWidth;
  final Brush activeBrush;
  final CalendarWithDrawings? activeCalendar;
  final ActiveCalendarController activeCalendarController;

  const _InteractivePaintView(
      this.selectedYear,
      this.activeColor,
      this.activeWidth,
      this.activeBrush,
      this.activeCalendar,
      this.activeCalendarController,
      {Key? key})
      : super(key: key);

  @override
  State<_InteractivePaintView> createState() => _InteractivePaintViewState();
}

class _InteractivePaintViewState extends State<_InteractivePaintView> {
  bool zoomEnabled = true;
  double zoomLevel = 1;

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
    if (dx > calWidth) {
      dx = calWidth;
    }
    if (dy > calHeight) {
      dy = calHeight;
    }
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return InteractiveViewer(
          constrained: false,
          clipBehavior: Clip.none,
          maxScale: 20,
          minScale: 0.5,
          boundaryMargin: EdgeInsets.all(constraints.maxWidth),
          onInteractionStart: (event) {
            print("onInteractionStart fingers: ${event.pointerCount}");
            if (event.pointerCount == 1) {
              setState(() {
                zoomEnabled = false;
              });
            } else {
              // this happens sometimes when you start with 1 finger
              // and then the second finger starts a few ms later
              if (currentDrawings.isNotEmpty) {
                currentDrawings = [];
              }
            }
          },
          onInteractionEnd: (event) {
            print("onInteractionEnd");
            setState(() {
              zoomEnabled = true;
            });
          },
          scaleEnabled: zoomEnabled,
          panEnabled: false,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 25),
            child: Stack(children: [
              CalTable(widget.selectedYear),
              StatefulBuilder(
                  // this is the actual drawing listener
                  builder: (context, setState) => Listener(
                        onPointerMove: (event) {
                          // if zoom is enabled, then don't draw. user is
                          // probably pinching
                          if (zoomEnabled) {
                            return;
                          }

                          // if eraser is on, check the positions
                          if (widget.activeBrush == Brush.eraser) {
                            // check points
                            widget.activeCalendarController
                                .onDeleteCalculation(event.localPosition);
                            return;
                          }

                          setState(() {
                            currentDrawings.add(checkPos(event.localPosition));
                          });
                        },
                        onPointerUp: (event) {
                          if (zoomEnabled) {
                            return;
                          }
                          print("points ${currentDrawings.length}");
                          // only save when there are more than 3 points
                          if (currentDrawings.length > 2) {
                            // and only do the algo when there are more than 20 points
                            // otherwise when you draw a point, then the point looks ugly
                            var points = currentDrawings;
                            if (points.length > 30) {
                              points = simplifyDouglasPeucker(
                                  currentDrawings, 0.01);
                            } else {
                              // i think the user wants to draw a point
                              // lets just take the first position
                              points = [points.first, points.last];
                            }
                            widget.activeCalendarController.saveSignatur(
                                points, widget.activeColor, widget.activeWidth);
                          }

                          setState(() {
                            currentDrawings = [];
                          });
                        },
                        child: Builder(builder: (context) {
                          if (widget.activeCalendar == null) {
                            return const SizedBox();
                          }
                          return CustomPaint(
                              painter: Signature(
                                  points: currentDrawings,
                                  drawingList:
                                      widget.activeCalendar!.drawingList,
                                  color: widget.activeColor,
                                  strokeWidth: widget.activeWidth),
                              size: const Size(calWidth, calHeight));
                        }),
                      ))
            ]),
          ));
    });
  }
}
