import 'stift_localizations.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get helpButton => 'So funktioniert\'s';

  @override
  String get helpWebsite => 'https://sites.google.com/view/stift-app-hilfe/de';

  @override
  String get clearYearButton => 'Jahr löschen';

  @override
  String get rateAppButton => 'App Bewerten';

  @override
  String get sendFeedbackButton => 'Feedback senden';

  @override
  String get shareCalendar => 'Kalender teilen';

  @override
  String get shareNow => 'Jetzt teilen';

  @override
  String get rateAppTitle => 'App Bewerten';

  @override
  String get rateAppText =>
      'Wenn dir diese App gefällt, nehm dir bitte ein paar Sekunden, um sie zu bewerten!\nEs hilft uns wirklich und es sollte wirklich schnell gehen.';

  @override
  String get rateAppRateButton => 'Bewerten';

  @override
  String get rateAppRateNoButton => 'Nein Danke';

  @override
  String get rateAppRateLaterButton => 'Später vielleicht';

  @override
  String get layersFeatureTitleName => 'Ebenen';

  @override
  String get layerNew => 'Neue Ebene';

  @override
  String get layerExplainTitle => 'Ebene Erklärt';

  @override
  String get layerExplainText =>
      'Ebenen sind wie transparente Blätter, die du übereinander stapeln kannst. Jede Ebene steht für eine andere Terminkategorie, z. B. Arbeit, privat oder eine Ebene pro Person. Du kannst die Ebenen ein- oder ausschalten, um sich auf bestimmte Arten von Terminen zu konzentrieren oder um deinen gesamten Terminplan auf einmal zu sehen. Mit diesem Schichtensystem kannst du deinen Terminplan flexibler und übersichtlicher gestalten.';

  @override
  String get layerTextFieldTitle => 'Gib der Ebene einen Namen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'Ok';

  @override
  String get premiumLayersTitle => 'Unbegrenzte Ebenen freischalten';

  @override
  String premiumLayersText(num numberOfFreeLayers) {
    return 'Unser kostenloser Plan ermöglicht es dir, die Ebenen zu entdecken und deinen Plan mit bis zu $numberOfFreeLayers Ebenen zu organisieren. Wenn du jedoch eine unbegrenzte Anzahl von Ebenen erstellen und die Effizienz deiner Planung wirklich maximieren möchtest, kannst du unseren einmal Kauf nutzen.';
  }

  @override
  String get premiumViewPriceButton => 'Preis anschauen';

  @override
  String get premiumGoToPremiumPage => 'Premium';

  @override
  String get premiumLifeTimeTitle => 'Lifetime';

  @override
  String get premiumLifeTimeBullet1 => '1 Zahlung, alle Funktionen, unbegrenzter Zugang';

  @override
  String get premiumLifeTimeBullet2 => 'Starte heute, spare für immer';

  @override
  String get premiumPurchaseButton => 'Jetzt starten';

  @override
  String premiumDiscount(String discount) {
    return '$discount Rabatt';
  }

  @override
  String get premiumAlreadyPurchasedTitle => 'Du hast Premium!';

  @override
  String get premiumAlreadyPurchasedText =>
      'Danke, dass du uns unterstützt. Wir arbeiten hart daran, diese App noch besser zu machen!';

  @override
  String get termsOfServiceTitle => 'AGBs';

  @override
  String get privacyPolicyTitle => 'Datenschutzbestimmungen';

  @override
  String get restore => 'Kauf Wiederherstellen';

  @override
  String get purchaseInProgressSnackbarText => 'Der Kauf wird bearbeitet. Einen moment noch.';
}
