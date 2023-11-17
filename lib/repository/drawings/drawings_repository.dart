import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/single_draw.dart';

abstract class DrawingsRepository {
  List<SingleDraw> loadDrawings(int year);

  Future<void> createSingleCalendarDrawings(Calendar? calendar, SingleDraw singleDraw, String id);

  Future<void> deleteSingleCalendarDrawings(Calendar? calendar, SingleDraw singleDraw);

  Future<void> deleteSingleCalendarDrawingList(Calendar? calendar, List<SingleDraw> singleDraw);
}
