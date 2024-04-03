import 'package:flutter/cupertino.dart';
import 'package:pencalendar/components/menu/fancy_selection_menu.dart';

class TopLeftCornerMenu extends StatelessWidget {
  const TopLeftCornerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CalendarTimeMenu(),
        FancySelectionMenu(),
      ],
    );
  }
}
