import 'package:flutter/material.dart';

class SideMenuButton extends StatelessWidget {
  final Function()? onTap;
  final IconData iconData;

  const SideMenuButton({Key? key, required this.onTap, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: 42,
          width: 46,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border:
                  Border.all(color: Theme.of(context).colorScheme.secondary)),
          child: Center(child: Icon(iconData, size: 20)),
        ));
  }
}
