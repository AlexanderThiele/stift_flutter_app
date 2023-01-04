import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_opened_tab_controller.dart';
import 'package:pencalendar/controller/active_width_controller.dart';
import 'package:pencalendar/design/buttons/side_menu_button.dart';
import 'package:pencalendar/models/brush.dart';
import 'package:pencalendar/models/opened_tab.dart';

class PencilWidget extends ConsumerWidget {
  const PencilWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = ref.watch(activeWidthProvider);
    return Row(
      children: [
        Text(width.toStringAsFixed(0), style: Theme.of(context).textTheme.caption),
        const SizedBox(width: 4),
        Builder(
          builder: (context) {
            final brush = ref.watch(activeBrushProvider);
            IconData activeBrushIconData = Icons.brush;
            if(brush == Brush.eraser){
              activeBrushIconData = FontAwesomeIcons.eraser;
            }
            return SideMenuButton(onTap: () {
              ref.read(openedTabProvider.notifier).state = OpenedTab.pen;
            }, iconData: activeBrushIconData);
          }
        ),
      ],
    );
  }
}