import 'package:design_system/buttons/side_menu_button.dart';
import 'package:design_system/buttons/side_menu_button_small.dart';
import 'package:design_system/theme/light_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Design System'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Column(
                  children: [
                    SideMenuButton(onTap: () {}, iconData: Icons.person),
                    SideMenuButtonSmall(
                      onTap: () {},
                      iconData: Icons.person,
                    ),
                    SideMenuButtonSmall(
                      onTap: () {},
                      widget: const Text("1"),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
