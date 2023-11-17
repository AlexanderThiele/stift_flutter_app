abstract class AnalyticsRepository {
  Future<void> trackEvent(AnalyticEvent event, {Map<String, Object>? parameters});
}

enum AnalyticEvent {
  addDrawing("add_drawing"),
  revertDrawing("revert_drawing"),
  eraseDrawing("erase_drawing"),
  clearYearDrawing("clear_year_drawing"),
  changeYear("change_year");

  const AnalyticEvent(this.name);

  final String name;
}