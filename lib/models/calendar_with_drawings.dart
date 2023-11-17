
import 'package:pencalendar/models/Calendar.dart';
import 'package:pencalendar/models/single_draw.dart';

class CalendarWithDrawings {
  final Calendar? calendar;
  final List<SingleDraw> drawingList;

  CalendarWithDrawings(this.calendar, {this.drawingList = const []});
}
