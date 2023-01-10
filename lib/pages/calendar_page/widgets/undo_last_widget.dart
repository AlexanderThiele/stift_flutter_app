import 'package:design_system/buttons/side_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';

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
