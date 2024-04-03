import 'package:design_system/atoms/ds_gutter.dart';
import 'package:design_system/atoms/ds_icon.dart';
import 'package:design_system/atoms/ds_text.dart';
import 'package:flutter/material.dart';

class DsBulletPoint extends StatelessWidget {
  final String text;
  final IconData iconData;

  const DsBulletPoint.check(this.text, {super.key}) : iconData = Icons.check_circle_outline;

  const DsBulletPoint.round(this.text, {super.key}) : iconData = Icons.radio_button_on;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DsIcon(iconData),
        const DsGutter.row(),
        Expanded(
            child: DsText.body(
          text,
        )),
      ],
    );
  }
}
