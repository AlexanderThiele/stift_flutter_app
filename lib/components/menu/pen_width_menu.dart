import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';

class PenWidthMenu extends ConsumerWidget {
  const PenWidthMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSubMenu = ref.watch(activeSubMenuProvider);
    final activeWidth = ref.watch(activeWidthProvider);
    return Container(
        margin: const EdgeInsets.only(left: 8, top: 8 + 108 + 8),
        width: 216,
        height: 52,
        child: Card(
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Slider(
                      onChanged: (newWidth) {
                        ref.read(activeWidthProvider.notifier).state = (newWidth * 2).roundToDouble() / 2.0;
                      },
                      value: activeWidth,
                      min: 0.5,
                      max: 10,
                    )),
                Expanded(flex: 1, child: Text(activeWidth.toStringAsFixed(1))),
              ],
            ))).animate(effects: [
      FadeEffect(duration: 200.ms, curve: Curves.easeOut),
      const ScaleEffect(begin: Offset(0, 0), curve: Curves.easeOut, alignment: Alignment(-0.8, -1)),
    ], target: activeSubMenu == OpenedTab.pen ? 1 : 0);
  }
}
