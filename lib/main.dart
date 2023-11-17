import 'package:design_system/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/firebase_options.dart';
import 'package:pencalendar/provider/shared_preference_provider.dart';
import 'package:pencalendar/repository/drawings/hive_drawings_repository.dart';
import 'package:pencalendar/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await openDrawingsBox();

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefInstanceProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: myLocalizationsDelegates,
      supportedLocales: myLocales,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1),
          child: child ?? const SizedBox(),
        );
      },
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      routeInformationProvider: appRoutes.routeInformationProvider,
      routeInformationParser: appRoutes.routeInformationParser,
      routerDelegate: appRoutes.routerDelegate,
      title: 'Stift',
    );
  }
}
