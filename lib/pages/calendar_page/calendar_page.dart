import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/components/calendar_table/interactive_paint_view.dart';
import 'package:pencalendar/components/menu/color_palette_menu.dart';
import 'package:pencalendar/components/menu/fancy_selection_menu.dart';
import 'package:pencalendar/components/menu/layer_menu.dart';
import 'package:pencalendar/components/menu/pen_width_menu.dart';
import 'package:pencalendar/components/menu/top_right_corner_menu.dart';
import 'package:pencalendar/controller/country_controller.dart';
import 'package:pencalendar/routes.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:responsive_spacing/responsive_spacing.dart';

class CalendarPage extends GoRoute {
  CalendarPage(AppRoute appRoute)
      : super(
          path: appRoute.path,
          builder: (context, state) {
            return RateMyAppBuilder(
                rateMyApp: RateMyApp(
                  preferencesPrefix: 'rateMyApp_',
                  minDays: 3,
                  minLaunches: 5,
                  remindDays: 7,
                  remindLaunches: 10,
                  googlePlayIdentifier: 'app.tnx.tabletcalendar',
                  appStoreIdentifier: '1661094074',
                ),
                onInitialized: (context, rateMyApp) {
                  if (rateMyApp.shouldOpenDialog) {
                    rateMyApp.showRateDialog(
                      context,
                      title: context.l10n.rateAppTitle,
                      message: context.l10n.rateAppText,
                      rateButton: context.l10n.rateAppButton,
                      noButton: context.l10n.rateAppRateNoButton,
                      laterButton: context.l10n.rateAppRateLaterButton,
                      ignoreNativeDialog: Platform.isAndroid,
                      // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
                      dialogStyle: const DialogStyle(),
                      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
                    );
                  }
                },
                builder: (context) {
                  return const CalendarWidget();
                });
          },
        );
}

class CalendarWidget extends ConsumerWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // load current country
    ref.read(countryControllerProvider.notifier);

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Spacing(
          width: constraints.maxWidth,
          child: Stack(
            children: [
              const InteractivePaintView(),
              const SafeArea(child: TopRightCornerMenu()),
              SafeArea(child: ColorPaletteMenu()),
              const SafeArea(child: PenWidthMenu()),
              const SafeArea(child: LayerMenu()),
              const SafeArea(child: FancySelectionMenu()),
            ],
          ),
        );
      }),
    );
  }
}
