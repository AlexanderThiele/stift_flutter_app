import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:pencalendar/utils/app_logger.dart';

class CalCellHolder {
  final Color color;
  final DateTime dateTime;
  final CellType cellType;
  final PublicHoliday? publicHoliday;

  CalCellHolder(
      {required this.color,
      required this.dateTime,
      required this.cellType,
      this.publicHoliday});

  TableCell build(BuildContext context, double height) {
    if (cellType == CellType.empty) {
      return EmptyCell(height: height);
    }
    if (cellType == CellType.month) {
      return CalCellMonth(
          height: height, color: color, dateTime: dateTime, context: context);
    }

    return CalCellDay(
        height: height,
        color: color,
        dateTime: dateTime,
        dayOfMonth: DateFormat("d").format(dateTime),
        dayOfWeek: DateFormat("E").format(dateTime).substring(0, 2),
        textStyle: Theme.of(context).textTheme.bodySmall,
        publicHoliday: publicHoliday);
  }
}

class CalCellDay extends TableCell {
  CalCellDay(
      {required double height,
      required Color color,
      required DateTime dateTime,
      required final String dayOfMonth,
      required final String dayOfWeek,
      required final TextStyle? textStyle,
      PublicHoliday? publicHoliday,
      Key? key})
      : super(
            key: key,
            child: Builder(builder: (context) {
              return Container(
                height: height,
                decoration: BoxDecoration(color: color),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayOfMonth,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.apply(fontWeightDelta: 2),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dayOfWeek,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.apply(fontSizeDelta: -3),
                          ),
                        ],
                      ),
                      if (publicHoliday != null) const SizedBox(width: 4),
                      if (publicHoliday != null)
                        Flexible(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(publicHoliday.localName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.apply(
                                        fontSizeDelta: -3,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground)),
                          ],
                        ))
                    ],
                  ),
                ),
              );
            }));
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
