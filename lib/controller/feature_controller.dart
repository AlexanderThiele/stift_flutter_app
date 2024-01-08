import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/models/features.dart';
import 'package:pencalendar/repository/repository_provider.dart';

final activeFeatureControllerProvider =
    StateNotifierProvider<FeatureController, Features>((ref) => FeatureController(ref)..load());

class FeatureController extends StateNotifier<Features> {
  final StateNotifierProviderRef _ref;

  FeatureController(this._ref) : super(Features.loading());

  void load() {
    if (_ref.read(billingRepositoryProvider).hasPremium) {
      state = Features.premium();
    } else {
      state = Features.free();
    }
  }
}
