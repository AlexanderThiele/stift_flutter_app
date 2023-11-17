import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:pencalendar/repository/analytics/analytics_repository.dart';
import 'package:pencalendar/utils/app_logger.dart';

class FirebaseAnalyticsRepository extends AnalyticsRepository {
  @override
  Future<void> trackEvent(AnalyticEvent event, {Map<String, Object>? parameters}) {
    if (parameters != null) {
      // clean parameters because firebase only accepts String and num
      for (final key in parameters.keys) {
        parameters[key] = parameters[key] is num ? parameters[key]! : parameters[key].toString();
      }
    }
    AppLogger.d("TrackEvent $event ${parameters ?? ''}");
    return FirebaseAnalytics.instance.logEvent(name: event.name, parameters: parameters);
  }

  @override
  Future<void> trackScreenView(AnalyticsScreenView screenView) {
    AppLogger.d("TrackScreen $screenView");
    return FirebaseAnalytics.instance.logScreenView(screenName: screenView.name);
  }
}
