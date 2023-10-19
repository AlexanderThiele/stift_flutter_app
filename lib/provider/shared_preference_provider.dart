import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overwritten by main.
///
/// We need an async instance for shared preferences, since we don't
/// always want to wait and check for a ready instance with a completer,
/// we just await inside the main and provide a ready to use instance of
/// Shared Preferences.
final sharedPrefInstanceProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});