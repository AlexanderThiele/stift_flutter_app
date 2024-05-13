import 'package:design_system/atoms/ds_text.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pencalendar/models/public_holiday.dart';
import 'package:week_of_year/date_week_extensions.dart';

class CalCellHolder {
  final Color color;
  final Color textColor;
  final DateTime dateTime;
  final DateTime now;
  final CellType cellType;
  final PublicHoliday? publicHoliday;

  CalCellHolder({
    required this.color,
    required this.textColor,
    required this.dateTime,
    required this.now,
    required this.cellType,
    this.publicHoliday,
  });

  TableCell build(BuildContext context, double height) {
    if (cellType == CellType.empty) {
      return EmptyCell(height: height);
    }
    if (cellType == CellType.month) {
      return CalCellMonth(
        height: height,
        color: color,
        textColor: textColor,
        dateTime: dateTime,
        context: context,
      );
    }
    String? weekNumber;
    if (dateTime.weekday == 1) {
      // its a monday
      // calculate the week number of datetime
      weekNumber = dateTime.weekOfYear.toString();
    }

    return CalCellDay(
      height: height,
      color: color,
      textColor: textColor,
      dateTime: dateTime,
      isToday: dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day,
      dayOfMonth: DateFormat("d").format(dateTime),
      dayOfWeek: DateFormat("E").format(dateTime).substring(0, 2),
      weekNumber: weekNumber,
      publicHoliday: publicHoliday,
    );
  }
}

class CalCellDay extends TableCell {
  CalCellDay({
    required double height,
    required Color color,
    required Color textColor,
    required DateTime dateTime,
    required final String dayOfMonth,
    required final String dayOfWeek,
    required final bool isToday,
    final String? weekNumber,
    PublicHoliday? publicHoliday,
    super.key,
  }) : super(
          child: Builder(
            builder: (context) {
              return Container(
                height: height,
                decoration: BoxDecoration(
                    color: color,
                    border: switch (isToday) {
                      true => Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
                      false => null
                    }),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayOfMonth,
                                style:
                                    Theme.of(context).textTheme.bodyMedium?.apply(fontWeightDelta: 2, color: textColor),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dayOfWeek,
                                style:
                                    Theme.of(context).textTheme.bodySmall?.apply(fontSizeDelta: -3, color: textColor),
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
                                          ?.apply(fontSizeDelta: -3, color: textColor)),
                                ],
                              ),
                            )
                        ],
                      ),
                      if (weekNumber != null)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: DsText.calenderInformation(weekNumber),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        );
}

class CalCellMonth extends TableCell {
  CalCellMonth({
    required double height,
    required Color color,
    required Color textColor,
    required DateTime dateTime,
    required BuildContext context,
    super.key,
  }) : super(
          child: Container(
            height: height,
            decoration: BoxDecoration(color: color),
            child: Align(
              alignment: Alignment.center,
              child: Text(DateFormat("MMMM").format(dateTime),
                  style: Theme.of(context).textTheme.titleLarge?.apply(color: textColor)),
            ),
          ),
        );
}

class EmptyCell extends TableCell {
  EmptyCell({required double height, super.key})
      : super(
          child: Container(
            height: height,
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: const SizedBox(),
          ),
        );
}

enum CellType {
  month,
  day,
  empty;
}
