import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppWrapper extends StatelessWidget {
  final Widget child;

  const RateAppWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
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
        builder: (context) => child);
  }
}
