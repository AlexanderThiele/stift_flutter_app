import 'package:billing/repositories/billing_repository.dart';
import 'package:in_app_purchase_platform_interface/src/types/product_details.dart';
import 'package:linkfive_purchases/models/linkfive_active_products.dart';
import 'package:linkfive_purchases/models/linkfive_products.dart';

class AlwaysProBillingRepository extends BillingRepository {
  final activeProduct = LinkFiveActiveProducts.fromJson({
    "oneTimePurchaseList": [
      {
        "productId": "productId",
        "orderId": "orderId",
        "purchaseDate": "2024-01-01",
        "storeType": "storeType",
      }
    ],
    "planList": [],
  });

  @override
  Future<LinkFiveProducts?> fetchOffering() async {
    return null;
  }

  @override
  Future<LinkFiveActiveProducts> load() async {
    return activeProduct;
  }

  @override
  Future<LinkFiveActiveProducts> loadActiveProducts() async {
    return activeProduct;
  }

  @override
  void purchase(ProductDetails productDetails) {}

  @override
  Stream<bool> purchaseInProgressStream() {
    return const Stream.empty();
  }

  @override
  Stream<LinkFiveActiveProducts> purchaseStream() {
    return const Stream.empty();
  }

  @override
  void restore() {}
}
