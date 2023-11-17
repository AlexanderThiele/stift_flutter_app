import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pencalendar/components/calendar_table/cal_table.dart';
import 'package:pencalendar/components/calendar_table/painter/signatur_painter.dart';
import 'package:pencalendar/components/shader/splash_shader.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/controller/public_holiday_controller.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:pencalendar/models/shader_type.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:pencalendar/utils/app_logger.dart';
import 'package:pencalendar/utils/const/cal_size.dart';
import 'package:pencalendar/utils/douglas_peucker_algorithmus.dart';

class InteractivePaintView extends ConsumerWidget {
  const InteractivePaintView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Brush activeBrush = ref.watch(activeBrushProvider);
    final int selectedYear = ref.watch(activeCalendarYearProvider);
    final activeCalendarController = ref.read(activeCalendarControllerProvider.notifier);
    final touchDrawEnabled = ref.watch(activeTouchProvider);
    final publicHolidays = ref.watch(publicHolidayControllerProvider);
    final activeShaderType = ref.watch(activeShaderProvider);
    return _InteractivePaintView(
      selectedYear,
      activeBrush,
      touchDrawEnabled,
      activeCalendarController,
      publicHolidays ?? [],
      activeShaderType,
    );
  }
}

class _InteractivePaintView extends StatefulWidget {
  final int selectedYear;
  final Brush activeBrush;
  final bool touchDrawEnabled;
  final ActiveCalendarController activeCalendarController;
  final List<PublicHoliday> publicHolidays;
  final ShaderType activeShaderType;

  const _InteractivePaintView(this.selectedYear, this.activeBrush, this.touchDrawEnabled, this.activeCalendarController,
      this.publicHolidays, this.activeShaderType);

  @override
  State<_InteractivePaintView> createState() => _InteractivePaintViewState();
}

class _InteractivePaintViewState extends State<_InteractivePaintView> {
  bool zoomEnabled = true;
  double zoomLevel = 1;

  List<TouchData> currentDrawings = [];
  Offset? lastTouchOffset;
  PointerMoveEvent? lastInfoEvent;

  // if this is set to true, then we filter all non stylus events and do
  // not allow any events that are not stylus
  bool enforceStylus = false;

  Offset calculateOffsetInFrame(Offset offset) {
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
        onInteractionStart: (ScaleStartDetails event) {
          AppLogger.d("onInteractionStart fingers: ${event.pointerCount}");
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
          AppLogger.d("onInteractionEnd");
          setState(() {
            zoomEnabled = true;
          });
        },
        scaleEnabled: zoomEnabled,
        panEnabled: false,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 25),
          child: Stack(children: [
            CalTable(year: widget.selectedYear, publicHolidays: widget.publicHolidays),
            StatefulBuilder(
              // this is the actual drawing listener
              builder: (BuildContext context, StateSetter setState) => Stack(
                children: [
                  if (widget.activeShaderType != ShaderType.none)
                    SplashSmallShader(
                      mousePosition: lastTouchOffset,
                      activeShaderType: widget.activeShaderType,
                    ),
                  Listener(
                    onPointerMove: (event) {
                      onPointerMove(event, setState);
                    },
                    onPointerUp: (event) {
                      onPointerUp(event, setState);
                    },
                    child: Stack(children: [
                      SignaturePainerWrapper(currentDrawings),
                      Builder(
                        builder: (context) {
                          if (lastInfoEvent == null) {
                            return const SizedBox();
                          }
                          if (widget.activeBrush != Brush.eraser) {
                            return const SizedBox();
                          }
                          return Positioned(
                              left: lastInfoEvent!.localPosition.dx - 9,
                              top: lastInfoEvent!.localPosition.dy - 9,
                              child: Icon(
                                FontAwesomeIcons.eraser,
                                color: Colors.black.withOpacity(0.5),
                                size: 18,
                              ));
                        },
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ]),
        ),
      );
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

    setState(() {
      lastInfoEvent = event;
    });

    // if touch draw is not enabled, do nothing with anything
    // that is not a stylus
    if (widget.touchDrawEnabled == false) {
      if (originalEvent.kind != PointerDeviceKind.stylus) {
        return;
      }
    }

    // if stylus is enforced, don't accept any events that are not stylus
    // enforceStylus is true whenever we start to draw with a stylus.
    if (enforceStylus == true && originalEvent.kind != PointerDeviceKind.stylus) {
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
    if (enforceStylus == false && originalEvent.kind == PointerDeviceKind.stylus) {
      // we filter all events that are not stylus
      currentDrawings.removeWhere((element) => element.kind != PointerDeviceKind.stylus);
      enforceStylus = true;
      AppLogger.d("enforce Stylus");
    }
    // print(originalEvent.kind);

    final pressure = originalEvent.pressure == 0 ? 0.5 : originalEvent.pressure;
    setState(() {
      final offsetInFrame = calculateOffsetInFrame(event.localPosition);
      lastTouchOffset = offsetInFrame;
      currentDrawings.add(TouchData(offsetInFrame, originalEvent.kind, pressure));
    });
  }

  void onPointerUp(PointerUpEvent event, StateSetter setState) {
    if (zoomEnabled) {
      return;
    }
    AppLogger.d("points ${currentDrawings.length}");

    if (currentDrawings.isEmpty) {
      // do nothing if empty

      resetState();
      return;
    }
    if (currentDrawings.length == 1) {
      // if less then 2 points, generate a point 1px next to it
      final touchData = currentDrawings.first;
      currentDrawings
          .add(TouchData(Offset(touchData.offset.dx + 1, touchData.offset.dy), touchData.kind, touchData.pressure));
    }
    // and only do the algo when there are more than 20 points
    // otherwise when you draw a point, then the point looks ugly
    // FILTER Points

    if (enforceStylus == true) {
      // means that this is a stylus drawing
      if (currentDrawings.length > 10) {
        currentDrawings = simplifyDouglasPeucker(currentDrawings, 0.003);
      } else {
        // i think the user wants to draw a point
        // lets just take the first position
        currentDrawings = [currentDrawings.first, currentDrawings.last];
      }
    } else {
      // only touch event, use every point we can use
      // there are a lot less points if we draw with fingers.
      if (currentDrawings.length > 10) {
        currentDrawings = simplifyDouglasPeucker(currentDrawings, 0.003);
      } else {
        // i think the user wants to draw a point
        // lets just take the first position
        currentDrawings = [currentDrawings.first, currentDrawings.last];
      }
    }

    // save
    widget.activeCalendarController.saveSignatur(currentDrawings, isStylusDrawing: enforceStylus);
    resetState();
  }

  void resetState() {
    setState(() {
      currentDrawings = [];
      lastTouchOffset = null;
      lastInfoEvent = null;
      enforceStylus = false;
    });
  }
}

class TouchData {
  final Offset offset;

  /// either stylus or sth else
  final PointerDeviceKind kind;

  final double pressure;

  const TouchData(this.offset, this.kind, this.pressure);
}
