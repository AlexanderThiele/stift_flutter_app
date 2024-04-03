import 'package:flutter/material.dart';

class CalendarTimeMenu extends StatelessWidget {
  const CalendarTimeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 8, right: 4),
      height: 72,
      width: 36,
      decoration: const BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        child: GridView.count(
          crossAxisCount: 1,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.calendar_view_week,
                  size: 18,
                )),
          ],
        ),
      ),
    );
  }
}
