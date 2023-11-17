import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/models/app_user.dart';
import 'package:pencalendar/repository/repository_provider.dart';
import 'package:pencalendar/utils/app_logger.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AppUser?>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<AppUser?> {
  final StateNotifierProviderRef _ref;

  AuthController(this._ref) : super(null);

  Future<void> appStarted() async {
    final user = _ref.read(authRepositoryProvider).getCurrentUser();
    AppLogger.d("app started");
    if (user != null) {
      state = user;
    }
    AppLogger.d("user with id: ${state?.id}");
  }

  void signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }

}
