import 'package:flutter/material.dart';
import 'package:pencalendar/pages/calendar_page/widgets/opened_tab_widget.dart';
import 'package:pencalendar/pages/calendar_page/widgets/pencil_widget.dart';
import 'package:pencalendar/pages/calendar_page/widgets/undo_last_widget.dart';

import 'color_widget.dart';

class CalWidgets extends StatelessWidget {
  const CalWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OpenedTabWidget(),
              const SizedBox(width: 4),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  SizedBox(height: 2),
                  ColorPickerWidget(),
                  PencilWidget(),
                  UndoLastWidget()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
