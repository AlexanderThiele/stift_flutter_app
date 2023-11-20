import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/components/calendar_table/cal_table.dart';
import 'package:pencalendar/components/calendar_table/painter/signatur_painter.dart';
import 'package:pencalendar/controller/active_year_controller.dart';
import 'package:pencalendar/controller/public_holiday_controller.dart';
import 'package:pencalendar/repository/analytics/analytics_repository.dart';
import 'package:pencalendar/repository/repository_provider.dart';
import 'package:responsive_spacing/responsive_spacing.dart';
import 'package:share_plus/share_plus.dart';

class ShareImagePage extends ConsumerStatefulWidget {
  const ShareImagePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShareImagePage();
}

class _ShareImagePage extends ConsumerState<ShareImagePage> {
  final GlobalKey globalKey = GlobalKey();

  bool buttonLoading = false;

  _shareCalendar(Rect position) async {
    setState(() {
      buttonLoading = true;
    });
    final picture = await _captureWidget();

    await Share.shareXFiles(
      [XFile.fromData(picture, mimeType: 'image/png', name: "Stift Calendar App", lastModified: DateTime.now())],
      sharePositionOrigin: position,
    );
    setState(() {
      buttonLoading = false;
    });
  }

  Future<Uint8List> _captureWidget() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedYear = ref.watch(activeCalendarYearProvider);
    final publicHolidays = ref.watch(publicHolidayControllerProvider);
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(context.l10n.shareCalendar),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.l, vertical: context.spacing.m),
            child: Builder(builder: (context) {
              final calendar = FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: RepaintBoundary(
                          key: globalKey,
                          child: Stack(
                            children: [
                              CalTable(year: selectedYear, publicHolidays: publicHolidays ?? []),
                              const SignaturePainerWrapper([]),
                            ],
                          ),
                        )),
                  ));

              final shareCard = Builder(builder: (context) {
                return ElevatedButton(
                  child: switch (buttonLoading) {
                    true => const SizedBox(width: 16, height: 16, child: CircularProgressIndicator()),
                    false => Text(context.l10n.shareNow)
                  },
                  onPressed: () {
                    if (buttonLoading) {
                      return;
                    }
                    ref.read(analyticsRepositoryProvider).trackEvent(AnalyticEvent.shareCalendar);
                    final box = context.findRenderObject() as RenderBox?;
                    _shareCalendar(box!.localToGlobal(Offset.zero) & box.size);
                  },
                );
              });

              if (context.spacingConfig.layoutColumns.columns == 12) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Flexible(child: calendar), shareCard],
                );
              }
              return Column(
                children: [
                  calendar,
                  SizedBox(
                    height: context.spacingConfig.gutter.size,
                  ),
                  shareCard
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
