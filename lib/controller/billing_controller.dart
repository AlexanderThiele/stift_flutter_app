import 'package:flutter_riverpod/flutter_riverpod.dart';

final billingControllerProvider = StateNotifierProvider<BillingController, bool>(
  (ref) => BillingController(ref),
);

class BillingController extends StateNotifier<bool> {
  final StateNotifierProviderRef _ref;

  BillingController(this._ref) : super(false);

  Future<void> initBilling() async {
    // _ref.read(billingRepositoryProvider).init();
  }
}
