import 'package:billing/billing.dart';
import 'package:billing/keys/linkfive_key.dart';

class ActiveBillingRepository extends BillingRepository {
  @override
  Future<LinkFiveActiveProducts> load() async {
    return LinkFivePurchasesImpl().init(
      LinkFiveKey().apiKey,
      logLevel: LinkFiveLogLevel.DEBUG,
      env: LinkFiveEnvironment.STAGING,
    );
  }

  @override
  Future<LinkFiveProducts?> fetchOffering() {
    return LinkFivePurchases.fetchProducts();
  }

  @override
  Future<LinkFiveActiveProducts> loadActiveProducts() async {
    return LinkFivePurchases.reloadActivePlans();
  }

  @override
  void purchase(ProductDetails productDetails) async {
    await LinkFivePurchases.purchase(productDetails);
  }

  @override
  Future<void> restore() async {
    await LinkFivePurchases.restore();
  }

  Stream<LinkFiveActiveProducts> listenToPurchases() {
    return LinkFivePurchases.activeProducts;
  }

  @override
  Stream<LinkFiveActiveProducts> purchaseStream() {
    return LinkFivePurchases.activeProducts;
  }

  @override
  Stream<bool> purchaseInProgressStream() {
    return LinkFivePurchases.purchaseInProgressStream;
  }
}
