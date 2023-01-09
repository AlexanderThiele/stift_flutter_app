import 'package:flutter/material.dart';

class SideMenuButtonSmall extends StatelessWidget {
  final Function()? onTap;
  final IconData? iconData;
  final Widget? widget;

  const SideMenuButtonSmall(
      {Key? key, required this.onTap, this.iconData, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          width: 22,
          height: 22,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade400, width: 0.3),
              color: Theme.of(context).colorScheme.primary),
          child: Center(
              child: iconData != null ? Icon(iconData, size: 14) : widget),
        ));
  }
}
