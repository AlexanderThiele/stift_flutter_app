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
}
