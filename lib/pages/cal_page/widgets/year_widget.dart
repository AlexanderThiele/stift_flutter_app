import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';

class YearWidget extends ConsumerWidget {
  const YearWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(activeCalendarYearProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              mini: true,
              onPressed: () {
                ref
                    .read(activeCalendarControllerProvider.notifier)
                    .changeYear(year - 1);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white)),
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Text("$year",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.apply(color: Colors.white))),
          FloatingActionButton(
              mini: true,
              onPressed: () {
                ref
                    .read(activeCalendarControllerProvider.notifier)
                    .changeYear(year + 1);
              },
              child: const Icon(Icons.arrow_forward, color: Colors.white))
        ],
      ),
    );
  }
}
