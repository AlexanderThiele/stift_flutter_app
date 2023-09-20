import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pencalendar/provider/firebase_provider.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;

  Future<void> signInAnonymously();

  User? getCurrentUser();

  Future<void> signOut();
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref));

class AuthRepository extends BaseAuthRepository {
  final ProviderRef _ref;

  AuthRepository(this._ref);

  @override
  Stream<User?> get authStateChanges =>
      _ref.read(firebaseAuthProvider).authStateChanges();

  @override
  Future<void> signInAnonymously() async {
    await _ref.read(firebaseAuthProvider).signInAnonymously();
  }

  @override
  User? getCurrentUser() {
    return _ref.read(firebaseAuthProvider).currentUser;
  }


  @override
  Future<void> signOut() async {
    await _ref.read(firebaseAuthProvider).signOut();
    await signInAnonymously();
  }
}