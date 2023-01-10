import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/design/buttons/side_menu_button.dart';

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
