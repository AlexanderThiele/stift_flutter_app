import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';

class ColorPaletteMenu extends ConsumerWidget {
  ColorPaletteMenu({super.key});

  final List<Color> colorsFirstRow = [
    Colors.black,
    Colors.grey.shade800,
    Colors.grey.shade700,
    Colors.grey.shade500,
    Colors.grey.shade300,
    Colors.grey.shade200,
    Colors.grey.shade100,
    Colors.white,
  ];

  final List<MaterialColor> colors = [
    Colors.blueGrey,
    Colors.brown,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.blue,
    Colors.cyan,
    Colors.green,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSubMenu = ref.watch(activeSubMenuProvider);
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 8 + 108 + 8),
      width: 216,
      child: GridView.count(
        crossAxisCount: 8,
        children: [
          for (final color in colorsFirstRow) _ColorGridItem(color),
          for (final color in colors)
            for (int i = 9; i > 1; i--) _ColorGridItem(color[i * 100]!)
        ],
      ),
    ).animate(effects: [
      FadeEffect(duration: 200.ms, curve: Curves.easeOut),
      const ScaleEffect(begin: Offset(0, 0), curve: Curves.easeOut, alignment: Alignment(-0.8, -1)),
    ], target: activeSubMenu == OpenedTab.color ? 1 : 0);
  }
}

class _ColorGridItem extends ConsumerWidget {
  final Color color;

  const _ColorGridItem(this.color);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(activeColorProvider.notifier).state = color;
        ref.read(activeBrushProvider.notifier).state = Brush.pen;
        ref.read(activeSubMenuProvider.notifier).state = OpenedTab.none;
      },
      child: Container(
        margin: const EdgeInsets.all(0.5),
        decoration: BoxDecoration(color: color),
      ),
    );
  }
}
