import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_layer.dart';
import 'package:pencalendar/models/single_draw.dart';

class CalendarWithDrawings {
  final Calendar? calendar;
  final List<CalendarLayer> layerList;

  /// first search is done by late keyword
  late CalendarLayer currentWritableCalendarLayer = layerList.firstWhere((element) => element.isWriteActive);

  CalendarWithDrawings(this.calendar, {required this.layerList});

  List<SingleDraw> get allVisibleDrawings => [
        for (final layer in layerList)
          if (layer.isVisible) ...layer.drawingList
      ];

  void addDrawingToWritable(SingleDraw singleDraw) {
    currentWritableCalendarLayer.drawingList.add(singleDraw);
  }

  (CalendarLayer?, SingleDraw?) deleteLast() {
    if (currentWritableCalendarLayer.drawingList.isEmpty) {
      return (null, null);
    }
    return (currentWritableCalendarLayer, currentWritableCalendarLayer.drawingList.removeLast());
  }

  deleteSingleDrawingsFromWritable(List<SingleDraw> singleDrawList) {
    for (final singleDraw in singleDrawList) {
      currentWritableCalendarLayer.drawingList.remove(singleDraw);
    }
  }

  void clearAllLayer() {
    for (final calendarLayer in layerList) {
      calendarLayer.drawingList.clear();
    }
  }

  void addLayer(CalendarLayer calendarLayer) {
    layerList.add(calendarLayer);
  }
}
