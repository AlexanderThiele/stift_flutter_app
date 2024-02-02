import 'package:billing/billing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/repository/repository_provider.dart';

final premiumPurchaseProvider = NotifierProvider<PremiumPurchaseNotifier, bool?>(() => PremiumPurchaseNotifier());

class PremiumPurchaseNotifier extends Notifier<bool?> {
  Future<void> initBilling() async {
    final activeProducts = await ref.read(billingRepositoryProvider).load();
    state = activeProducts.isNotEmpty;
    print("Billing initialized $state");

    ref.read(billingRepositoryProvider).purchaseStream().listen((LinkFiveActiveProducts event) {
      print("Purchase Update $event");
      state = event.isNotEmpty;
    });
  }

  @override
  bool? build() {
    return null;
  }
}

final premiumOfferProvider = NotifierProvider<PremiumOfferNotifier, LinkFiveProducts?>(() => PremiumOfferNotifier());

class PremiumOfferNotifier extends Notifier<LinkFiveProducts?> {
  Future<void> fetchOffering() async {
    state = await ref.read(billingRepositoryProvider).fetchOffering();
  }

  void purchase(LinkFiveProductDetails productDetails) {
    ref.read(billingRepositoryProvider).purchase(productDetails.productDetails);
  }

  void restore() {
    ref.read(billingRepositoryProvider).restore();
  }

  @override
  LinkFiveProducts? build() {
    return null;
  }
}

final premiumPurchaseInProgressProvider =
    NotifierProvider<PremiumPurchaseInProgressNotifier, bool>(() => PremiumPurchaseInProgressNotifier());

class PremiumPurchaseInProgressNotifier extends Notifier<bool> {
  init() {
    ref.read(billingRepositoryProvider).purchaseInProgressStream().listen((bool isPurchaseInProgress) {
      state = isPurchaseInProgress;
    });
  }

  @override
  bool build() {
    return false;
  }
}
