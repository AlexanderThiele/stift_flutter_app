import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/models/opened_tab.dart';

final openedTabProvider = StateProvider<OpenedTab>((ref) => OpenedTab.pen);
