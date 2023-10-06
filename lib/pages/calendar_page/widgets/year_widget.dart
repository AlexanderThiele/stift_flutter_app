import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/models/shader_type.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TopRightCornerWidget extends ConsumerWidget {
  const TopRightCornerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(activeCalendarYearProvider);
    final touchDrawEnabled = ref.watch(activeTouchProvider);
    final activeShader = ref.watch(activeShaderProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              mini: true,
              onPressed: () {
                if (activeShader.index >= ShaderType.values.length - 1) {
                  ref.read(activeShaderProvider.notifier).state = ShaderType.values.first;
                } else {
                  ref.read(activeShaderProvider.notifier).state = ShaderType.values[activeShader.index + 1];
                }
              },
              child: Builder(builder: (context) {
                return switch (activeShader) {
                  ShaderType.none => const Icon(
                      Icons.animation,
                      color: Colors.grey,
                    ),
                  ShaderType.focus => const Icon(
                      Icons.animation,
                      color: Colors.blue,
                    ),
                  ShaderType.focusFast => const Icon(
                      Icons.animation,
                      color: Colors.red,
                    ),
                };
              })),
          FloatingActionButton(
              mini: true,
              onPressed: () {
                ref.read(activeTouchProvider.notifier).state = !touchDrawEnabled;
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
                ref.read(activeCalendarControllerProvider.notifier).changeYear(year - 1);
              },
              child: const Icon(Icons.arrow_back)),
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Text("$year", style: Theme.of(context).textTheme.titleLarge)),
          FloatingActionButton(
              mini: true,
              onPressed: () {
                ref.read(activeCalendarControllerProvider.notifier).changeYear(year + 1);
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
    );
  }
}
