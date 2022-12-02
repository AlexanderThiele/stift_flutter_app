import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/repo/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref.read)..appStarted(),
);

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangeSubscription;

  AuthController(this._read) : super(null) {
    _authStateChangeSubscription?.cancel();
    _authStateChangeSubscription = _read(authRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  void appStarted() async {
    final user = _read(authRepositoryProvider).getCurrentUser();
    print("app started");
    if (user == null) {
      print("user null");
      await _read(authRepositoryProvider).signInAnonymously();
      print("SIGN IN anony");
      state = _read(authRepositoryProvider).getCurrentUser();
    } else {
      state = user;
    }
  }

  void signOut() async {
    await _read(authRepositoryProvider).signOut();
  }

  @override
  void dispose() {
    _authStateChangeSubscription?.cancel();
    super.dispose();
  }
}
