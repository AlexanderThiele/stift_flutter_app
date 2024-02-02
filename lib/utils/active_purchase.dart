abstract class ActivePurchase {
  String get link;

  const ActivePurchase();
}

///
/// Creates a Link to an active Plan on Google Play
///
class GooglePlayActivePlan extends ActivePurchase {
  ///
  /// Also known as SKU
  ///
  final String productId;

  ///
  /// It's the App PackageName e.g. com.tnx.packed
  ///
  final String package;

  const GooglePlayActivePlan(this.productId, this.package);

  @override
  String get link => "https://play.google.com/store/account/subscriptions?sku=$productId&package=$package";
}

///
/// This is a general link to the Google Play Store
///
class GooglePlayGeneralActivePlan extends ActivePurchase {
  const GooglePlayGeneralActivePlan();

  @override
  String get link => "https://play.google.com/store/account/subscriptions";
}

///
/// Link to Apple App Store Subscription Page
///
class AppleAppStoreActivePlan extends ActivePurchase {
  const AppleAppStoreActivePlan();

  @override
  String get link => "https://apps.apple.com/account/subscriptions";
}
