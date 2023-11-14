import 'package:go_router/go_router.dart';
import 'package:pencalendar/pages/calendar_page/calendar_page.dart';
import 'package:pencalendar/pages/share/share_image_page.dart';

enum AppRoute {
  calendarView("/"),
  shareCalendar("/share-calendar");

  const AppRoute(this.path);

  final String path;
}

final GoRouter appRoutes = GoRouter(
  initialLocation: AppRoute.calendarView.path,
  routes: [
    CalendarPage(AppRoute.calendarView),
    ShareImagePage(AppRoute.shareCalendar),
  ],
);
