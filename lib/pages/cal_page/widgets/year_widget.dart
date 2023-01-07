import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_touch_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

class YearWidget extends ConsumerWidget {
  const YearWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(activeCalendarYearProvider);
    final touchDrawEnabled = ref.watch(activeTouchProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              mini: true,
              onPressed: () {
                ref.read(activeTouchProvider.notifier).state =
                    !touchDrawEnabled;
              },
              child: Builder(builder: (context) {
                if (touchDrawEnabled) {
                  return const Icon(Icons.touch_app);
                }
                return const Icon(Icons.do_not_touch);
              })),
          FloatingActionButton(
              mini: true,
              onPressed: () {
                ref
                    .read(activeCalendarControllerProvider.notifier)
                    .changeYear(year - 1);
              },
              child: const Icon(Icons.arrow_back)),
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child:
                  Text("$year", style: Theme.of(context).textTheme.titleLarge)),
          FloatingActionButton(
              mini: true,
              onPressed: () {
                ref
                    .read(activeCalendarControllerProvider.notifier)
                    .changeYear(year + 1);
              },
              child: const Icon(Icons.arrow_forward)),
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text("Clear Year"),
                ),
                const PopupMenuItem(
                  value: 10,
                  child: Text("Rate App"),
                ),
                const PopupMenuItem(
                  value: 20,
                  child: Text("Send Feedback"),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 0:
                  ref
                      .read(activeCalendarControllerProvider.notifier)
                      .deleteAll();
                  break;
                case 10:
                  InAppReview.instance
                      .openStoreListing(appStoreId: "1661094074");
                  break;
                case 20:
                  launchUrlString(
                      "mailto:alex@tnx-apps.com?subject=App%20Feedback");
                  break;
              }
            },
          )
        ],
      ),
    );
  }
}
