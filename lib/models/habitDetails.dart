class HabitDetails {
  final String habitId;
  final Map<int, Map<String, int>> statistics;
  final List<DateTime> entries;

  HabitDetails({this.habitId, this.statistics, this.entries});
}
