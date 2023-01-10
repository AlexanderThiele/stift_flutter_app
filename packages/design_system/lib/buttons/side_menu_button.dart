import 'package:flutter/material.dart';

class SideMenuButton extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData;

  const SideMenuButton({Key? key, required this.onTap, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        clipBehavior: Clip.hardEdge,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.square(42),
            padding: EdgeInsets.zero,
            side: BorderSide(
                width: 1, color: Theme.of(context).colorScheme.secondary)),
        onPressed: onTap,
        child: Center(
            child: Icon(iconData,
                size: 20,
                color: Theme.of(context)
                    .floatingActionButtonTheme
                    .foregroundColor)));
  }
}
