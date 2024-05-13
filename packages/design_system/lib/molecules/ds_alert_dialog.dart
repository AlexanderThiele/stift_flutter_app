import 'dart:math';

import 'package:design_system/atoms/ds_metrics.dart';
import 'package:flutter/material.dart';

class DsAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;

  const DsAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: min(MediaQuery.of(context).size.width, Metrics.boxMaxWidth),
        child: content,
      ),
      actions: actions,
    );
  }
}
