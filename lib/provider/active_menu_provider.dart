import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/models/shader_type.dart';

/// current selected Brush
final activeBrushProvider = StateProvider<Brush>((ref) => Brush.pen);

/// Width of brush
final activeWidthProvider = StateProvider<double>((ref) => 1);

/// current active Color
final activeColorProvider = StateProvider<Color>((ref) => Colors.black);

/// if touch draw is enabled
final activeTouchProvider = StateProvider((ref) => false);

/// current active shader
final activeShaderProvider = StateProvider<ShaderType>((ref) => ShaderType.none);

/// if color palette is open
final activeSubMenuProvider = StateProvider<OpenedTab>((ref) => OpenedTab.none);