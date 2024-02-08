import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pencalendar/provider/shared_preference_provider.dart';

final rateAppNotifierProvider = NotifierProvider<RateAppNotifier, bool>(() => RateAppNotifier());

/// TRUE if the user can still rate the app
class RateAppNotifier extends Notifier<bool> {
  final _sharedPrefKey = "rate_app_was_opened_once";

  /// Save that the user already opened the rate app dialog
  Future<void> rateAppOpened() async {
    await ref.read(sharedPrefInstanceProvider).setBool(_sharedPrefKey, true);
    state = false;
  }

  Future<void> maybeOpenAppReview() async {
    // true == not yet opened
    if (state) {
      if (await InAppReview.instance.isAvailable()) {
        await InAppReview.instance.requestReview();
        await rateAppOpened();
      }
    }
  }

  @override
  bool build() {
    final alreadyOpenedOnce = ref.watch(sharedPrefInstanceProvider).getBool(_sharedPrefKey) ?? false;
    return !alreadyOpenedOnce;
  }
}
