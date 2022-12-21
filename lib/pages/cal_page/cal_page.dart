import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/cal/interactive_paint_view.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/calendar_controller.dart';
import 'package:pencalendar/pages/cal_page/widgets/brushes_widget.dart';
import 'package:pencalendar/pages/cal_page/widgets/color_widget.dart';
import 'package:pencalendar/pages/cal_page/widgets/width_slider_widget.dart';
import 'package:pencalendar/pages/cal_page/widgets/year_widget.dart';

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
  final zoomEnabledProvider =
      ChangeNotifierProvider((_) => ZoomEnabledNotifier());

  final resetViewProvider = StateProvider((ref) => 0);

  CalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ZoomEnabledNotifier zoomEnabled = ref.watch(zoomEnabledProvider);
    final selectedYear = ref.watch(activeCalendarYearProvider);
    // do not remove this line otherwise no calendar will be loaded.
    ref.watch(calendarControllerProvider);

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            InteractivePaintView(),
            SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                  YearWidget(),
                  ColorPickerWidget(),
                  BrushesWidget(),
                  WidthSliderWidget()
                ]))
          ],
        );
      }),
    );
  }
}
