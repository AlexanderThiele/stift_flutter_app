
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/design/buttons/side_menu_button_small.dart';
import 'package:pencalendar/models/brush.dart';

class OpenedTabBrush extends ConsumerWidget {
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
              ref.read(activeWidthProvider.notifier).state = 1;
            },
            iconData: FontAwesomeIcons.one),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 2;
            },
            iconData: FontAwesomeIcons.two),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 3;
            },
            iconData: FontAwesomeIcons.three),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 4;
            },
            iconData: FontAwesomeIcons.four),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 5;
            },
            iconData: FontAwesomeIcons.five),
        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = 9;
            },
            iconData: FontAwesomeIcons.nine),
        Container(
            height: 1,
            width: 20,
            decoration: BoxDecoration(color: Theme.of(context).dividerColor)),

        SideMenuButtonSmall(
            onTap: () {
              ref.read(activeWidthProvider.notifier).state = ref.read(activeWidthProvider) + 1;
            },
            iconData: Icons.keyboard_arrow_up),
        SideMenuButtonSmall(
            onTap: () {
              double width = ref.read(activeWidthProvider) - 1;
              if(width <= 0){
                width = 0.5;
              }
              ref.read(activeWidthProvider.notifier).state = width;
            },
            iconData: Icons.keyboard_arrow_down),
      ],
    );
  }
}
