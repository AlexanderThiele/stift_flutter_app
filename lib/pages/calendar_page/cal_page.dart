import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/components/calendar_table/interactive_paint_view.dart';
import 'package:pencalendar/components/menu/color_palette_menu.dart';
import 'package:pencalendar/components/menu/fancy_selection_menu.dart';
import 'package:pencalendar/components/menu/pen_width_menu.dart';
import 'package:pencalendar/controller/calendar_controller.dart';
import 'package:pencalendar/controller/country_controller.dart';
import 'package:pencalendar/pages/calendar_page/widgets/year_widget.dart';

class ZoomEnabledNotifier extends ChangeNotifier {
  bool enabled = true;

  void enable() {
    enabled = true;
    notifyListeners();
  }

  void disable() {
    enabled = false;
    notifyListeners();
  }
}

class CalPage extends ConsumerWidget {
  final zoomEnabledProvider = ChangeNotifierProvider((_) => ZoomEnabledNotifier());

  final resetViewProvider = StateProvider((ref) => 0);

  CalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // do not remove this line otherwise no calendar will be loaded.
    ref.read(calendarControllerProvider.notifier).initCalendar();

    // load current country
    ref.read(countryControllerProvider.notifier);

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            const InteractivePaintView(),
            const SafeArea(
                child: TopRightCornerWidget()),
            SafeArea(child: ColorPaletteMenu()),
            const SafeArea(child: PenWidthMenu()),
            const SafeArea(child: FancySelectionMenu()),
          ],
        );
      }),
    );
  }
}
