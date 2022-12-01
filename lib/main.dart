import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/controller/auth_controller.dart';
import 'package:pencalendar/firebase_options.dart';
import 'package:pencalendar/pages/cal_page/cal_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(authControllerProvider);

    ThemeData theme =
        ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.light);

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
      debugShowCheckedModeBanner: false,
      theme: theme,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Pencal',
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
