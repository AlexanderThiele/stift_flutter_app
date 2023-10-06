import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/models/opened_tab.dart';
import 'package:pencalendar/pages/calendar_page/widgets/opened_tab_brush.dart';
import 'package:pencalendar/pages/calendar_page/widgets/opened_tab_color.dart';
import 'package:pencalendar/provider/active_menu_provider.dart';

class OpenedTabWidget extends ConsumerWidget {
  const OpenedTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openedTab = ref.watch(openedTabProvider);
    switch (openedTab) {
      case OpenedTab.color:
        return OpenedTabColor();
      case OpenedTab.pen:
        return const OpenedTabBrush();
      default:
        return const SizedBox();
    }
  }
}
