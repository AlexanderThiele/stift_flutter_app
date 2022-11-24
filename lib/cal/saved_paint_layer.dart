import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/cal/widgets/signatur_painter.dart';
import 'package:pencalendar/controller/active_calendar_controller.dart';
import 'package:pencalendar/models/single_draw.dart';

class SavedPaintLayer extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var activeCalProvider = ref.watch(activeCalendarControllerProvider);
    if(activeCalProvider == null){
      return const SizedBox();
    }
    return CustomPaint(
      painter: SignaturePainter(drawList: activeCalProvider.drawingList),
      size: Size.infinite,
    );
  }
}
