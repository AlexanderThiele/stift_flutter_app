import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/cal/cal_table.dart';
import 'package:pencalendar/cal/signature.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_color_controller.dart';
import 'package:pencalendar/controller/active_touch_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/controller/public_holiday_controller.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/calendar_with_drawings.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:pencalendar/utils/const/cal_size.dart';
import 'package:pencalendar/utils/douglas_peucker_algorithmus.dart';

class InteractivePaintView extends ConsumerWidget {
  const InteractivePaintView({Key? key}) : super(key: key);

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
    final touchDrawEnabled = ref.watch(activeTouchProvider);
    final publicHolidays = ref.watch(publicHolidayControllerProvider);

    return _InteractivePaintView(
        selectedYear,
        activeColor,
        activeWidth,
        activeBrush,
        activeCalendar,
        touchDrawEnabled,
        activeCalendarController,
        publicHolidays ?? []);
  }
}

class _InteractivePaintView extends StatefulWidget {
  final int selectedYear;
  final Color activeColor;
  final double activeWidth;
  final Brush activeBrush;
  final CalendarWithDrawings? activeCalendar;
  final bool touchDrawEnabled;
  final ActiveCalendarController activeCalendarController;
  final List<PublicHoliday> publicHolidays;

  const _InteractivePaintView(
      this.selectedYear,
      this.activeColor,
      this.activeWidth,
      this.activeBrush,
      this.activeCalendar,
      this.touchDrawEnabled,
      this.activeCalendarController,
      this.publicHolidays,
      {Key? key})
      : super(key: key);

  @override
  State<_InteractivePaintView> createState() => _InteractivePaintViewState();
}

class _InteractivePaintViewState extends State<_InteractivePaintView> {
  bool zoomEnabled = true;
  double zoomLevel = 1;

  List<TouchData> currentDrawings = [];

  // if this is set to true, then we filter all non stylus events and do
  // not allow any events that are not stylus
  bool enforceStylus = false;

  Offset offsetInFrame(Offset offset) {
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
              CalTable(widget.selectedYear, widget.publicHolidays),
              StatefulBuilder(
                  // this is the actual drawing listener
                  builder: (BuildContext context, StateSetter setState) =>
                      Listener(
                        onPointerMove: (event) {
                          onPointerMove(event, setState);
                        },
                        onPointerUp: (event) {
                          onPointerUp(event, setState);
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

  void onPointerMove(PointerMoveEvent event, StateSetter setState) {
    // if zoom is enabled, then don't draw. user is
    // probably pinching
    if (zoomEnabled) {
      return;
    }

    // enforce original event to check of stylus etc.
    // not sure if this creates weird behaviour? lets see
    final originalEvent = event.original;
    if (originalEvent == null) {
      return;
    }

    // if touch draw is not enabled, do nothing with anything
    // that is not a stylus
    if (widget.touchDrawEnabled == false) {
      if (originalEvent.kind != PointerDeviceKind.stylus) {
        return;
      }
    }

    // if stylus is enforced, don't accept any events that are not stylus
    if (enforceStylus == true &&
        originalEvent.kind != PointerDeviceKind.stylus) {
      return;
    }

    // either a stylus event or a touch is also allowed

    // if eraser is on, check the positions
    if (widget.activeBrush == Brush.eraser) {
      // check points
      widget.activeCalendarController.onDeleteCalculation(event.localPosition);
      return;
    }

    // check if we handled the case where the user starts with a non stylus event
    // and then starts drawing with a stylus.
    // we then delete all events that were not a stylus event
    if (enforceStylus == false &&
        originalEvent.kind == PointerDeviceKind.stylus) {
      // we filter all events that are not stylus
      currentDrawings
          .removeWhere((element) => element.kind != PointerDeviceKind.stylus);
      enforceStylus = true;
      print("enforce Stylus");
    }

    // print(originalEvent.kind);

    setState(() {
      currentDrawings.add(TouchData(offsetInFrame(event.localPosition),
          originalEvent.kind, originalEvent.pointer));
    });
  }

  void onPointerUp(PointerUpEvent event, StateSetter setState) {
    if (zoomEnabled) {
      return;
    }
    print("points ${currentDrawings.length}");

    if (currentDrawings.isEmpty) {
      // do nothing if empty
      return;
    }
    if (currentDrawings.length == 1) {
      // if less then 2 points, generate a point 1px next to it
      final touchData = currentDrawings.first;
      currentDrawings.add(TouchData(
          Offset(touchData.offset.dx + 1, touchData.offset.dy),
          touchData.kind,
          touchData.pointerId));
    }
    // and only do the algo when there are more than 20 points
    // otherwise when you draw a point, then the point looks ugly
    var points = currentDrawings.map((touchData) => touchData.offset).toList();
    // FILTER Points

    if (enforceStylus == true) {
      // means that this is a stylus drawing
      if (points.length > 10) {
        points = simplifyDouglasPeucker(points, 0.003);
      } else {
        // i think the user wants to draw a point
        // lets just take the first position
        points = [points.first, points.last];
      }
    } else {
      // only touch event, use every point we can use
      // there are a lot less points if we draw with fingers.
      if (points.length > 10) {
        points = simplifyDouglasPeucker(points, 0.003);
      } else {
        // i think the user wants to draw a point
        // lets just take the first position
        points = [points.first, points.last];
      }
    }

    // save
    widget.activeCalendarController
        .saveSignatur(points, widget.activeColor, widget.activeWidth);

    setState(() {
      currentDrawings = [];
      enforceStylus = false;
    });
  }
}

class TouchData {
  final Offset offset;

  /// either stylus or sth else
  final PointerDeviceKind kind;

  /// every pointer has an ID which is unique
  final int pointerId;

  TouchData(this.offset, this.kind, this.pointerId);
}
