import 'package:design_system/theme/light_theme.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/auth_controller.dart';
import 'package:pencalendar/firebase_options.dart';
import 'package:pencalendar/pages/calendar_page/cal_page.dart';
import 'package:pencalendar/provider/shared_preference_provider.dart';
import 'package:pencalendar/repository/drawings_repository.dart';
import 'package:pencalendar/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.deleteFromDisk();
  await openDrawingsBox();

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
          return CalPage();
        },
      ),
    ],
  );
}
