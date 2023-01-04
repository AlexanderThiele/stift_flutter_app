import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_opened_tab_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/design/buttons/side_menu_button.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/opened_tab.dart';

class UndoLastWidget extends ConsumerWidget {
  const UndoLastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SideMenuButton(onTap: () {
              ref.read(activeCalendarControllerProvider.notifier).deleteLast();
            }, iconData: Icons.undo)
      ],
    );
  }
}
