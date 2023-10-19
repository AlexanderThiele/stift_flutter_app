import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/components/calendar_table/interactive_paint_view.dart';
import 'package:pencalendar/components/menu/color_palette_menu.dart';
import 'package:pencalendar/components/menu/fancy_selection_menu.dart';
import 'package:pencalendar/components/menu/pen_width_menu.dart';
import 'package:pencalendar/components/menu/top_right_corner_menu.dart';
import 'package:pencalendar/controller/calendar_controller.dart';
import 'package:pencalendar/controller/country_controller.dart';

class CalPage extends ConsumerWidget {

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
            const SafeArea(child: TopRightCornerMenu()),
            SafeArea(child: ColorPaletteMenu()),
            const SafeArea(child: PenWidthMenu()),
            const SafeArea(child: FancySelectionMenu()),
          ],
        );
      }),
    );
  }
}
