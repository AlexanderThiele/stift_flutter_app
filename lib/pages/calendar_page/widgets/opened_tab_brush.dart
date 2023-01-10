import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/design/buttons/side_menu_button_small.dart';
import 'package:pencalendar/models/brush.dart';

class OpenedTabBrush extends ConsumerWidget {
  const OpenedTabBrush({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeBrushProvider.notifier).state = Brush.pen;
            },
            iconData: Icons.brush),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeBrushProvider.notifier).state = Brush.eraser;
            },
            iconData: FontAwesomeIcons.eraser),
        Container(
            height: 1,
            width: 20,
            decoration: BoxDecoration(color: Theme.of(context).dividerColor)),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 0.1;
            },
            widget: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)),
              width: 1,
              height: 1,
            )),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 0.5;
            },
            widget: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)),
              width: 2,
              height: 2,
            )),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 1;
            },
            widget: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)),
              width: 4,
              height: 4,
            )),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 2;
            },
            widget: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)),
              width: 6,
              height: 6,
            )),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 5;
            },
            widget: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)),
              width: 8,
              height: 8,
            )),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 9;
            },
            widget: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)),
              width: 12,
              height: 12,
            )),
        Container(
            height: 1,
            width: 20,
            decoration: BoxDecoration(color: Theme.of(context).dividerColor)),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state =
                  ref.read(activeWidthProvider) + 1;
            },
            iconData: Icons.keyboard_arrow_up),
        SideMenuButtonSmall(
            onTap: () {
              double width = ref.read(activeWidthProvider) - 1;
              if (width <= 0) {
                width = 0.5;
              }
              ref.read(activeWidthProvider.notifier).state = width;
            },
            iconData: Icons.keyboard_arrow_down),
      ],
    );
  }
}
