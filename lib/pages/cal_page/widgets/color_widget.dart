import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/controller/active_color_controller.dart';

class ColorPickerWidget extends ConsumerWidget {
  const ColorPickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(activeColorProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                              child: BlockPicker(
                            pickerColor: color,
                            onColorChanged: (newColor) {
                              ref.read(activeColorProvider.notifier).state =
                                  newColor;
                              Navigator.of(context).pop();
                            },
                          )));
                    });
              },
              child: Container(
                  decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(8))),
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                child: Center(child: Text("Color", style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.white),)),
              ),)),
        ],
      ),
    );
  }
}
