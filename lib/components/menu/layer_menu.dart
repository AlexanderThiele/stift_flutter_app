import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:responsive_spacing/responsive_spacing.dart';

class LayerMenu extends ConsumerWidget {
  const LayerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSubMenu = ref.watch(activeSubMenuProvider);
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 8 + 108 + 8),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: context.spacing.m, top: context.spacing.m),
              child: Text(
                "Layers",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: context.spacing.m),
              child: Text(
                "Coming soon..",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(context.spacing.m),
                    child: Icon(Icons.visibility, size: context.spacing.l),
                  ),
                ),
                Text("📆", style: Theme.of(context).textTheme.titleLarge),
                Radio(value: true, groupValue: true, onChanged: (_) {}, visualDensity: VisualDensity.compact),
              ],
            ),
          ],
        ),
      ),
    ).animate(effects: [
      FadeEffect(duration: 200.ms, curve: Curves.easeOut),
      const ScaleEffect(begin: Offset(0, 0), curve: Curves.easeOut, alignment: Alignment(-0.8, -1)),
    ], target: activeSubMenu == OpenedTab.layers ? 1 : 0);
    ;
  }
}
