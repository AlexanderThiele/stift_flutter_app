import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/models/shader_type.dart';
import 'package:pencalendar/repository/repository_provider.dart';

/// current selected Brush
final activeBrushProvider = StateProvider<Brush>((ref) => Brush.pen);

/// Width of brush
final activeWidthProvider = NotifierProvider<ActivePencilWidthNotifier, double>(() => ActivePencilWidthNotifier());

/// current active Color
final activeColorProvider = NotifierProvider<ActiveColorNotifier, Color>(() => ActiveColorNotifier());

/// if touch draw is enabled
final activeTouchProvider = StateProvider((ref) => false);

/// current active shader
final activeShaderProvider = StateProvider<ShaderType>((ref) => ShaderType.none);

/// if color palette is open
final activeSubMenuProvider = StateProvider<OpenedTab>((ref) => OpenedTab.none);

class ActiveColorNotifier extends Notifier<Color> {
  void setNewColor(Color color) {
    ref.read(sharedPrefProvider).setActivePencilColor(color);
    state = color;
  }

  @override
  Color build() {
    final savedColor = ref.read(sharedPrefProvider).getActivePencilColor();
    if (savedColor != null) {
      return savedColor;
    }
    return Colors.black;
  }
}

class ActivePencilWidthNotifier extends Notifier<double> {
  void setNewWidth(double width) {
    ref.read(sharedPrefProvider).setActivePencilWidth(width);
    state = width;
  }

  @override
  double build() {
    final width = ref.read(sharedPrefProvider).getActivePencilWidth();
    if (width != null) {
      return width;
    }
    return 1;
  }
}
