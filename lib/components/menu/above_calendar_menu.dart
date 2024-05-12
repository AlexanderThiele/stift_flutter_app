import 'dart:async';

import 'package:design_system/atoms/ds_calendar_color_option.dart';
import 'package:design_system/atoms/ds_gutter.dart';
import 'package:design_system/buttons/ds_calendar_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/controller/calendar_color_controller.dart';
import 'package:pencalendar/controller/feature_notifier.dart';
import 'package:pencalendar/provider/router_provider.dart';

class AboveCalendarMenu extends ConsumerStatefulWidget {
  const AboveCalendarMenu({super.key});

  @override
  ConsumerState<AboveCalendarMenu> createState() => _AboveCalendarMenuState();
}

class _AboveCalendarMenuState extends ConsumerState<AboveCalendarMenu> with TickerProviderStateMixin {
  bool menuOpen = false;
  late final AnimationController animationController;
  final int openedMenuHeightMax = 36;
  double menuHeight = 0;

  Timer? premiumRevertTimer;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    animationController.addListener(() {
      setState(() {
        menuHeight = openedMenuHeightMax * animationController.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeFeatures = ref.watch(activeFeatureNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    menuOpen = !menuOpen;
                  });
                },
                icon: Icon(
                  Icons.color_lens_outlined,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ],
        ),
        Row(
          children: [
            for (final calendarOption in DsCalendarColorOption.values) ...[
              DsCalendarColorButton(
                height: menuHeight,
                calendarColorOption: calendarOption,
                onTap: () {
                  ref.read(calendarColorProvider.notifier).changeColorOption(calendarOption);
                  if (calendarOption.premium && !activeFeatures.activePremium) {
                    premiumRevertTimer?.cancel();
                    premiumRevertTimer = Timer(const Duration(seconds: 2), () {
                      ref.read(calendarColorProvider.notifier).changeColorOption(DsCalendarColorOption.standard);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(context.l10n.premiumCalendarColorTitle),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(context.l10n.premiumCalendarColorText,
                                    style: Theme.of(context).textTheme.bodyMedium)
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
                                    navigator.pop();
                                    GoRouter.of(context).push(AppRoute.paywall.path);
                                  },
                                  child: Text(context.l10n.premiumViewPriceButton))
                            ],
                          );
                        },
                      );
                    });
                  }
                },
              ),
              const DsGutter.row(),
            ],
          ],
        ).animate(
          controller: animationController,
          effects: [
            ScaleEffect(
                duration: 300.ms,
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                alignment: const Alignment(0, 1),
                curve: Curves.easeInOutExpo)
          ],
          autoPlay: true,
          target: menuOpen ? 1 : 0,
        ),
        SizedBox(height: 4),
      ],
    );
  }
}
