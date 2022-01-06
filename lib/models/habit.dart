import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:twoday/services/Database.dart';

class Habit extends Equatable {
  final String id;
  final String task;
  final bool done;
  final int currentStreak;
  final int longestStreak;
  final int daysSinceLastDone;

  Habit(this.task,
      {this.done = false,
      this.currentStreak = 0,
      this.longestStreak = 0,
      this.daysSinceLastDone = 4,
      String id})
      : this.id = id ?? UniqueKey().toString();

  Habit copyWith({
    String id,
    String task,
    bool done,
    int currentStreak,
    int longestStreak,
    int daysSinceLastDone,
  }) {
    return Habit(
      task ?? this.task,
      id: id ?? this.id,
      done: done ?? this.done,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      daysSinceLastDone: daysSinceLastDone ?? this.daysSinceLastDone,
    );
  }

  factory Habit.fromMap(Map<String, dynamic> map) =>
      new Habit(map[DBProvider.HABIT_COLUMN_TASK],
          id: map[DBProvider.HABIT_COLUMN_ID],
          done: map[DBProvider.HABIT_COLUMN_DONE] == 1,
          currentStreak: map[DBProvider.HABIT_COLUMN_CURRENT_STREAK],
          longestStreak: map[DBProvider.HABIT_COLUMN_LONGEST_STREAK],
          daysSinceLastDone: map[DBProvider.HABIT_COLUMN_DAYS_SINCE_LAST_DONE]);

  Map<String, dynamic> toMap() => {
        DBProvider.HABIT_COLUMN_ID: id,
        DBProvider.HABIT_COLUMN_TASK: task,
      };

  @override
  toString() {
    return 'Habit { task: $task, done: $done, daysSinceLastDone: $daysSinceLastDone }';
  }

  @override
  List<Object> get props => [
        id,
        task,
        done,
        currentStreak,
        longestStreak,
        daysSinceLastDone,
      ];
}
