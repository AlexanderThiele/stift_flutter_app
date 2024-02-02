import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/controller/premium_purchase_notifier.dart';
import 'package:pencalendar/models/features.dart';

final activeFeatureNotifierProvider = NotifierProvider<FeatureNotifier, Features>(() => FeatureNotifier());

class FeatureNotifier extends Notifier<Features> {
  @override
  Features build() {
    final hasPremium = ref.watch(premiumPurchaseProvider);
    return switch (hasPremium) {
      true => Features.premium(),
      false => Features.free(),
      _ => Features.loading(),
    };
  }
}
