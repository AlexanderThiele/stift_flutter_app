// Copyright 2023 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/**
 * This is an unfinished, pre-release effect for Flutter Animate:
 * https://pub.dev/packages/flutter_animate
 *
 * It includes a copy of `AnimatedSampler` from Flutter Shaders:
 * https://github.com/jonahwilliams/flutter_shaders
 *
 * Once `AnimatedSampler` (or equivalent) is stable, or included in the core
 * SDK, this effect will be updated, tested, refined, and added to the
 * effects.dart file.
 */

// TODO: document.

/// An effect that lets you apply an animated fragment shader to a target.
@immutable
class ShaderEffect extends Effect<double> {
  const ShaderEffect({
    super.delay,
    super.duration,
    super.curve,
    this.shader,
    this.update,
    ShaderLayer? layer,
  })  : layer = layer ?? ShaderLayer.replace,
        super(
          begin: 0,
          end: 1,
        );

  final ui.FragmentShader? shader;
  final ShaderUpdateCallback? update;
  final ShaderLayer layer;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    double ratio = 1 / MediaQuery.of(context).devicePixelRatio;
    Animation<double> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (_, __) {
        return AnimatedSampler(
          (image, size, canvas) {
            EdgeInsets? insets;
            if (update != null) {
              insets = update!(shader!, animation.value, size, image);
            }
            Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
            rect = insets?.inflateRect(rect) ?? rect;

            void drawImage() {
              canvas.save();
              canvas.scale(ratio, ratio);
              canvas.drawImage(image, Offset.zero, Paint());
              canvas.restore();
            }

            if (layer == ShaderLayer.foreground) drawImage();
            if (shader != null) canvas.drawRect(rect, Paint()..shader = shader);
            if (layer == ShaderLayer.background) drawImage();
          },
          enabled: shader != null,
          child: child,
        );
      },
    );
  }
}

extension ShaderEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [shader] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T shader({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    ui.FragmentShader? shader,
    ShaderUpdateCallback? update,
    ShaderLayer? layer,
  }) =>
      addEffect(ShaderEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        shader: shader,
        update: update,
        layer: layer,
      ));
}

enum ShaderLayer { foreground, background, replace }

/// Function signature for [ShaderEffect] update handlers.
typedef ShaderUpdateCallback = EdgeInsets? Function(ui.FragmentShader shader, double value, Size size, ui.Image image);
