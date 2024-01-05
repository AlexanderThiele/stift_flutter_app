import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/models/calendar_layer.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:responsive_spacing/responsive_spacing.dart';

class LayerMenu extends ConsumerWidget {
  const LayerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSubMenu = ref.watch(activeSubMenuProvider);
    final activeCalendar = ref.watch(activeCalendarControllerProvider);
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Layers",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                      onTap: () {
                        final controller = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("New Layer"),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    autofocus: true,
                                    controller: controller,
                                    maxLines: 1,
                                    maxLength: 24,
                                    decoration:
                                        InputDecoration(label: Text("Assign a name to the layer"), hintText: "🏝️"),
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () async {
                                      final navigator = Navigator.of(context);
                                      await ref
                                          .read(activeCalendarControllerProvider.notifier)
                                          .createLayer(controller.text);
                                      navigator.pop();
                                    },
                                    child: Text("Ok"))
                              ],
                            );
                          },
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.add, size: 16),
                      )),
                ],
              ),
            ),
            for (final layer in activeCalendar?.layerList ?? <CalendarLayer>[])
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      ref.read(activeCalendarControllerProvider.notifier).switchVisibility(!layer.isVisible, layer);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: context.spacing.m,
                          top: context.spacing.m,
                          bottom: context.spacing.m,
                          right: context.spacing.m / 2),
                      child: Icon(layer.isVisible ? Icons.visibility : Icons.visibility_off, size: context.spacing.l),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(activeCalendarControllerProvider.notifier).switchWritableLayer(layer);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: context.spacing.m / 2,
                          top: context.spacing.m,
                          bottom: context.spacing.m,
                          right: context.spacing.m),
                      child: Icon(layer.isWriteActive ? Icons.edit : Icons.edit_off, size: context.spacing.l),
                    ),
                  ),
                  switch (layer.name) {
                    "" => Text("📆", style: Theme.of(context).textTheme.titleLarge),
                    _ => Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            CustomSlidableAction(
                              flex: 5,
                              onPressed: (context) {
                                ref.read(activeCalendarControllerProvider.notifier).deleteLayer(layer);
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(0),
                              child: const Icon(Icons.delete, size: 16),
                            ),
                          ],
                        ),
                        child: Container(
                            constraints: const BoxConstraints(minWidth: 48),
                            child: Text(layer.name, style: Theme.of(context).textTheme.titleSmall)))
                  },
                  SizedBox(width: context.spacingConfig.padding.size),
                ],
              ),
          ],
        ),
      ),
    ).animate(effects: [
      FadeEffect(duration: 200.ms, curve: Curves.easeOut),
      const ScaleEffect(begin: Offset(0, 0), curve: Curves.easeOut, alignment: Alignment(-0.8, -1)),
    ], target: activeSubMenu == OpenedTab.layers ? 1 : 0);
  }
}
