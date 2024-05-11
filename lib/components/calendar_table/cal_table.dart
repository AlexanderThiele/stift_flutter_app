import 'package:collection/collection.dart';
import 'package:design_system/atoms/ds_calendar_color_option.dart';
import 'package:flutter/material.dart';
import 'package:pencalendar/components/calendar_table/widgets/cal_cell.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:pencalendar/utils/const/cal_size.dart';

class CalTable extends StatefulWidget {
  final int year;
  final List<PublicHoliday> publicHolidays;
  final DsCalendarColorOption calendarColor;
  late final DateTime firstDayOfYear = DateTime(year);

  CalTable({
    required this.year,
    required this.publicHolidays,
    super.key,
    required this.calendarColor,
  });

  @override
  State<CalTable> createState() => _CalTableState();
}

class _CalTableState extends State<CalTable> {
  final int maxRows = 32;
  late final double cellHeight = calHeight / maxRows;
  final double cellWidth = calWidth / 12;
  final DateTime now = DateTime.now();

  /// This will cache the cells for the next build
  late List<List<CalCellHolder>> cachedAllCells = allCells;

  List<List<CalCellHolder>> get allCells {
    List<List<CalCellHolder>> list = [];

    final monthColors = widget.calendarColor.calendarColors;
    // every month
    for (int i = 0; i < 12; i++) {
      List<CalCellHolder> dayList = [];
      dayList.add(CalCellHolder(
        color: monthColors[i],
        textColor: calculateTextColor(monthColors[i]),
        cellType: CellType.month,
        dateTime: DateTime(widget.firstDayOfYear.year, i + 1),
        now: now,
      ));

      // days in a month
      for (int j = 0; j < 31; j++) {
        int month = i + 1;
        Color color = Colors.white;
        DateTime day = DateTime(widget.firstDayOfYear.year, month, j + 1);
        CellType cellType = CellType.day;

        if (day.month != month) {
          cellType = CellType.empty;
        }

        if (day.weekday == 6 || day.weekday == 7) {
          color = monthColors[i];
        }

        dayList.add(CalCellHolder(
            color: color,
            textColor: calculateTextColor(color),
            cellType: cellType,
            dateTime: day,
            now: now,
            publicHoliday: widget.publicHolidays.firstWhereOrNull((element) =>
                element.date.year == day.year && element.date.month == day.month && element.date.day == day.day)));
      }
      list.add(dayList);
    }
    return list;
  }

  /// This will cache the tableRows for the next build
  late List<TableRow> cachedTableRows = tableRows;

  List<TableRow> get tableRows {
    List<TableRow> tableRows = [];

    for (int i = 0; i < maxRows; i++) {
      List<TableCell> tableCells = [];
      for (var monthCells in cachedAllCells) {
        tableCells.add(monthCells[i].build(context, cellHeight));
      }
      tableRows.add(TableRow(children: tableCells));
    }

    return tableRows;
  }

  Color calculateTextColor(Color backgroundColor) {
    // Calculate relative luminance
    double luminance = 0.2126 * backgroundColor.red + 0.7152 * backgroundColor.green + 0.0722 * backgroundColor.blue;

    // Choose text color based on luminance
    return luminance > (0.45 * 255) ? Colors.black : Colors.white;
  }

  @override
  void didUpdateWidget(CalTable oldWidget) {
    final bool isSameWidgetData = widget.publicHolidays.equals(oldWidget.publicHolidays) &&
        widget.year == oldWidget.year &&
        widget.calendarColor == oldWidget.calendarColor;
    if (!isSameWidgetData) {
      // widget data has changed. refresh the table cache
      cachedAllCells = allCells;
      cachedTableRows = tableRows;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultColumnWidth: FixedColumnWidth(cellWidth),
      children: cachedTableRows,
    );
  }
}
