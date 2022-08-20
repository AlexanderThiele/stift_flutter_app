library zoom_widget;

import 'dart:math';

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

  final minZoom = 0.4;
  final maxZoom = 3.0;

  // last initial top click position
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
  double initialScale = 1.0;
  double scaleChangeLastTick = 0.0;
  double changeScaleSinceStart = 0.0;
  double zoom = 0.0;

  // mittiger punkt auf dem getouched wird.(auf dem bildschirm und nicht auf dem widget)
  Offset midlePointOnStart = Offset(0.0, 0.0);

  // der punkt auf dem widget -> berechnet nur zu beginn
  Offset relativeMidlePointOnStart = Offset(0.0, 0.0);
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

  double get currentTopPosition =>
      movePosTopLast +
      movePosTopCurrent +
      auxTop +
      localTop +
      centerTop +
      scaleTop;

  double get currentLeftPosition =>
      movePosLeftLast +
      movePosLeftCurrent +
      auxLeft +
      localLeft +
      centerLeft +
      scaleLeft;

  double get currentLeftPositionForScale =>
      movePosLeftCurrent + movePosLeftLast + auxLeft + localLeft + centerLeft;

  double get currentTopPositionForScale =>
      movePosTopCurrent + movePosTopLast + auxTop + localTop + centerTop;

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
        scaleProcess(globalConstraints, Offset(0, 0));
        scaleFixPosition(globalConstraints);
      });
      if (scaleAnimation.value == 1.0 && widget.onScaleUpdate != null) {
        if (widget.onScaleUpdate != null) {
          widget.onScaleUpdate!(scale, zoom);
        }
        if (widget.onPositionUpdate != null) {
          widget.onPositionUpdate!(
            Offset(
              (currentLeftPosition) * -1,
              (currentTopPosition) * -1,
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
    return;
    if (((widget.maxZoomHeight * scale) > constraints.maxHeight) &&
        ((currentTopPosition) + (widget.maxZoomHeight * scale)) <
            constraints.maxHeight) {
      localTop += constraints.maxHeight -
          ((currentTopPosition) + widget.maxZoomHeight * scale);
    }

    if (((widget.maxZoomWidth * scale) > constraints.maxWidth) &&
        ((currentLeftPosition) + (widget.maxZoomWidth * scale)) <
            constraints.maxWidth) {
      localLeft += constraints.maxWidth -
          ((currentLeftPosition) + widget.maxZoomWidth * scale);
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

  void calcMiddlePoint() {}

  /**
   * calc the scale top and left position
   */
  void scaleProcess(constraints, Offset focalPoint) {
    // point on widget where to scale from
    // the middle point of scale rel to the card
    var relScalePoint = Offset(
        ((currentLeftPosition) * -1 + focalPoint.dx) * (1 / scale),
        ((currentTopPosition) * -1 + focalPoint.dy) * (1 / scale));
    var initialScale = (scale + -1 * (changeScaleSinceStart - 1));
    scaleLeft =
        (-1 * relScalePoint.dx * scale) + (relScalePoint.dx * initialScale);
    scaleTop =
        (-1 * relScalePoint.dy * scale) + (relScalePoint.dy * initialScale);

    //print("${relScalePoint.dx} $currentLeftPositionForScale ${focalPoint.dx}  $scale");
    // print("$movePosLeftCurrent + $movePosLeftLast + $auxLeft + $localLeft + $centerLeft");
    // print("scaleLeft: $scaleLeft, tick: $scaleChangeLastTick Point: $relScalePoint with scale: $scale.");

    /*/ das ist der punkt auf der karte auf dem gescaled werden soll
    Offset currentMidlePoint = Offset(
        ((currentLeftPositionForScale) * -1 + midlePointOnStart.dx) * (1 / scale) -
            localLeft,
        ((currentTopPositionForScale) * -1 + midlePointOnStart.dy) * (1 / scale));
    print("currentMiddle: ${currentMidlePoint} rel middle $relativeMidlePointOnStart} middle: $midlePointOnStart");

    double preScaleLeft =
        (relativeMidlePointOnStart.dx - currentMidlePoint.dx) * -scale;
    if ((auxLeft + localLeft + preScaleLeft) >
        -((widget.maxZoomWidth * scale) - constraints.maxWidth * scale))
      scaleLeft = preScaleLeft;

    double preScaleTop =
        (relativeMidlePointOnStart.dy - currentMidlePoint.dy) * -scale;
    if ((auxTop + localTop + preScaleTop) >
        -((widget.maxZoomHeight * scale) - constraints.maxHeight * scale))
      print("hier 1 mit ${preScaleTop}");
      scaleTop = preScaleTop;*/
  }

  void endEscale(constraints) {
    auxTop += localTop + scaleTop;
    auxLeft += localLeft + scaleLeft;
    initialScale = scale;
    scaleLeft = 0;
    scaleTop = 0;
    localTop = 0;
    localLeft = 0;
    downTouchLeft = 0;
    downTouchTop = 0;
    // print("left cur: $movePosLeftCurrent last: $movePosLeftLast");
    movePosLeftLast += movePosLeftCurrent;
    movePosTopLast += movePosTopCurrent;
    movePosLeftCurrent = 0;
    movePosTopCurrent = 0;
    /*if (auxLeft > 0) auxLeft = 0;
    if (auxTop > 0) auxTop = 0;

    if (widget.maxZoomHeight * scale < constraints.maxHeight && auxTop < 0) {
      auxTop = 0;
    }

    if (widget.maxZoomWidth * scale < constraints.maxWidth && auxLeft < 0) {
      auxLeft = 0;
    }*/
/*
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
        print("ää1");
        scale = max(constraints.maxWidth / widget.maxZoomWidth, minZoom);
      });
    }

    if (constraints.maxWidth > constraints.maxHeight &&
        widget.maxZoomHeight * scale < constraints.maxHeight) {
      setState(() {
        print("ää2");
        scale = max(constraints.maxHeight / widget.maxZoomHeight, minZoom);
      });
    }
*/
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        globalConstraints = constraints;
        if (!initOrientation) {
          scale = max(min(widget.initZoom, maxZoom),minZoom);/*map(
              widget.initZoom,
              1.0,
              0.0,
              1.0,
              (constraints.maxHeight > constraints.maxWidth)
                  ? constraints.maxWidth / widget.maxZoomWidth
                  : constraints.maxHeight / widget.maxZoomHeight);*/
          print("scale $scale");
          initOrientation = true;
          portrait =
              (constraints.maxHeight > constraints.maxWidth) ? true : false;

          if (widget.onScaleUpdate != null) {
            widget.onScaleUpdate!(scale, widget.initZoom);
          }

          print(constraints.maxHeight);
          movePosTopLast = (constraints.maxHeight-widget.maxZoomHeight*scale)/2;
          if(movePosTopLast < 0){
            movePosTopLast = 0;
          }

          if (widget.onPositionUpdate != null) {
            widget.onPositionUpdate!(
              Offset(
                (currentLeftPosition) * -1,
                (currentTopPosition) * -1,
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

        // print("real Left: $currentLeftPosition real top: $currentTopPosition");
        // print(
        //     "scale: $scale, lastTop: $movePosTopLast, currentTop: $movePosTopCurrent, auxTop $auxTop, localTop: $localTop, centerTop $centerTop, scaleTop: $scaleTop");

        return RawGestureDetector(
          gestures: {
            MultiTouchGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                MultiTouchGestureRecognizer>(
              () => MultiTouchGestureRecognizer(),
              (MultiTouchGestureRecognizer instance) {
                instance.onSingleTap = (point) {
                  if (widget.doubleTapZoom) {
                    midlePointOnStart = point;
                    relativeMidlePointOnStart = Offset(
                        ((currentLeftPositionForScale) * -1 +
                                midlePointOnStart.dx) *
                            (1 / scale),
                        ((currentTopPositionForScale) * -1 +
                                midlePointOnStart.dy) *
                            (1 / scale));
                  }
                };
                instance.onMultiTap = (firstPoint, secondPoint) {
                  midlePointOnStart = Offset(
                      (firstPoint.dx + secondPoint.dx) / 2.0,
                      (firstPoint.dy + secondPoint.dy) / 2.0);

                  // print("midlePoint");
                  // print(midlePointOnStart);

                  relativeMidlePointOnStart = Offset(
                      ((currentLeftPositionForScale) * -1 +
                              midlePointOnStart.dx) *
                          (1 / scale),
                      ((currentTopPositionForScale) * -1 +
                              midlePointOnStart.dy) *
                          (1 / scale));
                  initialScale = scale;
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

              changeScaleSinceStart = 1.0;
              // scaleLeft = 0;
              changeTop = details.focalPoint.dy;
              changeLeft = details.focalPoint.dx;
            },
            onScaleUpdate: (details) {
              if (!widget.enabled) {
                return;
              }
              // print("scale Update start");
              double up = details.focalPoint.dy - changeTop;
              double down = (changeTop - details.focalPoint.dy) * -1;
              double left = details.focalPoint.dx - changeLeft;
              double right = (changeLeft - details.focalPoint.dx) * -1;
              // print("asd $changeLeft, ${details.focalPoint.dx} ${details.localFocalPoint.dx}");

              setState(() {
                movePosLeftCurrent = left;
                movePosTopCurrent = up;
                if (details.scale > changeScaleSinceStart) {
                  // zoom in
                  double preScale = scale +
                      (details.scale - changeScaleSinceStart) /
                          widget.zoomSensibility;
                  final scaleLast = scale;
                  scale = min(max(preScale, minZoom), maxZoom);
                  scaleChangeLastTick = scaleLast - scale;
                } else {
                  double preScale = scale -
                      (changeScaleSinceStart - details.scale) /
                          widget.zoomSensibility ;
                  final scaleLast = scale;
                  scale = min(max(preScale, minZoom), maxZoom);
                  scaleChangeLastTick = scaleLast - scale;
                }

                changeScaleSinceStart = 1 + scale - initialScale;

                scaleProcess(constraints, details.focalPoint);
                scaleFixPosition(constraints);

                if (widget.onScaleUpdate != null) {
                  widget.onScaleUpdate!(scale, zoom);
                }

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
                    (currentLeftPosition) * -1, (currentTopPosition) * -1));
              }

              // print("AAA: real Left: $currentLeftPosition real top: $currentTopPosition");
              // print(
              //     "AAA: scale: $scale, lastTop: $movePosTopLast, currentTop: $movePosTopCurrent, auxTop $auxTop, localTop: $localTop, centerTop $centerTop, scaleTop: $scaleTop");

              // print("scale Update End");
            },
            onScaleEnd: (details) {
              // print("scale End Start");
              endEscale(constraints);
              // print("scale End end");
            },
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: widget.backgroundColor,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: currentTopPosition,
                    left: currentLeftPosition,
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
                    left: -(currentLeftPosition) /
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
                    top: -(currentTopPosition) /
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
