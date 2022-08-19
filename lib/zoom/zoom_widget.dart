library zoom_widget;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pencalendar/zoom/MultiTouchGestureRecognizer.dart';

class Zoom extends StatefulWidget {
  final double maxZoomWidth, maxZoomHeight;

  final Widget child;
  final Color backgroundColor;
  final Color canvasColor;
  final void Function(Offset)? onPositionUpdate;
  final void Function(double, double)? onScaleUpdate;
  final double scrollWeight;
  final double opacityScrollBars;
  final Color colorScrollBars;
  final bool centerOnScale;
  final double initZoom;
  final Offset initialPos;
  final bool enableScroll;
  final double zoomSensibility;
  final bool doubleTapZoom;
  final BoxShadow? canvasShadow;
  final void Function()? onTap;
  final bool enabled;

  Zoom(
      {Key? key,
      double? maxZoomWidth,
      double? maxZoomHeight,
      required this.child,
      @Deprecated('use maxZoomWidth instead') double? width,
      @Deprecated('use maxZoomHeight instead') double? height,
      this.onPositionUpdate,
      this.onScaleUpdate,
      this.backgroundColor = Colors.grey,
      this.canvasColor = Colors.white,
      this.scrollWeight = 7.0,
      this.opacityScrollBars = 0.5,
      this.colorScrollBars = Colors.black,
      this.centerOnScale = true,
      this.initZoom = 1.0,
      this.initialPos = const Offset(0, 0),
      this.enableScroll = true,
      this.zoomSensibility = 1.0,
      this.doubleTapZoom = true,
      this.canvasShadow,
      this.onTap,
      this.enabled = true})
      : assert(
          maxZoomWidth != null || width != null,
          'maxZoomWidth or width must not be null',
        ),
        assert(
          maxZoomHeight != null || height != null,
          'maxZoomHeight or height must not be null',
        ),
        this.maxZoomHeight = (maxZoomHeight ?? height)!,
        this.maxZoomWidth = (maxZoomWidth ?? width)!,
        super(key: key);

  _ZoomState createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> with TickerProviderStateMixin {
  double localTop = 0.0;
  double changeTop = 0.0;
  double auxTop = 0.0;
  double centerTop = 0.0;
  double scaleTop = 0.0;
  double downTouchTop = 0.0;
  double localLeft = 0.0;
  double changeLeft = 0.0;
  double auxLeft = 0.0;
  double centerLeft = 0.0;
  double downTouchLeft = 0.0;
  double scaleLeft = 0.0;
  double scale = 1.0;
  double changeScale = 0.0;
  double zoom = 0.0;
  Offset midlePoint = Offset(0.0, 0.0);
  Offset relativeMidlePoint = Offset(0.0, 0.0);
  bool initOrientation = false;
  late bool portrait;
  late AnimationController scaleAnimation;
  late bool doubleTapDown;
  double doubleTapScale = 0.0;
  late BoxConstraints globalConstraints;

  double movePosTopLast = 0.0;
  double movePosTopCurrent = 0.0;
  double movePosLeftLast = 0.0;
  double movePosLeftCurrent = 0.0;

  @override
  void initState() {
    auxTop = widget.initialPos.dy;
    auxLeft = widget.initialPos.dx;
    scaleAnimation = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 250));
    scaleAnimation.addListener(() {
      setState(() {
        if (doubleTapDown) {
          scale = map(scaleAnimation.value, 0.0, 1.0, doubleTapScale, 1.0);
        } else {
          scale = map(
              scaleAnimation.value,
              0.0,
              1.0,
              doubleTapScale,
              (globalConstraints.maxHeight > globalConstraints.maxWidth)
                  ? globalConstraints.maxWidth / widget.maxZoomWidth
                  : globalConstraints.maxHeight / widget.maxZoomHeight);
        }

        scaleProcess(globalConstraints);
        scaleFixPosition(globalConstraints);
      });
      if (scaleAnimation.value == 1.0 && widget.onScaleUpdate != null) {
        if (widget.onScaleUpdate != null) {
          widget.onScaleUpdate!(scale, zoom);
        }
        if (widget.onPositionUpdate != null) {
          widget.onPositionUpdate!(
            Offset(
              (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
              (auxTop + localTop + centerTop + scaleTop) * -1,
            ),
          );
        }

        endEscale(globalConstraints);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scaleAnimation.dispose();
    super.dispose();
  }

  double map(
      double x, double inMin, double inMax, double outMin, double outMax) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }

  void scaleFixPosition(constraints) {
    if (((widget.maxZoomHeight * scale) > constraints.maxHeight) &&
        ((auxTop + localTop + centerTop + scaleTop) +
                (widget.maxZoomHeight * scale)) <
            constraints.maxHeight) {
      localTop += constraints.maxHeight -
          ((auxTop + localTop + centerTop + scaleTop) +
              widget.maxZoomHeight * scale);
    }

    if (((widget.maxZoomWidth * scale) > constraints.maxWidth) &&
        ((auxLeft + localLeft + centerLeft + scaleLeft) +
                (widget.maxZoomWidth * scale)) <
            constraints.maxWidth) {
      localLeft += constraints.maxWidth -
          ((auxLeft + localLeft + centerLeft + scaleLeft) +
              widget.maxZoomWidth * scale);
    }

    if ((widget.maxZoomHeight * scale) < constraints.maxHeight) {
      if (widget.centerOnScale) {
        centerTop = (constraints.maxHeight - widget.maxZoomHeight * scale) / 2;
      }
    } else
      centerTop = 0.0;

    if ((widget.maxZoomWidth * scale) < constraints.maxWidth) {
      if (widget.centerOnScale) {
        centerLeft = (constraints.maxWidth - widget.maxZoomWidth * scale) / 2;
      }
    } else
      centerLeft = 0.0;

    zoom = map(
        scale,
        1.0,
        (constraints.maxHeight > constraints.maxWidth)
            ? constraints.maxWidth / widget.maxZoomWidth
            : constraints.maxHeight / widget.maxZoomHeight,
        1.0,
        0.0);
  }

  void scaleProcess(constraints) {
    Offset currentMidlePoint = Offset(
        ((auxLeft + localLeft + centerLeft) * -1 + midlePoint.dx) *
                (1 / scale) -
            localLeft,
        ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) * (1 / scale));

    if (currentMidlePoint.dx > relativeMidlePoint.dx) {
      double preScaleLeft =
          (currentMidlePoint.dx - relativeMidlePoint.dx) * scale;
      if (auxLeft + localLeft + preScaleLeft < 0) {
        scaleLeft = preScaleLeft;
      }
    } else {
      double preScaleLeft =
          (relativeMidlePoint.dx - currentMidlePoint.dx) * -scale;
      if ((auxLeft + localLeft + preScaleLeft) >
          -((widget.maxZoomWidth * scale) - constraints.maxWidth * scale))
        scaleLeft = preScaleLeft;
    }

    if (currentMidlePoint.dy > relativeMidlePoint.dy) {
      double preScaleTop =
          (currentMidlePoint.dy - relativeMidlePoint.dy) * scale;
      if (auxTop + localTop + preScaleTop < 0) {
        scaleTop = preScaleTop;
      }
    } else {
      double preScaleTop =
          (relativeMidlePoint.dy - currentMidlePoint.dy) * -scale;
      if ((auxTop + localTop + preScaleTop) >
          -((widget.maxZoomHeight * scale) - constraints.maxHeight * scale))
        scaleTop = preScaleTop;
    }
  }

  void endEscale(constraints) {
    auxTop += localTop + scaleTop;
    auxLeft += localLeft + scaleLeft;
    scaleLeft = 0;
    scaleTop = 0;
    localTop = 0;
    localLeft = 0;
    downTouchLeft = 0;
    downTouchTop = 0;
    print("left cur: $movePosLeftCurrent last: $movePosLeftLast");
    movePosLeftLast += movePosLeftCurrent;
    movePosTopLast += movePosTopCurrent;
    movePosLeftCurrent = 0;
    movePosTopCurrent = 0;
    if (auxLeft > 0) auxLeft = 0;
    if (auxTop > 0) auxTop = 0;

    if (widget.maxZoomHeight * scale < constraints.maxHeight && auxTop < 0) {
      auxTop = 0;
    }

    if (widget.maxZoomWidth * scale < constraints.maxWidth && auxLeft < 0) {
      auxLeft = 0;
    }

    if (widget.centerOnScale) {
      if (portrait) {
        if (widget.maxZoomHeight * scale < constraints.maxHeight) {
          centerTop =
              (constraints.maxHeight - widget.maxZoomHeight * scale) / 2;
        }
      } else {
        if (widget.maxZoomWidth * scale < constraints.maxWidth) {
          centerLeft = (constraints.maxWidth - widget.maxZoomWidth * scale) / 2;
        }
      }
    }

    if (constraints.maxHeight > constraints.maxWidth &&
        widget.maxZoomWidth * scale < constraints.maxWidth) {
      setState(() {
        scale = constraints.maxWidth / widget.maxZoomWidth;
      });
    }

    if (constraints.maxWidth > constraints.maxHeight &&
        widget.maxZoomHeight * scale < constraints.maxHeight) {
      setState(() {
        scale = constraints.maxHeight / widget.maxZoomHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        globalConstraints = constraints;
        if (!initOrientation) {
          scale = map(
              widget.initZoom,
              1.0,
              0.0,
              1.0,
              (constraints.maxHeight > constraints.maxWidth)
                  ? constraints.maxWidth / widget.maxZoomWidth
                  : constraints.maxHeight / widget.maxZoomHeight);
          initOrientation = true;
          portrait =
              (constraints.maxHeight > constraints.maxWidth) ? true : false;

          if (widget.centerOnScale) {
            if (portrait) {
              if (widget.maxZoomHeight * scale < constraints.maxHeight) {
                centerTop =
                    (constraints.maxHeight - widget.maxZoomHeight * scale) / 2;
              }
            } else {
              if (widget.maxZoomWidth * scale < constraints.maxWidth) {
                centerLeft =
                    (constraints.maxWidth - widget.maxZoomWidth * scale) / 2;
              }
            }
          }
          if (widget.onScaleUpdate != null) {
            widget.onScaleUpdate!(scale, widget.initZoom);
          }

          if (widget.onPositionUpdate != null) {
            widget.onPositionUpdate!(
              Offset(
                (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
                (auxTop + localTop + centerTop + scaleTop) * -1,
              ),
            );
          }
        }

        if (!portrait && constraints.maxHeight > constraints.maxWidth) {
          portrait = true;
          centerTop = 0;
          centerLeft = 0;
          scale = 1.0;
        } else if (portrait && constraints.maxHeight <= constraints.maxWidth) {
          portrait = false;
          centerTop = 0;
          centerLeft = 0;
          scale = 1.0;
        }

        return RawGestureDetector(
          gestures: {
            MultiTouchGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                MultiTouchGestureRecognizer>(
              () => MultiTouchGestureRecognizer(),
              (MultiTouchGestureRecognizer instance) {
                instance.onSingleTap = (point) {
                  if (widget.doubleTapZoom) {
                    midlePoint = point;
                    relativeMidlePoint = Offset(
                        ((auxLeft + localLeft + centerLeft) * -1 +
                                midlePoint.dx) *
                            (1 / scale),
                        ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) *
                            (1 / scale));
                  }
                };
                instance.onMultiTap = (firstPoint, secondPoint) {
                  midlePoint = Offset((firstPoint.dx + secondPoint.dx) / 2.0,
                      (firstPoint.dy + secondPoint.dy) / 2.0);

                  relativeMidlePoint = Offset(
                      ((auxLeft + localLeft + centerLeft) * -1 +
                              midlePoint.dx) *
                          (1 / scale),
                      ((auxTop + localTop + centerTop) * -1 + midlePoint.dy) *
                          (1 / scale));
                };
              },
            ),
          },
          child: GestureDetector(
            onTap: widget.onTap,
            onDoubleTap: () {
              if (widget.doubleTapZoom) {
                doubleTapScale = scale;

                if (scale >= 0.99) {
                  doubleTapDown = false;
                } else {
                  doubleTapDown = true;
                }
                scaleAnimation.forward(from: 0.0);
              }
            },
            onScaleStart: (details) {
              downTouchLeft = details.focalPoint.dx * (1 / scale);
              downTouchTop = details.focalPoint.dy * (1 / scale);

              changeScale = 1.0;
              scaleLeft = 0;
              changeTop = details.focalPoint.dy;
              changeLeft = details.focalPoint.dx;
            },
            onScaleUpdate: (details) {
              if (!widget.enabled) {
                return;
              }
              double up = details.focalPoint.dy - changeTop;
              double down = (changeTop - details.focalPoint.dy) * -1;
              double left = details.focalPoint.dx - changeLeft;
              double right = (changeLeft - details.focalPoint.dx) * -1;

              print("$up, $right, $down, $left");

              setState(() {
                movePosLeftCurrent = left;
                movePosTopCurrent = up;
                if (details.scale > changeScale) {
                  // zoom in
                  double preScale = scale +
                      (details.scale - changeScale) / widget.zoomSensibility;
                  scale = preScale;
                } else {
                  double preScale = scale -
                      (changeScale - details.scale) / widget.zoomSensibility;
                  scale = preScale;
                }

                scaleProcess(constraints);
                scaleFixPosition(constraints);

                if (widget.onScaleUpdate != null) {
                  widget.onScaleUpdate!(scale, zoom);
                }

                changeScale = details.scale;

                /*
                if (details.scale != 1.0) {
                  if (details.scale > changeScale) {
                    double preScale = scale +
                        (details.scale - changeScale) / widget.zoomSensibility;
                    if (preScale < 1.0) {
                      // zoom in
                      scale = preScale;
                      print("1 $scale" );
                    }
                    print("but wanted $preScale");
                  } else if (changeScale > details.scale &&
                      (widget.maxZoomWidth * scale > constraints.maxWidth ||
                          widget.maxZoomHeight * scale >
                              constraints.maxHeight)) {
                    double preScale = scale -
                        (changeScale - details.scale) / widget.zoomSensibility;

                    if (portrait) {
                      if (preScale >
                          (constraints.maxWidth / widget.maxZoomWidth)) {
                        scale = preScale;
                        print("2");
                      }
                    } else {
                      if (preScale >
                          (constraints.maxHeight / widget.maxZoomHeight)) {
                        // zoom out
                        scale = preScale;
                        print("3 $scale");
                      }
                    }
                  }


                  scaleProcess(constraints);
                  scaleFixPosition(constraints);

                  if (widget.onScaleUpdate != null) {
                    widget.onScaleUpdate!(scale, zoom);
                  }

                  changeScale = details.scale;
                } else {
                  if (details.focalPoint.dy > changeTop &&
                      (auxTop + up) < 0 &&
                      (auxTop + up) >
                          -((widget.maxZoomHeight) * scale -
                              constraints.maxHeight)) {
                    localTop = up;
                  } else if (changeTop > details.focalPoint.dy &&
                      (auxTop + down) < 0 &&
                      (auxTop + down) >
                          -((widget.maxZoomHeight) * scale -
                              constraints.maxHeight)) {
                    localTop = down;
                  }
                  if (details.focalPoint.dx > changeLeft &&
                      (auxLeft + right) < 0 &&
                      (auxLeft + right) >
                          -((widget.maxZoomWidth * scale) -
                              constraints.maxWidth)) {
                    localLeft = right;
                  } else if (changeLeft > details.focalPoint.dx &&
                      (auxLeft + left) < 0 &&
                      (auxLeft + left) >
                          -((widget.maxZoomWidth * scale) -
                              constraints.maxWidth)) {
                    localLeft = left;
                  }
                }*/
              });

              if (widget.onPositionUpdate != null) {
                widget.onPositionUpdate!(Offset(
                    (auxLeft + localLeft + centerLeft + scaleLeft) * -1,
                    (auxTop + localTop + centerTop + scaleTop) * -1));
              }

              print("aux $auxTop, localleft: $localLeft, centerLeft $centerLeft, scaleLeft: $scaleLeft");
            },
            onScaleEnd: (details) {
              endEscale(constraints);
            },
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: widget.backgroundColor,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: movePosTopLast + movePosTopCurrent + auxTop + localTop + centerTop + scaleTop,
                    left: movePosLeftLast + movePosLeftCurrent + auxLeft + localLeft + centerLeft + scaleLeft,
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            color: widget.canvasColor,
                            boxShadow: widget.canvasShadow != null
                                ? [widget.canvasShadow!]
                                : null),
                        width: widget.maxZoomWidth,
                        height: widget.maxZoomHeight,
                        child: widget.child,
                      ),
                    ),
                  ),
                  // scroll balken unten
                  Positioned(
                    top: constraints.maxHeight - widget.scrollWeight,
                    left: -(auxLeft + localLeft + centerLeft + scaleLeft) /
                        ((widget.maxZoomWidth * scale) / constraints.maxWidth),
                    child: Opacity(
                      opacity: (widget.maxZoomWidth * scale <=
                                  constraints.maxWidth ||
                              !widget.enableScroll)
                          ? 0
                          : widget.opacityScrollBars,
                      child: Container(
                        height: widget.scrollWeight,
                        width: constraints.maxWidth /
                            ((widget.maxZoomWidth * scale) /
                                constraints.maxWidth),
                        color: widget.colorScrollBars,
                      ),
                    ),
                  ),
                  // scroll balken oben
                  Positioned(
                    top: -(auxTop + localTop + centerTop + scaleTop) /
                        ((widget.maxZoomHeight * scale) /
                            constraints.maxHeight),
                    left: constraints.maxWidth - widget.scrollWeight,
                    child: Opacity(
                      opacity: (widget.maxZoomHeight * scale <=
                                  constraints.maxHeight ||
                              !widget.enableScroll)
                          ? 0
                          : widget.opacityScrollBars,
                      child: Container(
                        width: widget.scrollWeight,
                        height: constraints.maxHeight /
                            ((widget.maxZoomHeight * scale) /
                                constraints.maxHeight),
                        color: widget.colorScrollBars,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
