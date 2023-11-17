import 'package:pencalendar/models/app_user.dart';
import 'package:pencalendar/repository/auth/auth_repository.dart';

class NoAuthRepository extends AuthRepository {
  NoAuthRepository();

  @override
  Future<void> signIn() async {}

  @override
  AppUser? getCurrentUser() {
    return null;
  }

  @override
  Future<void> signOut() async {}
}
