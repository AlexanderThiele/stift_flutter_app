import 'package:design_system/atoms/ds_calendar_color_option.dart';
import 'package:design_system/atoms/ds_gutter.dart';
import 'package:design_system/buttons/ds_calendar_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/controller/calendar_color_controller.dart';

class AboveCalendarMenu extends ConsumerStatefulWidget {
  const AboveCalendarMenu({super.key});

  @override
  _AboveCalendarMenuState createState() => _AboveCalendarMenuState();
}

class _AboveCalendarMenuState extends ConsumerState<AboveCalendarMenu> with TickerProviderStateMixin {
  bool menuOpen = false;
  late final AnimationController animationController;
  final int openedMenuHeightMax = 36;
  double menuHeight = 0;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    animationController.addListener(() {
      setState(() {
        menuHeight = openedMenuHeightMax * animationController.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    menuOpen = !menuOpen;
                  });
                },
                icon: Icon(
                  Icons.color_lens_outlined,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ],
        ),
        Row(
          children: [
            for (final calendarOption in DsCalendarColorOption.values) ...[
              DsCalendarColorButton(
                height: menuHeight,
                calendarColorOption: calendarOption,
                onTap: () {
                  ref.read(calendarColorProvider.notifier).changeColorOption(calendarOption);
                },
              ),
              const DsGutter.row(),
            ],
          ],
        ).animate(
          controller: animationController,
          effects: [
            ScaleEffect(
                duration: 300.ms,
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                alignment: const Alignment(0, 1),
                curve: Curves.easeInOutExpo)
          ],
          autoPlay: true,
          target: menuOpen ? 1 : 0,
        ),
        SizedBox(height: 4),
      ],
    );
  }
}
