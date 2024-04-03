import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/components/calendar_table/interactive_paint_view.dart';
import 'package:pencalendar/components/menu/color_palette_menu.dart';
import 'package:pencalendar/components/menu/layer_menu.dart';
import 'package:pencalendar/components/menu/pen_width_menu.dart';
import 'package:pencalendar/components/menu/top_left_corner_menu.dart';
import 'package:pencalendar/components/menu/top_right_corner_menu.dart';
import 'package:pencalendar/components/wrapper/rate_app_wrapper.dart';
import 'package:pencalendar/components/wrapper/startup_dialog_wrapper.dart';
import 'package:pencalendar/controller/country_controller.dart';
import 'package:responsive_spacing/responsive_spacing.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // load current country
    ref.read(countryControllerProvider.notifier);

    return StartupDialogWrapper(
      child: RateAppWrapper(
        child: Scaffold(
          body: LayoutBuilder(builder: (context, constraints) {
            return Spacing(
              width: constraints.maxWidth,
              child: Stack(
                children: [
                  const InteractivePaintView(),
                  const SafeArea(child: TopRightCornerMenu()),
                  SafeArea(child: ColorPaletteMenu()),
                  const SafeArea(child: PenWidthMenu()),
                  const SafeArea(child: LayerMenu()),
                  const SafeArea(child: TopLeftCornerMenu()),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
