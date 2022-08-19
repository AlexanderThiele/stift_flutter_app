import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalCellHolder {
  final Color color;
  final DateTime dateTime;
  final CellType cellType;

  CalCellHolder(
      {required this.color, required this.dateTime, required this.cellType});

  TableCell build(BuildContext context, double height) {
    if (cellType == CellType.empty) {
      return EmptyCell(height: height);
    }
    if (cellType == CellType.month) {
      return CalCellMonth(
          height: height, color: color, dateTime: dateTime, context: context);
    }
    return CalCellDay(
        height: height, color: color, dateTime: dateTime, context: context);
  }
}

class CalCellDay extends TableCell {
  CalCellDay(
      {required double height,
      required Color color,
      required DateTime dateTime,
      required BuildContext context,
      Key? key})
      : super(
            key: key,
            child: Container(
              height: height,
              decoration: BoxDecoration(color: color),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text(
                      DateFormat("d").format(dateTime),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat("E").format(dateTime).substring(0, 2),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ));
}

class CalCellMonth extends TableCell {
  CalCellMonth(
      {required double height,
      required Color color,
      required DateTime dateTime,
      required BuildContext context,
      Key? key})
      : super(
            key: key,
            child: Container(
                height: height,
                decoration: BoxDecoration(color: color),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    DateFormat("MMMM").format(dateTime),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )));
}

class EmptyCell extends TableCell {
  EmptyCell({required double height, Key? key})
      : super(
            key: key,
            child: Container(
                height: height,
                decoration: BoxDecoration(color: Colors.grey.shade200),
                child: const SizedBox()));
}

enum CellType {
  month,
  day,
  empty;
}
