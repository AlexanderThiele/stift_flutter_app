import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/models/shader_type.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';

class FancySelectionMenu extends ConsumerWidget {
  const FancySelectionMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(activeColorProvider);
    final brush = ref.watch(activeBrushProvider);
    final activeShader = ref.watch(activeShaderProvider);
    final touchDrawEnabled = ref.watch(activeTouchProvider);
    return Container(
      margin: const EdgeInsets.all(8),
      height: 108,
      width: 108,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          IconButton(
            onPressed: () {
              if (activeShader.index >= ShaderType.values.length - 1) {
                ref.read(activeShaderProvider.notifier).state = ShaderType.values.first;
              } else {
                ref.read(activeShaderProvider.notifier).state = ShaderType.values[activeShader.index + 1];
              }
            },
            iconSize: 18,
            icon: Builder(builder: (context) {
              return switch (activeShader) {
                ShaderType.none => const Icon(
                    Icons.animation,
                    color: Colors.grey,
                  ),
                ShaderType.focus => const Icon(
                    Icons.animation,
                    color: Colors.blue,
                  ),
                ShaderType.focusFast => const Icon(
                    Icons.animation,
                    color: Colors.red,
                  ),
                ShaderType.kishimisu => const Icon(
                    Icons.animation,
                    color: Colors.amber,
                  ),
              };
            }),
          ),
          IconButton(
            onPressed: () {
              ref.read(activeTouchProvider.notifier).state = !touchDrawEnabled;
            },
            iconSize: 18,
            icon: Builder(builder: (context) {
              if (touchDrawEnabled) {
                return const Icon(Icons.touch_app);
              }
              return const Icon(Icons.do_not_touch);
            }),
          ),
          IconButton(
            onPressed: () {
              ref.read(activeBrushProvider.notifier).state = Brush.eraser;
            },
            icon: const Icon(
              FontAwesomeIcons.eraser,
            ),
            color:
                brush == Brush.eraser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
            iconSize: 18,
          ),
          IconButton(
            onPressed: () {
              ref.read(activeCalendarControllerProvider.notifier).deleteLast();
            },
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.undo),
            iconSize: 18,
          ),

          /// Color
          GestureDetector(
            onTap: () {
              final activeSubMenu = ref.read(activeSubMenuProvider);
              ref.read(activeSubMenuProvider.notifier).state =
                  activeSubMenu == OpenedTab.color ? OpenedTab.none : OpenedTab.color;
            },
            child: Container(
              decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400, width: 1)),
            ),
          ),
          IconButton(
            onPressed: () {
              ref.read(activeBrushProvider.notifier).state = Brush.pen;
            },
            icon: const Icon(
              Icons.brush,
            ),
            color: brush == Brush.pen ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
            iconSize: 18,
          ),
          Container(),
          IconButton(
            onPressed: () {
              final activeSubMenu = ref.read(activeSubMenuProvider);
              ref.read(activeSubMenuProvider.notifier).state =
                  activeSubMenu == OpenedTab.pen ? OpenedTab.none : OpenedTab.pen;
            },
            icon: const Icon(Icons.line_weight),
            iconSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          Container(),
        ],
      ),
    );
  }
}
