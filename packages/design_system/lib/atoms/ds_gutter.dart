import 'package:flutter/cupertino.dart';

class DsGutter extends StatelessWidget {
  final bool horizontal;

  const DsGutter.row({super.key}) : horizontal = true;

  const DsGutter.column({super.key}) : horizontal = false;

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return const SizedBox(width: 8);
    }
    return const SizedBox(height: 8);
  }
}
