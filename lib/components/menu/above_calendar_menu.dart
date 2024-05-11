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
            GestureDetector(
              onTap: () {
                ref.read(calendarColorProvider.notifier).changeColorOption(CalendarColorOption.standard);
              },
              child: Container(
                height: menuHeight,
                width: 48,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: CalendarColorOption.standard.calendarColors),
                    border: Border.all(color: Theme.of(context).colorScheme.primary)),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                ref.read(calendarColorProvider.notifier).changeColorOption(CalendarColorOption.blackWhite);
              },
              child: Container(
                height: menuHeight,
                width: 48,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.black, Colors.white]),
                    border: Border.all(color: Theme.of(context).colorScheme.primary)),
              ),
            )
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
        SizedBox(height: 2)
      ],
    );
  }
}
