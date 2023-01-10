import 'package:design_system/buttons/side_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_color_controller.dart';
import 'package:pencalendar/controller/active_opened_tab_controller.dart';
import 'package:pencalendar/models/opened_tab.dart';

class ColorPickerWidget extends ConsumerWidget {
  const ColorPickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(activeColorProvider);
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            ref.read(openedTabProvider.notifier).state = OpenedTab.color;
          },
          child: Container(
              height: 34,
              width: 16,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(32))),
        ),
        SideMenuButton(
            onTap: () {
              ref.read(openedTabProvider.notifier).state = OpenedTab.color;
            },
            iconData: Icons.palette_outlined),
      ],
    );
  }
}
