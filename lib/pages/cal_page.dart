import 'package:flutter/material.dart';
import 'package:pencalendar/cal/cal_table.dart';
import 'package:pencalendar/cal/paint_view.dart';
import 'package:pencalendar/zoom/zoom_widget.dart';

class CalPage extends StatefulWidget {
  const CalPage({Key? key}) : super(key: key);

  @override
  State<CalPage> createState() => _CalPageWidgetState();
}

class _CalPageWidgetState extends State<CalPage> {
  bool zoomEnabled = true;

  final double width = 2048;
  final double height = 1536;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Zoom(
          initZoom: 0.3,
          initialPos: Offset(-width / 6, -height / 5),
          centerOnScale: false,
          maxZoomWidth: width * 2,
          maxZoomHeight: height * 2,
          zoomSensibility: 1,
          enabled: zoomEnabled,
          canvasColor: Colors.lime.shade50,
          backgroundColor: Colors.lime.shade50,
          doubleTapZoom: false,
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: height / 2, horizontal: width / 2),
            child: Stack(
              children: [
                CalTable(2022),
                PaintView(
                    color: Colors.black,
                    enableZoom: () {
                      setState(() {
                        zoomEnabled = true;
                      });
                    },
                    disableZoom: () {
                      setState(() {
                        zoomEnabled = false;
                      });
                    })
              ],
            ),
          )),
    );
  }
}
