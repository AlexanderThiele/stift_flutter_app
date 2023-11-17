import 'package:pencalendar/repository/analytics/analytics_repository.dart';

class NoAnalyticsRepository extends AnalyticsRepository {
  @override
  Future<void> trackEvent(AnalyticEvent event, {Map<String, Object>? parameters}) async {}
}
