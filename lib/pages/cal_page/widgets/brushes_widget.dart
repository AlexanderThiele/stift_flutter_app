import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/active_brush_controller.dart';
import 'package:pencalendar/models/brush.dart';

class BrushesWidget extends ConsumerWidget {
  const BrushesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brush = ref.watch(activeBrushProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
              onPressed: () {
                ref.read(activeBrushProvider.notifier).state = Brush.pen;
              },
              backgroundColor: brush == Brush.pen
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              foregroundColor: brush == Brush.pen
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              child: const Icon(Icons.brush)),
          FloatingActionButton.small(
              onPressed: () {
                ref.read(activeBrushProvider.notifier).state = Brush.eraser;
              },
              backgroundColor: brush == Brush.eraser
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              foregroundColor: brush == Brush.eraser
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              child: const FaIcon(FontAwesomeIcons.eraser))
        ],
      ),
    );
  }
}
