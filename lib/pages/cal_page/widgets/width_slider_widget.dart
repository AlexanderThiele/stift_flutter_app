import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_width_controller.dart';

class WidthSliderWidget extends ConsumerWidget {
  const WidthSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = ref.watch(activeWidthProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: SizedBox(
            height: 200,
            width: 50,
            child: FlutterSlider(
              values: [width],
              max: 30,
              axis: Axis.vertical,
              min: 1,
              onDragCompleted: (index, lower, upper){
                ref.read(activeWidthProvider.notifier).state = lower;
              },
            )),
          ),
        ],
      ),
    );
  }
}
