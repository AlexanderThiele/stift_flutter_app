import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/feature_notifier.dart';
import 'package:pencalendar/models/calendar_layer.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:pencalendar/provider/router_provider.dart';
import 'package:responsive_spacing/responsive_spacing.dart';

class LayerMenu extends ConsumerWidget {
  const LayerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSubMenu = ref.watch(activeSubMenuProvider);
    final activeCalendar = ref.watch(activeCalendarControllerProvider);
    final activeFeatures = ref.watch(activeFeatureNotifierProvider);

    final canCreateMoreLayers = (activeCalendar?.layerList.length ?? 0) < activeFeatures.numberOfLayers;
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 8 + 108 + 8),
      child: Card(
        child: SingleChildScrollView(
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: context.spacing.m, top: context.spacing.xs, bottom: context.spacing.xs),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        switch (activeFeatures.activePremium) {
                          true => context.l10n.layerNew,
                          false =>
                            "${context.l10n.layerNew} ${activeCalendar?.layerList.length}/${activeFeatures.numberOfLayers}"
                        },
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            final controller = TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(context.l10n.layerNew),
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (canCreateMoreLayers)
                                        ExpansionTile(
                                          title: Text(context.l10n.layerExplainTitle),
                                          shape: const Border(),
                                          tilePadding: EdgeInsets.zero,
                                          children: [Text(context.l10n.layerExplainText)],
                                        ),
                                      if (canCreateMoreLayers)
                                        TextField(
                                          autofocus: true,
                                          controller: controller,
                                          maxLines: 1,
                                          maxLength: 24,
                                          decoration: InputDecoration(
                                              label: Text(context.l10n.layerTextFieldTitle), hintText: "🏝️"),
                                        ),
                                      if (!canCreateMoreLayers) ...[
                                        Text(
                                          context.l10n.premiumLayersTitle,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        Text(context.l10n.premiumLayersText(activeFeatures.numberOfLayers),
                                            style: Theme.of(context).textTheme.bodyMedium)
                                      ]
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(context.l10n.cancel)),
                                    TextButton(
                                        onPressed: () async {
                                          final navigator = Navigator.of(context);
                                          if (canCreateMoreLayers) {
                                            await ref
                                                .read(activeCalendarControllerProvider.notifier)
                                                .createLayer(controller.text);
                                            navigator.pop();
                                          } else {
                                            navigator.pop();
                                            GoRouter.of(context).push(AppRoute.paywall.path);
                                          }
                                        },
                                        child: switch (canCreateMoreLayers) {
                                          true => Text(context.l10n.ok),
                                          false => Text(context.l10n.premiumViewPriceButton)
                                        })
                                  ],
                                );
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Icon(Icons.add, size: 16),
                          )),
                    ],
                  ),
                ),
                for (final layer in activeCalendar?.layerList ?? <CalendarLayer>[])
                  Container(
                    decoration: BoxDecoration(
                        border: switch (layer.isWriteActive) {
                          true => Border.all(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Theme.of(context).colorScheme.secondary.withAlpha(100),
                            ),
                          false => null
                        },
                        color: switch (layer.isWriteActive) {
                          true => Theme.of(context).colorScheme.secondary.withAlpha(30),
                          false => Colors.transparent
                        }),
                    child: InkWell(
                      onTap: () {
                        ref.read(activeCalendarControllerProvider.notifier).switchWritableLayer(layer);
                      },
                      onLongPress: () {
                        showModalBottomSheet(
                          useSafeArea: true,
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 16),
                                if (layer.isDeletable)
                                  ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: Text(context.l10n.bottomSheetDeleteButton),
                                      onTap: () {
                                        ref.read(activeCalendarControllerProvider.notifier).deleteLayer(layer);
                                        Navigator.of(context).pop();
                                      }),
                                ListTile(
                                    leading: const Icon(Icons.cancel),
                                    title: Text(context.l10n.bottomSheetCancelButton),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    }),
                                const SizedBox(height: 24),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: switch (layer.isWriteActive) {
                              true => null,
                              false => () {
                                  ref
                                      .read(activeCalendarControllerProvider.notifier)
                                      .switchVisibility(!layer.isVisible, layer);
                                },
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: context.spacing.m,
                                  top: context.spacing.m,
                                  bottom: context.spacing.m,
                                  right: context.spacing.m),
                              child: Icon(
                                switch (layer.isVisible) { true => Icons.visibility, false => Icons.visibility_off },
                                size: context.spacing.l,
                                color: switch (layer.isWriteActive) {
                                  true => Theme.of(context).colorScheme.primary.withAlpha(127),
                                  false => Theme.of(context).colorScheme.primary
                                },
                              ),
                            ),
                          ),
                          switch (layer.name) {
                            "" => Text("📆", style: Theme.of(context).textTheme.titleLarge),
                            _ => Text(layer.name, style: Theme.of(context).textTheme.titleSmall)
                          },
                          SizedBox(width: context.spacingConfig.padding.size),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate(effects: [
      FadeEffect(duration: 200.ms, curve: Curves.easeOut),
      const ScaleEffect(begin: Offset(0, 0), curve: Curves.easeOut, alignment: Alignment(-0.8, -1)),
    ], target: activeSubMenu == OpenedTab.layers ? 1 : 0);
  }
}
