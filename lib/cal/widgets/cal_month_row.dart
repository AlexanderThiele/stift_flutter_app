import 'package:flutter/material.dart';
import 'package:pencalendar/cal/widgets/cal_cell.dart';

class CalRow extends TableRow {
  const CalRow(double maxHeight,
      List<CalCellDay> cells)
      : super(children: cells);
}

/*

          ...[for (int i = 0; i < 12; i++) i]
              .map((number) => CalCell(
                  maxHeight / 32,
                  Colors.red,
                  firstDayOfMonth,
                  Text(
                    DateFormat("MMMM").format(firstDayOfMonth),
                    style: Theme.of(context).textTheme.titleLarge,
                  )))
              .toList()
 */
