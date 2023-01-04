import 'package:flutter/material.dart';
import 'package:pencalendar/cal/widgets/cal_cell.dart';
import 'package:pencalendar/utils/const/cal_size.dart';

class CalTable extends StatelessWidget {
  final int year;
  final DateTime firstDayOfYear;
  final int maxRows = 32;

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

  CalTable(this.year, {Key? key})
      : firstDayOfYear = DateTime(year),
        super(key: key);

  List<List<CalCellHolder>> get allCells {
    List<List<CalCellHolder>> list = [];

    // every month
    for (int i = 0; i < 12; i++) {
      List<CalCellHolder> dayList = [];
      dayList.add(CalCellHolder(
          color: monthColors[i],
          cellType: CellType.month,
          dateTime: DateTime(firstDayOfYear.year, i + 1)));

      // days in a month
      for (int j = 0; j < 31; j++) {
        int month = i + 1;
        Color color = Colors.white;
        DateTime day = DateTime(firstDayOfYear.year, month, j + 1);
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
        ));
      }
      list.add(dayList);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    print("build cal table");
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cellHeight = calHeight / maxRows;
        const double cellWidth = calWidth / 12;
        // print(calHeight / maxRows);
        // print(calWidth / 12);
        List<TableRow> tableRows = [];

        for (int i = 0; i < maxRows; i++) {
          List<TableCell> tableCells = [];
          for (var monthCells in allCells) {
            tableCells.add(monthCells[i].build(context, cellHeight));
          }
          tableRows.add(TableRow(children: tableCells));
        }
        return Table(
          border: TableBorder.all(),
          defaultColumnWidth: FixedColumnWidth(cellWidth),
          children: tableRows,
        );
      },
    );
  }
}
