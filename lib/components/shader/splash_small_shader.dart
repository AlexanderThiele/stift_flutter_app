import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:pencalendar/components/shader/common/ticking_builder.dart';
import 'package:pencalendar/models/shader_type.dart';
import 'package:pencalendar/utils/const/cal_size.dart';

class SplashSmallShader extends StatefulWidget {
  final Offset? mousePosition;
  final ShaderType activeShaderType;

  const SplashSmallShader({
    super.key,
    required this.mousePosition,
    required this.activeShaderType,
  });

  @override
  State<SplashSmallShader> createState() => _SplashSmallShaderState();
}

class _SplashSmallShaderState extends State<SplashSmallShader> {
  final String assetKey = "assets/shader/splash-small.frag";

  @override
  void initState() {
    ShaderBuilder.precacheShader(assetKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activeShaderType == ShaderType.none) {
      return const SizedBox();
    }
    if (widget.mousePosition == null) {
      return const SizedBox();
    }
    return SizedBox(
      width: calWidth,
      height: calHeight,
      child: TickingBuilder(builder: (context, time) {
        return ShaderBuilder(
          (BuildContext context, FragmentShader shader, Widget? child) {
            return CustomPaint(
              painter: _SplashSmallShaderCustomPainter(
                  time: time,
                  mouseOffset: widget.mousePosition,
                  shader: shader,
                  speed: switch (widget.activeShaderType) {
                    ShaderType.focusFast => 16,
                    _ => 2,
                  }),
            );
          },
          assetKey: assetKey,
        );
      }),
    ).animate(effects: [const FadeEffect()]);
  }
}

class _SplashSmallShaderCustomPainter extends CustomPainter {
  final double time;
  final Offset? mouseOffset;
  final double speed;
  final FragmentShader shader;

  _SplashSmallShaderCustomPainter({
    required this.time,
    required this.mouseOffset,
    required this.shader,
    this.speed = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (mouseOffset == null) {
      return;
    }
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, mouseOffset!.dx)
      ..setFloat(4, mouseOffset!.dy)
      ..setFloat(5, speed);
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
