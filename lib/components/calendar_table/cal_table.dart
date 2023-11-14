import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pencalendar/components/calendar_table/widgets/cal_cell.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:pencalendar/utils/const/cal_size.dart';

class CalTable extends StatefulWidget {
  final int year;
  final List<PublicHoliday> publicHolidays;
  late final DateTime firstDayOfYear = DateTime(year);

  CalTable({required this.year, required this.publicHolidays, super.key});

  @override
  State<CalTable> createState() => _CalTableState();
}

class _CalTableState extends State<CalTable> {
  final int maxRows = 32;
  late final double cellHeight = calHeight / maxRows;
  final double cellWidth = calWidth / 12;

  final List<Color> monthColors = [
    Colors.blue.shade300,
    Colors.blue.shade100,
    Colors.teal.shade500,
    Colors.teal.shade300,
    Colors.green.shade400,
    Colors.green.shade200,
    Colors.yellow.shade300,
    Colors.orange.shade200,
    Colors.orange.shade500,
    Colors.red.shade200,
    Colors.red.shade400,
    Colors.purple.shade300,
    Colors.blue.shade300
  ];

  /// This will cache the cells for the next build
  late List<List<CalCellHolder>> cachedAllCells = allCells;

  List<List<CalCellHolder>> get allCells {
    List<List<CalCellHolder>> list = [];

    // every month
    for (int i = 0; i < 12; i++) {
      List<CalCellHolder> dayList = [];
      dayList.add(CalCellHolder(
          color: monthColors[i], cellType: CellType.month, dateTime: DateTime(widget.firstDayOfYear.year, i + 1)));

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
            cellType: cellType,
            dateTime: day,
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

  @override
  void didUpdateWidget(CalTable oldWidget) {
    final bool isSameWidgetData =
        widget.publicHolidays.equals(oldWidget.publicHolidays) && widget.year == oldWidget.year;
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
