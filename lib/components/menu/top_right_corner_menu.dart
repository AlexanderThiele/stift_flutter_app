import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/components/shader/sampler_shader.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:pencalendar/provider/router_provider.dart';
import 'package:pencalendar/repository/analytics/analytics_repository.dart';
import 'package:pencalendar/repository/repository_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TopRightCornerMenu extends ConsumerWidget {
  const TopRightCornerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(activeCalendarYearProvider);
    final activeShader = ref.watch(activeShaderProvider);

    return SamplerShader(
      activeShaderType: activeShader,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                heroTag: "year.back",
                mini: true,
                onPressed: () {
                  ref.read(activeCalendarControllerProvider.notifier).changeYear(year - 1);
                },
                elevation: 1,
                child: const Icon(Icons.arrow_back)),
            Card(
                surfaceTintColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("$year", style: Theme.of(context).textTheme.titleLarge),
                )),
            FloatingActionButton(
                heroTag: "year.forward",
                mini: true,
                onPressed: () {
                  ref.read(activeCalendarControllerProvider.notifier).changeYear(year + 1);
                },
                elevation: 1,
                child: const Icon(Icons.arrow_forward)),
            FloatingActionButton(
              heroTag: "menu",
              mini: true,
              onPressed: null,
              elevation: 1,
              child: PopupMenuButton<int>(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      child: Text(context.l10n.helpButton),
                    ),
                    PopupMenuItem(
                      value: 30,
                      child: Text(context.l10n.shareCalendar),
                    ),
                    PopupMenuItem(
                      value: 10,
                      child: Text(context.l10n.rateAppButton),
                    ),
                    PopupMenuItem(
                      value: 20,
                      child: Text(context.l10n.sendFeedbackButton),
                    ),
                    PopupMenuItem(
                      value: 40,
                      child: Text(context.l10n.premiumGoToPremiumPage),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      ref.read(activeCalendarControllerProvider.notifier).deleteAll();
                      break;
                    case 1:
                      launchUrlString(context.l10n.helpWebsite);
                      ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.howItWorks);
                      break;
                    case 10:
                      InAppReview.instance.openStoreListing(appStoreId: "1661094074");
                      ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.rateApp);
                      break;
                    case 20:
                      launchUrlString("mailto:alex@tnx-apps.com?subject=App%20Feedback");
                      break;
                    case 30:
                      GoRouter.of(context).push(AppRoute.shareCalendar.path);
                      break;
                    case 40:
                      GoRouter.of(context).push(AppRoute.paywall.path);
                      break;
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
