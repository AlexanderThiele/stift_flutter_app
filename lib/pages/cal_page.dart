import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/cal/cal_table.dart';
import 'package:pencalendar/cal/paint_view.dart';
import 'package:pencalendar/controller/calendar_controller.dart';
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/repo/firestore_repository.dart';
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
    final List<Calendar> allCalendars = ref.watch(calendarControllerProvider);

    print("got $allCalendars");

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final initialZoom = constraints.maxWidth / width;
        return Zoom(
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
              margin: EdgeInsets.symmetric(vertical: 50),
              child: Stack(
                children: [
                  CalTable(selectedYear.currentYear),
                  PaintView(
                      color: Colors.black,
                      enableZoom: () {
                        zoomEnabled.enable();
                      },
                      disableZoom: () {
                        zoomEnabled.disable();
                      })
                ],
              ),
            ));
      }),
    );
  }
}
