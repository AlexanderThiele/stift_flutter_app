import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/models/brush.dart';

final activeBrushProvider = StateProvider<Brush>((ref) => Brush.pen);
