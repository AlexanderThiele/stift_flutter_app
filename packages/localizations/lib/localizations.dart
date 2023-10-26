library localizations;

import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localizations/gen_l10n/stift_localizations.dart';

export 'package:localizations/gen_l10n/stift_localizations.dart';

List<LocalizationsDelegate<dynamic>> get myLocalizationsDelegates => [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

List<Locale> get myLocales => [const Locale('en'), const Locale('de')];

extension AppLocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
