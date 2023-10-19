import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/repository/auth_repository.dart';
import 'package:pencalendar/utils/app_logger.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref)..appStarted(),
);

class AuthController extends StateNotifier<User?> {
  final StateNotifierProviderRef _ref;

  StreamSubscription<User?>? _authStateChangeSubscription;

  AuthController(this._ref) : super(null) {
    _authStateChangeSubscription?.cancel();
    _authStateChangeSubscription = _ref.read(authRepositoryProvider).authStateChanges.listen((user) => state = user);
  }

  void appStarted() async {
    final user = _ref.read(authRepositoryProvider).getCurrentUser();
    AppLogger.d("app started");
    if (user == null) {
      AppLogger.d("user null");
      await _ref.read(authRepositoryProvider).signInAnonymously();
      AppLogger.d("SIGN IN anony");
      state = _ref.read(authRepositoryProvider).getCurrentUser();
    } else {
      state = user;
    }
    AppLogger.d("user with id: ${state?.uid}");
  }

  void signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }

  @override
  void dispose() {
    _authStateChangeSubscription?.cancel();
    super.dispose();
  }
}
