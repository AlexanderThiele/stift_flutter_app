import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/controller/rate_app_notifier.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppWrapper extends ConsumerWidget {
  final Widget child;

  const RateAppWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if (rateMyApp.shouldOpenDialog && ref.read(rateAppNotifierProvider)) {
            rateMyApp.showRateDialog(
              context,
              title: context.l10n.rateAppTitle,
              message: context.l10n.rateAppText,
              rateButton: context.l10n.rateAppButton,
              noButton: context.l10n.rateAppRateNoButton,
              laterButton: context.l10n.rateAppRateLaterButton,
              ignoreNativeDialog: false,
              listener: (RateMyAppDialogButton button) {
                switch (button) {
                  case RateMyAppDialogButton.rate:
                    ref.read(rateAppNotifierProvider.notifier).rateAppOpened();
                  default:
                }
                return true; // do not cancel the click event
              },
              dialogStyle: const DialogStyle(),
              onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
            );
          }
        },
        builder: (context) => child);
  }
}
