import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'adjusted_scale_gesture_recognizer.dart' as sh;

class TableGestureDetector {
  final TickerProvider _tickerProvider;
  final DoubleTapGestureRecognizer _doubleTapGestureRecognizer = DoubleTapGestureRecognizer();
  final sh.ScaleGestureRecognizer _scaleGestureRecognizer = sh.ScaleGestureRecognizer();

  late final AnimationController _controller = AnimationController(
    vsync: _tickerProvider,
    duration: const Duration(milliseconds: 300),
  );

  late double initialScaleFactor;
  late double initialFocalPointOnViewScaledX;
  late double initialFocalPointOnViewScaledY;
  late double initialFocalPointX;
  late double initialFocalPointY;
  late double initialViewOffsetX;
  late double initialViewOffsetY;

  Animation<Matrix4>? _animation;
  double? lastScale;

  /// initial position
  final TransformationController transformationController =
      TransformationController(Matrix4.translation(vm.Vector3(5, 25, 0)));

  TableGestureDetector(this._tickerProvider);

  /// this starts the animation
  void _startAnimate(Matrix4Tween matrix4tween) {
    _controller.reset();
    _animation = matrix4tween.animate(_controller);
    _animation!.addListener(_onAnimate);
    _controller.forward();
  }

  /// updates the view on animation
  void _onAnimate() {
    transformationController.value = _animation!.value;
    if (!_controller.isAnimating) {
      _animation!.removeListener(_onAnimate);
      _animation = null;
      _controller.reset();
    }
  }

  /// stops the current animation (or executed when animation ends)
  void _animateStop() {
    _controller.stop();
    _animation?.removeListener(_onAnimate);
    _animation = null;
    _controller.reset();
  }

  double get scaleFactor => transformationController.value.entry(0, 0);

  double get focalPointX => _scaleGestureRecognizer.currentFocalPoint!.dx;

  double get focalPointY => _scaleGestureRecognizer.currentFocalPoint!.dy;

  double get viewOffsetX => transformationController.value.entry(0, 3);

  double get viewOffsetY => transformationController.value.entry(1, 3);

  /// for all additional gesture detectors
  void onDownEvent(PointerDownEvent event) {
    _scaleGestureRecognizer.addPointer(event);
    _scaleGestureRecognizer.handleEvent(event);
    if (_scaleGestureRecognizer.pointerCount > 1) {
      initialScaleFactor = scaleFactor;
      initialFocalPointX = focalPointX;
      initialFocalPointY = focalPointY;
      initialViewOffsetX = viewOffsetX;
      initialViewOffsetY = viewOffsetY;
      initialFocalPointOnViewScaledX = (focalPointX - viewOffsetX) / scaleFactor;
      initialFocalPointOnViewScaledY = (focalPointY - viewOffsetY) / scaleFactor;
    }
  }

  /// Returns true if drawing is enabled.
  bool onMoveEvent(PointerMoveEvent event) {
    // print("onMoveEvent $event");
    _scaleGestureRecognizer.handleEvent(event);
    if (_scaleGestureRecognizer.pointerCount > 1) {
      double currentScale = initialScaleFactor + _scaleGestureRecognizer.scaleFactor - 1;
      lastScale ??= currentScale;

      if (currentScale < 0.5) {
        currentScale = 0.5;
      } else if (currentScale > 3) {
        currentScale = 3;
      }

      final calenderPositionAfterMoveX = initialViewOffsetX + focalPointX - initialFocalPointX;
      final calenderPositionAfterMoveY = initialViewOffsetY + focalPointY - initialFocalPointY;

      final newFocalOnViewScaledX = (focalPointX - calenderPositionAfterMoveX) / currentScale;
      final newFocalOnViewScaledY = (focalPointY - calenderPositionAfterMoveY) / currentScale;

      final newCalenderPositionX =
          calenderPositionAfterMoveX + (newFocalOnViewScaledX - initialFocalPointOnViewScaledX) * currentScale;
      final newCalenderPositionY =
          calenderPositionAfterMoveY + (newFocalOnViewScaledY - initialFocalPointOnViewScaledY) * currentScale;

      transformationController.value = Matrix4(currentScale, 0, 0, 0, 0, currentScale, 0, 0, 0, 0, currentScale, 0,
          newCalenderPositionX, newCalenderPositionY, 0, 1);
      lastScale = currentScale;
    } else {
      return true;
    }
    return false;
  }

  void onUpOrCancel(PointerEvent event) {
    _scaleGestureRecognizer.handleEvent(event);
    if (_scaleGestureRecognizer.pointerCount < 2) {
      lastScale = null;
    }
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controller.status == AnimationStatus.forward) {
      _animateStop();
    }
  }

  Matrix4Tween _moveRight() {
    return Matrix4Tween(
      begin: transformationController.value,
      end: Matrix4.copy(transformationController.value)..translate(vm.Vector3(-100, 0, 0)),
    );
  }

  void _zoomIn(PointerDownEvent pointerDownEvent) {
    final position = pointerDownEvent.localPosition;

    _startAnimate(Matrix4Tween(
      begin: transformationController.value,
      end: Matrix4.copy(transformationController.value)
        ..scale(1.2)
        ..translate(vm.Vector3(-position.dx / 6, -position.dy / 6, 0)), // -100 is positioned at september
    ));
  }

  void fingerMove(PointerMoveEvent event) {
    final curScale = transformationController.value.getMaxScaleOnAxis();
    transformationController.value = Matrix4.copy(transformationController.value)
      ..translate(vm.Vector3(event.delta.dx / curScale, event.delta.dy / curScale, 0));
  }
}
