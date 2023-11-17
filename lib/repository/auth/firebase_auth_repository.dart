import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pencalendar/models/app_user.dart';
import 'package:pencalendar/provider/firebase_provider.dart';
import 'package:pencalendar/repository/auth/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  final ProviderRef _ref;

  FirebaseAuthRepository(this._ref);

  @override
  Future<void> signIn() async {
    // under construction
  }

  @override
  AppUser? getCurrentUser() {
    final firebaseUser = _ref.read(firebaseAuthProvider).currentUser;
    if (firebaseUser == null) {
      return null;
    }
    return AppUser(id: firebaseUser.uid);
  }

  @override
  Future<void> signOut() async {
    await _ref.read(firebaseAuthProvider).signOut();
  }
}
