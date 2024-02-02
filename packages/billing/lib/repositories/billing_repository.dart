import 'package:linkfive_purchases/linkfive_purchases.dart';

abstract class BillingRepository {
  Future<LinkFiveActiveProducts> load();

  Future<LinkFiveProducts?> fetchOffering();

  Future<LinkFiveActiveProducts> loadActiveProducts();

  void purchase(ProductDetails productDetails);

  void restore();

  Stream<LinkFiveActiveProducts> purchaseStream();

  Stream<bool> purchaseInProgressStream();
}
