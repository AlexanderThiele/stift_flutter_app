import 'dart:io';

import 'package:design_system/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pencalendar/controller/auth_controller.dart';
import 'package:pencalendar/firebase_options.dart';
import 'package:pencalendar/pages/calendar_page/cal_page.dart';
import 'package:pencalendar/provider/shared_preference_provider.dart';
import 'package:pencalendar/repository/drawings_repository.dart';
import 'package:pencalendar/utils/app_logger.dart';
import 'package:rate_my_app/rate_my_app.dart';
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
      child: MyApp(),
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(authControllerProvider);

    AppLogger.d("user: $user");

    if (user == null) {
      return MaterialApp(
          theme: lightTheme,
          home: const Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [Align(alignment: Alignment.center, child: CircularProgressIndicator())])));
    }
    return MaterialApp.router(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1),
          child: child ?? const SizedBox(),
        );
      },
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Stift',
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return RateMyAppBuilder(
              rateMyApp: RateMyApp(
                preferencesPrefix: 'rateMyApp_',
                minDays: 7,
                minLaunches: 10,
                remindDays: 7,
                remindLaunches: 10,
                googlePlayIdentifier: 'app.tnx.tabletcalendar',
                appStoreIdentifier: '1661094074',
              ),
              onInitialized: (context, rateMyApp) {
                if (rateMyApp.shouldOpenDialog) {
                  rateMyApp.showRateDialog(
                    context,
                    title: 'Rate this app',
                    // The dialog title.
                    message:
                        'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
                    // The dialog message.
                    rateButton: 'RATE',
                    // The dialog "rate" button text.
                    noButton: 'NO THANKS',
                    // The dialog "no" button text.
                    laterButton: 'MAYBE LATER',
                    // The dialog "later" button text.
                    listener: (button) {
                      // The button click listener (useful if you want to cancel the click event).
                      switch (button) {
                        case RateMyAppDialogButton.rate:
                          print('Clicked on "Rate".');
                          break;
                        case RateMyAppDialogButton.later:
                          print('Clicked on "Later".');
                          break;
                        case RateMyAppDialogButton.no:
                          print('Clicked on "No".');
                          break;
                      }

                      return true; // Return false if you want to cancel the click event.
                    },
                    ignoreNativeDialog: Platform.isAndroid,
                    // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
                    dialogStyle: const DialogStyle(),
                    // Custom dialog styles.
                    onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
                        .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
                    // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
                    // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
                  );
                }
              },
              builder: (context) => CalPage());
        },
      ),
    ],
  );
}
