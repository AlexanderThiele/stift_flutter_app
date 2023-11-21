import 'package:in_app_purchase/in_app_purchase.dart';

// under construction
class StiftBilling {
  void load() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      return;
    }
    const Set<String> ids = <String>{'pro'};
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty) {
      print("error notFoundIDs isNotEmpty");
    }
    List<ProductDetails> products = response.productDetails;
    print(products);
  }
}
