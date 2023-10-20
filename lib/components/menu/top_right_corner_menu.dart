import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pencalendar/components/shader/sampler_shader.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TopRightCornerMenu extends ConsumerWidget {
  const TopRightCornerMenu({Key? key}) : super(key: key);

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
                mini: true,
                onPressed: () {
                  ref.read(activeCalendarControllerProvider.notifier).changeYear(year - 1);
                },
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                child: const Icon(Icons.arrow_back)),
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Text("$year", style: Theme.of(context).textTheme.titleLarge)),
            FloatingActionButton(
                mini: true,
                onPressed: () {
                  ref.read(activeCalendarControllerProvider.notifier).changeYear(year + 1);
                },
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surface,
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
                    ref.read(activeCalendarControllerProvider.notifier).deleteAll();
                    break;
                  case 10:
                    InAppReview.instance.openStoreListing(appStoreId: "1661094074");
                    break;
                  case 20:
                    launchUrlString("mailto:alex@tnx-apps.com?subject=App%20Feedback");
                    break;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
