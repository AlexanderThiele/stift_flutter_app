import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pencalendar/pages/calendar_page/calendar_page.dart';
import 'package:pencalendar/pages/share/share_image_page.dart';
import 'package:pencalendar/repository/analytics/analytics_repository.dart';
import 'package:pencalendar/repository/repository_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.calendarView.path,
    routes: [
      GoRoute(
        path: AppRoute.calendarView.path,
        builder: (_, __) {
          ref.read(analyticsRepositoryProvider).trackScreenView(AnalyticsScreenView.defaultCalendar);
          return const CalendarPage();
        },
      ),
      GoRoute(
        path: AppRoute.shareCalendar.path,
        builder: (_, __) {
          ref.read(analyticsRepositoryProvider).trackScreenView(AnalyticsScreenView.share);
          return ShareImagePage();
        },
      )
    ],
  );
});

enum AppRoute {
  calendarView("/"),
  shareCalendar("/share-calendar");

  const AppRoute(this.path);

  final String path;
}
