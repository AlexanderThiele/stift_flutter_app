import 'package:flutter/material.dart';

class DsText extends StatelessWidget {
  final String text;
  final DsTextStyle textStyle;

  const DsText.body(this.text, {super.key}) : textStyle = DsTextStyle.body;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: switch (textStyle) {
        DsTextStyle.body => Theme.of(context).textTheme.bodyMedium,
      },
    );
  }
}

enum DsTextStyle {
  body;
}
