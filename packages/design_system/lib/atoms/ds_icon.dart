import 'package:flutter/material.dart';

class DsIcon extends StatelessWidget {
  final IconData icon;

  const DsIcon(this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary);
  }
}
