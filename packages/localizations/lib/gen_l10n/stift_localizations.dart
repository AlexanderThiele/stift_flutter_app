import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'stift_localizations_de.dart';
import 'stift_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/stift_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en')];

  ///
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get helpButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'https://sites.google.com/view/stift-app-hilfe'**
  String get helpWebsite;

  ///
  ///
  /// In en, this message translates to:
  /// **'Clear Year'**
  String get clearYearButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateAppButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedbackButton;

  ///
  ///
  /// In en, this message translates to:
  /// **'Share Calendar'**
  String get shareCalendar;

  ///
  ///
  /// In en, this message translates to:
  /// **'Share now'**
  String get shareNow;

  /// No description provided for @rateAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate this app'**
  String get rateAppTitle;

  /// No description provided for @rateAppText.
  ///
  /// In en, this message translates to:
  /// **'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.'**
  String get rateAppText;

  /// No description provided for @rateAppRateButton.
  ///
  /// In en, this message translates to:
  /// **'RATE'**
  String get rateAppRateButton;

  /// No description provided for @rateAppRateNoButton.
  ///
  /// In en, this message translates to:
  /// **'NO THANKS'**
  String get rateAppRateNoButton;

  /// No description provided for @rateAppRateLaterButton.
  ///
  /// In en, this message translates to:
  /// **'MAYBE LATER'**
  String get rateAppRateLaterButton;

  /// No description provided for @layersFeatureTitleName.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get layersFeatureTitleName;

  /// No description provided for @layerNew.
  ///
  /// In en, this message translates to:
  /// **'New Layer'**
  String get layerNew;

  /// No description provided for @layerExplainTitle.
  ///
  /// In en, this message translates to:
  /// **'Layers Explained'**
  String get layerExplainTitle;

  /// No description provided for @layerExplainText.
  ///
  /// In en, this message translates to:
  /// **'In our app, layers are like transparent sheets that you can stack on top of each other. Each layer represents a different category of appointments, such as work, personal, or social events. You can turn layers on or off to focus on specific types of appointments or to see your entire schedule at once. This layering system allows you to organize your schedule with greater flexibility and clarity.'**
  String get layerExplainText;

  /// No description provided for @layerTextFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign a name to the layer'**
  String get layerTextFieldTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
