import 'package:pencalendar/repository/analytics/analytics_repository.dart';

class NoAnalyticsRepository extends AnalyticsRepository {
  @override
  void trackEvent(String name) {}
}
