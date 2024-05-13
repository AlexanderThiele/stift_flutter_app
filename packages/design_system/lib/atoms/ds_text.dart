import 'package:flutter/material.dart';

class DsText extends StatelessWidget {
  final String text;
  final DsTextStyle textStyle;

  const DsText.body(this.text, {super.key}) : textStyle = DsTextStyle.body;

  const DsText.calenderInformation(this.text, {super.key}) : textStyle = DsTextStyle.calenderInformation;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: switch (textStyle) {
        DsTextStyle.body => Theme.of(context).textTheme.bodyMedium,
        DsTextStyle.calenderInformation => Theme.of(context).textTheme.labelSmall?.apply(fontSizeDelta: -3),
      },
    );
  }
}

enum DsTextStyle {
  body,
  calenderInformation,
  ;
}
