import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/cal/cal_table.dart';
import 'package:pencalendar/cal/paint_view.dart';
import 'package:pencalendar/cal/saved_paint_layer.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_color_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/controller/calendar_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/pages/cal_page/widgets/color_widget.dart';
import 'package:pencalendar/pages/cal_page/widgets/width_slider_widget.dart';
import 'package:pencalendar/pages/cal_page/widgets/year_widget.dart';
import 'package:pencalendar/zoom/zoom_widget.dart';

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

class SelectedYearNotifier extends ChangeNotifier {
  int currentYear = DateTime.now().year;
}

class CalPage extends HookConsumerWidget {
  final zoomEnabledProvider =
      ChangeNotifierProvider((_) => ZoomEnabledNotifier());
  final selectedYearProvider =
      ChangeNotifierProvider((ref) => SelectedYearNotifier());

  //final double width = 2048;
  //final double height = 1536;
  final double width = 1600;
  final double height = 1200;

  CalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ZoomEnabledNotifier zoomEnabled = ref.watch(zoomEnabledProvider);
    final SelectedYearNotifier selectedYear = ref.watch(selectedYearProvider);
    final Color activeColor = ref.watch(activeColorProvider);
    final widthProvider = ref.watch(activeWidthProvider);
    final List<Calendar> allCalendars = ref.watch(calendarControllerProvider);

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final initialZoom = constraints.maxWidth / width;
        return Stack(
          children: [
            Zoom(
                initZoom: initialZoom,
                // initialPos: Offset(-width / 6, -height / 5),
                centerOnScale: false,
                maxZoomWidth: width,
                maxZoomHeight: height,
                zoomSensibility: 30,
                enabled: zoomEnabled.enabled,
                canvasColor: Colors.lime.shade50,
                backgroundColor: Colors.lime.shade50,
                doubleTapZoom: false,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  child: Stack(
                    children: [
                      CalTable(selectedYear.currentYear),
                      SavedPaintLayer(),
                      PaintView(
                          color: activeColor,
                          activeWidth: widthProvider,
                          enableZoom: () {
                            zoomEnabled.enable();
                          },
                          disableZoom: () {
                            zoomEnabled.disable();
                          },
                          onPaintEnd: (List<Offset> pointList, Color color,
                              double size) {
                            final calendarController = ref.read(
                                activeCalendarControllerProvider.notifier);
                            calendarController.saveSignatur(
                                pointList, color, size);
                          }),
                    ],
                  ),
                )),
            SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [YearWidget(), ColorPickerWidget(), WidthSliderWidget()]))
          ],
        );
      }),
    );
  }
}
