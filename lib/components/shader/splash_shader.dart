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

  final String splash = "assets/shader/splash-small.frag";
  final String kishimisu = "assets/shader/kishimisu.frag";
  final String jwibullori = "assets/shader/jwibullori.frag";
  final String fractalcineshader = "assets/shader/fractalcineshader.frag";

  SplashSmallShader({
    super.key,
    required this.mousePosition,
    required this.activeShaderType,
  }) {
    switch (activeShaderType) {
      case ShaderType.focus:
        ShaderBuilder.precacheShader(splash);
        break;
      case ShaderType.focusFast:
        ShaderBuilder.precacheShader(splash);
        break;
      case ShaderType.kishimisu:
        ShaderBuilder.precacheShader(kishimisu);
        break;
      case ShaderType.jwibullori:
        ShaderBuilder.precacheShader(jwibullori);
        break;
      case ShaderType.fractalcineshader:
        ShaderBuilder.precacheShader(fractalcineshader);
        break;
      case _:
        break;
    }
  }

  @override
  State<SplashSmallShader> createState() => _SplashSmallShaderState();
}

class _SplashSmallShaderState extends State<SplashSmallShader> {
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
        if (widget.activeShaderType == ShaderType.focus || widget.activeShaderType == ShaderType.focusFast) {
          return ShaderBuilder(
            (BuildContext context, FragmentShader shader, Widget? child) {
              return CustomPaint(
                painter: _SplashShaderCustomPainter(
                    time: time,
                    mouseOffset: widget.mousePosition,
                    shader: shader,
                    speed: switch (widget.activeShaderType) {
                      ShaderType.focusFast => 16,
                      _ => 2,
                    }),
              );
            },
            assetKey: widget.splash,
          );
        }
        if (widget.activeShaderType == ShaderType.kishimisu) {
          return ShaderBuilder(
            (BuildContext context, FragmentShader shader, Widget? child) {
              return CustomPaint(
                  painter: _ShaderKishimisuCustomPainter(
                time: time,
                shader: shader,
              ));
            },
            assetKey: widget.kishimisu,
          );
        }
        if (widget.activeShaderType == ShaderType.jwibullori) {
          return ShaderBuilder(
            (BuildContext context, FragmentShader shader, Widget? child) {
              return CustomPaint(
                  painter: _ShaderJwibulloriCustomPainter(
                time: time,
                shader: shader,
                mouseOffset: widget.mousePosition,
              ));
            },
            assetKey: widget.jwibullori,
          );
        }
        if (widget.activeShaderType == ShaderType.fractalcineshader) {
          return ShaderBuilder(
            (BuildContext context, FragmentShader shader, Widget? child) {
              return CustomPaint(painter: _ShaderFractalcineshaderCustomPainter(time: time, shader: shader));
            },
            assetKey: widget.fractalcineshader,
          );
        }

        return const SizedBox();
      }),
    ).animate(effects: [const FadeEffect()]);
  }
}

class _SplashShaderCustomPainter extends CustomPainter {
  final double time;
  final Offset? mouseOffset;
  final double speed;
  final FragmentShader shader;

  _SplashShaderCustomPainter({
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

class _ShaderKishimisuCustomPainter extends CustomPainter {
  final double time;
  final FragmentShader shader;

  _ShaderKishimisuCustomPainter({
    required this.time,
    required this.shader,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time);
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _ShaderJwibulloriCustomPainter extends CustomPainter {
  final double time;
  final Offset? mouseOffset;
  final FragmentShader shader;

  _ShaderJwibulloriCustomPainter({
    required this.time,
    required this.mouseOffset,
    required this.shader,
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
      ..setFloat(4, mouseOffset!.dy);
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _ShaderFractalcineshaderCustomPainter extends CustomPainter {
  final double time;
  final FragmentShader shader;

  _ShaderFractalcineshaderCustomPainter({
    required this.time,
    required this.shader,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time);
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}