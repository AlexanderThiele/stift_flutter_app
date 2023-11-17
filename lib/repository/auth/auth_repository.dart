import 'package:pencalendar/models/app_user.dart';

abstract class AuthRepository {
  Future<void> signIn();

  AppUser? getCurrentUser();

  Future<void> signOut();
}
