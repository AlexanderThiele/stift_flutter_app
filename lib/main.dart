import 'package:event_bus/event_bus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/auth_controller.dart';
import 'package:pencalendar/firebase_options.dart';
import 'package:pencalendar/pages/cal_page/cal_page.dart';
import 'package:pencalendar/repo/shared_pref_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /*await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );*/

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(overrides: [
    sharedPrefInstanceProvider.overrideWithValue(sharedPreferences),
  ], child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  static final EventBus eventBus = EventBus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(authControllerProvider);

    print("user");
    print(user);

    ThemeData theme = ThemeData(
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFCDF77E),
            onPrimary: Color(0xFFF77E65),
            secondary: Color(0xFF88966A),
            onSecondary: Color(0xFFFFFFFF),
            error: Colors.red,
            onError: Colors.white,
            background: Color(0xFFFAFEF2),
            onBackground: Colors.black,
            surface: Color(0xFFFAFEF2),
            onSurface: Colors.black),
        scaffoldBackgroundColor: const Color(0xFFFAFEF2),
        backgroundColor: const Color(0xFFFAFEF2),
        toggleableActiveColor: Color(0xFFF77E65),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFCDF77E),
            foregroundColor: Colors.black,
            focusColor: Colors.red),
        brightness: Brightness.light,
        textTheme: const TextTheme(bodySmall: TextStyle(color: Colors.black)));

    ThemeData themeDark =
        ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.dark);

    if (user == null) {
      return MaterialApp(
          theme: theme,
          home: Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator())
              ])));
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
      theme: theme,
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
          return CalPage();
        },
      ),
    ],
  );
}
