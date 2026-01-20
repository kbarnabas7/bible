class TodayService {
  static Map<String, dynamic>? getTodayPlan(
    Map<String, dynamic> plan,
    DateTime today,
  ) {
    final days = plan['days'] as List;

    final todayStr =
        "${today.year.toString().padLeft(4, '0')}-"
        "${today.month.toString().padLeft(2, '0')}-"
        "${today.day.toString().padLeft(2, '0')}";

    return days.cast<Map<String, dynamic>>().firstWhere(
          (d) => d['date'] == todayStr,
          orElse: () => {},
        );
  }
}
