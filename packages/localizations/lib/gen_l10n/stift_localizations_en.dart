import 'stift_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helpButton => 'How it works';

  @override
  String get helpWebsite => 'https://sites.google.com/view/stift-app-hilfe';

  @override
  String get clearYearButton => 'Clear Year';

  @override
  String get rateAppButton => 'Rate App';

  @override
  String get sendFeedbackButton => 'Send Feedback';

  @override
  String get shareCalendar => 'Share Calendar';

  @override
  String get shareNow => 'Share now';

  @override
  String get rateAppTitle => 'Rate this app';

  @override
  String get rateAppText =>
      'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.';

  @override
  String get rateAppRateButton => 'RATE';

  @override
  String get rateAppRateNoButton => 'NO THANKS';

  @override
  String get rateAppRateLaterButton => 'MAYBE LATER';

  @override
  String get layersFeatureTitleName => 'Layers';

  @override
  String get layerNew => 'Layers';

  @override
  String get layerExplainTitle => 'Layers Explained';

  @override
  String get layerExplainText =>
      'In our app, layers are like transparent sheets that you can stack on top of each other. Each layer represents a different category of appointments, such as work, personal, or social events. You can turn layers on or off to focus on specific types of appointments or to see your entire schedule at once. This layering system allows you to organize your schedule with greater flexibility and clarity.';

  @override
  String get layerTextFieldTitle => 'Assign a name to the layer';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'Ok';

  @override
  String get premiumLayersTitle => 'Unlock Unlimited Layers';

  @override
  String premiumLayersText(num numberOfFreeLayers) {
    return 'Our free plan allows you to experience the power of layered appointments, organizing your schedule with up to $numberOfFreeLayers layers. However, to create unlimited layers and truly maximize the efficiency of your planning, you can avail of our one-time purchase option.';
  }

  @override
  String get premiumViewPriceButton => 'View Price';

  @override
  String get premiumGoToPremiumPage => 'Premium';

  @override
  String get premiumLifeTimeTitle => 'Lifetime';

  @override
  String get premiumLifeTimeBullet1 => '1 payment, all functions, unlimited access';

  @override
  String get premiumLifeTimeBullet2 => 'Start today, save forever';

  @override
  String get premiumPurchaseButton => 'Start now';

  @override
  String premiumDiscount(String discount) {
    return '$discount Discount';
  }

  @override
  String get premiumAlreadyPurchasedTitle => 'You have Premium!';

  @override
  String get premiumAlreadyPurchasedText =>
      'Thank you for supporting us. We are working hard to make this app even better!';

  @override
  String get premiumFeature1 => 'Unlimited Layers';

  @override
  String get premiumFeature2 => 'No Ads';

  @override
  String get premiumFeature3 => 'And of course, you help the developers to further develop this app ❤️';

  @override
  String get premiumFeatureMore => 'More functions are currently being developed';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get restore => 'Restore Purchase';

  @override
  String get purchaseInProgressSnackbarText => 'Purchase in Progress, please wait.';

  @override
  String get bottomSheetDeleteButton => 'Delete';

  @override
  String get bottomSheetCancelButton => 'Cancel';

  @override
  String get updateDialogTitle => 'New Update Available';

  @override
  String get updateDialogText => 'There is a newer version of app available please update it now.';

  @override
  String get updateDialogButtonUpdate => 'Update Now';

  @override
  String get updateDialogButtonLater => 'Later';
}
