import 'package:intl/intl.dart';
import 'package:twoday/models/habit.dart';
import 'package:twoday/models/habitEntry.dart';
import 'package:twoday/services/Database.dart';
import 'package:twoday/services/db_constants.dart';

class HabitRepository {
  final _db = DBProvider.db;

  HabitRepository._();

  static final repo = HabitRepository._();

  Future<List<Habit>> getAllHabits() async {
    List<Habit> habits = <Habit>[];
    final habitsWithoutData = await _db.getAllHabitsWithoutData();
    for (final habitWithoutData in habitsWithoutData) {
      final habitData = await getDataOfHabit(habitWithoutData.id);
      final habit = habitWithoutData.copyWith(
          done: habitData[HABIT_COLUMN_DONE] == 1,
          currentStreak: habitData[HABIT_COLUMN_CURRENT_STREAK],
          longestStreak: habitData[HABIT_COLUMN_LONGEST_STREAK],
          daysSinceLastDone: habitData[HABIT_COLUMN_DAYS_SINCE_LAST_DONE]);
      habits.add(habit);
    }
    return habits;
  }

  Future<bool> createHabit(Habit habit) async {
    var count = 0;
    count += await _db.createHabit(habit);
    return count > 0;
  }

  Future<bool> deleteHabitById(String id) async {
    var count1 = 0;
    var count2 = 0;
    count1 += await _db.deleteHabitById(id);
    count2 += await _db.deleteAllHabitEntriesOfHabit(id);
    return count1 > 0 && count2 > 0;
  }

  Future<bool> updateHabit(Habit habit) async {
    var count = 0;
    count += await _db.updateHabit(habit);
    return count > 0;
  }

  Future<bool> toggleHabitEntry(
    String habitId,
    bool value,
    DateTime dateTime,
  ) async {
    var count = 0;
    if (value) {
      count += await _db.insertHabitEntry(habitId, dateTime);
    } else {
      count += await _db.deleteHabitEntry(habitId, dateTime);
    }
    return count > 0;
  }

  Future<Map<String, dynamic>> getDataOfHabit(String habitId) async {
    final habitRecords = await _db.getAllHabitEntriesOfHabit(habitId);
    var currentStreak = 0;
    var longestStreak = 0;
    var done = 0;
    var daysSinceMostRecentHabitEntry = 4;

    if (habitRecords.isNotEmpty) {
      var currentDateTime =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

      HabitEntry mostRecentHabitEntry;
      for (var i = 0; i < habitRecords.length; i) {
        if (habitRecords[0].date.difference(currentDateTime).inDays <= 0) {
          mostRecentHabitEntry = habitRecords[0];
          break;
        }
        habitRecords.removeAt(0);
      }

      if (mostRecentHabitEntry != null) {
        daysSinceMostRecentHabitEntry =
            currentDateTime.difference(mostRecentHabitEntry.date).inDays;

        var isStreakActive = daysSinceMostRecentHabitEntry < 3;

        if (daysSinceMostRecentHabitEntry == 0) {
          done = 1;
        }

        if (isStreakActive) {
          var iterationDate = habitRecords[0].date;
          for (var i = 0; i < habitRecords.length; i) {
            if (iterationDate.difference(habitRecords[0].date).inDays < 3) {
              currentStreak++;
              iterationDate = habitRecords[0].date;
              habitRecords.removeAt(0);
            } else {
              break;
            }
          }
          longestStreak = currentStreak;
        }
      }

      if (habitRecords.isNotEmpty) {
        var tempStreak = 0;
        var iterationDate = habitRecords[0].date;
        for (var i = 0; i < habitRecords.length; i) {
          if (iterationDate.difference(habitRecords[0].date).inDays < 3) {
            tempStreak++;
            iterationDate = habitRecords[0].date;
            habitRecords.removeAt(0);
          } else {
            if (tempStreak > longestStreak) {
              longestStreak = tempStreak;
            }
            tempStreak = 0;
            iterationDate = habitRecords[0].date;
          }
        }

        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      }
    }

    return {
      HABIT_COLUMN_DONE: done,
      HABIT_COLUMN_CURRENT_STREAK: currentStreak,
      HABIT_COLUMN_LONGEST_STREAK: longestStreak,
      HABIT_COLUMN_DAYS_SINCE_LAST_DONE: daysSinceMostRecentHabitEntry
    };
  }

  Future<Map<String, dynamic>> getQuarterlyStatisticsOfHabit(
      {String habitId}) async {
    final habitEntries = await _db.getAllHabitEntriesOfHabit(habitId);
    List<DateTime> entries = habitEntries.map((entry) => entry.date).toList();
    final dateTimeNow =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    Map<int, Map<String, int>> statistics = {};

    for (final entry in habitEntries) {
      if (entry.date.difference(dateTimeNow).inDays <= 0) {
        if (!statistics.containsKey(entry.date.year)) {
          statistics[entry.date.year] = {
            "q1": 0,
            "q2": 0,
            "q3": 0,
            "q4": 0,
          };
        }

        if (entry.date.month <= 3) {
          statistics[entry.date.year]
              .update("q1", (value) => value + 1, ifAbsent: () => 1);
        } else if (entry.date.month >= 4 && entry.date.month <= 6) {
          statistics[entry.date.year]
              .update("q2", (value) => value + 1, ifAbsent: () => 1);
        } else if (entry.date.month >= 7 && entry.date.month <= 9) {
          statistics[entry.date.year]
              .update("q3", (value) => value + 1, ifAbsent: () => 1);
        } else if (entry.date.month >= 10 && entry.date.month <= 12) {
          statistics[entry.date.year]
              .update("q4", (value) => value + 1, ifAbsent: () => 1);
        }
      }
    }

    return {"statistics": statistics, "entries": entries};
  }
}
