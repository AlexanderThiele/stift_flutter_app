import 'package:design_system/atoms/ds_calendar_color_option.dart';
import 'package:flutter/material.dart';

class DsCalendarColorButton extends StatelessWidget {
  final Function()? onTap;
  final double height;
  final DsCalendarColorOption calendarColorOption;

  const DsCalendarColorButton(
      {super.key, required this.onTap, required this.height, required this.calendarColorOption});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: 48,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: calendarColorOption.calendarColorsForButton),
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(6)),
        child: calendarColorOption.premium
            ? const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
              )
            : null,
      ),
    );
  }
}
