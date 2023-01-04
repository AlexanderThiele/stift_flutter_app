import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_opened_tab_controller.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/pages/cal_page/widgets/opened_tab_brush.dart';
import 'package:pencalendar/pages/cal_page/widgets/opened_tab_color.dart';

class OpenedTabWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openedTab = ref.watch(openedTabProvider);
    switch (openedTab) {
      case OpenedTab.color:
        return OpenedTabColor();
      case OpenedTab.pen:
        return OpenedTabBrush();
      default:
        return const SizedBox();
    }
  }
}
