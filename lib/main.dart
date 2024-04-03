import 'dart:ui';

import 'package:design_system/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localizations/localizations.dart';
import 'package:pencalendar/controller/premium_purchase_notifier.dart';
import 'package:pencalendar/firebase_options.dart';
import 'package:pencalendar/provider/router_provider.dart';
import 'package:pencalendar/provider/shared_preference_provider.dart';
import 'package:pencalendar/repository/repository_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Hive.initFlutter();

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    ref.read(premiumPurchaseProvider.notifier).initBilling();
    ref.read(configRepositoryProvider).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = ref.read(routerProvider);
    return MaterialApp.router(
      localizationsDelegates: myLocalizationsDelegates,
      supportedLocales: myLocales,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox(),
        );
      },
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: 'Stift',
    );
  }
}
