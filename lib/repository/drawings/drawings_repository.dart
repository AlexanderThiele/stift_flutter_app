import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/calendar_layer.dart';
import 'package:pencalendar/models/single_draw.dart';

abstract class DrawingsRepository {
  Future<void> createSingleCalendarDrawings(Calendar? calendar, CalendarLayer calendarLayer, SingleDraw singleDraw);

  Future<void> deleteSingleCalendarDrawings(Calendar? calendar, CalendarLayer calendarLayer, SingleDraw singleDraw);

  Future<void> deleteCalendarDrawings(Calendar? calendar, CalendarLayer calendarLayer, List<SingleDraw> singleDrawList);

  Future<void> deleteSingleCalendarDrawingList(
      Calendar? calendar, CalendarLayer calendarLayer, List<SingleDraw> singleDraw);

  Future<List<CalendarLayer>> loadAllCalendarLayer(int year);

  Future<int> createNewCalendarLayer(CalendarLayer calendarLayer);

  Future<void> deleteCalendarLayer(CalendarLayer calendarLayer);

  Future<void> saveAllCalendarLayer(List<CalendarLayer> calendarLayer);

  Future<void> clearCalendarLayer(CalendarLayer calendarLayer);
}
