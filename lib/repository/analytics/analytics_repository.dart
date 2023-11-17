abstract class AnalyticsRepository {
  Future<void> trackEvent(AnalyticEvent event, {Map<String, Object>? parameters});

  Future<void> trackScreenView(AnalyticsScreenView screenView);
}

enum AnalyticEvent {
  addDrawing("add_drawing"),
  revertDrawing("revert_drawing"),
  eraseDrawing("erase_drawing"),
  clearYearDrawing("clear_year_drawing"),
  changeYear("change_year"),
  howItWorks("how_it_works"),
  rateApp("rate_app"),
  shareCalendar("share_calendar");

  const AnalyticEvent(this.name);

  final String name;
}

enum AnalyticsScreenView {
  defaultCalendar("default_calendar"),
  share("share");

  const AnalyticsScreenView(this.name);

  final String name;
}
