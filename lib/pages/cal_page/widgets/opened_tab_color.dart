import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/controller/active_color_controller.dart';
import 'package:pencalendar/models/brush.dart';

class OpenedTabColor extends ConsumerWidget {
  final List<Color> colors = [
    Colors.black,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.white,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.blue.shade900,
    Colors.blue.shade500,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lime,
    Colors.yellow,
    Colors.orange,
    Colors.deepOrange,
  ];
  final double iconSize = 22;

  Timer? _timer;

  OpenedTabColor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(activeColorProvider);
    return Column(
      children: [
        InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        titlePadding: const EdgeInsets.all(0),
                        contentPadding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? const BorderRadius.vertical(
                                  top: Radius.circular(500),
                                  bottom: Radius.circular(100),
                                )
                              : const BorderRadius.horizontal(
                                  right: Radius.circular(500)),
                        ),
                        content: SingleChildScrollView(
                            child: HueRingPicker(
                          pickerAreaBorderRadius: BorderRadius.zero,
                          pickerColor: color,
                          enableAlpha: true,
                          displayThumbColor: true,
                          onColorChanged: (newColor) {
                            _timer?.cancel();
                            _timer = Timer(const Duration(milliseconds: 100), () {
                              ref.read(activeColorProvider.notifier).state =
                                  newColor;
                              ref.read(activeBrushProvider.notifier).state =
                                  Brush.pen;
                            });
                          },
                        )));
                  });
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red,
                        Colors.indigo,
                        Colors.blue,
                        Colors.cyan,
                        Colors.teal,
                        Colors.yellow,
                        Colors.deepOrange,
                        Colors.black,
                        Colors.white,
                      ]),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade400, width: 0.3),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        offset: const Offset(1, 2),
                        blurRadius: 3)
                  ]),
            )),
        BlockPicker(
          pickerColor: color,
          availableColors: colors,
          itemBuilder:
              (Color color, bool isCurrentColor, void Function() changeColor) {
            return InkWell(
              onTap: () => changeColor(),
              child: Container(
                margin: const EdgeInsets.all(4),
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade400, width: 0.3),
                    boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(0.8),
                          offset: const Offset(1, 2),
                          blurRadius: 3)
                    ]),
              ),
            );
          },
          layoutBuilder:
              (BuildContext context, List<Color> colors, PickerItem child) {
            return Column(children: [for (Color color in colors) child(color)]);
          },
          onColorChanged: (newColor) {
            print("color $newColor");
            ref.read(activeColorProvider.notifier).state = newColor;
            ref.read(activeBrushProvider.notifier).state = Brush.pen;
          },
        ),
      ],
    );
  }
}
