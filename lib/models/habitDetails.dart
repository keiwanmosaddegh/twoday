class HabitDetails {
  final String habitId;
  final int year;
  final Map<String, int> quarterStatistics;
  final List<DateTime> recordsForYear;

  HabitDetails(
      {this.habitId, this.year, this.quarterStatistics, this.recordsForYear});
}
