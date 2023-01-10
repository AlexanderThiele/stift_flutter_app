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
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class AuthRepository extends BaseAuthRepository {
  final Reader _read;

  AuthRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  Future<void> signInAnonymously() async {
    await _read(firebaseAuthProvider).signInAnonymously();
  }

  @override
  User? getCurrentUser() {
    return _read(firebaseAuthProvider).currentUser;
  }


  @override
  Future<void> signOut() async {
    await _read(firebaseAuthProvider).signOut();
    await signInAnonymously();
  }
}