import 'package:flutter/cupertino.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:pencalendar/components/shader/common/ticking_builder.dart';
import 'package:pencalendar/models/shader_type.dart';

class SamplerShader extends StatefulWidget {
  final ShaderType activeShaderType;
  final String uiGlitch = "assets/shader/ui-glitch.frag";
  final Widget child;

  SamplerShader({
    super.key,
    required this.activeShaderType,
    required this.child,
  }) {
    switch (activeShaderType) {
      case ShaderType.focus:
        ShaderBuilder.precacheShader(uiGlitch);
        break;
      case _:
    }
  }

  @override
  State<SamplerShader> createState() => _SamplerShaderState();
}

class _SamplerShaderState extends State<SamplerShader> {
  @override
  Widget build(BuildContext context) {
    if (widget.activeShaderType != ShaderType.uiGlitch) {
      return widget.child;
    }
    return TickingBuilder(builder: (context, time) {
      return ShaderBuilder(
        assetKey: widget.uiGlitch,
        (BuildContext context, FragmentShader shader, Widget? child) {
          return AnimatedSampler(
            child: widget.child,
            (image, size, canvas) {
              const double overdrawPx = 1;
              shader
                ..setFloat(0, size.width)
                ..setFloat(1, size.height)
                ..setFloat(2, time)
                ..setImageSampler(0, image);
              //
              Rect rect = Rect.fromLTWH(-overdrawPx, -overdrawPx, size.width + overdrawPx, size.height + overdrawPx);
              canvas.drawRect(rect, Paint()..shader = shader);
            },
          );
        },
      );
    });
  }
}
